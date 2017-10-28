//
//  Appearance.swift
//  LoginKit
//
//  Created by Kieran Andrews on 14/02/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SVProgressHUD

public let Appearance = AppearanceController.sharedInstance

open class AppearanceController {

    static let sharedInstance = AppearanceController()

    open var backgroundColor = UIColor.blue
    open var whiteColor = UIColor.white
    
    open var buttonColor = UIColor.red
    open var buttonBorderColor = UIColor.white

}
