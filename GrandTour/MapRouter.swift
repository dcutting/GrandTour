//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

class MapRouter {
    
    let viewController: MapViewController
    let locationStore = LocationStore()
    
    init(mapViewController: MapViewController) {
        self.viewController = mapViewController
    }
    
    func wire() {
        let interactor = MapInteractor(locationStore: locationStore)
        let presenter = MapPresenter(interactor: interactor, router: self)
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interface = viewController
    }
    
    func presentCreator() {
        let creatorRouter = CreatorRouter(locationStore: locationStore)
        creatorRouter.presentCreator(from: viewController)
    }
}
