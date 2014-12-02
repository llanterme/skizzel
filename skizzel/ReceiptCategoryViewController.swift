
import UIkit

class ReceiptCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var api : APIController?
    let kCellIdentifier: String = "ReceiptCategoryCell"
    var categoryList = [CategoryCountModel]()
    var refreshControl:UIRefreshControl!
    var filterDate: String?
    

    @IBOutlet weak var receiptCategoryTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ProgressView.shared.showProgressView(view)
        api = APIController(delegate: self)
        api!.getCategoryCount(Utils.reformatSelectedMonth(filterDate!));
        refreshControlSetup()
        
        self.title = filterDate;
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryList.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell: ReceiptCategoryCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as ReceiptCategoryCell;
        
        let category = self.categoryList[indexPath.row]
        
        cell.receiptCategory.text = category.category + " " +  "(" + String (category.categoryCount) + ")"
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(netHex:0x5BCAFF)
            cell.blockImage.backgroundColor = UIColor(netHex:0x55EFCB)
            
        } else {
            cell.backgroundColor = UIColor(netHex:0xE0F8D8)
            cell.blockImage.backgroundColor = UIColor(netHex:0x81F3FD)
            cell.receiptCategory.textColor = UIColor(netHex:0x34AADC)
        }
        
        
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.receiptCategoryTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func refreshControlSetup(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.receiptCategoryTableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject)
    {
         api!.getCategoryCount(Utils.reformatSelectedMonth(filterDate!));
        self.receiptCategoryTableView!.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func didRecieveJsonArray(results: NSArray) {
        
        ProgressView.shared.hideProgressView()
      
    
         if(results.count != 0) {
        
        var resultsArr: NSArray = results
        self.categoryList = CategoryCountModel.getCategoryCount(resultsArr);
        self.receiptCategoryTableView!.reloadData()
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "receiptOverviewSegue" {
            
            var currentCategoryIndex = receiptCategoryTableView!.indexPathForSelectedRow()!.row
            var selectedCategory = self.categoryList[currentCategoryIndex]
            
            var receiptOverviewViewController: MainViewController = segue.destinationViewController as MainViewController
            receiptOverviewViewController.filterDate = self.filterDate
            receiptOverviewViewController.selectedCategory = selectedCategory.categoryId
            receiptOverviewViewController.selectedCategoryName = selectedCategory.category
            
            
        }
    }
    


}
