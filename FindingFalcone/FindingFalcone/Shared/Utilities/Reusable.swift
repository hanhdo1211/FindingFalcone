import UIKit

protocol Reusable: UIView {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}

private extension UITableView {
    enum AssociatedKeys {
        static var registeredCells: UInt8 = 0
        static var registeredHeaderFooters: UInt8 = 0
    }
    
    var registeredCells: [String : Bool] {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.registeredCells) as? [String : Bool] else {
                let registeredCells: [String: Bool] = [:]
                self.registeredCells = registeredCells
                return registeredCells
            }
            return value
        }
        
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.registeredCells,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    var registeredHeaderFooters: [String : Bool] {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.registeredHeaderFooters) as? [String : Bool] else {
                let registeredCells: [String: Bool] = [:]
                self.registeredHeaderFooters = registeredCells
                return registeredCells
            }
            return value
        }
        
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.registeredHeaderFooters,
                newValue,
                objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    func registerReusable(_ cell: Reusable.Type) {
        guard registeredCells[cell.identifier] == nil else { return }
        
        registeredCells[cell.identifier] = true
        register(cell, forCellReuseIdentifier: cell.identifier)
    }
    
    func registerReusableHeaderFooter(_ headerFooterView: Reusable.Type) {
        guard registeredHeaderFooters[headerFooterView.identifier] == nil else { return }
        
        registeredHeaderFooters[headerFooterView.identifier] = true
        register(headerFooterView, forHeaderFooterViewReuseIdentifier: headerFooterView.identifier)
    }
}

extension UITableView {
    func dequeueReusable<T: Reusable>(at indexPath: IndexPath) -> T {
        registerReusable(T.self)
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Cell is not of expected type \(String(describing: T.self))")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooter<T: Reusable>() -> T {
        registerReusableHeaderFooter(T.self)
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T else {
            fatalError("Header footer is not of expected type \(String(describing: T.self))")
        }
        return headerFooter
    }
}
