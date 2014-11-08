
import UIKit
import CoreLocation

class MillageViewController: UIViewController, CLLocationManagerDelegate {

    
    var imageTapped:Bool = false
    @IBOutlet weak var imageControl: UIImageView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapped"))
        imageControl.addGestureRecognizer(singleTap);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tapped()
    {
        
        if(!imageTapped) {
        imageControl.image = UIImage(named: "2.png")
        imageTapped = true
         enableLocation()
        } else {
            imageControl.image = UIImage(named: "1.png")
            imageTapped = false
          disableLocation()
        }
        
    }
    
    func enableLocation()  {
        
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
            print(error)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as CLLocation
        var coord = locationObj.coordinate
        println(coord.latitude)
        println(coord.longitude)
    }
    
    func disableLocation() {
        locationManager.stopUpdatingLocation();
        
        var travelStartLocation = "151.211|-33.8634"
        

        
        
    }

    

  
    
}
