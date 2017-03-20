//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

protocol LandmarkCreatorViewControllerDelegate: class {
    func updateName(_ name: String)
    func createLandmark()
}

class LandmarkCreatorViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: LandmarkCreatorViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        updateName()
    }
    
    func updateName() {
        guard let text = nameTextField.text else { return }
        delegate?.updateName(text)
    }

    @IBAction func tappedDone(_ sender: Any) {
        delegate?.createLandmark()
    }
    
    @objc private func textChanged() {
        updateName()
    }

    func setCanCreate(isEnabled: Bool) {
        doneButton.isEnabled = isEnabled
    }
}
