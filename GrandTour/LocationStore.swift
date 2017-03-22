//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

class LocationStore {
    
    var locations: [MapLocation]?
    
    func fetchLocations(completion: @escaping ([MapLocation]) -> Void) {
        if let locations = locations {
            completion(locations)
        } else {
            loadLocations { [weak self] locations in
                self?.locations = locations
                completion(locations)
            }
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
    
    fileprivate func makeLocation(name: String, coordinate: MapCoordinate) -> MapLocation {
        return MapLocation(name: name, coordinate: coordinate)
    }
    
    func createLocation(named name: String, coordinate: MapCoordinate) {
        let location = makeLocation(name: name, coordinate: coordinate)
        locations?.append(location)
    }
}
