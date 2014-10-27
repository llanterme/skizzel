
import UIKit

class ReceiptMonthsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol, SideBarDelegate {
    
    var api : APIController?
    let kCellIdentifier: String = "ReceiptMonthsCell"
    var receiptMonthsLists = [ReceiptMonthsModel]()
    var refreshControl:UIRefreshControl!
    var sideBar:SideBar = SideBar()
    var isMenuOpen: Bool = false

    @IBOutlet weak var receiptMonthsTableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ProgressView.shared.showProgressView(view)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.hidesBackButton = true
        api = APIController(delegate: self)
        api!.getReceiptMonths()
        
        refreshControlSetup()
        
        sideBar = SideBar(sourceView: self.view, menuItems: ["first item", "second item", "funny item", "another item"])
        sideBar.delegate = self


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return receiptMonthsLists.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell: ReceiptMonthsTableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as ReceiptMonthsTableViewCell;
        
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
        
        var resultsArr: NSArray = results[0] as? NSArray ?? []
        self.receiptMonthsLists = ReceiptMonthsModel.getReceiptsMonth(results);
        self.receiptMonthsTableView!.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "receiptOverviewSegue" {
            
        var currentMonthIndex = receiptMonthsTableView!.indexPathForSelectedRow()!.row
        var selectedMonth = self.receiptMonthsLists[currentMonthIndex]

        var receiptOverviewViewController: MainViewController = segue.destinationViewController as MainViewController
        receiptOverviewViewController.filterDate = selectedMonth.receiptMonth;
            
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
    
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        if index == 0{
            println("0")
            
        } else if index == 1{
            
            println("1")
        }
    }
    
    
    @IBAction func showMenu(sender: AnyObject) {
        
        if(!isMenuOpen) {
            sideBar.showSideBar(true)
            isMenuOpen = true
        } else {
            sideBar.showSideBar(false)
            isMenuOpen = false
        }
    }
    
}

    

 
