//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

struct MapCoordinate {
    let latitude: Double
    let longitude: Double
}

struct MapLocation {
    let name: String
    let coordinate: MapCoordinate
}

class AppCoordinator {
    
    var locations = [MapLocation]()
    
    var mapViewController: MapViewController
    var landmarkCreatorViewController: LandmarkCreatorViewController?
    
    init(mapViewController: MapViewController) {
        self.mapViewController = mapViewController
        mapViewController.delegate = self
    }
    
    func start() {
        loadAndPresentLocations()
    }
    
    func loadAndPresentLocations() {
        loadLocations { locations in
            DispatchQueue.main.async {
                self.locations = locations
                self.presentLocations()
                self.presentCenter()
            }
        }
    }
    
    func presentLocations() {
        mapViewController.setLocations(locations)
    }
    
    func presentCenter() {
        if let center = locations.first?.coordinate {
            mapViewController.setCenter(coordinate: center)
        }
    }
    
    private func loadLocations(completion: @escaping ([MapLocation]) -> Void) {
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
                var annotations: [MapLocation] = []
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
                    let coordinate = MapCoordinate(latitude: latitude, longitude: longitude)
                    let location = self.makeLocation(name: name, coordinate: coordinate)
                    annotations.append(location)
                }
                completion(annotations)
            } catch {
                completion([])
            }
        }
        task.resume()
    }
    
    func makeLocation(name: String, coordinate: MapCoordinate) -> MapLocation {
        return MapLocation(name: name, coordinate: coordinate)
    }
}

extension AppCoordinator: MapViewControllerDelegate {

    func didTapCreateLandmark() {
        presentLandmarkCreator()
    }
    
    func presentLandmarkCreator() {
        landmarkCreatorViewController = loadViewController(withIdentifier: "landmarkCreatorViewController") as? LandmarkCreatorViewController
        guard let landmarkCreatorViewController = landmarkCreatorViewController else { return }
        landmarkCreatorViewController.delegate = self
        mapViewController.present(landmarkCreatorViewController, animated: true)
    }

    func loadViewController(withIdentifier identifier: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}

extension AppCoordinator: LandmarkCreatorViewControllerDelegate {
    
    func createdLocation(named name: String) {
        let center = mapViewController.centerCoordinate
        let coordinate = MapCoordinate(latitude: center.latitude, longitude: center.longitude)
        createLocation(named: name, coordinate: coordinate)
    }

    func createLocation(named name: String, coordinate: MapCoordinate) {
        let location = makeLocation(name: name, coordinate: coordinate)
        locations.append(location)
        presentLocations()
    }
}
