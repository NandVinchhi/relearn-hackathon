import SwiftUI

struct MainButtonStyle: ButtonStyle {
    var isSelected: Bool = false
    var shadowSize: CGFloat = 5
    var radius: CGFloat = 7
    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            Group {
                configuration.label.zIndex(2).foregroundColor(isSelected ? Color.white: Color.dark)
                RoundedRectangle(cornerRadius: radius)
                    .foregroundColor(isSelected ? Color.light: Color.white)
                    
                RoundedRectangle(cornerRadius: radius)
                    .stroke(Color.dark, lineWidth: 2)
                    
            }.zIndex(1).offset(x: configuration.isPressed ? 2: 0, y: configuration.isPressed ? 2: 0)
            
            RoundedRectangle(cornerRadius: radius)
                .foregroundColor(Color.dark)
                .offset(x: shadowSize, y: shadowSize)
                .zIndex(0)
            
        }
        .background(Color.white)
    }
}



struct ReelPageButton: View {
    var assetName: String
    var height: CGFloat
    var foregroundColor: Color = .white
    
    var body: some View {
        ZStack {
            Image(assetName)
                .resizable()
                .scaledToFit()
                .foregroundColor(foregroundColor)
                .frame(height: height)
                .zIndex(1)
            
            Image(assetName)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.dark)
                .frame(height: height)
                .zIndex(0)
                .offset(x: 3, y: 3)
        }
        
    }
}

#Preview {
    HStack {
        ReelPageButton(assetName: "likebutton", height: 100, foregroundColor: Color.light)
        ReelPageButton(assetName: "playbutton", height: 100, foregroundColor: Color.light)
    }
}
