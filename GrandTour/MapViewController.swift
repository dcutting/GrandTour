//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let presenter = MapPresenter()
    
    override func viewDidLoad() {
        self.presenter.presentableView = self
        self.presenter.displayLocations()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createLandmark" {
            guard let creatorViewController = segue.destination as? CreatorViewController else { return }
            creatorViewController.delegate = self
        }
    }
}

extension MapViewController: MapPresentableView {
    
    func setLocations(_ locations: [MapLocation]) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        let updatedAnnotations = locations.map { location in
            makeAnnotation(from: location)
        }
        self.mapView.addAnnotations(updatedAnnotations)
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
        self.mapView.centerCoordinate = center
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.canShowCallout = true
        return annotationView
    }
}

extension MapViewController: CreatorViewControllerDelegate {

    func createdLocation(named name: String) {
        guard !name.isEmpty else { return }
        let center = self.mapView.centerCoordinate
        let coordinate = MapCoordinate(latitude: center.latitude, longitude: center.longitude)
        self.presenter.createLocation(named: name, coordinate: coordinate)
    }
}
