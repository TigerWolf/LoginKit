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
    
    public var url: String = ""
    
    public var destination: UIViewController = UIViewController()
    
    // Prevent default initialization
    private init() {
    }
    
    public var logoImage: UIImage = UIImage()
    
    public var authType: AuthType = .JWT
    
}
