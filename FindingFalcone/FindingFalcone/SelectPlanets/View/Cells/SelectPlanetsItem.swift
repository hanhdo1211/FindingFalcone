import Foundation
import UIKit

final class SelectPlanetsItem {
    let name: String
    let distance: Int
    var isSelected: Bool
    let primaryAction: Action<Bool>
    
    init(
        name: String,
        distance: Int,
        isSelected: Bool,
        primaryAction: @escaping Action<Bool>
    ) {
        self.name = name
        self.distance = distance
        self.isSelected = isSelected
        self.primaryAction = primaryAction
    }
}

extension SelectPlanetsItem: CellDisplayable {
    func extracCell(from tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cell: SelectPlanetsCell = tableView.dequeueReusable(at: indexPath)
        cell.configure(with: self)
        return cell
    }
}

extension SelectPlanetsItem: Equatable {
    public static func == (lhs: SelectPlanetsItem, rhs: SelectPlanetsItem) -> Bool {
        return lhs.name == rhs.name
    }
}
