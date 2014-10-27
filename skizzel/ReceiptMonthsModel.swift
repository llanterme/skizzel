
import Foundation

class ReceiptMonthsModel {
    
    
    var receiptMonth: String
    var receiptCount: Int
    
    init(receiptMonth: String, receiptCount:Int) {
    self.receiptCount = receiptCount
    self.receiptMonth = receiptMonth
    
    }
    
    class func getReceiptsMonth(allResults: NSArray) -> [ReceiptMonthsModel] {
        
        var receiptMonthsList = [ReceiptMonthsModel]()
        
        if allResults.count > 0 {
            
            for item in allResults {
                
                let month = item["dateCreated"] as? String ?? ""
                let count = item["dateCount"] as? Int ?? 0
                
                let newListItem = ReceiptMonthsModel(receiptMonth:month, receiptCount:count );
                
                receiptMonthsList.append(newListItem)
            }
            
        }
        
        return receiptMonthsList;
        
    }
    
}
