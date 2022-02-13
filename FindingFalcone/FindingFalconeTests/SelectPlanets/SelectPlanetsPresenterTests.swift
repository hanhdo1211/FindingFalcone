import XCTest

@testable import FindingFalcone

final class SelectPlanetsPresenterTests: XCTestCase {

    private var mockDisplay: MockSelectPlanetsDisplay!
    private var mockCoordinator: MockSelectPlanetsCoordinator!
    private var mockNetwork: MockNetwokClient!
    private var presenter: SelectPlanetsPresenter!
    
    private var successResonse: Result<[PlantResponse], APIError> = {
        return .success(
            [
                PlantResponse(name: "Demo", distance: 100),
                PlantResponse(name: "Demo2", distance: 100),
                PlantResponse(name: "Demo3", distance: 100),
                PlantResponse(name: "Demo4", distance: 100)
            ]
        )
    }()
    
    override func setUp() {
        super.setUp()
        configure()
    }

    override func tearDown() {
        mockDisplay = nil
        mockCoordinator = nil
        mockNetwork = nil
        presenter = nil
        super.tearDown()
    }
    
    private func configure() {
        mockDisplay = MockSelectPlanetsDisplay()
        mockCoordinator = MockSelectPlanetsCoordinator()
        mockNetwork = MockNetwokClient()
        presenter = SelectPlanetsPresenter(
            display: mockDisplay,
            coordinator: mockCoordinator,
            network: mockNetwork
        )
    }

    func testDisplayDidLoadSuccess() throws {
        // Given
        let successResonse: Result<[PlantResponse], APIError> = .success([PlantResponse(name: "Demo", distance: 100)])
        
        // When
        presenter.displayDidLoad()
        
        // Then
        XCTAssertEqual(mockDisplay.showCalledCount, 1)
        XCTAssertEqual(mockDisplay.showLoading, true)
        XCTAssertEqual(mockNetwork.getPlanetsCalledCount, 1)
        
        // When
        mockNetwork.getPlanetsCompletion?(successResonse)
        
        // Then
        XCTAssertEqual(mockDisplay.showCalledCount, 2)
        XCTAssertEqual(mockDisplay.showLoading, false)
        XCTAssertEqual(mockDisplay.setSectionsCalledCount, 1)
        
        let sections = try XCTUnwrap(mockDisplay.setSections)
        XCTAssertEqual(sections.count, 1)
        let sectionItem = try XCTUnwrap(sections.last)
        XCTAssertEqual(sectionItem.items.count, 1)
        let cellItem = try XCTUnwrap(sectionItem.items.first as? SelectPlanetsItem)
        XCTAssertEqual(cellItem.name, "Demo")
        XCTAssertEqual(cellItem.distance, 100)
        XCTAssertEqual(cellItem.isSelected, false)
        XCTAssertNotNil(cellItem.primaryAction)
        
        let footer = try XCTUnwrap(sectionItem.footer as? SelectPlanetsFooterItem)
        
        XCTAssertEqual(footer.buttonName, "NEXT")
        XCTAssertEqual(footer.note, "Select 4 planets")
    }
    
    func testActionTapItem() throws {
        // Given
        let response = successResonse
        presenter.displayDidLoad()
        mockNetwork.getPlanetsCompletion?(response)
        
        let sectionItem = try XCTUnwrap(mockDisplay.setSections?.last)
        let cellItem = try XCTUnwrap(sectionItem.items.first as? SelectPlanetsItem)
        
        // When
        cellItem.primaryAction(true)
        
        // Then
        XCTAssertTrue(cellItem.isSelected)
        
        // When
        cellItem.primaryAction(false)
        
        // Then
        XCTAssertFalse(cellItem.isSelected)
    }
    
    func testNextAction_whenNotSelectedAnyItems_shouldShowError() throws {
        // Given
        let response = successResonse
        
        // When
        presenter.displayDidLoad()
        mockNetwork.getPlanetsCompletion?(response)
        
        let sectionItem = try XCTUnwrap(mockDisplay.setSections?.last)
        let footer = try XCTUnwrap(sectionItem.footer as? SelectPlanetsFooterItem)
        footer.action()
        
        // Then
        XCTAssertEqual(mockDisplay.showErrorCalledCount, 1)
        XCTAssertEqual(mockDisplay.showErrorMessage, "Please select 4 planets to continue!")
        XCTAssertEqual(mockCoordinator.showSelectVehiclesCalledCount, 0)
    }
    
    func testNextAction_whenSelect4Items_shouldMoveToSelectVehicles() throws {
        // Given
        let response = successResonse
        
        // When
        presenter.displayDidLoad()
        mockNetwork.getPlanetsCompletion?(response)
        
        let sectionItem = try XCTUnwrap(mockDisplay.setSections?.last)
        sectionItem.items.forEach { (item) in
            (item as? SelectPlanetsItem)?.isSelected = true
        }
        let footer = try XCTUnwrap(sectionItem.footer as? SelectPlanetsFooterItem)
        footer.action()
        
        // Then
        XCTAssertEqual(mockDisplay.showErrorCalledCount, 0)
        XCTAssertEqual(mockCoordinator.showSelectVehiclesCalledCount, 1)
        XCTAssertEqual(mockCoordinator.showSelectVehiclesSelectedPlanets?.count, 4)
        XCTAssertEqual(
            mockCoordinator.showSelectVehiclesSelectedPlanets?.first,
            sectionItem.items.first as? SelectPlanetsItem
        )
        
        // When
        mockCoordinator.showSelectVehiclesCompletion?()
        mockNetwork.getPlanetsCompletion?(successResonse)
        
        // Then
        XCTAssertEqual(mockDisplay.setSectionsCalledCount, 2)
    }

}
