//
//  StubbedTests.swift
//  LoginKit
//
//  Created by Kieran Andrews on 9/07/2016.
//  Copyright © 2016 Kieran Andrews. All rights reserved.
//

import Foundation
import OHHTTPStubs
import Alamofire

import Quick
import Nimble
//import UIKit

@testable import LoginKit

class StubbedTests: QuickSpec {
    
    var data:String = ""
    
    override func spec() {
        
        describe("LoginKitConfig"){
            
            it("logoImage is an image") {
                
                stub(isHost("mywebservice.com")) { _ in
                    let stubData = "{ \"hi\":\"Hello World!\" }".dataUsingEncoding(NSUTF8StringEncoding)
                    return OHHTTPStubsResponse(data: stubData!, statusCode:200, headers:nil)
                }
                
                var success = false
                
                LoginKitConfig.url = "mywebservice.com/"
                let user = User(id: "testUN", username: "testPass")
                user.authToken = "awesometoken"
                LoginService.user = user
                
                Alamofire.request(.GET, "https://mywebservice.com/woot", parameters: ["foo": "bar"])
                    .responseJSON { response in
                        print("###")
                        print(response)
                        print(response.response)
                        print(response.data)
//                        self.data = response.result.value!["hi"]
//                        self.data = response.result.value!["hi"] //"Hello World!"
//                        NSLog("\(self.data)")
//                        expect(response.result.value!["hi"]) == "Hello World!" // .to(be(["hi":"Hello World!"]))
                }
                
                expect(self.data).toEventually(contain("Hello"))

            }
        }
    }

}