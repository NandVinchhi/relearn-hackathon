import SwiftUI
import AVKit


struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ReelView: View {
    var currentReel: Reel
    @State var isPlaying: Bool = false
    
    @State var isLiked: Bool = false
    
    @State private var showingShareSheet = false
    
    @State private var showingComments = false
    
    @State private var showingProgress = false
    @EnvironmentObject var vm: UserAuthModel
    
    var body: some View {
       
        VideoPlayer(player: currentReel.player)
            .disabled(true)
            .onChange(of: currentReel) {
               Task {
                   currentReel.player.play()
                   isLiked = false
                   showingShareSheet = false
                   showingComments = false
                   isPlaying = true
//                   NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { _ in
//                       currentReel.player.seek(to: .zero)
//                       currentReel.player.play()
//                   }
               }
           }
           .onDisappear {
               Task {
                   currentReel.player.pause()
                   isPlaying = false
                   currentReel.player.seek(to: .zero)
               }
           }
           .overlay {
               ZStack {
                   if (!isPlaying) {
                       ReelPageButton(assetName: "playbutton", height: 80)
                           .zIndex(0)
                   }
                   
                   Rectangle()
                       .fill(Color.clear)
                       .contentShape(Rectangle())
                       .onTapGesture {
                           if (isPlaying) {
                               currentReel.player.pause()
                               isPlaying = false
                           } else {
                               currentReel.player.play()
                               isPlaying = true
                           }
                       }
                       .zIndex(1)
                   
                   VStack {
                       Spacer()
                       HStack {
                           Spacer()
                           VStack (spacing: 30) {
                               Button(action: {
                                   isLiked = !isLiked
                               }) {
                                   ReelPageButton(assetName: "likebutton", height: 36, foregroundColor: isLiked ? Color.light : Color.white)
                               }
                               
                               Button(action: {
                                   showingComments = true
                               }) {
                                   ReelPageButton(assetName: "commentbutton", height: 36)
                               }.halfSheet(isPresented: $showingComments) {
                                   CommentsPage()
                               }
                               
                               
                               Button(action: {
                                           self.showingShareSheet = true
                               }) {
                                   ReelPageButton(assetName: "sharebutton", height: 36)
                               }
                               .sheet(isPresented: $showingShareSheet) {
                                   ShareSheet(items: [currentReel.shareLink])
                               }
                               Menu {
                                   Button("Sign out") {
                                       vm.signOut()
                                   }
                               } label: {
                                   ReelPageButton(assetName: "morebutton", height: 36)
                               }
                               
                               Button(action: {
                                   showingProgress = true;
                               }) {
                                   ReelPageButton(assetName: "progressbutton", height: 36)
                               }.fullScreenCover(isPresented: $showingProgress) {
                                   ProgressPage()
                               }
                               
                           }.padding(.bottom, 96).padding(.trailing, 12)
                               
                       }
                   }.zIndex(2)
                   
                   HStack {
                       VStack(alignment: .leading, spacing: 6) {
                           Spacer()
                           Text(currentReel.topic).font(.headline).fontWeight(.bold).foregroundColor(.white)
                           Text(currentReel.unit).font(.subheadline).fontWeight(.semibold).foregroundColor(.white)
                       }.zIndex(3)
                           .padding(.leading, 12).padding(.bottom, 96)
                       Spacer()
                   }
                   
               }
           }
   }
}

struct InfinitePageView<C, T>: View where C: View, T: Hashable {
    @Binding var selection: T
    

    let before: (T) -> T
    let after: (T) -> T
    
    let scrollForward: () -> Void
    let scrollBack: () -> Void
    
    @ViewBuilder let view: (T) -> C

    @State private var currentTab: Int = 0
    

    var body: some View {
        let previousIndex = before(selection)
        let nextIndex = after(selection)
        ScrollView(.init()) {
            GeometryReader { proxy in
                TabView(selection: $currentTab) {
//                    view(previousIndex)
                    Rectangle().foregroundColor(.black)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .rotationEffect(.degrees(-90))
                        .tag(-1)
                    view(selection)
                        .onDisappear() {
                            if currentTab != 0 {
                                selection = currentTab < 0 ? previousIndex : nextIndex
                                currentTab = 0
                            }
                        }
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .rotationEffect(.degrees(-90))
                        .tag(0)
//                    view(nextIndex)
                    Rectangle().foregroundColor(.black)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .rotationEffect(.degrees(-90))
                        .tag(1)
                }
                .frame(width: proxy.size.height, height: proxy.size.width)
                .rotationEffect(.degrees(90), anchor: .topLeading)
                .offset(x: proxy.size.width)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .disabled(currentTab != 0) // FIXME: workaround to avoid glitch when swiping twice very quickly
                .onChange(of: currentTab) { oldValue, newValue in
                    if (newValue == 1) {
                        scrollForward()
                    } else if (newValue == -1){
                        scrollBack()
                    }
                }
            }
            
        }
        .ignoresSafeArea()
    }
}

struct MainPage: View {
    @EnvironmentObject var vm: UserAuthModel

    @State private var reelIndex: Int = 0

    var body: some View {
        Group {
            if vm.reels.count > 0 {

                InfinitePageView(
                    selection: $reelIndex,
                    before: { correctedIndex(for: $0 - 1) },
                    after: { correctedIndex(for: $0 + 1) },
                    scrollForward: {vm.scrollForward(reelIndex: reelIndex)},
                    scrollBack: {vm.scrollBack(reelIndex: reelIndex)},
                    view: { index in
                        ReelView(currentReel: vm.reels[index]).zIndex(1)
                        
                    }
                )
            }
        }
    }

    private func correctedIndex(for index: Int) -> Int {
        let count = 3
        return (count + index) % count
    }
}

#Preview {
    MainPage()
}
