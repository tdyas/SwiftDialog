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
    
    @objc
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
    
    func buildStringElements() -> RootElement {
        return RootElement.builder()
            .title("String elements")
            .section(SectionElement.builder()
                .header("String Elements")
                .element(StringElement("Basic string element"))
                .element(StringElement("Text", detailText: "Detail Text"))
                .element(Value2StringElement("Value2", detailText: "Detail Text"))
                .element(SubtitleStringElement("Subtitle string element", detailText: "Subtitle"))
                .build())
            .section(SectionElement.builder()
                .header("Tappable")
                .element(StringElement("Tap me", onSelect: { element in self.clickMeTapped() }))
                .element(StringElement("An info button", onInfo: { element in self.infoTapped() }))
                .element(StringElement(
                    "Both types of taps",
                    onSelect: { element in self.clickMeTapped() },
                    onInfo: { element in self.infoTapped() }))
                .build())
            .build()
    }
    
    func buildTextEntryElements() -> RootElement {
        return RootElement.builder()
            .title("Text entry elements")
            .section(SectionElement.builder()
                .header("Basic text entry")
                .element(TextEntryElement(text: "", placeholder: "Enter some text here"))
                .element(TextEntryElement(text: "", title: "Entry", placeholder: "Enter more text here"))
                .build())
            .section(SectionElement.builder()
                .header("Login form")
                .element(TextEntryElement(text: "", placeholder: "User name"))
                .element(TextEntryElement(text: "", placeholder: "Password", secureTextEntry: true))
                .build())
            .section(SectionElement.builder()
                .header("Advanced")
                .element(TextEntryElement.builder()
                    .title("URL")
                    .keyboardType(.URL)
                    .build())
                .element(TextEntryElement.builder()
                    .title("Phone")
                    .keyboardType(.phonePad)
                    .build())
                .build())
            .build()
    }
    
    func buildBooleanElements() -> RootElement {
        return RootElement.builder()
            .title("Boolean elements")
            .section(SectionElement.builder()
                .element(SwitchElement(text: "Switch", value: false))
                .element(CheckboxElement(text: "Checkbox", value: false))
                .build())
            .section(SectionElement.builder()
                .header("Radio group")
                .element(RadioElement(text: "Studio", group: "apts"))
                .element(RadioElement(text: "1 bedroom", group: "apts"))
                .element(RadioElement(text: "2 bedroom", group: "apts"))
                .element(RadioElement(text: "3 bedroom", group: "apts"))
                .build())
            .groups(["apts": 3])
            .build()
    }
    
    func buildSliderElements() -> RootElement {
        return RootElement(
            title: "Sliders",
            sections: [
                SectionElement(
                    elements: [
                        SliderElement(value: 0.5),
                        SliderElement(text: "Num", value: 0.5)
                    ]
                )
            ]
        )
    }
    
    func buildDateTimeElements() -> RootElement {
        return RootElement(
            title: "Date/time elements",
            elements: [
                DateTimeElement(text: "Date/Time Picker", value: NSDate() as Date),
                DateElement(text: "Date Picker", value: NSDate() as Date),
                TimeElement(text: "Time Picker", value: NSDate() as Date)
            ]
        )
    }
    
    func buildRootElementsSection() -> SectionElement {
        let customHeaderLabel = UILabel(frame: CGRect.zero)
        customHeaderLabel.autoresizingMask = .flexibleWidth
        customHeaderLabel.text = "Root Elements (+ custom header)"
        customHeaderLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline).pointSize)
        customHeaderLabel.sizeToFit()
        customHeaderLabel.textAlignment = .center
        
        return SectionElement.builder()
            .element(RootElement.builder()
                .title("Colors")
                .section(SectionElement.builder()
                    .element(RadioElement(text: "Red", group: "colors"))
                    .element(RadioElement(text: "Green", group: "colors"))
                    .element(RadioElement(text: "Blue", group: "colors"))
                    .build())
                .groups(["colors": 0])
                .summary(.radioGroup(group: "colors"))
                .build())
            .element(RootElement.builder()
                .title("World of Bool")
                .section(SectionElement.builder()
                    .header("Checkboxes")
                    .element(CheckboxElement(text: "First", value: false))
                    .element(CheckboxElement(text: "Second", value: false))
                    .element(CheckboxElement(text: "Third", value: false))
                    .build())
                .section(SectionElement.builder()
                    .header("Switches")
                    .element(SwitchElement(text: "First", value: false))
                    .element(SwitchElement(text: "Second", value: false))
                    .element(SwitchElement(text: "Third", value: false))
                    .build())
                .summary(.count)
                .childStyle(.plain)
                .build())
            .headerView(customHeaderLabel)
            .build()
    }
    
    func getRootElement() -> RootElement {
        return RootElement.builder()
            .title("SwiftDialog")
            .section(SectionElement.builder()
                .element(buildStringElements())
                .element(buildTextEntryElements())
                .element(buildBooleanElements())
                .element(buildSliderElements())
                .element(buildDateTimeElements())
                .build())
            .section(buildRootElementsSection())
            .groups(["apts": 0])
            .onRefresh({ root in self.displayRefreshAlert() })
            .build()
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
