import UIKit

class ViewController: UIViewController, APIControllerProtocol{
    
    var api : APIController?
    
    
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    
    

    @IBAction func userLogin(sender: AnyObject) {
      
        ProgressView.shared.showProgressView(view)
        
        var email = userEmail.text
        var password = userPassword.text
        
        var userModel = UserModel(name: "", email:email, password:password);
        api!.authenticateUser(userModel);
        
        
    }
    override func viewDidLoad() {

        api = APIController(delegate: self)
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "register" {
            
            var registerViewController: RegisterViewController = segue.destinationViewController as RegisterViewController
           
        }
        
        
    }
    

    
    
    func didRecieveJson(results: NSDictionary) {
        
        ProgressView.shared.hideProgressView()
        
        var userId = results["Message"] as? String
        var message = results["Status"] as? String
        
        if message == "success" {
            
            Utils.setLocalUser(userId!);
            
            //save categories to nsdefaults;
            var userCategories:NSArray = results["UserCategories"] as? NSArray ?? []
            Utils.setUserCategories(userCategories);

            
            let landingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("landingController") as LandingTableViewController
            self.navigationController?.pushViewController(landingViewController, animated: true)
            
        } else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Incorrect username / password!"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
    }
    
    func didRecieveError(error: NSError) {

        ProgressView.shared.hideProgressView()
        
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "An error has occured!"
        alert.addButtonWithTitle("OK")
        alert.show()
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }


}

