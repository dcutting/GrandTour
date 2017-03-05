//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

protocol EditLandmarkViewControllerDelegate: class {
    func didCompleteEditing()
}

class EditLandmarkViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var delegate: EditLandmarkViewControllerDelegate?
    
    var name: String?
    
    override func viewDidLoad() {
        nameTextField.text = name
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        delegate?.didCompleteEditing()
    }
}
