//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

protocol LandmarkCreatorViewControllerDelegate: class {
    func createdLocation(named: String)
}

class LandmarkCreatorViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var delegate: LandmarkCreatorViewControllerDelegate?
    
    @IBAction func tappedDone(_ sender: Any) {
        dismiss(animated: true)
        guard let name = nameTextField.text else { return }
        delegate?.createdLocation(named: name)
    }
}
