import Foundation

@testable import FindingFalcone
import UIKit

final class MockModalNavigationController: UINavigationController, ModalNavigationControlling {
    
    private(set) var pushViewControllerCalledCount: Int = 0
    private(set) var pushViewControllerViewController: UIViewController?
    private(set) var pushViewControllerAnimated: Bool?
    private(set) var pushViewControllerPopHandler: ButtonAction?
    func pushViewController(_ viewController: UIViewController, animated: Bool, popHandler: ButtonAction?) {
        pushViewControllerCalledCount += 1
        pushViewControllerViewController = viewController
        pushViewControllerAnimated = animated
        pushViewControllerPopHandler = popHandler
    }
    
    private(set) var popViewControllerCalledCount: Int = 0
    private(set) var popViewControllerAnimated: Bool?
    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCalledCount += 1
        popViewControllerAnimated = animated
        return super.popViewController(animated: animated)
    }
}
