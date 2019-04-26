//
//  VoteView.swift
//  FAMAApp
//
//  Created by João Pedro Aragão on 24/04/19.
//  Copyright © 2019 FAMA. All rights reserved.
//

import UIKit

enum Vote: Int {
    case up = 0x2ECC71
    case down = 0xE86F62
}

class VoteView: UIView {
    
    //#2ECC71 - 46 204 113
    //#E86F62 - 232 111 98
    
    var imageView: UIImageView!
    var label: UILabel!
    
    init(vote: Vote) {
        super.init(frame: .zero)
        backgroundColor = UIColor(rgb: vote.rawValue)
        
        label = UILabel(frame: .zero)
        label.text = "VOTO CONFIRMADO!"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        addSubview(label)
        
        imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        switch vote {
        case .up:
            imageView.image = UIImage(named: "upvote-black")
        case .down:
            imageView.image = UIImage(named: "downvote-black")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
