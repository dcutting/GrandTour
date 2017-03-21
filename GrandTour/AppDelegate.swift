//  Copyright © 2017 Dan Cutting. All rights reserved.

import UIKit

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let mapViewController = window!.rootViewController! as! MapViewController
        MapRouter().wire(viewController: mapViewController)
        
        return true
    }
}
