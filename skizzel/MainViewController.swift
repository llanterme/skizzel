
import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var api : APIController?
    let kCellIdentifier: String = "ReceiptListCell"
    var receiptLists = [ReceiptModel]()
    var filterDate: String?
    var refreshControl:UIRefreshControl!

    @IBOutlet weak var receiptTable: UITableView!
    
    override func viewDidLoad() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewDidLoad()
        
        ProgressView.shared.showProgressView(view)

        api = APIController(delegate: self)
        api!.getReceiptLists(Utils.reformatSelectedMonth(filterDate!));
        refreshControlSetup()
        
        self.title = filterDate;
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return receiptLists.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    
        let cell: MainViewTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as MainViewTableViewCell;

        let receipt = self.receiptLists[indexPath.row]
        
        cell.receiptAlias.text = receipt.alias
        cell.receiptDateCreated.text = receipt.dateCreated
        cell.receiptCategpry.text = receipt.category
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(netHex:0x5BCAFF)
            cell.receiptBlockImage.backgroundColor = UIColor(netHex:0x55EFCB)
            
        } else {
            cell.backgroundColor = UIColor(netHex:0xE0F8D8)
            cell.receiptBlockImage.backgroundColor = UIColor(netHex:0x81F3FD)
            cell.receiptAlias.textColor = UIColor(netHex:0x34AADC)
            cell.receiptCategpry.textColor = UIColor(netHex:0x34AADC)
            cell.receiptDateCreated.textColor = UIColor(netHex:0x34AADC)
        }

        
        var cellSelectionColorView=UIView(frame:cell.frame)
        cellSelectionColorView.backgroundColor = UIColor(netHex:0xFF6666)
        cell.selectedBackgroundView = cellSelectionColorView;
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.receiptTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
         if segue.identifier == "receiptImagesViewSegue" {
        
        var receiptImagesViewController: ReceiptImagesViewController = segue.destinationViewController as ReceiptImagesViewController
        
       var receiptListIndex = receiptTable!.indexPathForSelectedRow()!.row
       var selectedList = self.receiptLists[receiptListIndex]
       receiptImagesViewController.currentReceipt = selectedList;
            
            
            
        }
        
         if segue.identifier == "createReceiptSegue" {
            var addReceiptViewController: AddReceiptTableViewController = segue.destinationViewController as AddReceiptTableViewController

        }
        
    

    }
    
    
    func didRecieveJson(results: NSDictionary) {
        
        ProgressView.shared.hideProgressView()
       
        //save categories to nsdefaults;
        var userCategories:NSArray = results["UserOverView"]?["CategoriesList"] as? NSArray ?? []
        Utils.setUserCategories(userCategories);
        
         var resultsArr: NSArray = results["UserOverView"]?["ReceiptList"] as? NSArray ?? []
        
         self.receiptLists = ReceiptModel.getReceipts(resultsArr);
         self.receiptTable!.reloadData()
        
        
        
    }
    
    
    
    func refreshControlSetup(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.receiptTable.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject)
    {
        api!.getReceiptLists(Utils.reformatSelectedMonth(filterDate!));
        self.receiptTable!.reloadData()
        self.refreshControl.endRefreshing()
    }
    
 

}



extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

