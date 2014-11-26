
import UIKit

class MillageDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var api : APIController?
    let kCellIdentifier: String = "MillageListCell"
    var millageLists = [MillageModel]()
    var filterDate: String?
    var refreshControl:UIRefreshControl!
    
    
    @IBOutlet weak var millageTableView: UITableView!
    override func viewDidLoad() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewDidLoad()
        
        ProgressView.shared.showProgressView(view)
        
        api = APIController(delegate: self)
        api!.getMillageList(Utils.reformatSelectedMonth(filterDate!))
     
        
        self.title = filterDate;
        
         refreshControlSetup()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return millageLists.count
        
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell: MillageDetailsCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as MillageDetailsCell;
        
        let millage = self.millageLists[indexPath.row]
        
        cell.millageAlias.text = millage.alias
        cell.millageDate.text = millage.dateCreated
        cell.millageCategory.text = millage.category
        cell.millageTotal.text = "\(millage.total.toString())" + "km"
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(netHex:0x5BCAFF)
            cell.millageBlockImage.backgroundColor = UIColor(netHex:0x55EFCB)
            cell.millageAlias.textColor = UIColor(netHex:0xFFFFFF)
            cell.millageDate.textColor = UIColor(netHex:0xFFFFFF)
            cell.millageCategory.textColor = UIColor(netHex:0xFFFFFF)
            cell.millageTotal.textColor = UIColor(netHex:0xFFFFFF)
            
        } else {
            cell.backgroundColor = UIColor(netHex:0xE0F8D8)
            cell.millageBlockImage.backgroundColor = UIColor(netHex:0x81F3FD)
            cell.millageAlias.textColor = UIColor(netHex:0x34AADC)
            cell.millageDate.textColor = UIColor(netHex:0x34AADC)
            cell.millageCategory.textColor = UIColor(netHex:0x34AADC)
            cell.millageTotal.textColor = UIColor(netHex:0x34AADC)
        }
        
        
        var cellSelectionColorView=UIView(frame:cell.frame)
        cellSelectionColorView.backgroundColor = UIColor(netHex:0xFF6666)
        cell.selectedBackgroundView = cellSelectionColorView;
        
        
        return cell
    }
    
    func didRecieveJson(results: NSDictionary) {
        
        ProgressView.shared.hideProgressView()
        
        
        var resultsArr: NSArray = results["MillageList"] as? NSArray ?? []
        
        self.millageLists = MillageModel.getMillages(resultsArr);
        self.millageTableView.reloadData()
         
    }
    
    func didRecieveError(error: NSError) {
        
        ProgressView.shared.hideProgressView()
        let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "Hmmm, something went wrong. Try again?"
        alert.addButtonWithTitle("OK")
        alert.show()
    
    }
    
    
    
    func refreshControlSetup(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.millageTableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject)
    {
        api!.getMillageList(Utils.reformatSelectedMonth(filterDate!));
        self.millageTableView!.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    
    
}





