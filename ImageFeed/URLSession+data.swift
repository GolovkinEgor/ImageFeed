//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Golovkin Egor on 11.01.2025.
//

import Foundation
enum NetworkError: Error {  // 1
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func performRequest<T: Decodable>(with request: URLRequest, decodingType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let task = dataTask(with: request) { data, response, error in
            // Проверка на наличие ошибки в запросе
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            // Проверка статуса ответа
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Invalid Response", code: 0, userInfo: nil)))
                }
                return
            }
            
            // Если статус-код не в диапазоне 200-299, выводим ошибку и тело ответа
            guard (200...299).contains(httpResponse.statusCode) else {
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Ошибка от Unsplash: HTTP \(httpResponse.statusCode) - \(responseString)")
                }
                let serverError = NSError(domain: "Server Error", code: httpResponse.statusCode, userInfo: nil)
                DispatchQueue.main.async {
                    completion(.failure(serverError))
                }
                return
            }
            
           
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedResponse))
                    }
                } catch {
                    // Логирование ошибки декодирования
                    print("Ошибка декодирования JSON: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
}


