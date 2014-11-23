
import UIKit

class LandingTableViewController: UITableViewController, SideBarDelegate {
    
    var sideBar:SideBar = SideBar()
    var isMenuOpen: Bool = false
    
    override func viewDidLoad() {
          super.viewDidLoad()
        
         self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.hidesBackButton = true
        
        sideBar = SideBar(sourceView: self.view, menuItems: ["Catagories", "Millage", "Create"])
        sideBar.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        sideBar.showSideBar(false)
        isMenuOpen = false
    }
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        if index == 0{
            
        } else if index == 1{
            
            self.performSegueWithIdentifier("millageSegue", sender: nil)
        } else if index == 2 {
            self.performSegueWithIdentifier("createReceiptMonthsSegue", sender: nil)
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
