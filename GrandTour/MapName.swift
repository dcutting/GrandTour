//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

struct MapName {
    let value: String
}

extension MapName {
    func isValid() -> Bool {
        return value.characters.count > 2
    }
}
