// https://github.com/Quick/Quick

import Quick
import Nimble

@testable import LoginKit

class LoginKitSpec: QuickSpec {
    override func spec() {
        
        describe("testing travis ci"){
//            it("failure") {
//                expect(2) == 1
//            }
            it("success") {
                expect(1) == 1
            }
        }
        
        
        describe("LoginKitConfig"){
            
            it("logoImage is an image"){
                expect(LoginKitConfig.logoImage).to(beAnInstanceOf(UIImage))
            }
            
            it("authType is JWT by default"){
                expect(LoginKitConfig.authType) == AuthType.JWT
            }
            
        }
        
        describe("LoginController") {
            it("saves password on tap"){
                let lc = LoginController()
                let _ = lc.view
                expect(lc.savePasswordButton.selected) == false
                lc.savePasswordTapped()
                expect(lc.savePasswordButton.selected) == true

            }

        }
    }
}
