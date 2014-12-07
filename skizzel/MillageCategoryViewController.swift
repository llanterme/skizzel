
import UIKit

class MillageCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var api : APIController?
    let kCellIdentifier: String = "ReceiptCategoryCell"
    var categoryList = [CategoryCountModel]()
    var refreshControl:UIRefreshControl!
    var filterDate: String?
    
    
    @IBOutlet weak var categoryTableView: UITableView!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ProgressView.shared.showProgressView(view)
        api = APIController(delegate: self)
        api!.getCategoryCount(Utils.reformatSelectedMonth(filterDate!), type: "millage")
        refreshControlSetup()
        
        self.title = filterDate;
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryList.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell: CategoryCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as CategoryCell;
        
        let category = self.categoryList[indexPath.row]
        
        cell.category.text = category.category + " " +  "(" + String (category.categoryCount) + ")"
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(netHex:0x5BCAFF)
            cell.blockImage.backgroundColor = UIColor(netHex:0x55EFCB)
            
        } else {
            cell.backgroundColor = UIColor(netHex:0xE0F8D8)
            cell.blockImage.backgroundColor = UIColor(netHex:0x81F3FD)
            cell.category.textColor = UIColor(netHex:0x34AADC)
        }
        
        
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.categoryTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func refreshControlSetup(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.categoryTableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject)
    {
        api!.getCategoryCount(Utils.reformatSelectedMonth(filterDate!), type: "receipt")
        self.categoryTableView!.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func didRecieveJsonArray(results: NSArray) {
        
        ProgressView.shared.hideProgressView()
        
        
        if(results.count != 0) {
            
            var resultsArr: NSArray = results
            self.categoryList = CategoryCountModel.getCategoryCount(resultsArr);
            self.categoryTableView!.reloadData()
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "millageDetailsSegue" {
            
            var currentCategoryIndex = categoryTableView!.indexPathForSelectedRow()!.row
            var selectedCategory = self.categoryList[currentCategoryIndex]
            
            var millageOverviewViewController: MillageDetailsViewController = segue.destinationViewController as MillageDetailsViewController
            millageOverviewViewController.filterDate = self.filterDate
            millageOverviewViewController.selectedCategory = selectedCategory.categoryId
            millageOverviewViewController.selectedCategoryName = selectedCategory.category
            
            
        }
    }
}

