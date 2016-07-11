import UIKit
import Alamofire

public let LoginService = LoginServices.sharedInstance

public class LoginServices: NSObject {

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

    private override init() {
        if let appDir = self.appDir, user = NSKeyedUnarchiver.unarchiveObjectWithFile(appDir + "/user") as? User {
            self.user = user
        }
        
        Alamofire.Manager.sharedInstance.delegate.taskWillPerformHTTPRedirection = { session, task, response, request in
            var redirectedRequest = request
            
            if let
                originalRequest = task.originalRequest,
                headers = originalRequest.allHTTPHeaderFields,
                authorizationHeaderValue = headers["Authorization"]
            {
                let mutableRequest = request.mutableCopy() as! NSMutableURLRequest
                mutableRequest.setValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
                redirectedRequest = mutableRequest
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

    public func request(method: Alamofire.Method, _ path: String, parameters: [String: AnyObject]? = nil) -> Alamofire.Request {
        
        let manager = Alamofire.Manager.sharedInstance
        
        let location = LoginKitConfig.url + path
        
//        var request = manager.request(method, location, parameters: parameters, encoding: .JSON, headers: headers).validate()
        var request: Request
        
        
        if LoginKitConfig.authType == AuthType.Basic {
            request = AuthBasic().request(manager)
        }
        
        if LoginKitConfig.authType == AuthType.JWT {
            request = AuthJWT().request(manager)
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

    func topViewController() -> UIViewController? {
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
