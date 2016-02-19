// https://github.com/Quick/Quick

import Quick
import Nimble
import LoginKit

class LoginKitSpec: QuickSpec {
    override func spec() {
        describe("testing travis ci"){
            it("failure") {
                expect(2) == 1
            }
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

            
            
            
            
//            it("save password ticked"){
//                let loginController = LoginController()
//                expect(LoginService.storePassword) == false
//                loginController.savePasswordTapped()
//                expect(LoginService.storePassword) == true
//            }
//
//            it("can read") {
//                expect("number") == "string"
//            }
//
//            it("will eventually fail") {
//                expect("time").toEventually( equal("done") )
//            }
//            
//            context("these will pass") {
//
//                it("can do maths") {
//                    expect(23) == 23
//                }
//
//                it("can read") {
//                    expect("🐮") == "🐮"
//                }
//
//                it("will eventually pass") {
//                    var time = "passing"
//
//                    dispatch_async(dispatch_get_main_queue()) {
//                        time = "done"
//                    }
//
//                    waitUntil { done in
//                        NSThread.sleepForTimeInterval(0.5)
//                        expect(time) == "done"
//
//                        done()
//                    }
//                }
//            }
        }
    }
}
