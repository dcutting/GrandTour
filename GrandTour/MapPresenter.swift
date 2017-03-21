//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol MapInterface: class {
    func setLocations(_ locations: [MapLocation])
    func setCenter(coordinate: MapCoordinate)
}

class MapPresenter {
    
    let interactor: MapInteractor
    weak var interface: MapInterface?
    
    init(interactor: MapInteractor) {
        self.interactor = interactor
    }
    
    func refresh() {
        interactor.fetchLocations()
    }
}

extension MapPresenter: MapInteractorOutput {

    func didFetchLocations(_ locations: [MapLocation]) {
        interface?.setLocations(locations)
    }
    
    func setStartingLocation(_ location: MapLocation) {
        interface?.setCenter(coordinate: location.coordinate)
    }
}
