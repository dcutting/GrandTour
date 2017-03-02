//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

class LandmarkViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func didTapDone(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
