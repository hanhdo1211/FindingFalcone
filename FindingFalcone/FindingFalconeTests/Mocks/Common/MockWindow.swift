@testable import FindingFalcone
import UIKit

final class MockWindow: WindowRepresentable {
    var rootViewController: UIViewController?
    
    private (set) var makeKeyAndVisibleCalledCount: Int = 0
    func makeKeyAndVisible() {
        makeKeyAndVisibleCalledCount += 1
    }
}
