//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

protocol LandmarkCreatorViewControllerDelegate: class {
    func createdLocation(named: String)
}

class LandmarkCreatorViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var delegate: LandmarkCreatorViewControllerDelegate?
    
    @IBAction func tappedDone(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        guard name.characters.count > 2 else { return }
        dismiss(animated: true)
        delegate?.createdLocation(named: name)
    }
}
