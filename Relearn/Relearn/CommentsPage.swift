import SwiftUI

extension View {
    func halfSheet<SheetView: View>(isPresented: Binding<Bool>, @ViewBuilder sheetView: @escaping () -> SheetView) -> some View {
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(), isPresented: isPresented)
            )
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    var sheetView: SheetView
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true)
        } else {
            uiViewController.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent: HalfSheetHelper

        init(_ parent: HalfSheetHelper) {
            self.parent = parent
        }

        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.isPresented = false
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        super.viewDidLoad()

        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
    }
}

func timeAgoShortFormat(from date: Date) -> String {
    let calendar = Calendar.current
    let now = Date()
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: now)

    if let year = components.year, year > 0 {
        return "\(year)yr"
    } else if let month = components.month, month > 0 {
        return "\(month)mo"
    } else if let day = components.day, day > 0 {
        return "\(day)d"
    } else if let hour = components.hour, hour > 0 {
        return "\(hour)h"
    } else if let minute = components.minute, minute > 0 {
        return "\(minute)m"
    } else if let second = components.second, second >= 0 {
        return "now"
    } else {
        return "future"
    }
}

struct Comment: Identifiable, Hashable {
    var id: Int
    var reelId: Int
    var senderName: String
    var senderProfile: URL
    var sentAt: Date
    var comment: String
    var reply: String?
}

struct CommentView: View {
    
    var comment: Comment
    
    var body: some View {
        HStack (alignment: .top) {
            AsyncImage(url: comment.senderProfile) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .cornerRadius(100)
            } placeholder: {
                Rectangle().foregroundColor(Color.lightGray).frame(width: 40, height: 40).cornerRadius(100)
            }
                

            VStack (alignment: .leading) {
                HStack(spacing: 8) {
                    Text(comment.senderName).font(.subheadline).fontWeight(.bold)
                    Text(timeAgoShortFormat(from: comment.sentAt)).font(.caption).fontWeight(.semibold)
                }
                
                
                Text(comment.comment).font(.subheadline)
                
            }.padding(.leading, 6)
            
            Spacer()
        }.padding(.top, 16)
        
        
        if let reply = comment.reply {
            HStack (alignment: .top) {
                AsyncImage(url: URL(string: "https://hips.hearstapps.com/hmg-prod/images/gettyimages-615312634.jpg")!) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .cornerRadius(100)
                } placeholder: {
                    Rectangle().foregroundColor(Color.lightGray).frame(width: 40, height: 40).cornerRadius(100)
                }
                    

                VStack (alignment: .leading) {
                    HStack(spacing: 8) {
                        Text("Edison AI").font(.subheadline).fontWeight(.bold)
                        
                        RoundedRectangle(cornerRadius: 100).foregroundColor(Color.dark).frame(width: 60, height: 16).overlay {
                            HStack (spacing: 4) {
                                Image(systemName: "arrowshape.turn.up.left.circle.fill").resizable().frame(width: 12, height: 12).foregroundColor(.white).padding(.leading, 4)

                                Text("REPLY").font(.caption2).fontWeight(.semibold).foregroundColor(.white).padding(.trailing, 4)
                                
                            }
                            
                        }
                    }
                    
                    Text(reply).font(.subheadline)
                    
                }.padding(.leading, 6)
                
                Spacer()
            }.padding(.top, 16)
        }
        
    }
}

struct CommentsPage: View {
    
    @State var inputText: String = ""
    
    @State var comments: [Comment] = []
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 72)
                .frame(width: 70, height: 6)
                .foregroundColor(Color.lightGray)
                .padding(.top, 12)
            
            ScrollView {
                VStack (spacing: 0) {
                    
                    ForEach(comments, id: \.self) { comment in
                        CommentView(comment: comment)
                    }
                }
            }
            
            Spacer()
            
            TextField("Ask questions here...", text: $inputText)
                .padding(.vertical, 12).padding(.horizontal, 16)
                .overlay {
                    HStack {
                        Spacer()
                        Image("sendcomment").resizable()
                            .frame(width: 28, height: 28)
                            .padding(.trailing, 10)
                    }
                }
                .background{
                    ZStack {
                        RoundedRectangle(cornerRadius: 100)
                        
                            .stroke(Color.dark, lineWidth: 2)
                            .zIndex(2)
                        RoundedRectangle(cornerRadius: 100)
                        
                            .foregroundColor(Color.white)
                            .zIndex(1)
                        
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundColor(Color.dark)
                            .offset(x: 3, y: 3)
                            .zIndex(0)

                    }
                
                }.foregroundColor(.black).fontWeight(.semibold)
        }
        .padding(.horizontal, 10).padding(.bottom, 8)
        .onAppear {
            let newComment1: Comment = Comment(id: 0, reelId: 0, senderName: "Nand Vinchhi", senderProfile: URL(string: "https://www.hackingwithswift.com/samples/paul.jpg")!, sentAt: Date.now, comment: "Is the mitochondria the powerhouse of the cell?")
            
            comments.append(newComment1)
            
            let newComment2: Comment = Comment(id: 0, reelId: 0, senderName: "Advay Choudhury", senderProfile: URL(string: "https://www.hackingwithswift.com/samples/paul.jpg")!, sentAt: Date.now, comment: "What is the capital of India?", reply: "Hello! The capital of India is New Delhi.")
            
            comments.append(newComment2)
        }
    }
}

#Preview {
    CommentsPage()
}
