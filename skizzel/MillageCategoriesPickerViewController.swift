import UIKit

protocol listPickProtcol {
    func didSelectItemsComplete(category:CategoriesModel, alias:String)
}

class MillageCategoriesPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var millageAlias: UITextField!
    let kCellIdentifier: String = "millageCategoryPicker"
    var delegate: listPickProtcol? = nil;
    var categoriesList = [CategoriesModel]()
    var selectedCategory: CategoriesModel = CategoriesModel(categoryId: 0,category: "")
    

    
    override func viewDidLoad() {
        
        categoriesList = CategoriesModel.getUserCategories();
        
        super.viewDidLoad()

    }
    
    
      func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return categoriesList.count
        
    }
    
    
    @IBAction func dismissPIcker(sender: AnyObject) {
        
        
        if((delegate) != nil) {
            
            delegate?.didSelectItemsComplete(selectedCategory, alias:millageAlias.text);
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
        
    }
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        
        var currentCategory = self.categoriesList[indexPath.row] as CategoriesModel;
        selectedCategory = currentCategory

        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
       
         selectedCell?.accessoryType = .Checkmark
       }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
         selectedCell?.accessoryType = .None
    }
        
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: MillageCategoriesCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as MillageCategoriesCell;
        
        let category = self.categoriesList[indexPath.row]
        
        cell.categoryName.text = category.category
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(netHex:0x5BCAFF)
             cell.categoryName.textColor = UIColor(netHex:0xFFFFFF)
            
        } else {
            cell.backgroundColor = UIColor(netHex:0xE0F8D8)
             cell.categoryName.textColor = UIColor(netHex:0x34AADC)
          
        }

        
        return cell
    }


}