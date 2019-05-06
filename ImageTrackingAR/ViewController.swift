//
//  ViewController.swift
//  ImageTrackingAR
//
//  Created by Boppo on 17/04/19.
//  Copyright © 2019 Boppo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func navigateToAR(_ sender: HomePageButton) {
        performSegue(withIdentifier: "Lets Goto AR", sender: sender)
    }
    
}

