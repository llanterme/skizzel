
import Foundation

class ReceiptImageModel {
    
    var imageURL: String;
    var imageId: Int;

    init(imageURL: String, imageId: Int) {
        self.imageURL = imageURL
        self.imageId = imageId
    }
    
    class func getReceiptImages(receiptImages:NSMutableArray) -> [ReceiptImageModel] {
        
        var receiptImageList = [ReceiptImageModel]()
        
        if receiptImages.count > 0 {
            
             for item in receiptImages as NSMutableArray {
             
                let receiptImageURL = item["ImageUrl"] as? String ?? ""
                let receiptImageId = item["ImageId"] as? Int ?? 0
                
              var newListItem = ReceiptImageModel(imageURL: receiptImageURL, imageId: receiptImageId)
                
              receiptImageList.append(newListItem);
            }
            
        }
        
        return receiptImageList;
    }
    
}