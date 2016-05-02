import UIKit
import Alamofire

public let LoginService = LoginServices.sharedInstance

public class LoginServices {

    public static let sharedInstance = LoginServices()
    
    /**
     This stores the user that has logged into the application.
     */
    public var user: User?{
        didSet {
            if let appDir = self.appDir {
                if user != nil {
                    if NSKeyedArchiver.archiveRootObject(user!, toFile: appDir + "/user") == false {
                        // Error with storing user
                        NSLog("Error with storing user")
                    }
                } else {
                    do {
                        try NSFileManager.defaultManager().removeItemAtPath(appDir + "/user")
                    } catch {
                        // Error with storing user
                        NSLog("Error with storing user")                        
                    }
                }
            }
        }
    }

    let appDir: String! = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true).first

    var storePassword = false

    private init() {
        if let appDir = self.appDir, user = NSKeyedUnarchiver.unarchiveObjectWithFile(appDir + "/user") as? User {
            self.user = user
        }
    }
    
    /**
     Makes a network request using the authentication of the user.
     
     This will also check for invalid server responses and display
     a corresponding error.
     
     This extends functionality of the Alamofire method.
     
     - returns: Request
     */

    public func request(method: Alamofire.Method, _ path: String, parameters: [String: AnyObject]? = nil) -> Alamofire.Request {
        let location = LoginKitConfig.url + path

        let manager = Alamofire.Manager.sharedInstance

        var headers = [String: String]()
        if let user = self.user, let authToken = user.authToken {
            headers = ["Authorization": authToken]
        }

        var request = manager.request(method, location, parameters: parameters, encoding: .JSON, headers: headers).validate()

        if let username = self.user?.username, let password = self.user?.password {
            request = request.authenticate(user: username, password: password)
        }

        request.responseJSON { response in
            var message: String?
            var logoff = false

            if response.result.isSuccess {
                // Success is handled in seperate implementations
            } else {
                // If the token expires
                if response.response?.statusCode == 401 && request.request!.HTTPMethod == "GET" {
                    logoff = true
                    message = "Your session has expired. Please log in again."
                    // If session expired, cancel all network requests
                    self.cancelRequests()
                } else if response.response?.statusCode == 401 && request.request!.HTTPMethod == "POST" {
                    logoff = false
                    message = "Your login details are incorrect."

                    // If session expired, cancel all network requests
                    self.cancelRequests()
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
                        self.logoff()
                    }
                }))


                // TODO: Use new method
                if let viewController = self.getTopViewController() {
                    viewController.presentViewController(alert, animated: true, completion: nil)
                }
            }

        }

        return request
    }

    /**
     Logs the user out of the app and sends them to the login scree. 
     */
    public func logoff() {
        LoginService.user?.clearToken() // Removes the token from the keychain
        LoginService.clearUser() // Removes the user from the storage

        // BUG: Not sure if this is the best way as you cannot present a view controller
        if let window = UIApplication.sharedApplication().keyWindow {
            window.rootViewController = LoginController()
            window.makeKeyAndVisible()
        }
    }

    func clearUser() {
        self.user = nil
    }

    func getTopViewController() -> UIViewController? {
        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        }

        return nil
    }

    func cancelRequests() {
        let session = Alamofire.Manager.sharedInstance.session
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
