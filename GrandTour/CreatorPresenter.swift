//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol CreatorPresentableView: class {
    func setCanCreate(isEnabled: Bool)
    func createLocation(named: String)
}

class CreatorPresenter {
    
    weak var presentableView: CreatorPresentableView?
    
    var name = ""
    
    func updateName(_ name: String) {
        self.name = name
        let valid = isValid(name: name)
        presentableView?.setCanCreate(isEnabled: valid)
    }
    
    func createLocation() {
        guard isValid(name: name) else { return }
        presentableView?.createLocation(named: name)
    }
    
    private func isValid(name: String) -> Bool {
        return name.characters.count > 2
    }
}
