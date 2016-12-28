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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.dialogViewController = DialogViewController(root: getRootElement())
        self.navigationController = UINavigationController(rootViewController: self.dialogViewController)
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
        
        self.dialogViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Modal",
            style: .plain,
            target: self,
            action: #selector(AppDelegate.modalButtonTapped)
        )
        return true
    }
    
    func modalButtonTapped() {
        let modal = ModalDialogViewController(root: getModalRootElement())
        modal.delegate = self
        self.navigationController.present(modal, animated: true, completion: nil)
    }
    
    func dismissModalDialogViewController(_ modalDialogViewController: ModalDialogViewController) {
        self.navigationController.dismiss(animated: true, completion: nil)
    }
    
    func clickMeTapped() {
        let element = getTapRootElement()
        let vc = DialogViewController(root: element)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func infoTapped() {
        let alert = UIAlertView(title: "Info", message: "Info was pressed.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func getRootElement() -> RootElement {
        let customHeaderLabel = UILabel(frame: CGRect.zero)
        customHeaderLabel.autoresizingMask = .flexibleWidth
        customHeaderLabel.text = "Root Elements (+ custom header)"
        customHeaderLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline).pointSize)
        customHeaderLabel.sizeToFit()
        customHeaderLabel.textAlignment = .center
        
        return RootElement(
            title: "SwiftDialog",
            sections: [
                SectionElement(
                    elements: [
                        RootElement(
                            title: "String elements",
                            sections: [
                                SectionElement(
                                    elements: [
                                        StringElement("Basic string element"),
                                        StringElement("Text", detailText: "Detail Text"),
                                        Value2StringElement("Value2", detailText: "Detail Text"),
                                        SubtitleStringElement("Subtitle string element", detailText: "Subtitle")
                                    ],
                                    header: "String Elements"
                                ),
                                SectionElement(
                                    elements: [
                                        StringElement("Tap me", onSelect: { element in self.clickMeTapped() }),
                                        StringElement("An info button", onInfo: { element in self.infoTapped() }),
                                        StringElement(
                                            "Both types of taps",
                                            onSelect: { element in self.clickMeTapped() },
                                            onInfo: { element in self.infoTapped() }
                                        )
                                    ],
                                    header: "Tappable"
                                )
                            ]
                        ),
                        RootElement(
                            title: "Text entry elements",
                            sections: [
                                SectionElement(
                                    elements: [
                                        TextEntryElement(text: "", placeholder: "Enter some text here"),
                                        TextEntryElement(text: "", title: "Entry", placeholder: "Enter more text here")
                                    ],
                                    header: "Basic text entry"
                                ),
                                SectionElement(
                                    elements: [
                                        TextEntryElement(text: "", placeholder: "User name"),
                                        TextEntryElement(text: "", placeholder: "Password", secureTextEntry: true)
                                    ],
                                    header: "Login form"
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
                                    elements: [
                                        RadioElement(text: "Studio", group: "apts"),
                                        RadioElement(text: "1 bedroom", group: "apts"),
                                        RadioElement(text: "2 bedroom", group: "apts"),
                                        RadioElement(text: "3 bedroom", group: "apts")
                                    ],
                                    header: "Radio group"
                                )
                            ],
                            groups: ["apts": 3]
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
                                DateTimeElement(text: "Date/Time Picker", value: NSDate() as Date),
                                DateElement(text: "Date Picker", value: NSDate() as Date),
                                TimeElement(text: "Time Picker", value: NSDate() as Date)
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
                            summary: .radioGroup(group: "colors")
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
                            summary: .count,
                            childStyle: .plain
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
        let alert = UIAlertController(title: "Refresh", message: "You triggered a refresh.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            if let dvc = self.navigationController.topViewController as? DialogViewController {
                dvc.endRefreshing()
            }
            self.navigationController.dismiss(animated: true, completion: nil)
        }))
        self.navigationController.present(alert, animated: true, completion: nil)
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
