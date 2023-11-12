import SwiftUI

struct TopicSelect: View {
    var textContent: String
    var topicId: Int
    @State var isSelected: Bool = false
    @Binding var selectedTopics: [Int]
    
    
    var width: CGFloat {
        return (CGFloat) (textContent.count * 10)
    }
    
    var body: some View {
        Button(action: {
            if (isSelected) {
                isSelected = false
                selectedTopics.removeAll {
                    $0 == topicId
                }
            } else {
                isSelected = true
                selectedTopics.append(topicId)
            }
            
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
    @State var selectedTopics: [Int] = []
    @EnvironmentObject var vm: RequestModel
    
    var body: some View {
        Text("What would you like to relearn?")
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .foregroundColor(Color.dark)
            .fontWeight(.semibold)
            .multilineTextAlignment(.center)
        
        
        VStack (spacing: 14) {
            HStack(spacing: 10) {
                TopicSelect(textContent: "AP BIOLOGY", topicId: 1, selectedTopics: $selectedTopics)
                TopicSelect(textContent: "AP MICROECONOMICS", topicId: 6, selectedTopics: $selectedTopics)
            }
            HStack(spacing: 10) {
                TopicSelect(textContent: "AP ENVIRONMENTAL SCIENCE", topicId: 3, selectedTopics: $selectedTopics)
                TopicSelect(textContent: "AP CHEMISTRY", topicId: 2, selectedTopics: $selectedTopics)
            }
            HStack(spacing: 10) {
                TopicSelect(textContent: "AP US HISTORY", topicId: 4, selectedTopics: $selectedTopics)
                TopicSelect(textContent: "AP MACROECONOMICS", topicId: 5, selectedTopics: $selectedTopics)
            }
        }.padding(.vertical, 40)
        
        
        Button(action: {
            Task {
                try await Task.sleep(nanoseconds: 200000000)
                vm.onboard(topicSelection: selectedTopics)
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
