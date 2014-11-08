
import UIKit

class RegisterViewController: UIViewController, APIControllerProtocol {
    
    
    var api : APIController?

    
    
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    
    @IBAction func registerUser(sender: AnyObject) {
        
          ProgressView.shared.showProgressView(view)
        
        
        var email = userEmail.text
        var password = userPassword.text
        var name = userName.text
        
        var userModel = UserModel(name: name, email:email, password:password);
        api!.registerUser(userModel);
    }
 
    @IBAction func cancelRegistration(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
     
    }
    override func viewDidLoad() {
        
          api = APIController(delegate: self)
         super.viewDidLoad()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func didRecieveJson(results: NSDictionary) {
        
          ProgressView.shared.hideProgressView()
        
        var userId = results["Message"] as? String
        var message = results["Status"] as? String
        
        if message == "success" {
            
            Utils.setLocalUser(userId!);
            dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    

}
