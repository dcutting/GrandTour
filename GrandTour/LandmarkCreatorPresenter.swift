//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

struct LandmarkCreatorViewData {
    let name: String
    let isValid: Bool
}

protocol LandmarkCreatorPresentableView: class {
    func setViewData(_ viewData: LandmarkCreatorViewData)
}

class LandmarkCreatorPresenter {
    
    weak var presentableView: LandmarkCreatorPresentableView?
    
    func updateName(_ name: String) {
        let valid = isValid(name: name)
        let viewData = LandmarkCreatorViewData(name: name, isValid: valid)
        presentableView?.setViewData(viewData)
    }
    
    private func isValid(name: String) -> Bool {
        return name.characters.count > 2
    }
}
