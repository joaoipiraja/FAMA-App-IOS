//
//  VoteViewController.swift
//  FAMAApp
//
//  Created by João Pedro Aragão on 24/04/19.
//  Copyright © 2019 FAMA. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController {

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var blurredBackground: UIView!
    @IBOutlet weak var eventNumberLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var upvoteView: UIView!
    @IBOutlet weak var downvoteView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageFrame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.65))
        let blur = UIBlurEffect(style: .dark)
        let blurred = UIVisualEffectView(effect: blur)
        let blurFrame = CGRect(origin: .zero, size: CGSize(width: imageFrame.width, height: imageFrame.height * 0.2))
        blurred.frame = blurFrame
        blurredBackground.insertSubview(blurred, at: 0)
        
        upvoteView.layer.cornerRadius = 10
        upvoteView.layer.masksToBounds = true
        downvoteView.layer.cornerRadius = 10
        downvoteView.layer.masksToBounds = true
        
        loadExample()
    }
    
    func loadExample() {
        guard let path = Bundle.main.path(forResource: "Events", ofType: "json") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: []) else { return }
        guard let jsonResult = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] else { return }
        artistImageView.image = UIImage(named: "1")
        eventNumberLabel.text = "Atração 1"
        eventNameLabel.text = jsonResult.first ?? ""
    }
    
    @IBAction func tryToVote(_ sender: UIButton) {
        if sender.superview === upvoteView {
            vote(with: .up)
        }
        if sender.superview === downvoteView {
            vote(with: .down)
        }
    }
    
    func vote(with vote: Vote) {
        let storyboard = UIStoryboard(name: "ConfirmVoteAlert", bundle: .main)
        let alert = storyboard.instantiateViewController(withIdentifier: "confirmVoteAlert") as! ConfirmVoteAlertViewController
        alert.populate(withVote: vote, withEvent: "Atração 1 - Banda Update")
        alert.setOnConfirm { self.confirmVote(with: vote) }
        alert.present(onViewController: self)
    }
    
    func confirmVote(with vote: Vote) {
        let voteView = VoteView(vote: vote)
        voteView.frame.size.width = UIScreen.main.bounds.width
        voteView.center = view.center
        view.addSubview(voteView)
        
        let imageViewSize = CGSize(width: self.view.frame.width/2, height: self.view.frame.width/2)
        let imageViewCenter = CGPoint(x: self.view.center.x, y: self.view.center.y - (43 - 16)/2)
        voteView.imageView.frame.size = imageViewSize
        voteView.imageView.center = imageViewCenter
        voteView.imageView.frame.origin.x = -self.view.frame.width/2
        voteView.imageView.alpha = 0
        
        voteView.label.frame.size = CGSize(width: imageViewSize.width, height: 43)
        voteView.label.frame.origin.x = -self.view.frame.width/2
        voteView.label.frame.origin.y = voteView.imageView.frame.origin.y + imageViewSize.height + 16
        voteView.label.alpha = 0
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
            voteView.frame.size.height = self.view.frame.size.height
            voteView.center = self.view.center
        }, completion: { _ in
            voteView.imageView.alpha = 1
            voteView.label.alpha = 1
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                voteView.imageView.center.x = self.view.center.x
                voteView.label.center.x = self.view.center.x
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                voteView.imageView.frame.size = CGSize(width: voteView.imageView.frame.size.width * 1.2, height: voteView.imageView.frame.size.height * 1.2)
                voteView.imageView.center = imageViewCenter
                voteView.label.frame.origin.y = voteView.imageView.frame.origin.y + voteView.imageView.frame.height + 16 * 1.2
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                voteView.imageView.frame.size = CGSize(width: voteView.imageView.frame.size.width/1.2, height: voteView.imageView.frame.size.height/1.2)
                voteView.imageView.center = imageViewCenter
                voteView.label.frame.origin.y = voteView.imageView.frame.origin.y + voteView.imageView.frame.height + 16
            }, completion: { _ in
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
//            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
//                voteView.imageView.frame.origin.x = UIScreen.main.bounds.width
//                voteView.label.frame.origin.x = UIScreen.main.bounds.width
//            })
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
//                voteView.frame.size.height = .zero
//                voteView.center = self.view.center
//            }, completion: { _ in
//                voteView.removeFromSuperview()
//                self.navigationController?.dismiss(animated: true, completion: nil)
//            })
//        }
    }

}
