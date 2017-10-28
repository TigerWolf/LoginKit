/**
 The RegistrationController displays a configurable screen for users to register
 for a new account that is used by the rest of the library.
 */
import Alamofire
import SVProgressHUD

open class RegistrationController: UIViewController, UIScrollViewDelegate {
    
    let scrollView = UIScrollView(frame: UIScreen.main.bounds)
    
    var newUsername: UITextField = UITextField()
    var newPassword: UITextField = UITextField()
    var newPasswordConfirm: UITextField = UITextField()
    var centerCoords: CGFloat {
        return (self.view.frame.size.width/2) - (235/2)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = self.scrollView
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 200)
        
        view.backgroundColor = Appearance.backgroundColor
        
        self.newUsername = buildField("Email", top: 50)
        self.newPassword = buildField("Password", top: 120)
        self.newPasswordConfirm = buildField("Password Confirmation", top: 190)
        
        self.newPassword.isSecureTextEntry = true
        self.newPasswordConfirm.isSecureTextEntry = true
        
        self.view.addSubview(self.newUsername)
        self.view.addSubview(self.newPassword)
        self.view.addSubview(self.newPasswordConfirm)
        
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
        register.addTarget(self,
                        action: #selector(RegistrationController.performRegistration(_:)),
                        for: UIControlEvents.touchUpInside)
        register.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        register.frame = CGRect(x: centerCoords, y: self.newPasswordConfirm.frame.maxY + 20, width: 235, height: 50)
        self.view.addSubview(register)
        
        let cancel = UIButton(type: UIButtonType.system)
        cancel.setTitle("Cancel", for: UIControlState())
        cancel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cancel.setTitleColor(UIColor.white, for: UIControlState())
        cancel.clipsToBounds = true
        cancel.layer.cornerRadius = 5
        cancel.sizeToFit()
        cancel.layer.borderColor = Appearance.buttonBorderColor.cgColor
        cancel.layer.borderWidth = 1.0
        cancel.backgroundColor = Appearance.buttonColor
        cancel.addTarget(self,
                           action: #selector(RegistrationController.cancel(_:)),
                           for: UIControlEvents.touchUpInside)
        cancel.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        cancel.frame = CGRect(x: centerCoords, y: self.newPasswordConfirm.frame.maxY + 80, width: 235, height: 50)
        self.view.addSubview(cancel)
    }
    
    override open var shouldAutorotate : Bool {
        return true
    }
    
    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    func buildField(_ name: String, top: CGFloat) -> UITextField {
        let field = UITextField()
        field.sizeToFit()
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
    
    func cancel(_ sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func performRegistration(_ sender: UIButton!) {
        
        if let username = self.newUsername.text, let password = self.newPassword.text
            , username.characters.count > 0 && password.characters.count > 0 {
            
            let parameters: Alamofire.Parameters = [
                "user": [
                    "name": username as AnyObject,
                    "email": username as AnyObject,
                    "password": password as AnyObject
                ]
            ]
            
            LoginService.request(LoginKitConfig.registerPath, .post, parameters) .responseJSON { response in
                SVProgressHUD.dismiss()
                
                NSLog("\(response.response!.statusCode)")
                
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json)")
                }
                
                if response.result.isSuccess {
                    
                    switch response.response!.statusCode {
                    case 201, 200:
                        
                        let alert = UIAlertController(title: "Success", message: "Account created successfully. \r\n Login with your new account now.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in self.confirmRegister()}))
                            
                        self.present(alert, animated: true, completion: nil)
                        //TODO: Set username on login page to new user
                    case 500:
                        NSLog("FAIL!")
                    default:
                        print("performLogin action: unknown status code")
                    }
                }
            }

            //TODO:
            // * Send username and password to server
            // * Check for password that is not the same (validation)
            // * Check for password length
            // * Check for password strength
            
        } else {
            let alert = UIAlertController(title: nil, message: "Please enter a username and password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    open func confirmRegister(){
        self.dismiss(animated: true, completion: nil)
    }
    

    
    

}
