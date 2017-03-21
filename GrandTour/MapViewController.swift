//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        loadAnnotations { annotations in
            DispatchQueue.main.async {
                for annotation in annotations {
                    self.mapView.addAnnotation(annotation)
                }
                if let center = annotations.first?.coordinate {
                    self.mapView.centerCoordinate = center
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createLocation" {
            guard let creatorViewController = segue.destination as? CreatorViewController else { return }
            creatorViewController.delegate = self
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

extension MapViewController: CreatorViewControllerDelegate {

    func createLocation(named name: String) {
        let center = self.mapView.centerCoordinate
        let annotation = makeAnnotation(name: name, coordinate: center)
        self.mapView.addAnnotation(annotation)
    }
}

extension MapViewController {
    
    fileprivate func loadAnnotations(completion: @escaping ([MKAnnotation]) -> Void) {
        guard let url = Bundle.main.url(forResource: "landmarks", withExtension: "json") else {
            completion([])
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion([])
                return
            }
            do {
                guard let jsonLandmarks = try JSONSerialization.jsonObject(with: data) as? [Any] else {
                    completion([])
                    return
                }
                var annotations: [MKAnnotation] = []
                for jsonLandmark in jsonLandmarks {
                    guard let jsonLandmark = jsonLandmark as? [String: Any] else {
                        completion([])
                        return
                    }
                    guard let name = jsonLandmark["name"] as? String else {
                        completion([])
                        return
                    }
                    guard let jsonCoordinate = jsonLandmark["coordinate"] as? [String: Double] else {
                        completion([])
                        return
                    }
                    guard let latitude = jsonCoordinate["latitude"] else {
                        completion([])
                        return
                    }
                    guard let longitude = jsonCoordinate["longitude"] else {
                        completion([])
                        return
                    }
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let annotation = self.makeAnnotation(name: name, coordinate: coordinate)
                    annotations.append(annotation)
                }
                completion(annotations)
            } catch {
                completion([])
            }
        }
        task.resume()
    }
    
    fileprivate func makeAnnotation(name: String, coordinate: CLLocationCoordinate2D) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        return annotation
    }
}
