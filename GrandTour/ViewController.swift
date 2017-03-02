//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var annotations: [MKAnnotation] = []

    override func viewDidLoad() {
        let location = CLLocationCoordinate2DMake(51.5, -0.1)
        let annotation = makeAnnotation(name: "London", coordinate: location)
        mapView.addAnnotation(annotation)
    }
    
    func makeAnnotation(name: String, coordinate: CLLocationCoordinate2D) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        return annotation
    }
}
