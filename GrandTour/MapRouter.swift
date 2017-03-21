//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

class MapRouter {
    
    func wire(viewController: MapViewController) {
        let locationStore = LocationStore()
        
        let interactor = MapInteractor(locationStore: locationStore)
        let presenter = MapPresenter(interactor: interactor)
        viewController.presenter = presenter

        interactor.output = presenter
        presenter.interface = viewController
    }
}
