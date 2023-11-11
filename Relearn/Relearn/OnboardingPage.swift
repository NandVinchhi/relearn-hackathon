import SwiftUI

struct TopicSelect: View {
    var textContent: String
    @State var isSelected: Bool = false
    
    var width: CGFloat {
        return (CGFloat) (textContent.count * 10)
    }
    
    var body: some View {
        Button(action: {
            isSelected = !isSelected
        }) {
            Text(textContent)
                .fontWeight(.bold)
                .font(.system(size: 14))
        }
        .frame(width: width, height: 36)
        .buttonStyle(MainButtonStyle(isSelected: isSelected, shadowSize: 3, radius: 6))
            .multilineTextAlignment(.center)
    }
}

struct OnboardingPage: View {
    var body: some View {
        Text("What would you like to relearn?")
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .foregroundColor(Color.dark)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
        
        
        VStack (spacing: 14) {
            HStack(spacing: 10) {
                TopicSelect(textContent: "AP BIOLOGY")
                
                TopicSelect(textContent: "AP MICROECONOMICS")
                
            }
            HStack(spacing: 10) {
                TopicSelect(textContent: "AP ENVIRONMENTAL SCIENCE")
                TopicSelect(textContent: "AP CHEMISTRY")
                
                
            }
            HStack(spacing: 10) {
                TopicSelect(textContent: "AP US HISTORY")
                TopicSelect(textContent: "AP MACROECONOMICS")
                
            }
        }.padding(.vertical, 40)
        
        
        Button(action: {
            Task {
                try await Task.sleep(nanoseconds: 200000000)
            }
        }) {
            HStack(spacing: 10) {
                Text("GET STARTED")
                    .fontWeight(.bold)
                Image("rightarrow")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
            }
        }
        .frame(width: 200, height: 48)
        .buttonStyle(MainButtonStyle(isSelected: false, shadowSize: 4))
    }
}

#Preview {
    OnboardingPage()
}
