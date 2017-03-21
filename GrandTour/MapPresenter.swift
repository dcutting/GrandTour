//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

struct MapCoordinate {
    let latitude: Double
    let longitude: Double
}

struct MapLocation {
    let name: String
    let coordinate: MapCoordinate
}

protocol MapPresentableView: class {
    func setLocations(_ locations: [MapLocation])
    func setCenter(coordinate: MapCoordinate)
}

class MapPresenter {
    
    weak var presentableView: MapPresentableView?
    
    private var locations = [MapLocation]()
    
    func displayLocations() {
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
    
    private func presentLocations() {
        presentableView?.setLocations(locations)
    }
    
    private func presentCenter() {
        if let center = locations.first?.coordinate {
            presentableView?.setCenter(coordinate: center)
        }
    }
    
    func createLocation(named name: String, coordinate: MapCoordinate) {
        let location = makeLocation(name: name, coordinate: coordinate)
        locations.append(location)
        presentLocations()
    }
}

extension MapPresenter {
    
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
