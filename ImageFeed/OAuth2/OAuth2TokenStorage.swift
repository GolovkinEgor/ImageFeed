import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case token = "AuthToken"
    }
    
    var token: String? {
        get {
            
            let token: String? = KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
            return token
        }
        set {
            
            guard let token = newValue else {return}
            let isSuccess = KeychainWrapper.standard.set(token, forKey: Keys.token.rawValue)
            guard isSuccess else {
                print("[OAuth2TokenStorage]: error saving token")
                return
            }
        }
    }
    func removeToken(){
        KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
    }
}
