//  Copyright © 2017 Dan Cutting. All rights reserved.

import Foundation

struct PresentableLocation {
    let name: String
    let latitude: Double
    let longitude: Double
}

protocol MapInterface: class {
    func setLocations(_ locations: [PresentableLocation])
    func setStartingCoordinate(latitude: Double, longitude: Double)
}
