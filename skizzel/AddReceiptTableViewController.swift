
import UIKit

class AddReceiptTableViewController: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, APIControllerProtocol {
    
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var createReceiptDateCreated: UITextField!
    @IBOutlet weak var createReceiptAlias: UITextField!
    var userCategories = [CategoriesModel]()
    
   
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    var selectedItem: Int = 0;
    
    var api : APIController?
    
    
    override func viewDidLoad() {
    
      api = APIController(delegate: self)
      userCategories = CategoriesModel.getUserCategories();
      self.setDateCreated()
        
       super.viewDidLoad()

      
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     
        return userCategories.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(userCategories[row].category)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.selectedItem = row;
    }

    @IBAction func createReceiptAction(sender: AnyObject) {
        
        let selectedCategory = userCategories[self.selectedItem];
        
        let categoryId = String (selectedCategory.categoryId)
        let userId = Utils.checkRegisteredUser()
        let receiptAlias = createReceiptAlias.text
        let dateCreated = createReceiptDateCreated.text
            
        api!.createReceipt(categoryId, userId: userId, alias: receiptAlias, dateCreated:dateCreated)
    
    }
    
    func didRecieveJson(results: NSDictionary) {
        
        var receiptId = results["message"] as? String
        var message = results["status"] as? String
        
        println(message! + " " + receiptId!)
        if message == "success" {
            
            let alert = UIAlertView()
            alert.delegate = self;
            alert.title = "Alert"
            alert.message = "Receipt captured. Upload image?"
            alert.addButtonWithTitle("Yes")
            alert.addButtonWithTitle("No")
            alert.show()
            
            
        } else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Hmmm, something went wrong. Try again?"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
    }
    
    func didRecieveError(error: NSError) {
        
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "An error has occured!"
        alert.addButtonWithTitle("OK")
        alert.show()
        
    }
    
    func setDateCreated() {
        
        let date = NSDate.date();
        
        var formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd";
        let defaultTimeZoneStr = formatter.stringFromDate(date);
        
        self.createReceiptDateCreated.text = defaultTimeZoneStr

    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex{
            
        case 1:
            println("image picker dismessed")
            break;
        case 0:
            getImage()
            break;
        default:
            NSLog("Default");
            break;
            //Some code here..
            
        }
    }
    
    func getImage() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            
            var image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            image.allowsEditing = false
            
            self.presentViewController(image, animated: true, completion: nil)
        }
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        
        imagePreview.image=image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    @IBAction func uploadImageAction(sender: AnyObject) {
        
        api!.UploadStreamAlmafire(imagePreview.image!);
    }
    
    
   
}
