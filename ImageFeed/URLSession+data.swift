
import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
    case noData
    case networkError(Error)
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("[URLSession.dataTask()]: network error (httpStatusCode) \(String(statusCode))")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("[URLSession.dataTask()]: network error (urlRequestError) error: \(error)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("[URLSession.dataTask()]: network error (urlSessionError)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let decodingData = try decoder.decode(T.self, from: data)
                    completion(.success(decodingData))
                } catch {
                    print("[URLSession.objectTask()]: decoding error. Objekt: \(T.self). Error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("[URLSession.objectTask()]: error creating URLSessionTask. Objekt: \(T.self). Error: \(error)")
                completion(.failure(error))
            }
        }
        return task
    }
}
