import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}

    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url  = createURL() else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
         func createURL()->URL?{
            return URL(string: "https://unsplash.com/oauth/token")
        }
        func createRequest(url: URL) -> URLRequest {
            return URLRequest(url: url)
        }

        var request = createRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyParams = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: Constants.authCode)
        ]

        request.httpBody = bodyParams
            .map { "\($0.name)=\($0.value ?? "")" }
            .joined(separator: "&")
            .data(using: .utf8)


        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                DispatchQueue.main.async {
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
                      completion(.failure(error))
                  }
            }
        }
        task.resume()
    }
}


