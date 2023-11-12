import SwiftUI

@main
struct RelearnApp: App {
    @StateObject var requestModel: RequestModel =  RequestModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(requestModel)
        }
    }
}
