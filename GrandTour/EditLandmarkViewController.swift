//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

class EditLandmarkViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var name: String?
    
    override func viewDidLoad() {
        nameTextField.text = name
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
