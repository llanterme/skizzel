
import UIKit

class MillageMonthsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var api : APIController?
    let kCellIdentifier: String = "MillageMonthsCell"
    var MonthsLists = [MonthsModel]()
    var refreshControl:UIRefreshControl!

    
    @IBOutlet weak var milllageMonthsTableView: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ProgressView.shared.showProgressView(view)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.hidesBackButton = false
        api = APIController(delegate: self)
        api!.getMillageMonths()
        
        refreshControlSetup()
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MonthsLists.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell: MonthsTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as MonthsTableViewCell;
        
        let receipt = self.MonthsLists[indexPath.row]
        
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
        
        self.milllageMonthsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func didRecieveJsonArray(results: NSArray) {
        
        ProgressView.shared.hideProgressView()
        
        if(results.count != 0) {
            
            var resultsArr: NSArray = results[0] as? NSArray ?? []
            self.MonthsLists = MonthsModel.getReceiptsMonth(results);
            self.milllageMonthsTableView!.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "millageDetailsSegue" {
            
            var currentMonthIndex = milllageMonthsTableView!.indexPathForSelectedRow()!.row
            var selectedMonth = self.MonthsLists[currentMonthIndex]
            
            var millageDetailsViewController: MillageDetailsViewController = segue.destinationViewController as MillageDetailsViewController
            millageDetailsViewController.filterDate = selectedMonth.receiptMonth;
            
        }
    }
    
    func refreshControlSetup(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.milllageMonthsTableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject)
    {
        api!.getMillageMonths()
        self.milllageMonthsTableView!.reloadData()
        self.refreshControl.endRefreshing()
    }



}
