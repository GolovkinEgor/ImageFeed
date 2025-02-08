import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService()
    private let profileImageService = ProfileImageService.shared
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let token = oauth2TokenStorage.token
        if token != nil {
            
            switchToTabBarController()
        } else {
            // Если токена нет, переходим к авторизации
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { return }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                self.oauth2TokenStorage.token = token
                self.switchToTabBarController()
            
            case .failure(let error):
                print("Ошибка получения токена: \(error.localizedDescription)")
            }
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let authViewController = navigationController.viewControllers.first as? AuthViewController else {
                fatalError("Ошибка перехода на экран авторизации")
            }
            authViewController.delegate = self
        }
    }
   
}

    
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
       
        guard let token = oauth2TokenStorage.token else {
            print("[ERROR] oauth2TokenStorage.token is nil!")
            return
        }
        fetchProfile(token)
    }

    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token: token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self = self else { return }

            switch result {
            case .success:
               self.switchToTabBarController()

            case .failure:
                // TODO [Sprint 11] Покажите ошибку получения профиля
                break
            }
        }
    }
    private func fetchProfileImage(profile:Profile){
        ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { result in
            switch result{
            case .success(let imageURL):
                print(imageURL)
            case .failure(let error):
                print("[fetchProfileImage()]: error getting profile image. Error: \(error)" )
            }
        }
    }
}
