import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService()
    private let profileImageService = ProfileImageService.shared
    private let alertPresenter = AlertPresenter()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let token = oauth2TokenStorage.token
        if token != nil {
            fetchProfile()
            
        } else {
            
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
        fetchProfile()
    }
    
    private func fetchProfile() {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile { [weak self] (result: Result<ProfileResult, Error>) in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profileResult):
                let profile = Profile(result: profileResult)  
                self.profileService.profile = profile
                self.fetchProfileImage(profile: profile)
                self.switchToTabBarController()
                
            case .failure(let error):
                
                print("[fetchProfile()]: error getting profile. Error: \(error)")
                break
            }
        }
    }
    private func showAlert(error:Error){
        alertPresenter.showErrorAlert(title: "Что-то пошло не так",
                                      message: "Не удалось войти в систему, \(error.localizedDescription)") 
    }
    
    
    private func fetchProfileImage(profile: Profile) {
        ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { result in
            switch result {
            case .success(let imageURL):
                print(imageURL)
            case .failure(let error):
                print("[fetchProfileImage()]: error getting profile image. Error: \(error)")
            }
        }
    }
}
