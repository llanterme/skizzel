
import UIKit

class AddReceiptTableViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, APIControllerProtocol {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet weak var createReceiptAlias: UITextField!
    @IBOutlet weak var createReceiptDateCreated: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    var userCategories = [CategoriesModel]()
   
    var selectedItem: Int = 0;
    var seletedDate: NSDate?
    
    var api : APIController?
    
    
    override func viewDidLoad() {
    
      api = APIController(delegate: self)
      userCategories = CategoriesModel.getUserCategories();

        
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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
       
        var pickerLabel = view as UILabel!
        if view == nil {
            pickerLabel = UILabel()
            
            let hue = CGFloat(row)/CGFloat(userCategories.count)
            
             if row % 2 == 0 {
            pickerLabel.backgroundColor = UIColor(netHex:0x5BCAFF)
            pickerLabel.textAlignment = .Center
                
             } else {
                pickerLabel.backgroundColor = UIColor(netHex:0x81F3FD)
                pickerLabel.textAlignment = .Center
            }
            
        }
        let titleData = userCategories[row].category
     
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0),NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        
        return pickerLabel
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.selectedItem = row;
    }
    
    func didRecieveJson(results: NSDictionary) {
        
         ProgressView.shared.hideProgressView()
        
        var receiptId = results["Message"] as? String
        var message = results["Status"] as? String
        
        if message == "success" {
            
            var uploadImageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("uploadImage") as UploadImagesViewController
            uploadImageViewController.currentReceiptId = receiptId?.toInt()
            self.presentViewController(uploadImageViewController, animated: true, completion: uploadControllerDismissed)

            
        } else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Hmmm, something went wrong. Try again?"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
    }
    
    func uploadControllerDismissed() {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func didRecieveError(error: NSError) {
        
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "An error has occured!"
        alert.addButtonWithTitle("OK")
        alert.show()
        
    }
    

    @IBAction func createReceipt(sender: AnyObject) {
        
          ProgressView.shared.showProgressView(view)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // superset of OP's format
        
        let selectedCategory = userCategories[self.selectedItem];
        
        let categoryId = String (selectedCategory.categoryId)
        let userId = Utils.checkRegisteredUser()
        let receiptAlias = createReceiptAlias.text
        let dateCreated = dateFormatter.stringFromDate(seletedDate!)
        
        api!.createReceipt(categoryId, userId: userId, alias: receiptAlias, dateCreated:dateCreated)
    }
   

    @IBAction func datePickerAction(sender: UIDatePicker) {
        
            printDate(sender.date)
          seletedDate = sender.date;

    }
    
    func printDate(date:NSDate){
        
        var formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd";
        let defaultTimeZoneStr = formatter.stringFromDate(date);
        
          println("Delivered at: " + defaultTimeZoneStr)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
   
}
