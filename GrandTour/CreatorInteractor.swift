//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol CreatorInteractorOutput: class {
    func setCanCreate(isEnabled: Bool)
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
    
    func updateName(_ name: String) {
        let valid = isValid(name: name)
        output?.setCanCreate(isEnabled: valid)
    }
    
    func createLocation(named name: String) {
        locationStore.createLocation(named: name, coordinate: coordinate)
        output?.createdLocation()
    }
    
    private func isValid(name: String) -> Bool {
        return name.characters.count > 2
    }
}
