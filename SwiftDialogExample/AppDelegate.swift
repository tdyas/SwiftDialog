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
        let element = getTapRootElement()
        let vc = DialogViewController(root: element)
        self.navigationController.pushViewController(vc!, animated: true)
    }
    
    func infoTapped() {
        let alert = UIAlertView(title: "Info", message: "Info was pressed.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func getRootElement() -> RootElement {
        let customHeaderLabel = UILabel(frame: CGRect.zeroRect)
        customHeaderLabel.autoresizingMask = .FlexibleWidth
        customHeaderLabel.text = "Root Elements (+ custom header)"
        customHeaderLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).pointSize)
        customHeaderLabel.sizeToFit()
        customHeaderLabel.textAlignment = .Center
        
        return RootElement(
            title: "SwiftDialog",
            sections: [
                SectionElement(
                    elements: [
                        RootElement(
                            title: "String elements",
                            sections: [
                                SectionElement(
                                    header: "String Elements",
                                    elements: [
                                        StringElement("Basic string element"),
                                        StringElement("Text", detailText: "Detail Text"),
                                        Value2StringElement("Value2", detailText: "Detail Text"),
                                        SubtitleStringElement("Subtitle string element", detailText: "Subtitle")
                                    ]
                                ),
                                SectionElement(
                                    header: "Tappable",
                                    elements: [
                                        StringElement("Tap me", onSelect: { element in self.clickMeTapped() }),
                                        StringElement("An info button", onInfo: { element in self.infoTapped() }),
                                        StringElement(
                                            "Both types of taps",
                                            onSelect: { element in self.clickMeTapped() },
                                            onInfo: { element in self.infoTapped() }
                                        )
                                    ]
                                )
                            ]
                        ),
                        RootElement(
                            title: "Text entry elements",
                            sections: [
                                SectionElement(
                                    header: "Basic text entry",
                                    elements: [
                                        TextEntryElement(text: "", placeholder: "Enter some text here"),
                                        TextEntryElement(text: "", title: "Entry", placeholder: "Enter more text here")
                                    ]
                                ),
                                SectionElement(
                                    header: "Login form",
                                    elements: [
                                        TextEntryElement(text: "", placeholder: "User name"),
                                        TextEntryElement(text: "", placeholder: "Password", secureTextEntry: true)
                                    ]
                                )
                            ]
                        ),
                        RootElement(
                            title: "Boolean elements",
                            sections: [
                                SectionElement(
                                    elements: [
                                        SwitchElement(text: "Switch", value: false),
                                        CheckboxElement(text: "Checkbox", value: false)
                                    ]
                                ),
                                SectionElement(
                                    header: "Radio group",
                                    elements: [
                                        RadioElement(text: "Studio", group: "apts"),
                                        RadioElement(text: "1 bedroom", group: "apts"),
                                        RadioElement(text: "2 bedroom", group: "apts"),
                                        RadioElement(text: "3 bedroom", group: "apts")
                                    ]
                                )
                            ]
                        ),
                        RootElement(
                            title: "Sliders",
                            sections: [
                                SectionElement(
                                    elements: [
                                        SliderElement(value: 0.5),
                                        SliderElement(text: "Num", value: 0.5)
                                    ]
                                )
                            ]
                        ),
                        RootElement(
                            title: "Date/time elements",
                            elements: [
                                DateTimeElement(text: "Date/Time Picker", value: NSDate()),
                                DateElement(text: "Date Picker", value: NSDate()),
                                TimeElement(text: "Time Picker", value: NSDate())
                            ]
                        )
                    ]
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
                                    SwitchElement(text: "First", value: false),
                                    SwitchElement(text: "Second", value: false),
                                    SwitchElement(text: "Third", value: false),
                                ], header: "Switches")
                            ],
                            summary: .Count,
                            childStyle: .Plain
                        )
                    ],
                    headerView: customHeaderLabel
                    
                ),
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
    
    func getTapRootElement() -> RootElement {
        return RootElement(
            title: "Info",
            elements: [
                StringElement("You tapped on a cell.")
            ]
        )
    }
}
