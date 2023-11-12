import SwiftUI
import GoogleSignIn
import AVKit

import Foundation

func dateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // You can adjust the format as needed
    return dateFormatter.string(from: date)
}

func stringToDate(string: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // This format should match the one used in dateToString
    if let final = dateFormatter.date(from: string) {
        return final
    } else {
        return Date()
    }
}


class RequestModel: ObservableObject {
    
    @Published var givenName: String = ""
    @Published var profilePicUrl: String = ""
    @Published var email: String = ""
    @Published var selectedTopics: [Int] = []
    @Published var authState: AuthState = .loading
    @Published var errorMessage: String = ""
    @Published var reels: [Reel] = []
    
    let baseUrl: String = "http://ec2-3-88-232-170.compute-1.amazonaws.com"
    
    private func convertDictToReel(data: [String: Any]) -> Reel {
        return Reel(id: UUID(),
            player: AVPlayer(url:  URL(string: data["link"] as? String ?? "https://relearn.app")!), reelId: data["id"] as? Int ?? 0, shareLink: URL(string: data["link"] as? String ?? "https://relearn.app")!, topic: data["topic"] as? String ?? "", unit: data["unit"] as? String ?? ""
        )
    }
    
    private func convertDictArrayToReel(data: [[String: Any]?]) -> [Reel] {
        var finalReel: [Reel] = []
        
        if let data1 = data[0] {
            finalReel.append(convertDictToReel(data: data1))
        }
        
        if let data2 = data[1] {
            finalReel.append(convertDictToReel(data: data2))
        }
        
        if let data3 = data[2] {
            finalReel.append(convertDictToReel(data: data3))
        }
        
        print(finalReel)
        return finalReel
    }
    
    func getLikedRequest(reel_id: String, completion: @escaping (Bool?, Error?) -> Void) {
        let url = URL(string: baseUrl + "/is_liked")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email, "reel_id": reel_id]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = json["message"] as? Bool {
                    DispatchQueue.main.async {
                        completion(message, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }
    
    func likeReelRequest(reel_id: String, completion: @escaping (Bool?, Error?) -> Void) {
        let url = URL(string: baseUrl + "/like_reel")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email, "reel_id": reel_id]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = json["message"] as? String {
                    DispatchQueue.main.async {
                        if (message == "success") {
                            completion(true, nil)
                        } else {
                            completion(false, nil)
                        }
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }
    
    private func getInitialReels(completion: @escaping ([Reel]?, Error?) -> Void) {
        let url = URL(string: baseUrl + "/recommend_initial")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email, "selection_list": selectedTopics]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    if let message = json["message"] as? [[String: Any]?] {
                        DispatchQueue.main.async {
                            
                            completion(self.convertDictArrayToReel(data: message), nil)
                        }
                    }
                } else {
                    
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }
    
    private func getReelRequest(completion: @escaping (Reel?, Error?) -> Void) {
        let url = URL(string: baseUrl + "/recommend_reel")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email, "selection_list": selectedTopics]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = json["message"] as? [String: Any] {
                    DispatchQueue.main.async {
                        completion(self.convertDictToReel(data: message), nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }
    private func convertDictToComment(data: [String: Any]) -> Comment {
        return Comment(
            id: data["id"] as? Int ?? 0,
            reelId: data["reel_id"] as? Int ?? 0,
            senderName: data["name"] as? String ?? "",
            senderProfile: URL(string: data["profile"] as? String ?? "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png")!,
            sentAt: stringToDate(string: data["created_at"] as? String ?? ""),
            comment: data["content"] as? String ?? "",
            reply:  data["edison_reply"] as? String ?? nil
        )
    }
    
    private func convertDictArrayToComment(data: [[String: Any]?]) -> [Comment] {
        var finalReel: [Comment] = []
        
        for i in 1...data.count {
            if let newData = data[i - 1] {
                finalReel.append(convertDictToComment(data: newData))
            }
        }

        return finalReel
    }
    
    func getCommentsRequest(reel_id: String, completion: @escaping ([Comment]?, Error?) -> Void) {
        let url = URL(string: baseUrl + "/get_comments")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["reel_id": reel_id]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    if let message = json["message"] as? [[String: Any]?] {
                        DispatchQueue.main.async {
                            
                            completion(self.convertDictArrayToComment(data: message), nil)
                        }
                    }
                } else {
                    
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }
    
    func addCommentRequest(reel_id: String, comment: String, completion: @escaping (String?, Error?) -> Void) {
        let url = URL(string: baseUrl + "/add_comment_with_edison")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["reel_id": reel_id, "email": self.email, "name": self.givenName, "profile_url": self.profilePicUrl, "created_at": dateToString(date: Date()), "comment": comment]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    if let message = json["message"] as? [String: Any] {
                        DispatchQueue.main.async {
                            completion(message["edison_reply"] as? String ?? nil, nil)
                        }
                    }
                } else {
                    
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }
    
    private func getMemeReelRequest(completion: @escaping (Reel?, Error?) -> Void) {
        let url = URL(string: baseUrl + "/get_meme_reel")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = json["message"] as? [String: Any] {
                    DispatchQueue.main.async {
                        completion(self.convertDictToReel(data: message), nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }
    
    public func scrollForward() {
        let randomNum: Int = Int.random(in: 1...5)
        
        if (randomNum != 1) {
            getReelRequest() { reel, error in
                if let reel {
                    self.reels.append(reel)
                }
            }
        } else {
            getMemeReelRequest() { reel, error in
                if let reel {
                    self.reels.append(reel)
                }
            }
        }
        
    }
    
    public func scrollBack() {
        getReelRequest() { reel, error in
            if let reel {
                self.reels.insert(reel, at: 0)
            }
        }
    }
    
    private func isOnboardedRequest(email: String, completion: @escaping ([Int]?, Error?) -> Void) {
        let url = URL(string: baseUrl + "/is_onboarded")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = json["message"] as? [Int] {
                    DispatchQueue.main.async {
                        completion(message, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }
    
    private func onboardRequest(email: String, topicSelection: [Int], completion: @escaping (Bool?, Error?) -> Void) {
        let url = URL(string: baseUrl + "/onboard")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email, "topic_selection": topicSelection]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = json["message"] as? String {
                    DispatchQueue.main.async {
                        if (message == "success") {
                            completion(true, nil)
                        }
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }

        task.resume()
    }
    
    func onboard(topicSelection: [Int]) {
        onboardRequest(email: self.email, topicSelection: topicSelection) { result, error in
            if let result, result == true {
                self.selectedTopics = topicSelection
                self.getInitialReels(completion: { initialReels, error in
                        if let initialReels {
                            self.reels = initialReels
                        }
                })
                self.authState = .loggedIn
            }
        }
    }
    
    init(){
        check()
    }
    
    func checkStatus(){
        if(GIDSignIn.sharedInstance.currentUser != nil){
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return }
            let givenName = user.profile?.givenName
            let profilePicUrl = user.profile!.imageURL(withDimension: 100)!.absoluteString
            self.givenName = givenName ?? ""
            self.profilePicUrl = profilePicUrl
            self.email = user.profile?.email ?? ""
            
            isOnboardedRequest(email: self.email) { isOnboarded, error in
                if let isOnboarded, isOnboarded.count > 0 {
                    self.selectedTopics = isOnboarded
                    self.getInitialReels(completion: { initialReels, error in
                        if let initialReels {
                            self.reels = initialReels
                        }
                    })
                    self.authState = .loggedIn
                } else {
                    self.authState = .onboarding
                }
            }
           
        } else{
            self.authState = .loggedOut
            self.givenName = "Not Logged In"
            self.profilePicUrl =  ""
        }
    }
    
    func check(){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            self.checkStatus()
        }
    }
    
    func signIn(){
       guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController, completion: { user, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            self.checkStatus()
        })
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        self.checkStatus()
    }
}
