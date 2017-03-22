//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol MapInteractorOutput: class {
    func fetchedLocations(_ locations: [MapLocation])
    func setStartingCoordinate(_ coordinate: MapCoordinate)
}

class MapInteractor {
    
    let locationStore: LocationStore
    weak var output: MapInteractorOutput?
    
    init(locationStore: LocationStore) {
        self.locationStore = locationStore
    }

    func start() {
        fetchAndOutputLocations() { [weak self] locations in
            guard let coordinate = locations.first?.coordinate else { return }
            self?.output?.setStartingCoordinate(coordinate)
        }
    }
    
    func fetchLocations() {
        fetchAndOutputLocations()
    }
    
    private func fetchAndOutputLocations(completion: (([MapLocation]) -> Void)? = nil) {
        locationStore.fetchLocations { [weak self] locations in
            self?.output?.fetchedLocations(locations)
            completion?(locations)
        }
    }
}
