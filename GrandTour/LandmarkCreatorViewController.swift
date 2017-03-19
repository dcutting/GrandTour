//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

protocol LandmarkCreatorViewControllerDelegate: class {
    func createdLocation(named: String)
}

class LandmarkCreatorViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var delegate: LandmarkCreatorViewControllerDelegate?

    var presenter = LandmarkCreatorPresenter()
    var viewData: LandmarkCreatorViewData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.presentableView = self
        nameTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    
    @IBAction func tappedDone(_ sender: Any) {
        guard let viewData = viewData else { return }
        guard viewData.isValid else { return }
        dismiss(animated: true)
        delegate?.createdLocation(named: viewData.name)
    }
    
    func textChanged() {
        guard let text = nameTextField.text else { return }
        presenter.updateName(text)
    }
}

extension LandmarkCreatorViewController: LandmarkCreatorPresentableView {
    
    func setViewData(_ viewData: LandmarkCreatorViewData) {
        self.viewData = viewData
    }
}
