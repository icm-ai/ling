#if os(iOS)
import UIKit
import SwiftUI
import UniformTypeIdentifiers

// @objc(ActionViewController) removed to avoid conflict
open class ActionViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ensure the view background is consistent
        view.backgroundColor = .systemBackground
        
        // Look for text in the extension context
        findInputText()
    }
    
    private func findInputText() {
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            close()
            return
        }
        
        for item in extensionItems {
            guard let attachments = item.attachments else { continue }
            
            for provider in attachments {
                if provider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
                    provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { [weak self] (result, error) in
                        DispatchQueue.main.async {
                            if let text = result as? String {
                                self?.configureInterface(with: text)
                            } else {
                                // If plain string fails, try URL or others if needed, but for now strict text.
                                // Sometimes text comes as URL (weirdly), but usually String.
                                self?.close()
                            }
                        }
                    }
                    return
                }
            }
        }
    }
    
    private func configureInterface(with text: String) {
        let extensionAccessoryView = ExtensionView(inputText: text) { [weak self] in
            self?.close()
        }
        
        let hostingController = UIHostingController(rootView: extensionAccessoryView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    private func close() {
        self.extensionContext?.completeRequest(returningItems: self.extensionContext?.inputItems, completionHandler: nil)
    }
}
#endif
