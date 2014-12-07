import Foundation
import CoreLocation

class MillageModel {
    
    var alias: String;
    var category: String;
    var dateCreated: String;
    var total: Double;
    var startLat:Double?
    var startLong:Double?
    var stopLat:Double?
    var stopLong:Double?
    
    
    init(alias: String, category:String, dateCreated:String, total:Double, startLat:Double,startLong:Double,stopLat:Double, stopLong:Double) {
        
        self.alias = alias
        self.category = category
        self.dateCreated = dateCreated
        self.total = total
        self.startLat = startLat
        self.startLong = startLong
        self.stopLat = stopLat
        self.stopLong = stopLong
        
    }
    
    class func getMillages(allResults: NSArray) -> [MillageModel] {
        
        var millageList = [MillageModel]()
        
        if allResults.count > 0 {
            
            for item in allResults {
                
                let dateCreated = item["DateCreated"] as? String ?? ""
                let alias = item["Alias"] as? String ?? ""
                let total = item["Total"] as? Double ?? 0
                let category = item["Category"] as? String ?? ""
                let startLatRaw = item["StartLat"] as? String ?? ""
                let startLongRaw = item["StartLong"] as? String ?? ""
                let stopLatRaw = item["StopLat"] as? String ?? ""
                let stopLongRaw = item["StopLong"] as? String ?? ""
                
                let startLat = NSString(string: startLatRaw)
                let startLong = NSString(string: startLongRaw)
                let stopLat = NSString(string: stopLatRaw)
                let stopLong = NSString(string: stopLongRaw)



                let newListItem = MillageModel(alias:alias, category: category, dateCreated:dateCreated, total:total, startLat:startLat.doubleValue,startLong:startLong.doubleValue,stopLat:stopLat.doubleValue,stopLong:stopLong.doubleValue)
                
                millageList.append(newListItem)
            }
            
        }
        
        return millageList;
        
    }

    
    
    
}
