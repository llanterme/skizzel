import UIKit

class UploadImagesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, APIControllerProtocol, UIAlertViewDelegate {
    
    
    var squareView: UIView!
    var gravity: UIGravityBehavior!
    var animator: UIDynamicAnimator!
    var collision: UICollisionBehavior!
    
    var currentReceiptId: Int?;
     var api : APIController?

    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var imageUploadButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        api = APIController(delegate: self)
        
        imageUploadButton.hidden = true;
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    @IBAction func uploadImageAction(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            
            var image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            image.allowsEditing = false
            
            self.presentViewController(image, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        
        if (image != nil) {
         imagePreview.image = image
         self.dismissViewControllerAnimated(true, completion: nil)
        
         imageUploadButton.hidden = false;
            
        }
    }

    
    @IBAction func dismissModal(sender: AnyObject) {
           self.dismissViewControllerAnimated(true, completion: nil)
    }

  

    @IBAction func uploadImage(sender: AnyObject) {
        
        ProgressView.shared.showProgressView(view)
        api!.UploadStream(imagePreview.image!, receiptId: String (self.currentReceiptId!));
    }
    
    func didRecieveJson(results: NSDictionary) {
        
        ProgressView.shared.hideProgressView()
        var message = results["status"] as? String
        
        if(message == "success") {
            let alert = UIAlertView()
            alert.delegate = self
            alert.title = "Alert"
            alert.message = "Image uploaded succesfully. Upload another?"
            alert.addButtonWithTitle("Yes")
            alert.addButtonWithTitle("No")
            alert.show()
        }
        
    }
    
    func didRecieveError(error: NSError) {
        
        ProgressView.shared.hideProgressView()
        
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "An error has occured!"
        alert.addButtonWithTitle("Ok")
        alert.show()
        
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex{
            
        case 0:
            NSLog("Retry");
            break;
        case 1:
            navigateToMain()
            break;
        default:
            NSLog("Default");
            break;
            //Some code here..
            
        }
    }
    
    func navigateToMain() {
        
        
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    

}
