// https://github.com/Quick/Quick

import Quick
import Nimble
//import UIKit

@testable import LoginKit

class MainTests: QuickSpec {
    override func spec() {
        
        describe("LoginKitConfig"){
            
            it("logoImage is an image") {
                expect(LoginKitConfig.logoImage).to(beAnInstanceOf(UIImage))
            }
            
            it("authType is JWT by default") {
                expect(LoginKitConfig.authType) == AuthType.JWT
            }
            
            it("configuration changes are reflected") {
                LoginKitConfig.authType = AuthType.Basic
                expect(LoginKitConfig.authType) == AuthType.Basic
            }
            
        }
        
        describe("LoginController") {
            let lc = LoginController()
            it("saves password on tap") {
                let _ = lc.view
                expect(LoginService.storePassword) == false
                expect(lc.savePasswordButton.selected) == false
                lc.savePasswordTapped()
                expect(LoginService.storePassword) == true
                expect(lc.savePasswordButton.selected) == true
                lc.savePasswordTapped()
                expect(LoginService.storePassword) == false
                expect(lc.savePasswordButton.selected) == false
            }
            
            it("token is saved") {
                let _ = lc.view
                let token = ["token":"aafafafserghfses"]
                lc.saveToken(token)
                NSLog("The token: \(LoginService.user!.authToken)")
                expect(LoginService.user!.authToken).to(equal("aafafafserghfses"))
                
            }
            
            it("performLogin"){
                let _ = lc.view
                var loginButton = UIButton()
                lc.username.text = "bac"
                lc.password.text = "haf"
                lc.performLogin(loginButton)
//                expect()
            }
            
            it("token is not saved for basic auth") {
                LoginKitConfig.authType = AuthType.Basic
                let _ = lc.view
                let token = ["token":"aafafafserghfses"]
                lc.saveToken(token)
                NSLog("The token: \(LoginService.user!.authToken)")
                expect(LoginService.user!.authToken).to(equal("aafafafserghfses"))
                
            }
            
            // Test controller display (openDestination(:_))
            
            
        }

    }
}
