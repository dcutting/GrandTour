//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

protocol CreatorPresentableView: class {
    func setCanCreate(isEnabled: Bool)
    func createLocation(named: String)
}

class CreatorPresenter {
    
    weak var presentableView: CreatorPresentableView?
    
    var newLocationName = ""
    
    func updateName(_ name: String) {
        newLocationName = name
        let valid = isValid(name: newLocationName)
        presentableView?.setCanCreate(isEnabled: valid)
    }
    
    func createLocation() {
        guard isValid(name: newLocationName) else { return }
        presentableView?.createLocation(named: newLocationName)
    }
    
    private func isValid(name: String) -> Bool {
        return name.characters.count > 2
    }
}
