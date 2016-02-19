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

public class AppearanceController {

    static let sharedInstance = AppearanceController()

    public var backgroundColor = UIColor.blueColor()
    public var whiteColor = UIColor.whiteColor()
    public var buttonColor = UIColor.redColor()

}
