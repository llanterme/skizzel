import UIKit
import Foundation
import Alamofire;


@objc protocol APIControllerProtocol {
    func didRecieveJson(results: NSDictionary)
    optional func didRecieveError(error: NSError)
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
    
    func getReceiptLists() {
        
        Alamofire.request(.GET, Utils.getPlistValue("API") + "/UserOverView/" + self.userId, parameters: nil)
            .responseJSON { (request, response, JSON, error) in
                
                if(error == nil) {
                    let jsonResults = JSON as Dictionary<String, NSObject>
                    self.delegate.didRecieveJson(jsonResults)
                }
                
        }
        
    }
    
    func authenticateUser(user: UserModel) {
        
        var parameters = ["email": user.email, "password": user.password];
        Alamofire.request(.POST, Utils.getPlistValue("API") + "/Authenticate", parameters: parameters,encoding: .JSON)
            .responseJSON
            { (request, response, JSON, error) in

                if (error == nil) {
                let jsonResults = JSON as Dictionary<String, NSObject>
                self.delegate.didRecieveJson(jsonResults)
                } else {
                    self.delegate.didRecieveError!(error!);
                }
                
        }
       
    }

    
    func createReceipt(categoryId:String, userId: String, alias:String, dateCreated:String) {
        
        
        var parameters = ["userId": userId, "categoryId": categoryId, "alias": alias, "dateCreated" : dateCreated];
        Alamofire.request(.POST, Utils.getPlistValue("API") + "/CreateReceipt", parameters: parameters,encoding: .JSON)
            .responseJSON
            { (request, response, JSON, error) in
                
                if (error == nil) {
                    let jsonResults = JSON as Dictionary<String, NSObject>
                    self.delegate.didRecieveJson(jsonResults)
                } else {
                    self.delegate.didRecieveError!(error!);
                }
                
        }
        
    }
    
    
    func UploadStreamAlmafire(image:UIImage) {
        
        var manager = Manager.sharedInstance;
        manager.session.configuration.HTTPAdditionalHeaders = ["Content-Type": "application/octet-stream"]
        
        
        let imageData: NSMutableData = NSMutableData.dataWithData(UIImageJPEGRepresentation(image, 30));
        
        Alamofire.upload(.POST, Utils.getPlistValue("API") + "/Upload",  imageData)
            .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                println(totalBytesWritten)
            }
            .responseString { (request, response, JSON, error) in
                println(request)
                println(response)
                println(JSON)
        }
        
        
    }

    
    
    
}


