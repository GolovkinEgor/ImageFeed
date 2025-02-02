//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alesia Matusevich on 04/12/2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    private let profileService = ProfileService()
    private let token = "access_token"
    private let profileImageView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "imageUser")
        view.image = image
        return view
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 23)
        return label
    }()
    
    private let userLoginLabel: UILabel = {
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
        setupViews()
        setupСonstraints()
        
    }
    private func fetchUserProfile() {
            profileService.fetchProfile(token: token) { [weak self] result in
                switch result {
                case .success(let profile):
                    // Обновляем UI с данными профиля
                    self?.userNameLabel.text = profile.name
                    self?.userLoginLabel.text = profile.loginName
                    self?.descriptionLabel.text = profile.bio
                    
                case .failure(let error):
                    // Выводим ошибку в консоль
                    print("Ошибка загрузки профиля: \(error.localizedDescription)")
                }
            }
        }
    // MARK: - Private Methods
    
    @objc
    private func didTapButton() {
       
    }
    
    private func setupViews() {
        [profileImageView, userNameLabel, userLoginLabel, descriptionLabel, logoutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupСonstraints(){
        NSLayoutConstraint.activate([
            // фото профиля
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            // имя
            userNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            
            // логин
            userLoginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userLoginLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            
            // дискрипшен
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: userLoginLabel.bottomAnchor, constant: 8),
            
            // кнопка логаута
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
}
