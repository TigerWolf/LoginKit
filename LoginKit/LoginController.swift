import UIKit
import SVProgressHUD
import SwiftyJSON

class LoginController: UIViewController {

    var center_coords: CGFloat {
        return (self.view.frame.size.width/2) - (235/2)
    }

    var url: String = ""

    var username: UITextField = UITextField()
    var password: UITextField = UITextField()

    var savePasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

//        let the_header = header()
//        view.addSubview(the_header)

        view.backgroundColor = Appearance.backgroundColor

        self.username = build_field("Username", top: 250)
        self.password = build_field("Password", top: 320)
        self.password.secureTextEntry = true
        self.view.addSubview(self.username)
        self.view.addSubview(self.password)

        self.savePasswordButton = UIButton()
        self.savePasswordButton.setTitle("Keep me logged in", forState: .Normal)
        //Get bundle image
        let normalImage = UIImage(named: "icon_unchecked", inBundle: NSBundle(forClass: LoginKit.self), compatibleWithTraitCollection: nil)!
        let selectedImage = UIImage(named: "icon_checked", inBundle: NSBundle(forClass: LoginKit.self), compatibleWithTraitCollection: nil)!

        self.savePasswordButton.setImage(normalImage, forState: .Normal)
        self.savePasswordButton.setImage(selectedImage, forState: .Selected)
        self.savePasswordButton.imageView?.tintColor = Appearance.whiteColor
        self.savePasswordButton.addTarget(self, action: "savePasswordTapped", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.savePasswordButton)
        self.savePasswordButton.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        self.savePasswordButton.titleLabel?.font = self.password.font
        self.savePasswordButton.frame = CGRectMake(
            self.password.frame.minX,
            self.password.frame.maxY + 3,
            self.password.frame.width,
            self.password.frame.height)
        self.savePasswordButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, self.savePasswordButton.frame.width - (normalImage.size.width + 32.0), 0.0, 0.0)
        self.savePasswordButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, normalImage.size.width + 30);

        let login = UIButton(type: UIButtonType.System)
        login.setTitle("Login", forState: UIControlState.Normal)
        login.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        login.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
        login.clipsToBounds = true
        login.layer.cornerRadius = 5
        login.sizeToFit()
        login.layer.borderColor = Appearance.whiteColor.CGColor
        login.layer.borderWidth = 1.0
        login.backgroundColor = Appearance.buttonColor
        login.frame = CGRectMake(center_coords, self.savePasswordButton.frame.maxY + 3, 235, 50)
        login.addTarget(self,
            action: "perform_login:",
            forControlEvents: UIControlEvents.TouchUpInside)
        login.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        self.view.addSubview(login)
    }

    override func viewDidAppear(animated: Bool) {
        if let user = LoginService.user {
            // Password is saved
            if user.authToken != nil {
                open_destination()
            }
        }
    }

    func header() -> UIView {
        let view:UIView = UIView()
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 200)
        let myImage = UIImage(named: "uofa_logo_vertical")
        let imageView = UIImageView(image: myImage)

        var imageFrame = imageView.frame
        imageFrame.size.height = 250
        imageFrame.size.width = self.view.frame.size.width
        imageView.frame = imageFrame
        view.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]

        imageView.contentMode = .ScaleAspectFit
        imageView.bounds = CGRectInset(imageView.frame, 10.0, 10.0)
        view.addSubview(imageView)
        return view
    }

    func build_field(name: String, top: CGFloat) -> UITextField {
        let field = UITextField()
        field.sizeToFit()
        let placeholderText = name
        let attrs = [NSForegroundColorAttributeName : UIColor.grayColor()]
        let placeholderString = NSMutableAttributedString(string: placeholderText, attributes:attrs)
        field.attributedPlaceholder = placeholderString
        let cord: CGFloat = 235
        let width: CGFloat = 50
        field.frame = CGRectMake(center_coords, top, cord, width)
        field.borderStyle = UITextBorderStyle.RoundedRect

        // Enhancements
        field.autocorrectionType = UITextAutocorrectionType.No
        field.autocapitalizationType = UITextAutocapitalizationType.None
        field.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]

        return field
    }

    func perform_login(Sender: UIButton!) {

        if let username = self.username.text, let password = self.password.text
            where username.characters.count > 0 && password.characters.count > 0 {

                let parameters: Dictionary<String, AnyObject> = [
                    "username": username,
                    "password": password
                ]

                SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black)
                LoginService.request(.POST, "", parameters: parameters).validate()
                    .responseJSON() { response in
                        SVProgressHUD.dismiss()


                        if response.result.isSuccess {
                            switch response.response!.statusCode {
                            case 201:
                                self.login(response.result.value!)

                            default:
                                print("perform_login action: unknown status code")
                            }
                        }
                }

        } else {
            let alert = UIAlertController(title: nil, message: "Please enter your username and password.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    func login(result: AnyObject) {
        #if !RELEASE
            NSLog("GET Result: \(result)")
        #endif

        var json = JSON(result)

        let user = User(id: username.text!, username: username.text!)
        user.clearToken()
        user.authToken = json["token"].stringValue

        LoginService.user = user

        NSLog("success!")


        open_destination()
    }
    
    func open_destination(){
        //        self.presentViewController(LoginService.destination, animated: true, completion: nil)
        
        // This could probably be done better - issue with being a framework and not having access to AppDelegate
        // "Application tried to present modally an active controller ios"
        // This also ensures we dont have any memory leaks
        if let window = UIApplication.sharedApplication().keyWindow {
            window.rootViewController = LoginService.destination
            window.makeKeyAndVisible()
        }
    }

    func savePasswordTapped() {
        self.savePasswordButton.selected = !self.savePasswordButton.selected
        LoginService.storePassword = self.savePasswordButton.selected
    }

}
