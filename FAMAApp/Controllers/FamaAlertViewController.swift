//
//  TimerOverAlertViewController.swift
//  FAMAApp
//
//  Created by João Pedro Aragão on 26/04/19.
//  Copyright © 2019 FAMA. All rights reserved.
//

import UIKit

class FamaAlertViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var alertTitle: String?
    private var message: String?
    private var onConfirm: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.alpha = 0
        view.alpha = 0
        alertView.layer.cornerRadius = 10
        alertView.layer.masksToBounds = true
        
        titleLabel.text = alertTitle
        messageLabel.text = message
    }
    
    func set(title: String) {
        self.alertTitle = title
    }
    
    func set(message: String) {
        self.message = message
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        onConfirm?()
        dismiss()
    }
    
    func setOnConfirm(_ handler: @escaping (() -> Void)) {
        self.onConfirm = handler
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
