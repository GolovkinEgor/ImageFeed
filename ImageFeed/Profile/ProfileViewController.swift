
import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatarImage(with url: URL)
    //func showLogoutAlert()
    func updateProfileDetails(profile: Profile)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    var presenter: (any ProfilePresenterProtocol)?
    
    
    
    
    // MARK: - Private Properties
    private let profileService = ProfileService.shared
    
    private var userName: String?
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileLogOutService = ProfileLogoutService.shared
    
    private let profileImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "imageUser")
        view.image = image
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private var userNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 23)
        return label
    }()
    
    private var userLoginLabel: UILabel = {
        var label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = UIColor.gray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        var label = UILabel()
        label.text = "Hello, World!"
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .custom)
        let logoutImage =  UIImage(named: "LogOut")
        button.setImage(logoutImage, for: button.state)
        button.addTarget(
            nil,
            action: #selector(Self.didTapButton),
            for: .touchUpInside
        )
        button.accessibilityIdentifier = "logoutButton"
        return button
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        

        let radius = profileImageView.frame.width / 2
        profileImageView.layer.cornerRadius = radius
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
           presenter?.viewDidLoad()
           setupUI()
           setupViews()
           setupСonstraints()
       }
    // MARK: - Private Methods
    
    @objc
    private func didTapButton() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены,что хотите выйти?", preferredStyle: .alert)
        
        let yesAlertAction = UIAlertAction(title: "Да", style: .default){ _ in
            self.profileLogOutService.logout()
            
            guard let window = UIApplication.shared.windows.first else{
                fatalError("[ProfileViewController]-didTapButton guard let window")
            }
            let splashViewController = SplashViewController()
            window.rootViewController = splashViewController
        }
        let noAlertAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
        alert.addAction(yesAlertAction)
        alert.addAction(noAlertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
     func updateProfileDetails(profile: Profile){
        userName = profile.username
        userNameLabel.text = profile.name
        userLoginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func updateAvatarImage(with url: URL) {
        profileImageView.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        profileImageView.kf.setImage(with: url,
                                     placeholder: UIImage(named: "placeholder.jpeg"),
                                     options: [.processor(processor)])
    }
    private func setupUI() {
        self.view.backgroundColor = .backGroundFigma
    }
    
    private func setupViews() {
        [profileImageView, userNameLabel, userLoginLabel, descriptionLabel, logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupСonstraints(){
        NSLayoutConstraint.activate([
           
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            userNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            
            
            userLoginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userLoginLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: userLoginLabel.bottomAnchor, constant: 8),
            
            
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
}
