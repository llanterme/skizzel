
import Foundation

class ReceiptModel {
    
    var dateCreated: String
    var alias: String
    var category: String
    var filterDate: String
    var receiptId:Int
    var receiptImages: NSArray

    init(dateCreated:String, alias: String, category:String,filterDate:String, receiptId:Int, receiptImages:NSArray) {
        
        self.dateCreated = dateCreated
        self.alias = alias
        self.category = category
        self.receiptId = receiptId
        self.filterDate = filterDate
        self.receiptImages = receiptImages
        
    }
    
    
    class func getReceipts(allResults: NSArray) -> [ReceiptModel] {
        
        var receiptList = [ReceiptModel]()
        
        if allResults.count > 0 {
            
            for item in allResults {
                
                let dateCreated = item["DateCreated"] as? String ?? ""
                let alias = item["Alias"] as? String ?? ""
                let category = item["Category"] as? String ?? ""
                let filterDate = item["FilterDate"] as? String ?? ""
                let receiptImages = item["ReceiptImagesList"] as? NSArray ?? []
                var receiptId = item["ReceiptId"] as? Int ?? 0
                let userCategories = item["CategoriesList"] as? NSArray ?? []
                
                let newListItem = ReceiptModel(dateCreated:dateCreated, alias: alias, category:category, filterDate:filterDate, receiptId: receiptId, receiptImages:receiptImages);
                
                receiptList.append(newListItem)
            }
            
        }
        
        return receiptList;
        
    }

    
}
