//
//  PrivateController.swift
//  LoginKit
//
//  Created by Kieran Andrews on 16/02/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

import UIKit
import LoginKit

class PrivateController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc = UITableViewController()
        vc.title = "Test"
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logoff", style: .Plain, target: self, action: "logout")

        self.viewControllers = [vc]
    }

    func logout(){
        LoginService.logoff()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
