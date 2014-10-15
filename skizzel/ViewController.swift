import UIKit

class ViewController: UITableViewController, APIControllerProtocol{
    
    var api : APIController?
    
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    
    @IBAction func loginAction(sender: AnyObject) {
        
        ProgressView.shared.showProgressView(view)
        
        var email = userEmail.text
        var password = userPassword.text
        
        var userModel = UserModel(name: "", email:email, password:password);
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
        
        ProgressView.shared.hideProgressView()
        
        var userId = results["message"] as? String
        var message = results["status"] as? String
        
        if message == "success" {
            
            Utils.setLocalUser(userId!);
            let mainViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainViewController") as MainViewController
            self.navigationController?.pushViewController(mainViewController, animated: true)
            
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


}

