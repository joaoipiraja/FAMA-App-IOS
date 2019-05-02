//
//  QrCodeScannerViewController.swift
//  FAMAApp
//
//  Created by João Pedro Aragão on 24/04/19.
//  Copyright © 2019 FAMA. All rights reserved.
//

import UIKit

enum QrCodeScannerStates {
    case success
    case failure
}

protocol QrCodeScannerDelegate {
    func didScan(with: QrCodeScannerStates)
}

class QrCodeScannerViewController: UIViewController, LoginDelegate {

    var delegate: QrCodeScannerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? LoginViewController
        destination?.shouldContinueWithoutLogin = false
        destination?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
//        if !user.isLogged {
//            startScanning()
//        } else {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.performSegue(withIdentifier: "login", sender: nil)
        }
//        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func didLogin() {
        startScanning()
    }
    
    func didCancel() {
        
    }
    
    func startScanning() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.didScan(with: .success)
        }
    }

}
