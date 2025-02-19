import UIKit
import ProgressHUD


protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2TokenStorage = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate?
    private let oauthService = OAuth2Service.shared
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else {
                fatalError("Ошибка перехода на WebView")
            }
            
            webViewViewController.delegate = self
            print("Делегат успешно установлен")
        } else {
            print("Неверный идентификатор сегвея: \(segue.identifier ?? "nil")")
        }
    }

}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()

        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }

            UIBlockingProgressHUD.dismiss()

            switch result {
            case .success(let token):
                self.oauth2TokenStorage.token = token.token
                self.performSegue(withIdentifier: self.showWebViewSegueIdentifier, sender: nil) // Переход на следующий экран
            case .failure(let error):
                print("[AuthViewController delegate]: ошибка сохранения токена. Ошибка: \(error)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
        
    }
            
    

    
}

