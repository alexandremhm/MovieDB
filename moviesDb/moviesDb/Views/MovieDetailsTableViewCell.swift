//
//  MovieDetailsTableViewCell.swift
//  moviesDb
//
//  Created by Matheus Henrique Mendes Alexandre on 25/08/22.
//

import UIKit

class MovieDetailsTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MovieDetailsTableViewCell.self)

    @IBOutlet weak var detailsActorImageView: UIImageView!
    @IBOutlet weak var detailsActorNameLabel: UILabel!
    @IBOutlet weak var detailsCaracterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        detailsActorImageView.layer.cornerRadius = detailsActorImageView.frame.size.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
