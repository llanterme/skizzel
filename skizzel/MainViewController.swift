
import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var api : APIController?
    let kCellIdentifier: String = "ReceiptListCell"
    
    var receiptLists = [ReceiptModel]()


    @IBOutlet weak var receiptTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProgressView.shared.showProgressView(view)

        self.navigationItem.hidesBackButton = true;
        api = APIController(delegate: self)
        api!.getReceiptLists();
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
        
        return cell
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
        var userCategories:NSArray = results ["categoriesList"] as? NSArray ?? []
        Utils.setUserCategories(userCategories);
        
         var resultsArr: NSArray = results["receiptList"] as? NSArray ?? []
         self.receiptLists = ReceiptModel.getReceipts(resultsArr);
         self.receiptTable!.reloadData()
    }

}

