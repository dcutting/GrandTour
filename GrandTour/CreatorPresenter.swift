//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol CreatorInterface: class {
    func enableDoneButton()
    func disableDoneButton()
}

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
        interactor.updateName(name)
    }
    
    func tappedDone(withName name: String) {
        interactor.createLocation(named: name)
    }
    
    private func isValid(name: String) -> Bool {
        return name.characters.count > 2
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
