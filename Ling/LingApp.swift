import SwiftUI
import LingApp // 导入我们的库模块

@main
struct LingApp: App {
    // 初始化生产环境（Live）环境
    // 这将使用真实的 LLMClient 和 SwiftData 存储
    let environment = AppEnvironment.live()
    
    var body: some Scene {
        WindowGroup {
            LingRootView(environment: environment)
        }
    }
}
