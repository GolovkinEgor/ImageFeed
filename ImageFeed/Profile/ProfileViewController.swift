//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Golovkin Egor on 01.12.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var labelName: UILabel!
    private var labelTag:UILabel!
    private var  labelGreeting:UILabel!
    
   
        
        private let profileImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "Image1"))
            imageView.tintColor = .gray
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()

        private let logOutButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "LogOut"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logOutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.addSubview(profileImageView)
            view.addSubview(logOutButton)
            
            setupConstraints()
        

        

        
        let labelName = UILabel()
        labelName.textColor = .white
        labelName.text = "Екатерина Новикова"
        labelName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelName)
        labelName.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        labelName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        
        self.labelName = labelName
        
        let labelTag = UILabel()
        labelTag.textColor = .gray
        labelTag.text = "@ekaterina_nov"
        labelTag.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        labelTag.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelTag)
        labelTag.leadingAnchor.constraint(equalTo: labelName.leadingAnchor).isActive = true
        labelTag.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8).isActive = true
        
        self.labelTag = labelTag
        
        let labelGreeting = UILabel()
        labelGreeting.textColor = .white
        labelGreeting.text = "Hello,world!"
        labelGreeting.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        labelGreeting.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelGreeting)
        labelGreeting.leadingAnchor.constraint(equalTo: labelTag.leadingAnchor).isActive = true
        labelGreeting.topAnchor.constraint(equalTo: labelTag.bottomAnchor, constant: 8).isActive = true
        
        self.labelGreeting = labelGreeting
        
        
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "LogOut"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
    }
    
    
}


