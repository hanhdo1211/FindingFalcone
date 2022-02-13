import Foundation
import UIKit

final class SelectPlanetsFooterItem {
    let note: String
    let buttonName: String
    let action: ButtonAction
    
    init(
        note: String,
        buttonName: String,
        action: @escaping ButtonAction
    ) {
        self.note = note
        self.buttonName = buttonName
        self.action = action
    }
}

extension SelectPlanetsFooterItem: HeaderFooterDisplayable {
    func extractView(from tableView: UITableView, for section: Int) -> UIView? {
        let footerView: SelectPlanetsFooterView = tableView.dequeueReusableHeaderFooter()
        footerView.configure(with: self)
        return footerView
    }
}
