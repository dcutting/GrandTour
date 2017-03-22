//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var presenter: MapPresenter!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.start()
    }

    @IBAction func tappedCreate(_ sender: Any) {
        let center = mapView.centerCoordinate
        presenter.tappedCreate(withLatitude: center.latitude, longitude: center.longitude)
    }
}

extension MapViewController: MapInterface {
    
    func setLocations(_ locations: [MapInterfaceLocation]) {
        DispatchQueue.main.async {
            self.updateAnnotations(for: locations)
        }
    }
    
    func setStartingCoordinate(latitude: Double, longitude: Double) {
        DispatchQueue.main.async {
            let center = self.makeLocationCoordinate2D(fromLatitude: latitude, longitude: longitude)
            self.mapView.centerCoordinate = center
        }
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.canShowCallout = true
        return annotationView
    }
}

extension MapViewController {
    
    fileprivate func updateAnnotations(for locations: [MapInterfaceLocation]) {
        mapView.removeAnnotations(mapView.annotations)
        let updatedAnnotations = locations.map { location in
            makeAnnotation(from: location)
        }
        mapView.addAnnotations(updatedAnnotations)
    }
    
    fileprivate func makeAnnotation(from location: MapInterfaceLocation) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = location.name
        annotation.coordinate = makeLocationCoordinate2D(fromLatitude: location.latitude, longitude: location.longitude)
        return annotation
    }
    
    fileprivate func makeLocationCoordinate2D(fromLatitude latitude: Double, longitude: Double) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
