
import UIKit

struct UserResult: Decodable {
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Decodable {
    let small: String?
    
    enum CodingKeys: String, CodingKey{
        case small = "small"
    }
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
        
        guard let token = OAuth2TokenStorage().token else {
            print("[fetchProfileImageURL]: Ошибка - отсутствует токен")
            return
        }
        guard let request = makeProfileImageURLRequest(username: username, token: token) else {
            print("[fetchProfileImageURL]: Ошибка - не удалось создать URL-запрос")
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            print("[fetchProfileImageURL]: Получен результат запроса: \(result)")
            
            switch result {
            case .success(let userResult):
                print("[fetchProfileImageURL]: JSON-ответ от сервера: \(userResult)")
                
                guard let profileImage = userResult.profileImage else {
                    print("[fetchProfileImageURL]: Поле `profileImage` отсутствует в ответе сервера.")
                    return
                }
                
                guard let resultURL = profileImage.small else {
                    print("[fetchProfileImageURL]: Поле `small` в `profileImage` равно nil.")
                    return
                }
                
                self.avatarURL = URL(string: resultURL)
                handler(.success(userResult))
                
            case .failure(let error):
                print("[fetchProfileImageURL]: Ошибка при выполнении запроса: \(error)")
                handler(.failure(error))
            }
        }
        task.resume()
    }
    
}
