//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol CreatorModuleDelegate: class {
    func createdLocation()
}

protocol CreatorInterface: class {
    func enableDoneButton()
    func disableDoneButton()
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
        interactor.validate(name: name)
    }
    
    func tappedDone(withName name: String) {
        interactor.createLocation(named: name)
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
