//
//  ViewController.swift
//  FAMAApp
//
//  Created by João Victor Ipirajá de Alencar on 19/04/19.
//  Copyright © 2019 FAMA. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    func didLogin()
    func didCancel()
}

class LoginViewController: UIViewController {

    @IBOutlet weak var famaLogoImageView: UIImageView!
    @IBOutlet weak var continueWithoutLoginButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var shouldContinueWithoutLogin = true
    var delegate: LoginDelegate?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if famaLogoImageView.frame.origin.y < 16 { famaLogoImageView.frame.origin.y = 16 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        continueWithoutLoginButton.isHidden = !shouldContinueWithoutLogin
        closeButton.isHidden = shouldContinueWithoutLogin
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        delegate?.didCancel()
    }
    
    @IBAction func facebookLogin(_ sender: UIButton) {
        // Login logic
        didLogin()
    }
    
    @IBAction func googleLogin(_ sender: UIButton) {
        // Login logic
        didLogin()
    }
    
    func didLogin() {
        if shouldContinueWithoutLogin {
            performSegue(withIdentifier: "events", sender: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
        delegate?.didLogin()
    }
    
    @IBAction func continueWithoutLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "events", sender: nil)
    }
    
}
