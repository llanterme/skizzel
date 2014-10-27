import Foundation
import UIKit

class Utils : UIViewController {
    
    
    class func setLocalUser(userId: String) {
        
        NSUserDefaults.standardUserDefaults().setObject(userId, forKey:"UserId")
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    class func setUserCategories(categories: NSArray) {
        
        NSUserDefaults.standardUserDefaults().setObject(categories, forKey:"userCategories")
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    class func getUserCategories() -> NSArray{
        
        var userDefaults: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("userCategories")
        var userCategories = userDefaults as? NSArray ?? []
        
        return userCategories;
        
    }
    
    class func checkRegisteredUser() -> String{
        
        var doesUserExists: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("UserId")
        var userid = doesUserExists as? String ?? ""
        
        return userid;
        
    }
    
    class func getPlistValue(itemValue:String) -> String {
        
        let path = NSBundle.mainBundle().pathForResource("config", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        
        return dict.objectForKey(itemValue) as String;
    }
    
    class func reformatSelectedMonth(selectedMonth:NSString) -> NSString {

        var stringSplit: NSArray = selectedMonth.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet());
        var month: NSString = stringSplit.objectAtIndex(0) as NSString;
        var year: NSString = stringSplit.objectAtIndex(1) as NSString;
        
        var formattedSelectedDate = month + "_" + year
        return formattedSelectedDate;
        
    }
    

    
}

