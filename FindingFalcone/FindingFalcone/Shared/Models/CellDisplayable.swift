import UIKit

typealias Action<T> = (T) -> Void
typealias ButtonAction = () -> Void

protocol CellDisplayable {
    func extracCell(from tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
}
