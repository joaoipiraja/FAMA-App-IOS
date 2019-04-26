//
//  ArtistTableViewCell.swift
//  FAMAApp
//
//  Created by João Pedro Aragão on 24/04/19.
//  Copyright © 2019 FAMA. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNumberLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var eventNumberLabelTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func populate(artist: Artist) {
        eventImageView.image = UIImage(named: "\(artist.number)")
        eventNumberLabel.text = "Atração \(artist.number)"
        eventNameLabel.text = artist.name
    }
    
}
