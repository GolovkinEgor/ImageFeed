
import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let token = "access_token"
    private let profileImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "imageUser")
        view.image = image
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 23)
        return label
    }()
    
    private let loginNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
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
        return button
    }()
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
            super.viewDidLoad()
            

            if let profile = profileService.profile {
    
                updateProfileDetails(profile: profile)
            }
        else{
            fetchUserProfile()
            
        }
        
        profileImageServiceObserver = NotificationCenter.default    // 2
                    .addObserver(
                        forName: ProfileImageService.didChangeNotification, // 3
                        object: nil,                                        // 4
                        queue: .main                                        // 5
                    ) { [weak self] _ in
                        guard let self = self else { return }
                        self.updateAvatar()                                 // 6
                    }
                updateAvatar()                                              // 7
            
        
        
        setupViews()
        setupСonstraints()
        }

        private func fetchUserProfile() {
            guard let token = OAuth2TokenStorage().token else {
                print("[ERROR] Token is nil.")
                return
            }


            profileService.fetchProfile(token: token) { [weak self] result in
                switch result {
                case .success(let profile):
                    DispatchQueue.main.async {
                        self?.updateProfileDetails(profile: profile)
                    }

                case .failure(let error):
                    DispatchQueue.main.async {
                        print("[ERROR] Failed to fetch profile: \(error.localizedDescription)")
                    }
                }
            }
        }
        private func updateProfileDetails(profile: Profile) {
            nameLabel.text = profile.name
            loginNameLabel.text = profile.loginName
            descriptionLabel.text = profile.bio
            setupViews()
            setupСonstraints()
        }
    private func updateAvatar() {                                   // 8
        guard let profileImageURL = ProfileImageService.shared.avatarURL else{return}
                let url = profileImageURL
       
            // TODO [Sprint 11] Обновить аватар, используя Kingfisher
        }
    
    // MARK: - Private Methods
    
    @objc
    private func didTapButton() {
       
    }
    
    private func setupViews() {
     
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logoutButton)
    }

    
    private func setupСonstraints(){
        NSLayoutConstraint.activate([
            
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
         
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            
      
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            
         
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
}
