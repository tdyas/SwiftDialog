SwiftDialog
===========

The SwiftDialog framework allows the easy creation of UITableView's. There are many other such frameworks,
why write another one in Swift? To discover idiomatic Swift using a non-trivial project.

SwiftDialog is inspired by Miguel de Icaza's
[MonoTouch.Dialog](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPFrameworks/Tasks/CreatingFrameworks.html).

SwiftDialog is licensed under the Apache License, Version 2.0.


Installing SwiftDialog
----------------------

Xcode does not currently appear to support Swift and embedded frameworks. The easiest
solution is to just add the SwiftDialog files directly to your application:

1. Add SwiftDialog as a GIT submodule by running:

```git submodule add https://github.com/SwiftDialog/SwiftDialog.git
```

2. Add the SwiftDialog files to your project. Choose File then "Add Files to ...".
   In the resulting dialog, choose the SwiftDialog/SwiftDialog directory with all of
   the Swift source files, ensure "Create groups" is selected, select the relevant 
   targets, and click OK.

3. Commit the changes to your repository.


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

- Document the library, preferably using a method that can generate HTML. 

- Improve the SwiftDialogExample application with more examples.

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
