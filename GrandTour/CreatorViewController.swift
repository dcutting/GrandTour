//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

class CreatorViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var presenter: CreatorPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        updateName()
    }
    
    @objc private func textChanged() {
        updateName()
    }
    
    func updateName() {
        let text = nameTextField.text ?? ""
        presenter.updatedName(text)
    }

    @IBAction func tappedDone(_ sender: Any) {
        presenter.tappedDone()
    }
}

extension CreatorViewController: CreatorInterface {
    
    func setCanCreate(isEnabled: Bool) {
        doneButton.isEnabled = isEnabled
    }
}
