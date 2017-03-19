//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let presenter = MapPresenter()
    
    override func viewDidLoad() {
        self.presenter.mapView = self
        self.presenter.displayLocations()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createLandmark" {
            guard let landmarkCreatorViewController = segue.destination as? LandmarkCreatorViewController else { return }
            landmarkCreatorViewController.delegate = self
        }
    }
}

extension MapViewController: MapView {
    
    func setLocations(_ locations: [MapLocation]) {
        // TODO
        print("setting locations")
    }
    
    func setCenter(coordinate: MapCoordinate) {
        // TODO
        print("setting center")
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.canShowCallout = true
        return annotationView
    }
}

extension MapViewController: LandmarkCreatorViewControllerDelegate {

    func createdLocation(named name: String) {
        guard !name.isEmpty else { return }
        let center = self.mapView.centerCoordinate
        let coordinate = MapCoordinate(latitude: center.latitude, longitude: center.longitude)
        self.presenter.createLocation(named: name, coordinate: coordinate)
    }
}
