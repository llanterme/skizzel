

import Foundation

class CategoryCountModel {
    
    var categoryId: Int;
    var categoryCount: Int;
    var category: String;
    
    init(categoryId:Int, category:String, categoryCount:Int) {
        self.categoryId = categoryId
        self.category = category
        self.categoryCount = categoryCount
    }
    
    class func getCategoryCount(allResults: NSArray) -> [CategoryCountModel] {
        
        var categoriesList = [CategoryCountModel]()
        
        if allResults.count > 0 {
            
            for item in allResults {
                
                let categoryId = item["CategoryId"] as? Int ?? 0
                let category = item["ReceiptCategory"] as? String ?? ""
                let categoryCount = item["CategoryCount"] as? Int ?? 0
                
                let newListItem = CategoryCountModel(categoryId: categoryId, category: category,categoryCount:categoryCount);
                
                categoriesList.append(newListItem)
            }
            
        }
        
        return categoriesList;
        
    }
    
    
}

