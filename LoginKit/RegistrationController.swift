/**
 The RegistrationController displays a configurable screen for users to register
 for a new account that is used by the rest of the library.
 */
public class RegistrationController: UIViewController {
    var newUsername: UITextField = UITextField()
    var newPassword: UITextField = UITextField()
    var newPasswordConfirm: UITextField = UITextField()
    var centerCoords: CGFloat {
        return (self.view.frame.size.width/2) - (235/2)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Appearance.backgroundColor
        
        self.newUsername = buildField("Username", top: 50)
        self.newPassword = buildField("Password", top: 120)
        self.newPasswordConfirm = buildField("Password Confirmation", top: 190)
        
        self.view.addSubview(self.newUsername)
        self.view.addSubview(self.newPassword)
        self.view.addSubview(self.newPasswordConfirm)
        
        let register = UIButton(type: UIButtonType.System)
        register.setTitle("Register", forState: UIControlState.Normal)
        register.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        register.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        register.clipsToBounds = true
        register.layer.cornerRadius = 5
        register.sizeToFit()
        register.layer.borderColor = Appearance.buttonBorderColor.CGColor
        register.layer.borderWidth = 1.0
        register.backgroundColor = Appearance.buttonColor
        register.addTarget(self,
                        action: #selector(RegistrationController.performRegistration(_:)),
                        forControlEvents: UIControlEvents.TouchUpInside)
        register.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        register.frame = CGRectMake(centerCoords, self.newPasswordConfirm.frame.maxY + 20, 235, 50)
        self.view.addSubview(register)
    }
    
    override public func shouldAutorotate() -> Bool {
        return true
    }
    
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    func buildField(name: String, top: CGFloat) -> UITextField {
        let field = UITextField()
        field.sizeToFit()
        let placeholderText = name
        let attrs = [NSForegroundColorAttributeName: UIColor.grayColor()]
        let placeholderString = NSMutableAttributedString(string: placeholderText, attributes: attrs)
        field.attributedPlaceholder = placeholderString
        let cord: CGFloat = 235
        let width: CGFloat = 50
        field.frame = CGRectMake(centerCoords, top, cord, width)
        field.borderStyle = UITextBorderStyle.RoundedRect
        
        // Enhancements
        field.autocorrectionType = UITextAutocorrectionType.No
        field.autocapitalizationType = UITextAutocapitalizationType.None
        field.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        
        return field
    }
    
    func performRegistration(sender: UIButton!) {
        
        if let username = self.newUsername.text, let password = self.newPassword.text
            where username.characters.count > 0 && password.characters.count > 0 {
            
            //TODO: 
            // * Send username and password to server
            // * Check for password that is not the same (validation)
            // * Check for password length
            // * Check for password strength
            
        } else {
            let alert = UIAlertController(title: nil, message: "Please enter a username and password.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    

    
    

}
