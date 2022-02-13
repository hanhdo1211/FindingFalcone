import UIKit

protocol HeaderFooterDisplayable {
    func extractView(from tableView: UITableView, for section: Int) -> UIView?
}
