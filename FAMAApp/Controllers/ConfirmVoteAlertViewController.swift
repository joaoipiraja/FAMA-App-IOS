//
//  ConfirmVoteAlertViewController.swift
//  FAMAApp
//
//  Created by João Pedro Aragão on 26/04/19.
//  Copyright © 2019 FAMA. All rights reserved.
//

import UIKit

class ConfirmVoteAlertViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    private var onConfirm: (() -> Void)?
    private var eventName: String?
    private var vote: Vote?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.alpha = 0
        self.alertView.alpha = 0
        
        alertView.layer.cornerRadius = 10
        alertView.layer.masksToBounds = true
        
        
        guard let vote = vote, let event = eventName else { return }
        voteLabel.text = vote == .up ? "SIM" : "NÃO"
        voteLabel.textColor = UIColor(rgb: vote.rawValue)
        eventNameLabel.text = "à \(event)?"
        confirmButton.setTitleColor(UIColor(rgb: vote.rawValue), for: .highlighted)
    }
    
    func populate(withVote vote: Vote, withEvent event: String) {
        self.eventName = event
        self.vote = vote
    }
    
    func setOnConfirm(_ handler: @escaping (() -> Void)) {
        self.onConfirm = handler
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        onConfirm?()
        dismiss()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss()
    }
    
    func present(onViewController vc: UIViewController) {
        vc.addChild(self)
        didMove(toParent: vc)
        vc.view.addSubview(view)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
            self.view.alpha = 1
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                self.alertView.alpha = 1
            })
        }
        
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
            self.alertView.alpha = 0
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                self.view.alpha = 0
            }, completion: { _ in
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            })
        }
        
    }
    
}
