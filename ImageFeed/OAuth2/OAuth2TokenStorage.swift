import Foundation

final class OAuth2TokenStorage {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case token = "token"
    }
    
    var token: String? {
        get {
            storage.string(forKey: Keys.token.rawValue) ?? nil
        }
        set {
            storage.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
