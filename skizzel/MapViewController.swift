
import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var myMap: MKMapView!
    var myRoute : MKRoute?
    var startLat:CLLocationDegrees?
    var startLong:CLLocationDegrees?
    var stopLat:CLLocationDegrees?
    var stopLong:CLLocationDegrees?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var point1 = MKPointAnnotation()
        var point2 = MKPointAnnotation()
        
        myMap.mapType = MKMapType.Hybrid

        
        point1.coordinate = CLLocationCoordinate2DMake(startLat!, startLong!)
        point1.title = "Taipei"
        point1.subtitle = "Taiwan"
        myMap.addAnnotation(point1)
        
        point2.coordinate = CLLocationCoordinate2DMake(stopLat!, stopLong!)
        point2.title = "Chungli"
        point2.subtitle = "Taiwan"
        myMap.addAnnotation(point2)
        myMap.centerCoordinate = point2.coordinate
        myMap.delegate = self
        
        
        
        //Span of the map
        myMap.setRegion(MKCoordinateRegionMake(point2.coordinate, MKCoordinateSpanMake(0.1,0.1)), animated: true)
        
        var directionsRequest = MKDirectionsRequest()
        let markTaipei = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
        let markChungli = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
        
        directionsRequest.setSource(MKMapItem(placemark: markChungli))
        directionsRequest.setDestination(MKMapItem(placemark: markTaipei))
        directionsRequest.transportType = MKDirectionsTransportType.Automobile
        var directions = MKDirections(request: directionsRequest)
        directions.calculateDirectionsWithCompletionHandler { (response:MKDirectionsResponse!, error: NSError!) -> Void in
            if error == nil {
                self.myRoute = response.routes[0] as? MKRoute
                self.myMap.addOverlay(self.myRoute?.polyline)
            }
        }
        
        
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        var myLineRenderer = MKPolylineRenderer(polyline: myRoute?.polyline!)
       //  var myLineRenderer = MKPolylineRenderer(overlay: overlay)
        myLineRenderer.strokeColor = UIColor.blueColor()
        myLineRenderer.lineWidth = 4
        return myLineRenderer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
