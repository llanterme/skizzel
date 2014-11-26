import Foundation

class MillageModel {
    
    var alias: String;
    var category: String;
    var dateCreated: String;
    var total: Double;
    
    
    init(alias: String, category:String, dateCreated:String, total:Double) {
        
        self.alias = alias
        self.category = category
        self.dateCreated = dateCreated
        self.total = total
        
    }
    
    class func getMillages(allResults: NSArray) -> [MillageModel] {
        
        var millageList = [MillageModel]()
        
        if allResults.count > 0 {
            
            for item in allResults {
                
                let dateCreated = item["DateCreated"] as? String ?? ""
                let alias = item["Alias"] as? String ?? ""
                let total = item["Total"] as? Double ?? 0
                let category = item["Category"] as? String ?? ""

                let newListItem = MillageModel(alias:alias, category: category, dateCreated:dateCreated, total:total)
                
                millageList.append(newListItem)
            }
            
        }
        
        return millageList;
        
    }

    
    
    
}
