//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit
import MapKit

protocol MapViewControllerDelegate: class {
    func didTapCreateLocation()
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    weak var delegate: MapViewControllerDelegate?
    
    var centerCoordinate: MapCoordinate {
        get {
            let center = mapView.centerCoordinate
            return MapCoordinate(latitude: center.latitude, longitude: center.longitude)
        }
    }
    
    @IBAction func didTapCreateLocation(_ sender: Any) {
        delegate?.didTapCreateLocation()
    }

    func setLocations(_ locations: [MapLocation]) {
        mapView.removeAnnotations(mapView.annotations)
        let updatedAnnotations = locations.map { location in
            makeAnnotation(from: location)
        }
        mapView.addAnnotations(updatedAnnotations)
    }
    
    private func makeAnnotation(from location: MapLocation) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = location.name
        annotation.coordinate = makeLocationCoordinate2D(from: location.coordinate)
        return annotation
    }
    
    private func makeLocationCoordinate2D(from coordinate: MapCoordinate) -> CLLocationCoordinate2D {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func setCenter(coordinate: MapCoordinate) {
        let center = makeLocationCoordinate2D(from: coordinate)
        mapView.centerCoordinate = center
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.canShowCallout = true
        return annotationView
    }
}
