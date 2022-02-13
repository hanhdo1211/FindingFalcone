import UIKit

typealias Action<T> = (T) -> Void
typealias ButtonAction = () -> Void


protocol CellDisplayable {
    var action: ButtonAction? { get }
    
    func extracCell(from tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
}

extension CellDisplayable {
    var action: ButtonAction? {
        return nil
    }
}
