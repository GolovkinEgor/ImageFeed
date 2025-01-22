struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String?
    let scope: String?
    let createdAt: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "accessToken"
        case tokenType = "tokenType"
        case scope
        case createdAt = "createdAt"
    }
}
