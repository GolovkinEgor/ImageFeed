//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Golovkin Egor on 27.11.2024.
//


import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
}

