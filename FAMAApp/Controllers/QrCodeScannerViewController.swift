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

class QrCodeScannerViewController: UIViewController {

    var delegate: QrCodeScannerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.didScan(with: .success)
        }
    }

}
