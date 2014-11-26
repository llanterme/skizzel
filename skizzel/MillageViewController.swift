
import UIKit
import CoreLocation

class MillageViewController: UIViewController, CLLocationManagerDelegate,APIControllerProtocol,listPickProtcol {

    
    
    @IBOutlet weak var startLat: UILabel!
    @IBOutlet weak var startAddress: UITextView!

    @IBOutlet weak var startLong: UILabel!
    @IBOutlet weak var startTime: UILabel!

    
    @IBOutlet weak var stopLat: UILabel!
    @IBOutlet weak var stopLong: UILabel!
    @IBOutlet weak var stopAddress: UITextView!
    @IBOutlet weak var endTime: UILabel!
   
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var endButton: UIButton!

    
    @IBOutlet weak var finishButton: UIBarButtonItem!
    
    let locationManager = CLLocationManager()
    var geocoder : CLGeocoder = CLGeocoder()
    var placemark : CLPlacemark = CLPlacemark()
    var coord:CLLocationCoordinate2D!
    var api : APIController?
    var startingLocationDic : NSDictionary = NSDictionary()
    var millageAlias: String =  String()
    var userCategories = CategoriesModel(categoryId: 0,category: "")
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         api = APIController(delegate: self)
        finishButton.enabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func getStartLocation(sender: AnyObject) {
        
        var emptyArray = []
        Utils.setTracking(emptyArray)
        clearEndLocation()
        enableLocation()

    }
   
    @IBAction func getStopLocation(sender: AnyObject) {
           enableLocation()
    }

    
    override func viewWillAppear(animated: Bool) {
        var startLocation = Utils.getTracking()
       
        if(startLocation.count != 0) {
            startLat.text = startLocation[0] as? String
            startLong.text = startLocation[1] as? String
            startAddress.text = startLocation[2] as? String
            startTime.text = startLocation[3] as? String
        }
    }
  
    
    func enableLocation()  {
        
        ProgressView.shared.showProgressView(view)

        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()

        } else {
            println("Location services are not enabled");
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            ProgressView.shared.hideProgressView()

            print(error)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as CLLocation
        coord = locationObj.coordinate


        locationManager.stopUpdatingLocation();
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
              
                ProgressView.shared.hideProgressView()
                println("Reverse geocode failed with error")
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                self.displayLocationInfo(pm)
               
            } else {
              
                println("Problem with the date recieved from geocoder")
            }
            
        })
            
        
    }
    
    
    func displayLocationInfo(placemark: CLPlacemark) {
        
        let startLocation = Utils.getTracking()
        let userLat = "\(coord.latitude)"
        let userLong = "\(coord.longitude)"
        var userStartTime = getTime()
        var tempString : String = ""

        if(placemark.locality != nil){
            tempString = tempString +  placemark.locality + "\n"
        }
        if(placemark.postalCode != nil){
            tempString = tempString +  placemark.postalCode + "\n"
        }
        if(placemark.administrativeArea != nil){
            tempString = tempString +  placemark.administrativeArea + "\n"
        }
        if(placemark.country != nil){
            tempString = tempString +  placemark.country + "\n"
        }

        if(startLocation.count == 0) {
       
        startAddress.text = tempString
        startLat.text = userLat
        startLong.text = userLong
        startTime.text = getTime()
       
        var locationArray=[userLat, userLong,tempString,userStartTime]
        Utils.setTracking(locationArray)
            
        } else {
            stopAddress.text = tempString
            stopLat.text = userLat
            stopLong.text = userLong
            endTime.text = getTime()
            nextButton.hidden = false
        }
        
        ProgressView.shared.hideProgressView()
    }
    
    func clearEndLocation() {
        
        nextButton.hidden = true
        stopLong.text = ""
        stopLat.text = ""
        stopAddress.text = ""
        endTime.text = ""
    }
    
    func clearStartLocation() {
        
      
        startLong.text = ""
        startLat.text = ""
        startAddress.text = ""
        startTime.text = ""
        Utils.setTracking([])
    }
    

    func didSelectItemsComplete(category:CategoriesModel, alias:String) {
 
        userCategories = category
        millageAlias = alias
        
        if(userCategories.categoryId != 0) {
        
        finishButton.enabled = true
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "millageCategoryPickerSegue" {
            
            self.userCategories = CategoriesModel(categoryId: 0,category: "")
            self.millageAlias = ""
            finishButton.enabled = false
            
            let listPickerViewController: MillageCategoriesPickerViewController = segue.destinationViewController as MillageCategoriesPickerViewController
            listPickerViewController.delegate = self;
        }
        
    }
    
    func getTime() -> String {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        return timestamp
    }


    @IBAction func saveMilage(sender: AnyObject) {
        
         ProgressView.shared.showProgressView(view)
        
        let categoryId = String (userCategories.categoryId)
        let userId = Utils.checkRegisteredUser()
        let userStartLat = startLat.text
        let userStartLong = startLong.text
        let userEndLat = stopLat.text
        let userEndLong = stopLong.text
        
        api?.createMillage(categoryId, userId: userId, alias: millageAlias, startLat: userStartLat!, startLong: userStartLong!, endLat: userEndLat!, endLong: userEndLong!)
    }
    
    func didRecieveJson(results: NSDictionary) {
        
        ProgressView.shared.hideProgressView()
        
        var millageId = results["Message"] as? String
        var message = results["Status"] as? String
        
        if message == "success" {
            finishButton.enabled = false
            clearEndLocation()
            clearStartLocation()
            
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Millage created sucessfully!"
            alert.addButtonWithTitle("OK")
            alert.show()
            
        } else {
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Hmmm, something went wrong. Try again?"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
    }
    
}
