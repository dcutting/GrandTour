//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

protocol CreatorViewControllerDelegate: class {
    func updateLocation(name: String)
    func createLocation()
}

class CreatorViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: CreatorViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        updateLocationName()
    }
    
    func updateLocationName() {
        let text = nameTextField.text ?? ""
        delegate?.updateLocation(name: text)
    }

    @IBAction func tappedDone(_ sender: Any) {
        delegate?.createLocation()
    }
    
    @objc private func textChanged() {
        updateLocationName()
    }

    func setCanCreate(isEnabled: Bool) {
        doneButton.isEnabled = isEnabled
    }
}
