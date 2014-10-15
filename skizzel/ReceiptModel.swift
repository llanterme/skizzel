
import Foundation

class ReceiptModel {
    
    var dateCreated: String
    var alias: String
    var receiptImages: NSArray

    init(dateCreated:String, alias: String, receiptImages:NSArray) {
        
        self.dateCreated = dateCreated
        self.alias = alias
        self.receiptImages = receiptImages
    }
    
    
    class func getReceipts(allResults: NSArray) -> [ReceiptModel] {
        
        var receiptList = [ReceiptModel]()
        
        if allResults.count > 0 {
            
            for item in allResults {
                
                let dateCreated = item["dateCreated"] as? String ?? ""
                let alias = item["alias"] as? String ?? ""
                let receiptImages = item["receiptImageCollection"] as? NSArray ?? []
                let userCategories = item["categoriesList"] as? NSArray ?? []
                
                let newListItem = ReceiptModel(dateCreated:dateCreated, alias: alias, receiptImages:receiptImages);
                
                receiptList.append(newListItem)
            }
            
        }
        
        return receiptList;
        
    }

    
}
