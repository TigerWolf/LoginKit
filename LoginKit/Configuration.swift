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
    case Basic
    case JWT
}

public class Configuration {

    public static let sharedInstance = Configuration()

    /**
     The url of the login server
     */
    public var url: String = ""

    /**
     The path to the login endpoint
     */
    public var loginPath: String = "login"

    /**
     The controller to display if the login is successful. This is a lambda to ensure that the code
     in the controller is not excecuted prematurely.
     */
    public var destination: () -> (UIViewController) = { () -> UIViewController in UIViewController()}
    
    /**
     Toggle savedLogin functionality
     */
    public var savedLogin: Bool = true

    // Prevent default initialization
    private init() {
    }

    /**
     The logo to be displayed on the login page
     */

    public var logoImage: UIImage = UIImage()

    /**
     The auth type to be used when connecting to the server. See AuthType for options
     */
    public var authType: AuthType = .JWT

}
