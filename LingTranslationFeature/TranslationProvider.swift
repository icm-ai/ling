import SwiftUI
import ExtensionKit
import TranslationUIProvider
import LingTranslationFeature

@available(iOS 18.4, *)
@main
struct LingTranslationProviderMain: TranslationUIProviderExtension {
    var body: some TranslationUIProviderExtensionScene {
         LingTranslationFeature.TranslationProvider().body
    }
}
