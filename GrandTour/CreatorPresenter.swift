//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol CreatorModuleDelegate: class {
    func createdLocation()
}

class CreatorPresenter {
    
    let interactor: CreatorInteractor
    weak var router: CreatorRouter?
    weak var interface: CreatorInterface?
    weak var moduleDelegate: CreatorModuleDelegate?
    
    init(interactor: CreatorInteractor, router: CreatorRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func updatedName(_ name: String) {
        let mapName = MapName(value: name)
        interactor.validate(name: mapName)
    }
    
    func tappedDone(withName name: String) {
        let mapName = MapName(value: name)
        interactor.createLocation(named: mapName)
    }
}

extension CreatorPresenter: CreatorInteractorOutput {
    
    func canCreateLocation() {
        interface?.enableDoneButton()
    }
    
    func cannotCreateLocation() {
        interface?.disableDoneButton()
    }
    
    func createdLocation() {
        moduleDelegate?.createdLocation()
        router?.dismissCreator()
    }
}
