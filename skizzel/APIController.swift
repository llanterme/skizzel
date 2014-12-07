import UIKit
import Foundation
import Alamofire



@objc protocol APIControllerProtocol {
    optional func didRecieveJson(results: NSDictionary)
    optional func didRecieveError(error: NSError)
    optional func didRecieveJsonArray(results: NSArray)
}

class APIController {
    
    var userId:String {
        get{
            return Utils.checkRegisteredUser();
        }
    }
    
    
    var delegate: APIControllerProtocol;
    
    init(delegate: APIControllerProtocol) {
        self.delegate = delegate
    }
    
    func getReceiptLists(selectedMonth:String, selectedCategory:Int) {
        
        var category = String(selectedCategory)
        
        var manager = Manager.sharedInstance;
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type": "application/json"]

       Alamofire.request(.GET, Utils.getPlistValue("API") + "/ReceiptOverview/" + self.userId + "/" + selectedMonth + "/" + category, parameters: nil)
            .responseJSON { (request, response, JSON, error) in

                if(error == nil) {
                    let jsonResults = JSON as Dictionary<String, NSObject>
                    self.delegate.didRecieveJson!(jsonResults)
                }
        }
        
    }
    
    
    func getMillageList(selectedMonth:String,selectedCategory:Int) {
        
          var category = String(selectedCategory)
        
        var manager = Manager.sharedInstance;
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type": "application/json"]
        
        Alamofire.request(.GET, Utils.getPlistValue("API") + "/MillageOverview/" + self.userId + "/" + selectedMonth + "/" + category, parameters: nil)
            .responseJSON { (request, response, JSON, error) in
                println(error)
                if(error == nil) {
                    let jsonResults = JSON as Dictionary<String, NSObject>
                    self.delegate.didRecieveJson!(jsonResults)
                } else {
                    self.delegate.didRecieveError!(error!);
                }
        }
        
    }
    
    func getMillageMonths() {
        
        var manager = Manager.sharedInstance;
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type": "application/json"]
        
        Alamofire.request(.GET, Utils.getPlistValue("API") + "/MillageDates/" + self.userId, parameters: nil)
            .responseJSON { (request, response, JSON, error) in
                if(error == nil) {
                    let jsonResults = JSON as NSArray
                    self.delegate.didRecieveJsonArray!(jsonResults)
                }
        }
        
    }
    
    func getReceiptMonths() {
        
        var manager = Manager.sharedInstance;
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type": "application/json"]
        
        Alamofire.request(.GET, Utils.getPlistValue("API") + "/UserDates/" + self.userId, parameters: nil)
            .responseJSON { (request, response, JSON, error) in
                if(error == nil) {
                    let jsonResults = JSON as NSArray
                    self.delegate.didRecieveJsonArray!(jsonResults)
                }
        }
        
    }
    
    func getCategoryCount(selectedMonth:String, type:String) {
        
        var manager = Manager.sharedInstance;
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type": "application/json"]
        
        Alamofire.request(.GET, Utils.getPlistValue("API") + "/UserCategoryCount/" + self.userId + "/" + selectedMonth + "/" + type, parameters: nil)
            .responseJSON { (request, response, JSON, error) in
                println(error)
                if(error == nil) {
                    let jsonResults = JSON as NSArray
                    self.delegate.didRecieveJsonArray!(jsonResults)
                }
        }
        
    }
    
    
    func authenticateUser(user: UserModel) {
        
        let parameters = [
           
            "user": [
                "Email": user.email,
                "Password": user.password

            ]
        ]

        
        Alamofire.request(.POST, Utils.getPlistValue("API") + "/Authenticate", parameters: parameters,encoding: .JSON)
            .responseJSON
            { (request, response, JSON, error) in

                if (error == nil) {
                let jsonResults = JSON as Dictionary<String, NSObject>
                self.delegate.didRecieveJson!(jsonResults)
                } else {
                    self.delegate.didRecieveError!(error!);
                }
                
        }
       
    }
    
    func registerUser(user: UserModel) {
        
        let parameters = [
            
            "user": [
                "Email": user.email,
                "Password": user.password,
                 "Name": user.name
                
            ]
        ]
        
        
        Alamofire.request(.POST, Utils.getPlistValue("API") + "/RegisterUser", parameters: parameters,encoding: .JSON)
            .responseJSON
            { (request, response, JSON, error) in

                if (error == nil) {
                    let jsonResults = JSON as Dictionary<String, NSObject>
                    self.delegate.didRecieveJson!(jsonResults)
                } else {
                    self.delegate.didRecieveError!(error!);
                }
                
        }
        
    }

    
    func createCategory(category: String) {
        
        let parameters = [
            
            "category": [
                "Category": category,
                "UserId": Utils.checkRegisteredUser()
                
            ]
        ]
        
        
        Alamofire.request(.POST, Utils.getPlistValue("API") + "/CreateCategory", parameters: parameters,encoding: .JSON)
            .responseJSON
            { (request, response, JSON, error) in

                if (error == nil) {
                    let jsonResults = JSON as Dictionary<String, NSObject>
                    self.delegate.didRecieveJson!(jsonResults)
                } else {
                    self.delegate.didRecieveError!(error!);
                }
                
        }
        
    }

    
    
    
    func createReceipt(categoryId:String, userId: String, alias:String, dateCreated:String) {
        
        
        let parameters = [
            
            "receipt": [
                "Alias": alias,
                "UserId": userId,
                "CategoryId": categoryId,
                "DateCreated": dateCreated
                
            ]
        ]
        
        
        Alamofire.request(.POST, Utils.getPlistValue("API") + "/CreateReceipt", parameters: parameters,encoding: .JSON)
            .responseJSON
            { (request, response, JSON, error) in
                
                if (error == nil) {
                    let jsonResults = JSON as Dictionary<String, NSObject>
                    self.delegate.didRecieveJson!(jsonResults)
                } else {
                    self.delegate.didRecieveError!(error!);
                }
                
        }
        
    }
    
    func createMillage(categoryId:String, userId: String, alias:String, startLat:String, startLong:String, endLat:String, endLong:String) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = NSDate()
        let dateCreated = dateFormatter.stringFromDate(date)
        
        let parameters = [
            
            "millage": [
                "Alias": alias,
                "UserId": userId,
                "CategoryId": categoryId,
                "StartLat": startLat,
                "StartLong": startLong,
                "StopLat": endLat,
                "StopLong": endLong,
                "DateCreated": dateCreated
                
            ]
        ]
        
        
        Alamofire.request(.POST, Utils.getPlistValue("API") + "/CreateMillage", parameters: parameters,encoding: .JSON)
            .responseJSON
            { (request, response, JSON, error) in

                if (error == nil) {
                    let jsonResults = JSON as Dictionary<String, NSObject>
                    self.delegate.didRecieveJson!(jsonResults)
                } else {
                    self.delegate.didRecieveError!(error!);
                }
                
        }
        
    }
    
    
    func UploadStream(image:UIImage, receiptId:String) {
        
        var manager = Manager.sharedInstance;
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type": "application/octet-stream"]
        
        var url = Utils.getPlistValue("API") + "/UploadFile?fileName=file.jpg" + "_" + receiptId

        var imageData:NSData = UIImageJPEGRepresentation(image, 30)
        
        Alamofire.upload(.POST, url,  imageData)
            .responseJSON { (request, response, JSON, error) in
                
                if (error == nil) {
                    let jsonResults = JSON as Dictionary<String, NSObject>
                    self.delegate.didRecieveJson!(jsonResults)

                } else {
                    self.delegate.didRecieveError!(error!);
                }

        }
        
        
    }
    
    
}


