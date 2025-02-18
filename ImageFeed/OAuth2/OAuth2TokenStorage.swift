import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case token = "token"
    }
    
    var token: String? {
        get {
            let token: String? = KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
            return token
        }
        set {
            let token = "token"
            let isSuccess = KeychainWrapper.standard.set(token, forKey: Keys.token.rawValue)
            guard isSuccess else {
                print("[OAuth2TokenStorage]:the token has not been saved")
                return
                
            }
        }
    }
    let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
}
