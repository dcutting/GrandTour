//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

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
    
    func tappedCreate(withLatitude latitude: Double, longitude: Double) {
        let coordinate = MapCoordinate(latitude: latitude, longitude: longitude)
        router?.presentCreator(for: coordinate)
    }
}

extension MapPresenter: MapInteractorOutput {

    func fetchedLocations(_ locations: [MapLocation]) {
        let formattedLocations = format(locations: locations)
        interface?.setLocations(formattedLocations)
    }
    
    private func format(locations: [MapLocation]) -> [PresentableLocation] {
        return locations.map {
            PresentableLocation(name: $0.name.value, latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
        }
    }
    
    func setStartingCoordinate(_ coordinate: MapCoordinate) {
        interface?.setStartingCoordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

extension MapPresenter: CreatorModuleDelegate {
    
    func createdLocation() {
        interactor.fetchLocations()
    }
}
