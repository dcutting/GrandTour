//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol CreatorInteractorOutput: class {
    
}

class CreatorInteractor {
    
    let locationStore: LocationStore
    weak var output: CreatorInteractorOutput?
    
    init(locationStore: LocationStore) {
        self.locationStore = locationStore
    }
    
//    func createLocation(named name: String, coordinate: MapCoordinate) {
//        let location = makeLocation(name: name, coordinate: coordinate)
//        locations.append(location)
//        presentLocations()
//    }

    //extension MapViewController: CreatorViewControllerDelegate {
    //
    //    func createLocation(named name: String) {
    //        let center = mapView.centerCoordinate
    //        let coordinate = MapCoordinate(latitude: center.latitude, longitude: center.longitude)
    //        presenter.createLocation(named: name, coordinate: coordinate)
    //    }
    //}

    func updateName(_ name: String) {
//        let valid = isValid(name: newLocationName)
//        output.setCanCreate(isEnabled: valid)
    }
    
    func createLocation() {
//        guard isValid(name: newLocationName) else { return }
//        store.createLocation(named: newLocationName)
//        router.dismissCreator()
    }
    
    private func isValid(name: String) -> Bool {
        return name.characters.count > 2
    }
}
