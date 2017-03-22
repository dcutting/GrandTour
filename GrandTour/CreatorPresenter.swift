//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol CreatorInterface: class {
    func setDoneButton(isEnabled: Bool)
}

protocol CreatorModuleDelegate: class {
    func didCreateLocation()
}

class CreatorPresenter {
    
    let interactor: CreatorInteractor
    weak var router: CreatorRouter?
    weak var interface: CreatorInterface?
    weak var delegate: CreatorModuleDelegate?
    
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
    
    func setCanCreate(isEnabled: Bool) {
        interface?.setDoneButton(isEnabled: isEnabled)
    }
    
    func createdLocation() {
        delegate?.didCreateLocation()
        router?.dismissCreator()
    }
}
