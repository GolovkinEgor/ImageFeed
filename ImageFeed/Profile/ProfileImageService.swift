
import UIKit

struct UserResult: Decodable{
    let profileImage: ProfileImage?
}
struct ProfileImage: Decodable {
    let small: String?
}

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    
    private(set) var avatarURL: URL?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let jsonDecoder = JSONDecoder()
    
    private init(){}
    
    func makeProfileImageURLRequest(username: String?, token: String) -> URLRequest? {
        if let username = username,
           let baseURL = Constants.defaultBaseURL,
           let url = URL(string: "/users/\(username)", relativeTo: baseURL) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return request
        } else {
            print("[makeProfileImageURLRequest]: error creating profile image request")
            return nil
        }
    }

    
    func fetchProfileImageURL(username: String?, handler: @escaping (Result<UserResult, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                        object: self,
                                        userInfo: ["URL": self.avatarURL as Any])
        
        guard let token = OAuth2TokenStorage().token else { return }
        guard let request = makeProfileImageURLRequest(username: username, token: token) else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let userResult):
                guard let profileImage = userResult.profileImage,
                      let resultURL = profileImage.small else {
                    print("{fetchProfileImageURL}: profile image URL is nil or not available.")
                    return
                }

                self.avatarURL = URL(string: resultURL)
                handler(.success(userResult))
            case .failure(let error):
                print("[fetchProfileImageURL]: error creating URLSessionTask. Error: \(error)")
                handler(.failure(error))
            }
        }
        task.resume()
    }
}
