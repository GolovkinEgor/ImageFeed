
import UIKit
import WebKit

enum WebWViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let loginWebView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .white
        return webView
    }()
    
    private let backBatton: UIButton = {
        let button = UIButton(type: .custom)
        let logoutImage =  UIImage(named: "backButton")
        button.setImage(logoutImage, for: button.state)
        button.addTarget(
            nil,
            action: #selector(Self.didTapButton),
            for: .touchUpInside
        )
        return button
    }()
    
    private var progressView: UIProgressView = {
        let progresView = UIProgressView()
        progresView.progressTintColor = .backGroundFigma
        return progresView
    }()
    
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginWebView.navigationDelegate = self
        
        estimatedProgressObservation = loginWebView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 self?.updateProgress()
             })
        setupViews()
        setupСonstraints()
        loadAuthView()
    }
    
    // MARK: - Private Methods
    
    @objc
    private func didTapButton() {
        dismiss(animated: true)
    }
    
    private func updateProgress() {
        progressView.progress = Float(loginWebView.estimatedProgress)
        progressView.isHidden = fabs(loginWebView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func setupViews() {
        [backBatton, loginWebView, progressView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupСonstraints(){
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            
            backBatton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 9),
            backBatton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            
            
            loginWebView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0),
            loginWebView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0),
            loginWebView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0),
            loginWebView.topAnchor.constraint(equalTo: backBatton.bottomAnchor, constant: 0),
            
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
    
    private func loadAuthView(){
        guard var urlComponents = URLComponents(string: WebWViewConstants.unsplashAuthorizeURLString)
        else {
            print("[WebViewViewController.loadAuthView()]: urlComponents creation error")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url
        else {
            print("[WebViewViewController.loadAuthView()]: url creation error")
            return
        }
        let request = URLRequest(url: url)
        loginWebView.load(request)
    }
}

    // MARK: - Extensions

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let code = code(from: navigationAction) {
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            print("[WebViewController.code()]: error getting CODE")
            return nil
        }
    }
}

