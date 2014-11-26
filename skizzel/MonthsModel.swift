
import Foundation

class MonthsModel {
    
    
    var receiptMonth: String
    var receiptCount: Int
    
    init(receiptMonth: String, receiptCount:Int) {
    self.receiptCount = receiptCount
    self.receiptMonth = receiptMonth
    
    }
    
    class func getReceiptsMonth(allResults: NSArray) -> [MonthsModel] {
        
        var receiptMonthsList = [MonthsModel]()
        
        if allResults.count > 0 {
            
            for item in allResults {
                
                let month = item["ReceiptMonth"] as? String ?? ""
                let count = item["MonthCount"] as? Int ?? 0
                
                let newListItem = MonthsModel(receiptMonth:month, receiptCount:count );
                
                receiptMonthsList.append(newListItem)
            }
            
        }
        
        return receiptMonthsList;
        
    }
    
}
