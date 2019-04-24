//
//  ViewController.swift
//  FAMAApp
//
//  Created by João Victor Ipirajá de Alencar on 19/04/19.
//  Copyright © 2019 FAMA. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performSegue(withIdentifier: "events", sender: nil)
    }
    
}

