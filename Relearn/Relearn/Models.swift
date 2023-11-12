import Foundation
import AVKit

enum AuthState {
    case loading, loggedOut, onboarding, loggedIn
}

struct Reel: Equatable, Hashable, Identifiable {
    let id: UUID
    var player: AVPlayer
    var reelId: Int
    var shareLink: URL
    var topic: String
    var unit: String
    
    static func == (lhs: Reel, rhs: Reel) -> Bool {
        return lhs.id == rhs.id
    }
}

struct LikeData: Identifiable {
    let id = UUID()
    let date: Date
    let likes: Double
    
    init(date: Date, likes: Double) {
        self.date = date
        self.likes = likes
    }
}

struct UnitType: Hashable {
    var text: String
    var number: Int
}
