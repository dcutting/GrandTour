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
    
    func validate(name: String) {
        if isValid(name: name) {
            output?.canCreateLocation()
        } else {
            output?.cannotCreateLocation()
        }
    }
    
    private func isValid(name: String) -> Bool {
        return name.characters.count > 2
    }
    
    func createLocation(named name: String) {
        locationStore.createLocation(named: name, coordinate: coordinate)
        output?.createdLocation()
    }
}
