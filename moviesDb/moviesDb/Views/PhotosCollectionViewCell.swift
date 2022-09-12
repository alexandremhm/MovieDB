//
//  PhotosCollectionViewCell.swift
//  moviesDb
//
//  Created by Matheus Henrique Mendes Alexandre on 26/08/22.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photosImageView: UIImageView!
        
    static let reuseIdentifier = String(describing: PhotosCollectionViewCell.self)
}
