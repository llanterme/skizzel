import UIKit
import Foundation
import Alamofire;


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
    
    func getReceiptLists(selectedMonth:String) {
        
        var manager = Manager.sharedInstance;
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type": "application/json"]

       Alamofire.request(.GET, Utils.getPlistValue("API") + "/UserOverView/" + self.userId + "/" + selectedMonth, parameters: nil)
            .responseJSON { (request, response, JSON, error) in

                if(error == nil) {
                    let jsonResults = JSON as Dictionary<String, NSObject>
                    self.delegate.didRecieveJson!(jsonResults)
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
                println(error)
                if (error == nil) {
                    let jsonResults = JSON as Dictionary<String, NSObject>
                    self.delegate.didRecieveJson!(jsonResults)
                } else {
                    self.delegate.didRecieveError!(error!);
                }
                
        }
        
    }

    
    func createReceipt(categoryId:String, userId: String, alias:String, dateCreated:String) {
        
        var parameterss = ["userId": userId, "categoryId": categoryId, "alias": alias, "dateCreated" : dateCreated];
        
        
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
    
    
    func UploadStream(image:UIImage, receiptId:String) {
        
        var manager = Manager.sharedInstance;
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type": "application/octet-stream"]
        
        var url = Utils.getPlistValue("API") + "/UploadFile?fileName=file.jpg" + "_" + receiptId
        let imageData: NSMutableData = NSMutableData.dataWithData(UIImageJPEGRepresentation(image, 30));
        
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


