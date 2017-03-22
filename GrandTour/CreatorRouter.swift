//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

class CreatorRouter {
    
    let locationStore: LocationStore
    let coordinate: MapCoordinate
    let creatorModuleDelegate: CreatorModuleDelegate?

    var sourceViewController: UIViewController?

    init(locationStore: LocationStore, coordinate: MapCoordinate, creatorModuleDelegate: CreatorModuleDelegate?) {
        self.locationStore = locationStore
        self.coordinate = coordinate
        self.creatorModuleDelegate = creatorModuleDelegate
    }
    
    func presentCreator(from source: UIViewController) {
        sourceViewController = source
        let viewController = prepareCreatorViewController()
        source.present(viewController, animated: true)
    }
    
    private func prepareCreatorViewController() -> CreatorViewController {
        let viewController = loadCreatorViewController()
        wire(viewController)
        return viewController
    }
    
    private func loadCreatorViewController() -> CreatorViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "creatorViewController") as! CreatorViewController
    }
    
    private func wire(_ viewController: CreatorViewController) {
        let interactor = CreatorInteractor(locationStore: locationStore, coordinate: coordinate)
        let presenter = CreatorPresenter(interactor: interactor, router: self)
        viewController.presenter = presenter
        interactor.output = presenter
        presenter.interface = viewController
        presenter.delegate = creatorModuleDelegate
    }
    
    func dismissCreator() {
        sourceViewController?.dismiss(animated: true)
        sourceViewController = nil
    }
}
