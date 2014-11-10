SwiftDialog
===========

The SwiftDialog framework allows the easy creation of UITableView's. There are many other such frameworks,
why write another one in Swift? To discover idiomatic Swift using a non-trivial project.

SwiftDialog is inspired by Miguel de Icaza's
[MonoTouch.Dialog](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPFrameworks/Tasks/CreatingFrameworks.html).

SwiftDialog is licensed under the Apache License, Version 2.0.


Installing SwiftDialog
----------------------

1. Clone the SwiftDialog git repository.

2. Create a workspace for your existing application target.

3. Drag the project for SwiftDialog (SwiftDialog.xcodeproj) into the workspace.

4. Follow the instructions in the "Embedding a Private Framework in Your Application Bundle"
section of the [Creating Frameworks](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPFrameworks/Tasks/CreatingFrameworks.html) site.



Using SwiftDialog
-----------------

The heart of SwiftDialog is the subclasses of Element that configure different types of cells.
The toplevel element is always a RootElement containing one or more SectionElement's. Those
sections define the actual user interface using these Element's.

* StringElement - Basic label with support for detail text. Supports callbacks for a tapping on the cell
or pressing an accessory button.
* TextEntryElement - Text input field with an optional label
* Boolean elements:
  - SwitchElement - Contains text and a UISwitch
  - CheckboxElement - Contains text and a checkmark when true.
  - RadioElement - Allows groups where only one element has the checkmark.
* SliderElement - A UISlider with an optional label
* Date/time elements (pops up a UIDatePicker):
  - DateTimeElement
  - DateElement
  - TimeElement
* RootElement - Pushes a new DialogViewController onto the navigation stack when clicked. It
also supports summarizing the contents of the child dialog.

Once you have a RootElement, construct a DialogViewController and push it onto the 
navigation stack.

The SwiftDialogExample application is a working example of SwiftDialog.


Contributing to SwiftDialog
---------------------------

Pull requests welcome. Fork the repository and send away!

Please let me know if you use SwiftDialog in an application so we can link to it here.


Open Issues
-----------

SwiftDialog is still under development. Parts will change as better ways of using Swift are found.
Here is a *non-exhaustive* list of open issues:

- Cleanup the SwiftDialogExample application to better organize the examples.

- Cocoa POD support.

- Sizing the UIDatePicker for DateTimeElement (and related Element's) properly. Also for iPad,
the UIDatePicker should probably pop-over instead of being an input view.

- Attributed string support for StringElement (or another Element type).

- For text fields, support a "Next" button if there is more than one TextEntryElement in a view.
MonoTouch.Dialog does this.

- Explore whether Swift's reflection is powerful enough to automatically construct dialogs
for editing arbitrary types.

- Support a "button" element with proper styling. For example, for a login dialog,
it would be the Login button.
