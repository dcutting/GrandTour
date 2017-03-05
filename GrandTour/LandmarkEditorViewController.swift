//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

protocol LandmarkEditorViewControllerDelegate: class {
    func didCompleteEditing(landmarkEditorViewController: LandmarkEditorViewController)
}

class LandmarkEditorViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var delegate: LandmarkEditorViewControllerDelegate?
    
    @IBAction func didTapDone(_ sender: Any) {
        delegate?.didCompleteEditing(landmarkEditorViewController: self)
    }
}
