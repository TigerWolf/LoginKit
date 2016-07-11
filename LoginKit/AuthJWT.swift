import Foundation
import UIKit
import Alamofire

class AuthJWT{
    
    
    func request(manager: Manager) -> Alamofire.Request {
        
        var headers = [String: String]()
        
        if let user = LoginService.user, let authToken = user.authToken {
            headers = ["Authorization": authToken]
        }
        
        var request = manager.request(method, location, parameters: parameters, encoding: .JSON, headers: headers).validate()
                
        request.responseJSON { response in
            var message: String? = "Unexpected error, please try again later."
            var logoff = false
            
            if response.result.isSuccess {
                // Success is handled in seperate implementations
                message = nil
            } else {
                // If the token expires
                if response.response?.statusCode == 401 && request.request!.HTTPMethod == "GET" {
                    if LoginKitConfig.authType == AuthType.JWT {
                        logoff = true
                        message = "Your session has expired. Please log in again."
                    } else {
                        message = "Your login details are incorrect."
                    }
                    // If session expired, cancel all network requests
                    LoginService.cancelRequests()
                } else if response.response?.statusCode == 401 && request.request!.HTTPMethod == "POST" {
                    logoff = false
                    message = "Your login details are incorrect."
                    
                    // If session expired, cancel all network requests
                    LoginService.cancelRequests()
                } else if response.response?.statusCode == 404 {
                    message = "Could not connect to server"
                } else if response.response?.statusCode == 500 {
                    // If the request fails, then check if the connection is open
                    message = "Internal server error, please try again later."
                } else if response.response == nil {
                    if LoginKitConfig.authType == AuthType.Basic {
                        // This looks like hacky way to do it - why return -999 Cancelled?
                        logoff = true
                        message = "Your login details are incorrect."
                    }
                } else if response.response?.statusCode == nil {
                    // Cancelled requests have no status code
                    if response.result.error!.code == NSURLErrorCancelled {
                        // No need to handle this, no message required
                        message = nil
                    } else {
                        message = "Unexpected error, please try again later."
                    }
                } else {
                    message = "Unexpected error, please try again later."
                }
            }
            
            if let message = message {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in action.style
                    if logoff == true {
                        NSLog("Logoff")
                        LoginService.logoff()
                    }
                }))
                
                
                // TODO: Use new method
                if let viewController = LoginService.topViewController() {
                    viewController.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
        }
        
        return request

    }
    
}