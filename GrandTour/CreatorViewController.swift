//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

protocol CreatorViewControllerDelegate: class {
    func createLocation(named: String)
}

class CreatorViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: CreatorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        updateDoneButton()
    }
    
    @IBAction func tappedDone(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        guard isValid() else { return }
        dismiss(animated: true)
        delegate?.createLocation(named: name)
    }

    @objc private func textChanged() {
        updateDoneButton()
    }
    
    private func updateDoneButton() {
        doneButton.isEnabled = isValid()
    }
    
    private func isValid() -> Bool {
        guard let text = nameTextField.text else { return false }
        return text.characters.count > 2
    }
}
