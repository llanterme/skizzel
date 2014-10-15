
import UIKit

class RegisterViewController: UIViewController, APIControllerProtocol {
    
    
    var api : APIController?


    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    
    
    @IBAction func cancelRegAction(sender: AnyObject) {
        
    dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func registerAction(sender: AnyObject) {
        
        
        var email = userEmail.text
        var password = userPassword.text
        var name = userName.text
        
        var userModel = UserModel(name: name, email:email, password:password);
        api!.authenticateUser(userModel);
        
    }
    override func viewDidLoad() {
        
         api = APIController(delegate: self)
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
