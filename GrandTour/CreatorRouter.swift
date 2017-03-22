//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

class CreatorRouter {
    
    var viewController: CreatorViewController?
    let locationStore: LocationStore
    
    init(locationStore: LocationStore) {
        self.locationStore = locationStore
    }
    
    func presentCreatorInterface(from source: UIViewController) {
        
        viewController = source.storyboard?.instantiateViewController(withIdentifier: "creatorViewController") as? CreatorViewController
        
        let interactor = CreatorInteractor(locationStore: locationStore)
        let presenter = CreatorPresenter(interactor: interactor, router: self)
        viewController?.presenter = presenter
        
        interactor.output = presenter
        presenter.interface = viewController
        
        source.present(viewController!, animated: true)
    }
    
    func dismissCreator() {
        viewController?.dismiss(animated: true)
    }
}
