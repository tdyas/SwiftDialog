import Foundation
import UIKit

public class DialogController : NSObject, UITableViewDataSource, UITableViewDelegate {
    var rootElement: RootElement!
    
    init(_ rootElement: RootElement!) {
        self.rootElement = rootElement
    }
    
    func elementAtIndexPath(indexPath: NSIndexPath!) -> Element {
        let section = self.rootElement.sections[indexPath.section]
        return section.elements[indexPath.row]
    }
    
    // UITableViewDataSource
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.rootElement.sections.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let element = elementAtIndexPath(indexPath)
        return element.getCell(tableView)
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        let section = self.rootElement.sections[sectionIndex]
        return section.elements.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String! {
        let section = self.rootElement.sections[sectionIndex]
        return section.header
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection sectionIndex: Int) -> String! {
        let section = self.rootElement.sections[sectionIndex]
        return section.footer
    }
    
    // UITableViewDelegate
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let element = self.elementAtIndexPath(indexPath)
        element.elementSelected(self, tableView: tableView, atPath: indexPath)
    }
    
    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let element = self.elementAtIndexPath(indexPath)
        element.elementDeselected(self, tableView: tableView, atPath: indexPath)
    }
}
