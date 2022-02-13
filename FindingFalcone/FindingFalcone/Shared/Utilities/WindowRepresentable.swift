import UIKit

protocol WindowRepresentable {
    var rootViewController: UIViewController? {get set}
    
    func makeKeyAndVisible()
}

extension UIWindow: WindowRepresentable {}
