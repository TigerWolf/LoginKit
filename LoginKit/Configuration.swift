//
//  LoginKitConfiguration.swift
//  LoginKit
//
//  Created by Kieran Andrews on 18/02/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public let LoginKitConfig = Configuration.sharedInstance

public enum AuthType {
    case basic
    case jwt
}

open class Configuration {

    open static let sharedInstance = Configuration()

    /**
     The url of the login server
     */
    open var url: String = ""

    /**
     The path to the login endpoint
     */
    open var loginPath: String = "login"

    /**
     The path to the registration endpoint
     */
    open var registerPath: String = "register"
    
    
    /**
     The controller to display if the login is successful. This is a lambda to ensure that the code
     in the controller is not excecuted prematurely.
     */
    open var destination: () -> (UIViewController) =
        { () -> UIViewController in UIViewController()}
    
    /**
     Toggle savedLogin functionality
     */
    open var savedLogin: Bool = true

    // Prevent default initialization
    fileprivate init() {
    }

    /**
     The logo to be displayed on the login page
     */

    open var logoImage: UIImage = UIImage()

    /**
     The auth type to be used when connecting to the server. See AuthType for options
     */
    open var authType: AuthType = .jwt

}
