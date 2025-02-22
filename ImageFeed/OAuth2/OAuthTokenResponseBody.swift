struct OAuthTokenResponseBody: Decodable {
    let token: String


    enum CodingKeys: String, CodingKey {
        case token = "accessToken"
        
    }
}
