//
//  VoteViewController.swift
//  FAMAApp
//
//  Created by João Pedro Aragão on 24/04/19.
//  Copyright © 2019 FAMA. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func confirmVote(with vote: Vote) {
        let voteView = VoteView(vote: vote)
        voteView.center = view.center
        view.addSubview(voteView)
        
        UIView.animate(withDuration: 1.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
            voteView.frame.size = self.view.frame.size
            voteView.center = self.view.center
            
            let imageViewSize = CGSize(width: voteView.frame.width/2, height: voteView.frame.width/2)
            let imageViewCenter = CGPoint(x: self.view.center.x, y: self.view.center.y - (21.5 - 16)/2)
            voteView.imageView.frame.size = imageViewSize
            voteView.imageView.center = imageViewCenter
            
            voteView.label.frame.size = CGSize(width: imageViewSize.width, height: 21.5)
            voteView.label.frame.origin = CGPoint(x: voteView.imageView.frame.origin.x, y: voteView.imageView.frame.origin.y + voteView.imageView.frame.height + 16)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 1.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                voteView.imageView.frame.size = .zero
                voteView.imageView.center = self.view.center
                
                voteView.label.frame.size = .zero
                voteView.label.center = self.view.center
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 1.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                voteView.frame.size = .zero
                voteView.center = self.view.center
            }, completion: { _ in
                voteView.removeFromSuperview()
            })
        }
    }

}
