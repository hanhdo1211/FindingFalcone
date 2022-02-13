import Foundation
import UIKit

final class FindingResultItem {
    let timeTaken: Int
    let result: String
    let planetFound: String?
    let primaryAction: ButtonAction
    
    init(
        timeTaken: Int,
        result: String,
        planetFound: String?,
        primaryAction: @escaping ButtonAction
    ) {
        self.timeTaken = timeTaken
        self.result = result
        self.planetFound = planetFound
        self.primaryAction = primaryAction
    }
}

extension FindingResultItem: CellDisplayable {
    func extracCell(from tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cell: FindingResultCell = tableView.dequeueReusable(at: indexPath)
        cell.configure(with: self)
        return cell
    }
}
