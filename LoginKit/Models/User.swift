import Foundation
import KeychainAccess

public class User: NSObject, NSCoding {

    public let id: String
    let username: String
    var password: String? {
        didSet {
            if LoginService.storePassword && LoginKitConfig.authType == AuthType.Basic {
                // Store to keychain
                if password != nil {
                    do {
                        try keychain.set(password!, key: "password")
                    } catch {
                        NSLog("Failed to set password")
                    }
                } else {
                    self.clearPassword()
                }
            }
        }
    }

    let keychain = Keychain(service: NSBundle.mainBundle().bundleIdentifier!)

    var authToken: String? {
        didSet {
            if LoginService.storePassword {
                // Store to keychain
                if LoginKitConfig.authType == AuthType.JWT {
                    
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
    }

    func clearToken() {
        do {
            try keychain.remove("authToken")
        } catch {
            NSLog("Failed to clear authToken")
        }
    }
    
    func clearPassword() {
        do {
            try keychain.remove("password")
        } catch {
            NSLog("Failed to clear password")
        }
    }

    init(id: String, username: String) {
        self.id = id
        self.username = username
    }

    public required init(coder aDecoder: NSCoder) {
        if let username = aDecoder.decodeObjectForKey("username") as? String,
            let id = aDecoder.decodeObjectForKey("id") as? String {
                self.id = id
                self.username = username

        } else {
            self.id = ""
            self.username = ""
        }
        
        do {
            if let password = try keychain.get("password") {
                self.password = password
            }
        } catch {
            NSLog("Failed to set password")
        }

        if (LoginKitConfig.savedLogin == false){
            do {
                if let authToken = try keychain.get("authToken") {
                    self.authToken = authToken
                }
            } catch {
                NSLog("Failed to set authToken")
            }
        }
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.id, forKey: "id")
        aCoder.encodeObject(self.username, forKey: "username")
        if let authToken = self.authToken {
            aCoder.encodeObject(authToken, forKey: "authToken")
        }
    }



}
