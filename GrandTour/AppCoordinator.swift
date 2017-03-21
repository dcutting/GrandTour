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
    
    fileprivate var locations = [MapLocation]()
    fileprivate var newLocationName = ""
    
    fileprivate var mapViewController: MapViewController
    fileprivate var creatorViewController: CreatorViewController?
    
    init(mapViewController: MapViewController) {
        self.mapViewController = mapViewController
        mapViewController.delegate = self
    }
    
    func start() {
        loadAndPresentLocations()
    }
    
    private func loadAndPresentLocations() {
        loadLocations { locations in
            DispatchQueue.main.async {
                self.setAndPresentLocations(locations)
            }
        }
    }
    
    private func setAndPresentLocations(_ locations: [MapLocation]) {
        self.locations = locations
        presentLocations()
        presentCenter()
    }
    
    func presentLocations() {
        mapViewController.setLocations(locations)
    }
    
    func presentCenter() {
        if let center = locations.first?.coordinate {
            mapViewController.setCenter(coordinate: center)
        }
    }
}

extension AppCoordinator: MapViewControllerDelegate {

    func didTapCreateLocation() {
        presentCreator()
    }
}

extension AppCoordinator: CreatorViewControllerDelegate {
    
    func updateLocation(name: String) {
        newLocationName = name
        let valid = isValid(name: name)
        creatorViewController?.setCanCreate(isEnabled: valid)
    }
    
    private func isValid(name: String) -> Bool {
        return name.characters.count > 2
    }

    func createLocation() {
        addLocationForCenterCoordinate()
        presentLocations()
        dismissCreator()
    }
    
    private func addLocationForCenterCoordinate() {
        let location = makeLocationForCenterCoordinate()
        locations.append(location)
    }
    
    private func makeLocationForCenterCoordinate() -> MapLocation {
        let center = mapViewController.centerCoordinate
        let coordinate = MapCoordinate(latitude: center.latitude, longitude: center.longitude)
        return makeLocation(name: newLocationName, coordinate: coordinate)
    }
}

extension AppCoordinator {
    
    fileprivate func presentCreator() {
        creatorViewController = loadCreatorViewController()
        guard let creatorViewController = creatorViewController else { return }
        creatorViewController.delegate = self
        mapViewController.present(creatorViewController, animated: true)
    }
    
    private func loadCreatorViewController() -> CreatorViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "creatorViewController")
        return controller as? CreatorViewController
    }
    
    fileprivate func dismissCreator() {
        creatorViewController?.dismiss(animated: true)
        creatorViewController = nil
    }
}

extension AppCoordinator {
    
    fileprivate func loadLocations(completion: @escaping ([MapLocation]) -> Void) {
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
    
    fileprivate func makeLocation(name: String, coordinate: MapCoordinate) -> MapLocation {
        return MapLocation(name: name, coordinate: coordinate)
    }
}
