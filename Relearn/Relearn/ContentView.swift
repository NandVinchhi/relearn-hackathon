import SwiftUI
import Supabase

struct ContentView: View {
    @EnvironmentObject var vm: RequestModel
    
    var body: some View {
        VStack {
            switch vm.authState {
            case .loading:
                LoadingView()
            case .loggedOut:
                LoginPage()
            case .onboarding:
                OnboardingPage()
            case .loggedIn:
                MainPage()
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
