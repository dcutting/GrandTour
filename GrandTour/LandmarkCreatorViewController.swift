//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

protocol LandmarkCreatorViewControllerDelegate: class {
    func createdLocation(named: String)
}

class LandmarkCreatorViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: LandmarkCreatorViewControllerDelegate?

    var presenter = LandmarkCreatorPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.presentableView = self
        nameTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        updateName()
    }
    
    func updateName() {
        guard let text = nameTextField.text else { return }
        presenter.updateName(text)
    }

    @IBAction func tappedDone(_ sender: Any) {
        presenter.createLocation()
    }
    
    @objc private func textChanged() {
        updateName()
    }
}

extension LandmarkCreatorViewController: LandmarkCreatorPresentableView {
    
    func setCanCreate(isEnabled: Bool) {
        doneButton.isEnabled = isEnabled
    }
    
    func createLocation(named name: String) {
        dismiss(animated: true)
        delegate?.createdLocation(named: name)
    }
}
