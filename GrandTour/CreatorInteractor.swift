//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol CreatorInteractorOutput: class {
    func canCreateLocation()
    func cannotCreateLocation()
    func createdLocation()
}

class CreatorInteractor {
    
    let locationStore: LocationStore
    weak var output: CreatorInteractorOutput?
    let coordinate: MapCoordinate
    
    init(locationStore: LocationStore, coordinate: MapCoordinate) {
        self.locationStore = locationStore
        self.coordinate = coordinate
    }
    
    func validate(name: MapName) {
        if name.isValid() {
            output?.canCreateLocation()
        } else {
            output?.cannotCreateLocation()
        }
    }
    
    func createLocation(named name: MapName) {
        locationStore.createLocation(named: name, coordinate: coordinate)
        output?.createdLocation()
    }
}
