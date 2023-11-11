import Foundation
import AVKit

enum AuthState {
    case loading, loggedOut, onboarding, loggedIn
}

struct Reel: Equatable {
    var player: AVPlayer
    var id: Int
    var shareLink: URL
    var topic: String
    var unit: String
    
    static func == (lhs: Reel, rhs: Reel) -> Bool {
        return lhs.id == rhs.id
    }
}
