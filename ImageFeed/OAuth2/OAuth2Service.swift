//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Golovkin Egor on 12.01.2025.
//

import Foundation
final class OAuth2Service {
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        completion(.success("")) // TODO [Sprint 10]
    }
}
