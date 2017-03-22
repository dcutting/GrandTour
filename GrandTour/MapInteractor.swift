//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol MapInteractorOutput: class {
    func didFetchLocations(_ locations: [MapLocation])
    func setStartingLocation(_ location: MapLocation)
}

class MapInteractor {
    
    let locationStore: LocationStore
    weak var output: MapInteractorOutput?
    
    init(locationStore: LocationStore) {
        self.locationStore = locationStore
    }

    func startTour() {
        fetchAndOutputLocations() { [weak self] locations in
            if let first = locations.first {
                self?.output?.setStartingLocation(first)
            }
        }
    }
    
    func fetchLocations() {
        fetchAndOutputLocations()
    }
    
    private func fetchAndOutputLocations(completion: (([MapLocation]) -> Void)? = nil) {
        locationStore.fetchLocations { [weak self] locations in
            self?.output?.didFetchLocations(locations)
            completion?(locations)
        }
    }
}
