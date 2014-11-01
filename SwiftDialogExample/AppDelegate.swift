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
class AppDelegate: UIResponder, UIApplicationDelegate, ModalDialogViewControllerDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController!
    var dialogViewController: DialogViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.dialogViewController = DialogViewController(root: getRootElement())
        self.navigationController = UINavigationController(rootViewController: self.dialogViewController)
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
        
        self.dialogViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Modal",
            style: .Plain,
            target: self,
            action: "modalButtonTapped"
        )
        return true
    }
    
    func modalButtonTapped() {
        let modal = ModalDialogViewController(root: getModalRootElement())
        modal.delegate = self
        self.navigationController.presentViewController(modal, animated: true, completion: nil)
    }
    
    func dismissModalDialogViewController(modalDialogViewController: ModalDialogViewController) {
        self.navigationController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func clickMeTapped() {
        let vc = DialogViewController(root: getModalRootElement())
        self.navigationController.pushViewController(vc!, animated: true)
    }
    
    func infoTapped() {
        let alert = UIAlertView(title: "Info", message: "Info was pressed", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func getRootElement() -> RootElement {
        return RootElement(
            title: "SwiftDialog",
            sections: [
                SectionElement(
                    elements: [
                        StringElement("Basic string element"),
                        StringElement("Text", detailText: "Detail Text"),
                        Value2StringElement("Value2", detailText: "Detail Text"),
                        SubtitleStringElement("Subtitle string element", detailText: "Subtitle"),
                    ], header: "String Elements"
                ),
                SectionElement(
                    elements: [
                        StringElement("Click me", onSelect: { element in self.clickMeTapped() }),
                        StringElement("More info!", onInfo: { element in self.infoTapped() }),
                        StringElement(
                            "Two types of taps",
                            onSelect: { element in self.clickMeTapped() },
                            onInfo: { element in self.infoTapped() }
                        ),
                        TextEntryElement(),
                        SwitchElement(caption: "Switch", value: false),
                        CheckboxElement(text: "Checkbox", value: false),
                        SliderElement(value: 0.5),
                        SliderElement(text: "Num", value: 0.5),
                    ],
                    header: "Basic"
                ),
                SectionElement(
                    elements: [
                        RootElement(
                            title: "Colors",
                            sections: [
                                SectionElement(elements: [
                                    RadioElement(text: "Red", group: "colors"),
                                    RadioElement(text: "Green", group: "colors"),
                                    RadioElement(text: "Blue", group: "colors")
                                ])
                            ],
                            groups: ["colors": 0],
                            summary: .RadioGroup(group: "colors")
                        ),
                        RootElement(
                            title: "World of Bool",
                            sections: [
                                SectionElement(elements: [
                                    CheckboxElement(text: "First", value: false),
                                    CheckboxElement(text: "Second", value: false),
                                    CheckboxElement(text: "Third", value: false),
                                ], header: "Checkboxes"),
                                SectionElement(elements: [
                                    SwitchElement(caption: "First", value: false),
                                    SwitchElement(caption: "Second", value: false),
                                    SwitchElement(caption: "Third", value: false),
                                ], header: "Switches")
                            ],
                            summary: .Count,
                            childStyle: .Plain
                        )
                    ]
                ),
                SectionElement(
                    elements: [
                        RadioElement(text: "Studio", group: "apts"),
                        RadioElement(text: "1 bedroom", group: "apts"),
                        RadioElement(text: "2 bedroom", group: "apts"),
                        RadioElement(text: "3 bedroom", group: "apts")
                    ],
                    header: "Apartment Types"
                )
            ],
            groups: [
                "apts": 0
            ],
            onRefresh: { root in self.displayRefreshAlert() }
        )
    }
    
    func displayRefreshAlert() {
        let alert = UIAlertController(title: "Refresh", message: "You triggered a refresh.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { action in
            if let dvc = self.navigationController.topViewController as? DialogViewController {
                dvc.endRefreshing()
            }
            self.navigationController.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.navigationController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func getModalRootElement() -> RootElement {
        return RootElement(title: "Modal", sections: [
            SectionElement(elements: [StringElement("This is a modal.")]),
            SectionElement(elements: [StringElement("Another section.")], header: "Header", footer: "Footer"),
        ])
    }
}
