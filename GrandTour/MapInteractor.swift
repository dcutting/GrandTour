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

    func fetchLocations() {
        locationStore.fetchLocations { [weak self] locations in
            self?.processFetchedLocations(locations)
        }
    }
    
    private func processFetchedLocations(_ locations: [MapLocation]) {
        output?.didFetchLocations(locations)
        if let first = locations.first {
            output?.setStartingLocation(first)
        }
    }
}
