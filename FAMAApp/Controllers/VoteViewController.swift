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
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    lazy var remainingSeconds = 30
    var timer: Timer?
    var artist: Artist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageFrame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6))
        let blur = UIBlurEffect(style: .dark)
        let blurred = UIVisualEffectView(effect: blur)
        let blurFrame = CGRect(origin: .zero, size: CGSize(width: imageFrame.width, height: imageFrame.height * 0.2))
        blurred.frame = blurFrame
        blurredBackground.insertSubview(blurred, at: 0)
        
        upvoteView.layer.cornerRadius = 10
        upvoteView.layer.masksToBounds = true
        
        downvoteView.layer.cornerRadius = 10
        downvoteView.layer.masksToBounds = true
        
        if let artist = artist {
            eventNumberLabel.text = "Atração \(artist.number)"
            eventNameLabel.text = artist.name
            artistImageView.image = UIImage(named: "\(artist.number)")
        }
        
        loadArtist()
        startTimer()
        
    }
    
    func loadArtist() {
        
        artistImageView.image = UIImage(named: "\(artist?.number ?? 0)")
        eventNumberLabel.text = "Atração \(artist?.number ?? 0)"
        eventNameLabel.text = artist?.name
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.remainingSeconds == 0 { self.timeout() }
            self.remainingSeconds -= 1
            self.remainingTimeLabel.text = self.remainingSeconds >= 10 ? "00:\(self.remainingSeconds)" : "00:0\(self.remainingSeconds)"
        }
    }
    
    func timeout() {
        timer?.invalidate()
        presentAlert(withMessage: "O tempo para a votação deste candidato acabou")
    }
    
    func backgroundError() {
        timer?.invalidate()
        presentAlert(withMessage: "Ocorreu algum erro. Tente votar novamente")
    }
    
    func presentAlert(withMessage message: String) {
        let storyboard = UIStoryboard(name: "FamaAlert", bundle: .main)
        let alert = storyboard.instantiateViewController(withIdentifier: "famaAlert") as! FamaAlertViewController
        alert.set(title: "Ops...")
        alert.set(message: message)
        alert.setOnConfirm { self.dismiss(animated: true, completion: nil) }
        alert.present(onViewController: self)
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
        guard let artist = artist else { return }
        let storyboard = UIStoryboard(name: "ConfirmVoteAlert", bundle: .main)
        let alert = storyboard.instantiateViewController(withIdentifier: "confirmVoteAlert") as! ConfirmVoteAlertViewController
        alert.populate(withVote: vote, withEvent: artist.name)
        alert.setOnConfirm {
            self.uploadVote(with: vote)
            self.timer?.invalidate()
        }
        alert.present(onViewController: self)
    }
    
    func confirmVote(with vote: Vote) {
        DispatchQueue.main.async {
            self.persistVote()
            self.runAnimation(forVote: vote)
        }
    }
    
    private func uploadVote(with vote: Vote) {
        self.confirmVote(with: vote)
        // MARK: Upload para o Firebase
            // Se der certo chamar self.confirmVote(vote: vote)
            // Senão, chamar presentAlert(withMessage: "Algo deu errado. Verifique a sua conexão com a internet e tente novamente")
    }
    
    private func persistVote() {
        let defaults = UserDefaults.standard
        var votes = (defaults.array(forKey: "votes") as? [Int]) ?? [Int]()
        votes.append(artist!.number)
        defaults.setValue(votes, forKey: "votes")
    }
    
    private func runAnimation(forVote vote: Vote) {
        let voteView = VoteView(vote: vote, artist: artist!)
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 1.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                voteView.imageView.frame.size = CGSize(width: voteView.imageView.frame.size.width * 1.2, height: voteView.imageView.frame.size.height * 1.2)
                voteView.imageView.center = imageViewCenter
                voteView.label.frame.origin.y = voteView.imageView.frame.origin.y + voteView.imageView.frame.height + 16 * 1.2
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.35) {
            UIView.animate(withDuration: 1.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                voteView.imageView.frame.size = CGSize(width: voteView.imageView.frame.size.width/1.2, height: voteView.imageView.frame.size.height/1.2)
                voteView.imageView.center = imageViewCenter
                voteView.label.frame.origin.y = voteView.imageView.frame.origin.y + voteView.imageView.frame.height + 16
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.dismiss(animated: true, completion: nil)
        }
    }

}
