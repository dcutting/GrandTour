//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, LandmarkEditorViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedAnnotation: MKAnnotation?
    
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .infoDark)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            selectedAnnotation = view.annotation
            performSegue(withIdentifier: "showLandmark", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLandmark" {
            guard let landmarkViewController = segue.destination as? LandmarkViewController else { return }
            landmarkViewController.name = selectedAnnotation?.title ?? "unknown"
        } else if segue.identifier == "editLandmark" {
            guard let editLandmarkViewController = segue.destination as? LandmarkEditorViewController else { return }
            editLandmarkViewController.delegate = self
        }
    }
    
    func makeAnnotation(name: String, coordinate: CLLocationCoordinate2D) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        return annotation
    }
    
    func loadAnnotations(completion: @escaping ([MKAnnotation]) -> Void) {
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
    
    func didCompleteEditing(landmarkEditorViewController: LandmarkEditorViewController) {
        dismiss(animated: true)

        guard let name = landmarkEditorViewController.nameTextField.text, !name.isEmpty else {
            return
        }
        
        let center = mapView.centerCoordinate
        let annotation = makeAnnotation(name: name, coordinate: center)
        mapView.addAnnotation(annotation)
    }
}
