
import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let screenLogoImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "auth_screen_logo")
        view.image = image
        return view
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(
            nil,
            action: #selector(Self.didTapButton),
            for: .touchUpInside
        )
        button.setTitle("Войти", for: button.state)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        button.setTitleColor(.backGroundFigma, for: button.state)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.accessibilityIdentifier = "Authenticate"
        
        return button
    }()
    
    private let tokenStorage = OAuth2TokenStorage()
    weak var delegate: AuthViewControllerDelegate?
    private let identifier = "ShowWebView"
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backGroundFigma
        setupViews()
        setupСonstraints()
        
    }
    
    // MARK: - Private Methods
    
    @objc
    private func didTapButton() {
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            guard let webViewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as? WebViewViewController else {return}
            webViewController.delegate = self
            webViewController.modalPresentationStyle = .fullScreen
            
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewController
            //webViewViewController.delegate = self
            
            present(webViewController, animated: true)
        }
    
    private func setupViews() {
        [screenLogoImageView, loginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupСonstraints(){
        NSLayoutConstraint.activate([
            
            screenLogoImageView.heightAnchor.constraint(equalToConstant: 60),
            screenLogoImageView.widthAnchor.constraint(equalToConstant: 60),
            screenLogoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            screenLogoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            

            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 640)
        ])
    }
    

}

    // MARK: - Extensions

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else {return}
            
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let token):
                self.tokenStorage.token = token.token
                self.delegate?.authViewController(self, didAuthenticateWithCode: code)
            case .failure(let error):
                print("[AuthViewController (delegate)]: error saving token. Error: \(error)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
