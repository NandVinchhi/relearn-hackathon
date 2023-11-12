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
    var currentTab: UUID
    var currentReel: Reel
    @State var isPlaying: Bool = false
    
    @State var isLiked: Bool = false
    
    @State private var showingShareSheet = false
    
    @State private var showingComments = false
    
    @State private var showingProgress = false
    @EnvironmentObject var vm: RequestModel
    
    var body: some View {
       
        VideoPlayer(player: currentReel.player)
            .disabled(true)
            .onChange(of: currentTab) { oldValue, newValue in
               Task {
                   if (currentReel.id == newValue) {
                       currentReel.player.play()
                       
                       vm.getLikedRequest(reel_id: String(currentReel.reelId) ) { status, error in
                           if let status, status == true {
                               isLiked = true
                           } else {
                               isLiked = false
                           }
                       }
                       
                       showingShareSheet = false
                       showingComments = false
                       isPlaying = true
                       
                   }
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
                                   if (currentReel.topic != "") {
                                       isLiked = !isLiked
                                       vm.likeReelRequest(reel_id: String(currentReel.reelId) ) { status, error in
                                           print("LIKE BUTTON PRESSED \(status)")
                                       }
                                   }
                                   
                               }) {
                                   ReelPageButton(assetName: "likebutton", height: 36, foregroundColor: isLiked ? Color.light : Color.white)
                               }
                               
                               Button(action: {
                                   if (currentReel.topic != "") {
                                       currentReel.player.pause()
                                       isPlaying = false
                                       showingComments = true
                                   }
                                   
                               }) {
                                   ReelPageButton(assetName: "commentbutton", height: 36)
                               }.halfSheet(isPresented: $showingComments) {
                                   CommentsPage()
                               }
                               
                               
                               Button(action: {
                                   currentReel.player.pause()
                                   isPlaying = false
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
                                   currentReel.player.pause()
                                   isPlaying = false
                                   showingProgress = true
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

struct MainPage: View {
    @EnvironmentObject var vm: RequestModel
    
    @State var currentTab: UUID = UUID()
    var body: some View {
        Group {
            if vm.reels.count > 0 {
                
                ScrollView(.init()) {
                    GeometryReader { proxy in
                        TabView(selection: $currentTab) {
                            ForEach(vm.reels) { reel in
                                ReelView(currentTab: currentTab, currentReel: reel)
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                    .rotationEffect(.degrees(-90))
                                    .tag(reel.id)
                            }
                            
                        }
                        .frame(width: proxy.size.height, height: proxy.size.width)
                        .rotationEffect(.degrees(90), anchor: .topLeading)
                        .offset(x: proxy.size.width)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .onChange(of: currentTab) { oldValue, newValue in
                            vm.scrollForward()
                        }
                    }
                    
                }
                .onAppear {
                    vm.reels.first(where: { $0.id == currentTab})?.player.play()
                }
                .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    MainPage()
}
