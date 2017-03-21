//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

protocol CreatorViewControllerDelegate: class {
    func createLocation(named: String)
}

class CreatorViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: CreatorViewControllerDelegate?

    var presenter = CreatorPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.presentableView = self
        nameTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        updateName()
    }
    
    func updateName() {
        let text = nameTextField.text ?? ""
        presenter.updateName(text)
    }

    @IBAction func tappedDone(_ sender: Any) {
        presenter.createLocation()
    }
    
    @objc private func textChanged() {
        updateName()
    }
}

extension CreatorViewController: CreatorPresentableView {
    
    func setCanCreate(isEnabled: Bool) {
        doneButton.isEnabled = isEnabled
    }
    
    func createLocation(named name: String) {
        dismiss(animated: true)
        delegate?.createLocation(named: name)
    }
}
