//
//  ViewController.swift
//  LoginKit
//
//  Created by Kieran Andrews on 02/14/2016.
//  Copyright (c) 2016 Kieran Andrews. All rights reserved.
//

import UIKit
import LoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {

        // Setup
        LoginKitConfig.url = "https://private-5855a-loginkit.apiary-mock.com/token"
        LoginKitConfig.destination = PrivateController()
        LoginKitConfig.logoImage = UIImage(named: "logo") ?? UIImage()

        Appearance.backgroundColor = UIColor(red: 0.46, green: 0.70, blue: 0.93, alpha: 1.0)

        let login_screen = LoginKit.loginScreenController() as! LoginController
        self.presentViewController(login_screen, animated: animated,completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
