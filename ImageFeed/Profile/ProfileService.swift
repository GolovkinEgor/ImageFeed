
import UIKit

struct ProfileResult: Decodable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
          case username
          case firstName = "first_name"
          case lastName = "last_name"
          case bio
      }
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
                  name: "\(profile.firstName ?? "") \(profile.lastName ?? "")".trimmingCharacters(in: .whitespaces),
                  loginName: "@\(profile.username)",
                  bio: profile.bio)
    }
}

final class ProfileService {
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let jsonDecoder = JSONDecoder()
    
    private(set) var profile: Profile?
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
            task?.cancel()

            guard let request = makeProfileURLRequest(token: token) else {
                completion(.failure(NetworkError.invalidRequest))
                return
            }

            let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    guard let self = self else { return }

                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    guard let data = data else {
                        completion(.failure(AuthServiceError.noData))
                        return
                    }

                    do {
                        let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                        let profile = Profile(result: profileResult)

                        
                        self.profile = profile

                        completion(.success(profile))
                    } catch {
                        completion(.failure(NetworkError.decodingError(error)))
                    }
                }
            }
            
            self.task = task
            task.resume()
        }
    }
