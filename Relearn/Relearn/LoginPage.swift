import SwiftUI
import Supabase

struct LoginPage: View {
    
    @EnvironmentObject var vm: RequestModel
   
    var body: some View {
        Image("logo")
            .resizable()
            .scaledToFit()
            .frame(height: 48)
        Image("homepage")
            .resizable()
            .scaledToFit()
            .frame(height: 128)
            .padding(.vertical, 60)
        Button(action: {
            Task {
                try await Task.sleep(nanoseconds: 200000000)
                vm.signIn()
            }
            
                }) {
                    HStack(spacing: 10) {
                        Image("devicon_google")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                        Text("CONTINUE WITH GOOGLE")
                            .fontWeight(.bold)
                    }
                }
                .frame(width: 300, height: 48)
                .buttonStyle(MainButtonStyle(isSelected: false, shadowSize: 4))
    }
}
//
//#Preview {
//    LoginPage(authState: Binding.constant(.loggedOut))
//}
