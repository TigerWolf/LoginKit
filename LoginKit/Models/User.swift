import Foundation
import KeychainAccess

class User: NSObject, NSCoding {
    
    let id: String
    let username: String
    var password: String?
    
    let keychain = Keychain(service: NSBundle.mainBundle().bundleIdentifier!)
    
    var authToken: String? {
        didSet {
            if LoginService.storePassword {
                // Store to keychain
                if authToken != nil {
                    do {
                        try keychain.set(authToken!, key: "authToken")
                    } catch {
                        NSLog("Failed to set authToken")
                    }
                } else {
                    self.clearToken()
                }
            }
        }
    }
    
    func clearToken() {
        do {
            try keychain.remove("authToken")
        } catch {
            NSLog("Failed to clear authToken")
        }
    }
    
    init(id: String, username: String) {
        self.id = id
        self.username = username
    }
    
    required init(coder aDecoder: NSCoder) {
        if let username = aDecoder.decodeObjectForKey("username") as? String,
            let id = aDecoder.decodeObjectForKey("id") as? String {
                self.id = id
                self.username = username
                
        } else {
            self.id = ""
            self.username = ""
        }
        

        do {
            if let authToken = try keychain.get("authToken") {
                self.authToken = authToken
            }
        } catch {
            NSLog("Failed to set authToken")
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.username, forKey: "username")
        if let authToken = self.authToken {
            aCoder.encodeObject(authToken, forKey: "authToken")
        }
    }
    
    
    
}