import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}

    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {

        
        
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            print("[OAuth2Service]: Ошибка записи urlComponents")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            print("[OAuth2Service]: Ошибка записи urlComponents")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("[OAuth2Service]: ошибка \(error.localizedDescription)")
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                DispatchQueue.main.async {
                    print("[OAuth2Service]: ошибка выполнения запроса")
                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                }
                return
            }
            
            do {
                let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(tokenResponse.accessToken))
                }
            } catch {
                DispatchQueue.main.async {
                    print("[OAuth2Service]: ошибка декодирования \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}


