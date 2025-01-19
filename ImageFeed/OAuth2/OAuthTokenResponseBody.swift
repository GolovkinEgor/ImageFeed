//
//  File.swift
//  ImageFeed
//
//  Created by Golovkin Egor on 18.01.2025.
//

import Foundation
struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String?
    let scope: String?
    let createdAt: Int?
}
