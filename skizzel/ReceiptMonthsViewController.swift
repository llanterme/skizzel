
import UIKit

class ReceiptMonthsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var api : APIController?
    let kCellIdentifier: String = "ReceiptMonthsCell"
    var receiptMonthsLists = [MonthsModel]()
    var refreshControl:UIRefreshControl!
  
  

    @IBOutlet weak var receiptMonthsTableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ProgressView.shared.showProgressView(view)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.hidesBackButton = false
        api = APIController(delegate: self)
        api!.getReceiptMonths()
        
        refreshControlSetup()
        
  
  
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return receiptMonthsLists.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell: MonthsTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as MonthsTableViewCell;
        
        let receipt = self.receiptMonthsLists[indexPath.row]
        
        cell.receiptMonth.text = receipt.receiptMonth + " " +  "(" + String (receipt.receiptCount) + ")"
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(netHex:0x5BCAFF)
            cell.receiptBlockImage.backgroundColor = UIColor(netHex:0x55EFCB)

        } else {
            cell.backgroundColor = UIColor(netHex:0xE0F8D8)
            cell.receiptBlockImage.backgroundColor = UIColor(netHex:0x81F3FD)
            cell.receiptMonth.textColor = UIColor(netHex:0x34AADC)
        }
        
      
        
        
        return cell
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.receiptMonthsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func didRecieveJsonArray(results: NSArray) {
        
        ProgressView.shared.hideProgressView()
        
        if(results.count != 0) {
        
        var resultsArr: NSArray = results[0] as? NSArray ?? []

        self.receiptMonthsLists = MonthsModel.getReceiptsMonth(results);
        self.receiptMonthsTableView!.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "categoryOverviewSegue" {
            
        var currentMonthIndex = receiptMonthsTableView!.indexPathForSelectedRow()!.row
        var selectedMonth = self.receiptMonthsLists[currentMonthIndex]

        var categoriesOverviewViewController: ReceiptCategoryViewController = segue.destinationViewController as ReceiptCategoryViewController
        categoriesOverviewViewController.filterDate = selectedMonth.receiptMonth;
            
        }
    }
    
    func refreshControlSetup(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.receiptMonthsTableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject)
    {
        api!.getReceiptMonths();
        self.receiptMonthsTableView!.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    
        
}

    

 

