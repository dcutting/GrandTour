//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol CreatorInterface: class {
    func setCanCreate(isEnabled: Bool)
}

class CreatorPresenter {
    
    let interactor: CreatorInteractor
    weak var router: CreatorRouter?
    weak var interface: CreatorInterface?
    
    init(interactor: CreatorInteractor, router: CreatorRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func updateName(_ name: String) {
        interactor.updateName(name)
    }
    
    func createLocation() {
        interactor.createLocation()
    }
    
    private func isValid(name: String) -> Bool {
        return name.characters.count > 2
    }
}

extension CreatorPresenter: CreatorInteractorOutput {
    
}
