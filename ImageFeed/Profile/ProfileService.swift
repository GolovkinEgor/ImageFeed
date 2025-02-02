
import UIKit

struct ProfileResult: Decodable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

extension Profile {
    init(result profile: ProfileResult) {
        self.init(username: profile.username,
                  name: "\(profile.firstName ?? "") \(profile.lastName ?? "")",
                  loginName: "@\(profile.username)",
                  bio: profile.bio)
    }
}

final class ProfileService {
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let jsonDecoder = JSONDecoder()
    
    var profile: Profile?
    
    init() {}
    
    func makeProfileURLRequest(token: String) -> URLRequest? {
        guard let baseURL = Constants.defaultBaseURL else {
            print("[makeProfileURLRequest()]: error - baseURL is nil")
            return nil
        }
        guard let url = URL(string: "/me", relativeTo: baseURL) else {
            print("[makeProfileURLRequest()]: error - unable to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        task?.cancel()
        
        guard let token = OAuth2TokenStorage().token else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        guard let request = makeProfileURLRequest(token: token) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard self != nil else { return }
            
            switch result {
            case .success(let profileResult):
                let profile = Profile(result: profileResult) 
                completion(.success(profile))
                
            case .failure(let error):
                print("[fetchProfile()]: error creating URLSessionTask. Error: \(error)")
                completion(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
}
