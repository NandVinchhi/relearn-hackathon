import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack(spacing: 4) {
            Text("Loading").foregroundColor(Color.dark)
            ProgressView()
        }
        
    }
}

#Preview {
    LoadingView()
}
