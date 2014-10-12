// Copyright 2014 Thomas K. Dyas
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
                        Value1LabelElement(text: "Value1", detailText: "Detail Text"),
                        Value2LabelElement(text: "Value2", detailText: "Detail Text"),
                        SubtitleLabelElement(text: "Subtitle", detailText: "Detail Text"),
                        BoolElement(caption: "Switch", value: false),
                        
                    ],
                    withHeader: "Basic",
                    withFooter: nil
                )
            ])
    }
}
