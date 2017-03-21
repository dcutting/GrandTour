//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol MapInteractorOutput: class {
    func didFetchLocations(_ locations: [MapLocation])
    func foundCenter(coordinate: MapCoordinate)
}

class MapInteractor {
    
    let locationStore: LocationStore
    
    weak var output: MapInteractorOutput?
    
    init(locationStore: LocationStore) {
        self.locationStore = locationStore
    }

    func fetchLocations() {
        locationStore.loadLocations { [weak self] locations in
            self?.processFetchedLocations(locations)
        }
    }
    
    private func processFetchedLocations(_ locations: [MapLocation]) {
        output?.didFetchLocations(locations)
        if let center = locations.first?.coordinate {
            output?.foundCenter(coordinate: center)
        }
    }
}
