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
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let label = UILabel()
        label.textColor = .white
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        
        self.label = label
        
        let labelTag = UILabel()
        
        labelTag.textColor = .gray
        labelTag.text = "@ekaterina_nov"
        labelTag.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        labelTag.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelTag)
        labelTag.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        labelTag.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8).isActive = true
        
        self.labelTag = labelTag
        
        let label3 = UILabel()
        label3.textColor = .white
        label3.text = "Hello,world!"
        label3.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label3)
        label3.leadingAnchor.constraint(equalTo: labelTag.leadingAnchor).isActive = true
        label3.topAnchor.constraint(equalTo: labelTag.bottomAnchor, constant: 8).isActive = true
        
        self.label3 = label3
        
        
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "LogOut"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    
}


