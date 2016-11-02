import UIKit
import SVProgressHUD
import Alamofire

/**
 This LoginController displays a configurable login screen that is used by the rest
 of the library.
 */
open class LoginController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    let scrollView = UIScrollView(frame: UIScreen.main.bounds)

    var centerCoords: CGFloat {
        return (self.view.frame.size.width/2) - (235/2)
    }

    var username: UITextField = UITextField()
    var password: UITextField = UITextField()

    var savePasswordButton: UIButton!

    /** 
    This LoginController displays a configurable login screen that is used by the rest
     of the library.
     */
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = self.scrollView
    
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 200)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginController.stopEditing))
        view.addGestureRecognizer(tap)

        let logoHeader = header()
        view.addSubview(logoHeader)

        view.backgroundColor = Appearance.backgroundColor

        self.username = buildField("Username", top: 250)
        self.username.returnKeyType = .next
        self.password = buildField("Password", top: 320)
        self.password.returnKeyType = .go

        self.password.isSecureTextEntry = true
        self.view.addSubview(self.username)
        self.view.addSubview(self.password)

        self.savePasswordButton = UIButton()
        self.savePasswordButton.setTitle("Save login", for: UIControlState())

        // Get bundle image
        let normalImage = UIImage(named: "LoginKit.bundle/images/icon_unchecked", in: LoginKit.bundle(), compatibleWith: nil) ?? UIImage()
        let selectedImage = UIImage(named: "LoginKit.bundle/images/icon_checked", in: LoginKit.bundle(), compatibleWith: nil) ?? UIImage()

        
        self.savePasswordButton.setImage(normalImage, for: UIControlState())
        self.savePasswordButton.setImage(selectedImage, for: .selected)
        self.savePasswordButton.imageView?.tintColor = Appearance.whiteColor
        self.savePasswordButton.addTarget(self, action: #selector(LoginController.savePasswordTapped), for: .touchUpInside)
        self.view.addSubview(self.savePasswordButton)
        self.savePasswordButton.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        self.savePasswordButton.titleLabel?.font = self.password.font
        self.savePasswordButton.frame = CGRect(
            x: self.password.frame.minX,
            y: self.password.frame.maxY + 3,
            width: self.password.frame.width,
            height: self.password.frame.height)
        self.savePasswordButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: self.savePasswordButton.frame.width - (normalImage.size.width + 32.0), bottom: 0.0, right: 0.0)
        self.savePasswordButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: normalImage.size.width + 30)
        if LoginKitConfig.savedLogin == false {
            self.savePasswordButton.isHidden = true
        }

        let login = UIButton(type: UIButtonType.system)
        login.setTitle("Login", for: UIControlState())
        login.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        login.setTitleColor(UIColor.white, for: UIControlState())
        login.clipsToBounds = true
        login.layer.cornerRadius = 5
        login.sizeToFit()
        login.layer.borderColor = Appearance.buttonBorderColor.cgColor
        login.layer.borderWidth = 1.0
        login.backgroundColor = Appearance.buttonColor
        if LoginKitConfig.savedLogin == true {
            login.frame = CGRect(x: centerCoords, y: self.savePasswordButton.frame.maxY + 3, width: 235, height: 50)
        } else {
            login.frame = CGRect(x: centerCoords, y: self.password.frame.maxY + 20, width: 235, height: 50)
        }
        login.addTarget(self,
            action: #selector(LoginController.performLogin(_:)),
            for: UIControlEvents.touchUpInside)
        login.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        self.view.addSubview(login)
        
        let register = UIButton(type: UIButtonType.system)
        register.setTitle("Register", for: UIControlState())
        register.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        register.setTitleColor(UIColor.white, for: UIControlState())
        register.clipsToBounds = true
        register.layer.cornerRadius = 5
        register.sizeToFit()
        register.layer.borderColor = Appearance.buttonBorderColor.cgColor
        register.layer.borderWidth = 1.0
        register.backgroundColor = Appearance.buttonColor
        if LoginKitConfig.savedLogin == true {
            register.frame = CGRect(x: centerCoords, y: self.savePasswordButton.frame.maxY + 63, width: 235, height: 50)
        } else {
            register.frame = CGRect(x: centerCoords, y: self.password.frame.maxY + 80, width: 235, height: 50)
        }
        register.addTarget(self,
                        action: #selector(LoginController.register(_:)),
                        for: UIControlEvents.touchUpInside)
        register.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        
        self.view.addSubview(register)
        
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = LoginService.user {
            // Password is saved
            if user.authToken != nil {
                openDestination()
            } else {
                NSLog("ERROR")
            }
        }
        if let password = LoginService.user?.password, let username = LoginService.user?.username
            , password.characters.count > 0 && username.characters.count > 0 {
            openDestination()
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = LoginService.user {
            self.username.text = user.username
            self.password.text = user.password
        }
    }

    func header() -> UIView {
        let view: UIView = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200)
        let myImage = LoginKitConfig.logoImage
        let imageView = UIImageView(image: myImage)

        var imageFrame = imageView.frame
        imageFrame.size.height = 250
        imageFrame.size.width = self.view.frame.size.width
        imageView.frame = imageFrame
        view.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]

        imageView.contentMode = .scaleAspectFit
        imageView.bounds = imageView.frame.insetBy(dx: 20.0, dy: 25.0)
        view.addSubview(imageView)
        return view
    }

    func buildField(_ name: String, top: CGFloat) -> UITextField {
        let field = UITextField()
        field.sizeToFit()
        field.delegate = self
        let placeholderText = name
        let attrs = [NSForegroundColorAttributeName: UIColor.gray]
        let placeholderString = NSMutableAttributedString(string: placeholderText, attributes: attrs)
        field.attributedPlaceholder = placeholderString
        let cord: CGFloat = 235
        let width: CGFloat = 50
        field.frame = CGRect(x: centerCoords, y: top, width: cord, height: width)
        field.borderStyle = UITextBorderStyle.roundedRect

        // Enhancements
        field.autocorrectionType = UITextAutocorrectionType.no
        field.autocapitalizationType = UITextAutocapitalizationType.none
        field.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]

        return field
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.username {
            self.password.becomeFirstResponder()
        }
        
        if textField == self.password {
            self.performLogin(nil)
        }
        
        return false // We do not want UITextField to insert line-breaks.
    }

    func performLogin(_ sender: UIButton!) {

        if let username = self.username.text, let password = self.password.text
            , username.characters.count > 0 && password.characters.count > 0 {
            
            LoginService.user = User(id: username, username: username)
            LoginService.user?.password = password

                if LoginKitConfig.authType == AuthType.jwt {
                    let parameters: Alamofire.Parameters = [
                        "email": username as AnyObject,
                        "password": password as AnyObject
                    ]

                    SVProgressHUD.show()
                    LoginService.request(LoginKitConfig.loginPath, .post, parameters) //.validate()
                        .responseJSON { response in
                            SVProgressHUD.dismiss()


                            if response.result.isSuccess {
                                switch response.response!.statusCode {
                                case 201, 200:
                                    self.saveToken(response.result.value! as AnyObject)

                                default:
                                    print("performLogin action: unknown status code")
                                }
                            }
                    }

                }

                if LoginKitConfig.authType == AuthType.basic {

                    SVProgressHUD.show()
                    LoginService.request(LoginKitConfig.loginPath, HTTPMethod.get, nil) //.validate()
                        .authenticate(user: username, password: password)
                        .responseJSON() { response in
                            SVProgressHUD.dismiss()

                            if response.result.isSuccess {
                                switch response.response!.statusCode {
                                case 201, 200:
                                    self.openDestination()
                                default:
                                    print("performLogin action: unknown status code")
                                }
                            }
                    }
                }


        } else {
            let alert = UIAlertController(title: nil, message: "Please enter your username and password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func register(_ sender: UIButton!) {
        let registerController = RegistrationController()
        self.present(registerController, animated: true, completion: nil)
    }

    func saveToken(_ result: AnyObject) {
       
        guard let token = result["token"] as? String
        else {
            return;
        }

        let user = User(id: username.text!, username: username.text!)
        user.clearToken()
        user.authToken = token

        LoginService.user = user

        openDestination()
    }
    
    func stopEditing() {
        self.username.resignFirstResponder()
        self.password.resignFirstResponder()
    }

    func openDestination() {
        self.stopEditing()

        //        self.presentViewController(LoginService.destination, animated: true, completion: nil)

        // This could probably be done better - issue with being a framework and not having access to AppDelegate
        // "Application tried to present modally an active controller ios"
        // This also ensures we dont have any memory leaks
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController = LoginKitConfig.destination()
            window.makeKeyAndVisible()
        }
    }

    func savePasswordTapped() {
        self.savePasswordButton.isSelected = !self.savePasswordButton.isSelected
        LoginService.storePassword = self.savePasswordButton.isSelected
    }
    
    override open var shouldAutorotate : Bool {
        return true
    }
    
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }


}
