import SwiftDialog
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController!
    var dialogViewController: DialogViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.dialogViewController = DialogViewController(root: getRootElement())
        self.navigationController = UINavigationController(rootViewController: self.dialogViewController)
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func getRootElement() -> RootElement {
        return RootElement(
            title: "SwiftDialog",
            sections: [
                SectionElement(
                    elements: [
                        LabelElement("Label"),
                        BoolElement(caption: "Switch", value: false),
                        
                    ],
                    withHeader: "Basic",
                    withFooter: nil
                )
            ])
    }
}
