import UIKit
import Alamofire

public let LoginService = LoginServices.sharedInstance

open class LoginServices {

    open static let sharedInstance = LoginServices()
    
    /**
     This stores the user that has logged into the application.
     */
    open var user: User?{
        didSet {
            if let appDir = self.appDir {
                if user != nil {
                    if NSKeyedArchiver.archiveRootObject(user!, toFile: appDir + "/user") == false {
                        // Error with storing user
                        NSLog("Error with storing user")
                    }
                } else {
                    do {
                        try FileManager.default.removeItem(atPath: appDir + "/user")
                    } catch {
                        // Error with storing user
                        NSLog("Error with storing user")                        
                    }
                }
            }
        }
    }

    let appDir: String! = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first

    var storePassword = false

    fileprivate init() {
        if let appDir = self.appDir, let user = NSKeyedUnarchiver.unarchiveObject(withFile: appDir + "/user") as? User {
            self.user = user
        }
        
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.delegate.taskWillPerformHTTPRedirection = { session, task, response, request in
            var redirectedRequest = request
            
            if let
                originalRequest = task.originalRequest,
                let headers = originalRequest.allHTTPHeaderFields,
                let authorizationHeaderValue = headers["Authorization"]
            {
//                let mutableRequest = request.mutableCopy() as! NSMutableURLRequest
//                requrest
//                mutableRequest.setValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
//                redirectedRequest = mutableRequest
                redirectedRequest.setValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
//                redirectedRequest = originalRequest
            }
            
            return redirectedRequest
        }
    }
    
    /**
     Makes a network request using the authentication of the user.
     
     This will also check for invalid server responses and display
     a corresponding error.
     
     This extends functionality of the Alamofire method.
     
     - returns: Request
     */

    open func request( _ path: String, _ method: HTTPMethod, _ parameters: Parameters?) -> Alamofire.DataRequest {
        
        let location: URLConvertible = LoginKitConfig.url + path

//        let manager = Alamofire.Manager.sharedInstance
        let manager = Alamofire.SessionManager.default

        var headers = [String: String]()
        
        if LoginKitConfig.authType == AuthType.jwt {
            if let user = self.user, let authToken = user.authToken {
                headers = ["Authorization": authToken]
            }
        }
        
        // Due to issues with redirects, the HTTP Authorization headers need to be manually built.
        if LoginKitConfig.authType == AuthType.basic {
            if let username = self.user?.username, let password = self.user?.password {
                let loginString = NSString(format: "%@:%@", username, password)
                let loginData: Data = loginString.data(using: String.Encoding.utf8.rawValue)!
                let base64LoginString = loginData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
                headers = ["Authorization": "Basic \(base64LoginString)"]
            }
        }
        
        let request = manager.request(location, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate()

        request.responseJSON { response in
            var message: String? = "Unexpected error, please try again later."
            var logoff = false

            if response.result.isSuccess {
                // Success is handled in seperate implementations
                message = nil
            } else {
                // If the token expires
                if response.response?.statusCode == 401 && request.request!.httpMethod == "GET" {
                    if LoginKitConfig.authType == AuthType.jwt {
                        logoff = true
                        message = "Your session has expired. Please log in again."
                    } else {
                        message = "Your login details are incorrect."
                    }
                    // If session expired, cancel all network requests
                    self.cancelRequests()
                } else if response.response?.statusCode == 401 && request.request!.httpMethod == "POST" {
                    logoff = false
                    message = "Your login details are incorrect."

                    // If session expired, cancel all network requests
                    self.cancelRequests()
                } else if response.response?.statusCode == 404 {
                    message = "Could not connect to server"
                } else if response.response?.statusCode == 500 {
                    // If the request fails, then check if the connection is open
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(json)")
                    }
                    message = "Internal server error, please try again later."
                } else if response.response?.statusCode == 422 {
                    // TODO: Show validation erorrs
                    message = "Incorrect details, please correct and try again"
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(json)")
                    }
                } else if response.response == nil {
                    if LoginKitConfig.authType == AuthType.basic {
                        // This looks like hacky way to do it - why return -999 Cancelled?
                        logoff = true
                        message = "Your login details are incorrect."
                    }
                } else if response.response?.statusCode == nil {
                    // Cancelled requests have no status code
//                    response.result.error
                    
                    // TODO: Currently not working - will need to test.
                    abort()
//                    if response.result.error!.code == NSURLErrorCancelled {
//                        // No need to handle this, no message required
//                        message = nil
//                    } else {
//                        message = "Unexpected error, please try again later."
//                    }
                } else {
                    message = "Unexpected error, please try again later."
                }
            }

            if let message = message {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in action.style
                    if logoff == true {
                        NSLog("Logoff")
                        self.logoff()
                    }
                }))

                if let viewController = self.getTopViewController() {
                    viewController.present(alert, animated: true, completion: nil)
                }
            }

        }

        return request
    }

    /**
     Logs the user out of the app and sends them to the login scree. 
     */
    open func logoff() {
        LoginService.user?.clearToken() // Removes the token from the keychain
        LoginService.clearUser() // Removes the user from the storage

        // BUG: Not sure if this is the best way as you cannot present a view controller
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController = LoginController()
            window.makeKeyAndVisible()
        }
    }

    func clearUser() {
        self.user = nil
    }

    func getTopViewController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        }

        return nil
    }

    func cancelRequests() {
//        let session = Alamofire.Manager.sharedInstance.session
        let session = Alamofire.SessionManager.default.session
        session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            for task in dataTasks {
                task.cancel()
            }
            for task in uploadTasks {
                task.cancel()
            }
            for task in downloadTasks {
                task.cancel()
            }
        }
    }

}
