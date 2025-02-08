
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
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 self?.updateProgress()
             })
        setupViews()
        setupConstraints()
        loadAuthView()
    }
    
    // MARK: - Private Methods
    @objc
    @IBAction private func didTapButton() {
        dismiss(animated: true)
    }
   
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func setupViews() {
        [backButton, webView, progressView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        let layout = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            webView.leadingAnchor.constraint(equalTo: layout.leadingAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: layout.trailingAnchor, constant: 0),
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: layout.bottomAnchor, constant: 0),
            
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
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
        webView.load(request)
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

