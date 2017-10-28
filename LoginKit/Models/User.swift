import Foundation
import KeychainAccess

open class User: NSObject, NSCoding {

    open let id: String
    let username: String
    var password: String? {
        didSet {
            if LoginService.storePassword && LoginKitConfig.authType == AuthType.basic {
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
    
    let keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "com.loginkit.keychain")

    var authToken: String? {
        didSet {
            if LoginService.storePassword {
                // Store to keychain
                if LoginKitConfig.authType == AuthType.jwt {
                    
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
        if let username = aDecoder.decodeObject(forKey: "username") as? String,
            let id = aDecoder.decodeObject(forKey: "id") as? String {
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

        if (LoginKitConfig.savedLogin == false) {
            do {
                if let authToken = try keychain.get("authToken") {
                    self.authToken = authToken
                }
            } catch {
                NSLog("Failed to set authToken")
            }
        }
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.username, forKey: "username")
        if let authToken = self.authToken {
            aCoder.encode(authToken, forKey: "authToken")
        }
    }



}
