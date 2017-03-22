//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

class MapRouter {
    
    let viewController: MapViewController
    let locationStore = LocationStore()
    var creatorModuleDelegate: CreatorModuleDelegate?
    
    var creatorRouter: CreatorRouter?
    
    init(mapViewController: MapViewController) {
        self.viewController = mapViewController
        wire()
    }
    
    func wire() {
        let interactor = MapInteractor(locationStore: locationStore)
        let presenter = MapPresenter(interactor: interactor, router: self)
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interface = viewController

        creatorModuleDelegate = presenter
    }
    
    func presentCreator(for coordinate: MapCoordinate) {
        creatorRouter = CreatorRouter(locationStore: locationStore, coordinate: coordinate, creatorModuleDelegate: creatorModuleDelegate)
        creatorRouter?.presentCreator(from: viewController)
    }
}
