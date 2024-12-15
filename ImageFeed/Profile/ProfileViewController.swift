//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Golovkin Egor on 01.12.2024.
//

import UIKit

    final class ProfileViewController: UIViewController {
        private var label: UILabel!
        private var labelTag:UILabel!
        private var  label3:UILabel!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let profileImage = UIImage(named: "Image1")
            let imageView = UIImageView(image: profileImage)
            imageView.tintColor = .gray
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            let label = UILabel()
            label.textColor = .white
            label.text = "Екатерина Новикова"
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
            self.label = label
            
            let labelTag = UILabel()
            labelTag.textColor = .gray
            labelTag.text = "@ekaterina_nov"
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(labelTag)
            labelTag.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
            labelTag.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
            self.labelTag = labelTag
            
            let label3 = UILabel()
            label3.textColor = .white
            label3.text = "Hello,world!"
            label3.translatesAutoresizingMaskIntoConstraints = true
            view.addSubview(label3)
            label3.leadingAnchor.constraint(equalTo: labelTag.leadingAnchor).isActive = true
            label3.topAnchor.constraint(equalTo: labelTag.bottomAnchor).isActive = true
            self.label3 = label3
            
            let button = UIButton.systemButton(
                with: UIImage(named: "LogOut")!,
                target: self,
                action: #selector(Self.didTapButton)
            )
            button.tintColor = .red
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        }
        
        @objc
        private func didTapButton() {
            
            label?.removeFromSuperview()
            label = nil
            
        }
    }


