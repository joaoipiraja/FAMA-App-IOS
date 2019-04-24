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
        
//        translatesAutoresizingMaskIntoConstraints = false
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -(21.5 + 16)/2).isActive = true
//        imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.33).isActive = true
//        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
//        
//        label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
//        label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
//        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
//        label.heightAnchor.constraint(equalToConstant: 21.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
