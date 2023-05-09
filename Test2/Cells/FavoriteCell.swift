//
//  FavoriteCell.swift
//  Test2
//
//  Created by Tatyana Sidoryuk on 09.05.2023.
//

import Foundation
import UIKit

class FavoriteCell: UITableViewCell {

    let queryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(queryLabel)
        contentView.addSubview(favoriteImageView)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 100),
            queryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            queryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            queryLabel.trailingAnchor.constraint(equalTo: favoriteImageView.leadingAnchor, constant: -16),
            queryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            favoriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with favorite: (query: String, image: Data)) {
        queryLabel.text = favorite.query
        favoriteImageView.image = UIImage(data: favorite.image)
    }
}

