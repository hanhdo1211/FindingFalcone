import UIKit

protocol ActivityIndicating {
    func show(loading: Bool)
}

extension ActivityIndicating where Self: UIViewController {
    private var controller: UIViewController {
        return tabBarController ?? navigationController ?? self
    }
    
    func show(loading: Bool) {
        if loading {
            ActivityIndicator.show(on: controller)
        } else {
            ActivityIndicator.dismiss(from: controller)
        }
    }
}
