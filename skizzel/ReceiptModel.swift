
import Foundation

class ReceiptModel {
    
    var dateCreated: String
    var alias: String
    var filterDate: String
    var receiptId:Int
    var receiptImages: NSArray

    init(dateCreated:String, alias: String, filterDate:String, receiptId:Int, receiptImages:NSArray) {
        
        self.dateCreated = dateCreated
        self.alias = alias
        self.receiptId = receiptId
        self.filterDate = filterDate
        self.receiptImages = receiptImages
        
    }
    
    
    class func getReceipts(allResults: NSArray) -> [ReceiptModel] {
        
        var receiptList = [ReceiptModel]()
        
        if allResults.count > 0 {
            
            for item in allResults {
                
                let dateCreated = item["dateCreated"] as? String ?? ""
                let alias = item["alias"] as? String ?? ""
                let filterDate = item["filterDate"] as? String ?? ""
                let receiptImages = item["receiptImageCollection"] as? NSArray ?? []
                var receiptId = item["receiptId"] as? Int ?? 0
                let userCategories = item["categoriesList"] as? NSArray ?? []
                
                let newListItem = ReceiptModel(dateCreated:dateCreated, alias: alias, filterDate:filterDate, receiptId: receiptId, receiptImages:receiptImages);
                
                receiptList.append(newListItem)
            }
            
        }
        
        return receiptList;
        
    }

    
}
