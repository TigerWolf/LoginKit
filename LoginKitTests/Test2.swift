// https://github.com/Quick/Quick

import Quick
import Nimble

@testable import LoginKit

class Test2: QuickSpec {
    override func spec() {
        
        describe("LoginKitConfig"){
            
            it("logoImage is an image") {
                expect(LoginKitConfig.logoImage).to(beAnInstanceOf(UIImage))
            }
            
            it("authType is JWT by default") {
                expect(LoginKitConfig.authType) == AuthType.JWT
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
//                let _ = lc.view
//                let json = "{'token':'aafafafserghfses'}"
//                lc.saveToken(json)
//                expect(LoginService.user!.authToken).to(equal("Qaafafafserghfses"))
                
            }
            
        }

    }
}
