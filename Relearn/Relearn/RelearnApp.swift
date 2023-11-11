import SwiftUI

@main
struct RelearnApp: App {
    @StateObject var userAuth: UserAuthModel =  UserAuthModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(userAuth)
        }
    }
}
