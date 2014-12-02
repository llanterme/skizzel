
import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var myMap: MKMapView!
    var myRoute : MKRoute?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var point1 = MKPointAnnotation()
        var point2 = MKPointAnnotation()
        
        point1.coordinate = CLLocationCoordinate2DMake(25.0305, 121.5360)
        point1.title = "Taipei"
        point1.subtitle = "Taiwan"
        myMap.addAnnotation(point1)
        
        point2.coordinate = CLLocationCoordinate2DMake(24.9511, 121.2358)
        point2.title = "Chungli"
        point2.subtitle = "Taiwan"
        myMap.addAnnotation(point2)
        myMap.centerCoordinate = point2.coordinate
        myMap.delegate = self
        
        
        //Span of the map
        myMap.setRegion(MKCoordinateRegionMake(point2.coordinate, MKCoordinateSpanMake(0.7,0.7)), animated: true)
        
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
        myLineRenderer.strokeColor = UIColor.redColor()
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
