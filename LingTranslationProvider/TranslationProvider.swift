
import Swift
import LingTranslationProvider

@available(iOS 18.0, *)
@main
struct LingTranslationProviderMain: TranslationUIProviderExtension {
    var body: some TranslationUIProviderExtensionScene {
         LingTranslationProvider.TranslationProvider().body
    }
}
