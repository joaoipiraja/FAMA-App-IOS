//
//  VoteView.swift
//  FAMAApp
//
//  Created by João Pedro Aragão on 24/04/19.
//  Copyright © 2019 FAMA. All rights reserved.
//

import UIKit
import Firebase

enum Vote: Int {
    case up = 0x2ECC71
    case down = 0xE86F62
}

class VoteView: UIView {
    
    //#2ECC71 - 46 204 113
    //#E86F62 - 232 111 98
    
    var imageView: UIImageView!
    var label: UILabel!
    
    init(vote: Vote, artist: Artist) {
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
            let db = Firestore.firestore()
            
            let frankDocRef = db.collection("contagem").document("atracoes")
            frankDocRef.collection(artist.name ?? "").document("voto").updateData(["total" : FieldValue.increment(Int64(1))]){ err in
                if let err = err {
                    frankDocRef.collection(artist.name ?? "").document("voto").setData(["total" : 1])
                } else {
                    print("Document successfully updated")
                }
            }
            
        case .down:
            imageView.image = UIImage(named: "downvote-black")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
