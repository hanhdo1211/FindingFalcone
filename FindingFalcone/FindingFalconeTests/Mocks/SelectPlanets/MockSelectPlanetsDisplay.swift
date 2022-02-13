@testable import FindingFalcone
import UIKit

final class MockSelectPlanetsDisplay: SelectPlanetsDisplaying {
    
    private(set) var showCalledCount: Int = 0
    private(set) var showLoading: Bool?
    func show(loading: Bool) {
        showCalledCount += 1
        showLoading = loading
    }
    
    private(set) var setSectionsCalledCount: Int = 0
    private(set) var setSections: [TableViewSectionItem]?
    func set(sections: [TableViewSectionItem]) {
        setSectionsCalledCount += 1
        setSections = sections
    }
    
    private(set) var showErrorCalledCount: Int = 0
    private(set) var showErrorMessage: String?
    func showError(message: String) {
        showErrorCalledCount += 1
        showErrorMessage = message
    }
}
