//
//  MovieCollectionViewCell.swift
//  moviesDb
//
//  Created by Matheus Henrique Mendes Alexandre on 24/08/22.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: MovieCollectionViewCell.self)
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
}
