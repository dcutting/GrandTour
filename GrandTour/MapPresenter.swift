//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol MapInterface: class {
    func setLocations(_ locations: [MapLocation])
    func setCenter(coordinate: MapCoordinate)
}

class MapPresenter {
    
    let interactor: MapInteractor
    weak var router: MapRouter?
    weak var interface: MapInterface?
    
    init(interactor: MapInteractor, router: MapRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func start() {
        interactor.start()
    }
    
    func refresh() {
        interactor.fetchLocations()
    }
    
    func tappedCreate(withCoordinate coordinate: MapCoordinate) {
        router?.presentCreator(for: coordinate)
    }
}

extension MapPresenter: MapInteractorOutput {

    func fetchedLocations(_ locations: [MapLocation]) {
        interface?.setLocations(locations)
    }
    
    func setStartingLocation(_ location: MapLocation) {
        interface?.setCenter(coordinate: location.coordinate)
    }
}

extension MapPresenter: CreatorModuleDelegate {
    
    func createdLocation() {
        refresh()
    }
}
