
import Foundation

class CategoriesModel {
    
    var categoryId: Int;
    var category: String;

    init(categoryId:Int, category:String) {
        self.categoryId = categoryId
        self.category = category
    }
    
    class func getUserCategories() -> [CategoriesModel] {
        
        var userCategoriesRaw = Utils.getUserCategories();
        
        var categoriesList = [CategoriesModel]()
        
        if Utils.getUserCategories().count > 0 {
            
            for item in userCategoriesRaw {
                
                let categoryId = item["categoryId"] as? Int ?? 0
                let category = item["category"] as? String ?? ""
                
                let newListItem = CategoriesModel(categoryId: categoryId, category: category);
                
                categoriesList.append(newListItem)
            }
            
        }
        
        return categoriesList;
        
    }

    
}
