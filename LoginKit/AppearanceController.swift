//
//  Appearance.swift
//  LoginKit
//
//  Created by Kieran Andrews on 14/02/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SVProgressHUD

let Appearance = AppearanceController.sharedInstance

class AppearanceController {
    
    static let sharedInstance = AppearanceController()
    
    var backgroundColor = UIColor.blueColor()
    var whiteColor = UIColor.whiteColor()
    var buttonColor = UIColor.redColor()

}