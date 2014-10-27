
import UIKit

class RegisterViewController: UIViewController, APIControllerProtocol {
    
    
    var api : APIController?

    
    
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    
    @IBAction func registerUser(sender: AnyObject) {
        
        api = APIController(delegate: self)
        
        var email = userEmail.text
        var password = userPassword.text
        var name = userName.text
        
        var userModel = UserModel(name: name, email:email, password:password);
        api!.authenticateUser(userModel);

        
    }
 
    @IBAction func cancelRegistration(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)

        
        
    }
    override func viewDidLoad() {
        
    
         super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func didRecieveJson(results: NSDictionary) {
        
        var userId = results["message"] as? String
        var message = results["status"] as? String
        
        if message == "success" {
            
            Utils.setLocalUser(userId!);
            dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    

}
