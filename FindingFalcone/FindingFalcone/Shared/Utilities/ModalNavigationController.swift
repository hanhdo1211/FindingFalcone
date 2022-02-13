//
//  ModalNavigationController.swift
//  FindingFalcone
//
//  Created by Hanh Do on 12/02/2022.
//

import UIKit

private final class PopHandler {
    enum State {
        case pushed
        case displayed
    }
    
    let viewControler: UIViewController
    let action: ButtonAction
    var state: State
    
    init(
        viewController: UIViewController,
        state: State = .pushed,
        action: @escaping ButtonAction
    ) {
        self.viewControler = viewController
        self.state = state
        self.action = action
    }
}

protocol ModalNavigationControlling: UINavigationController {
    func pushViewController(_ viewController: UIViewController, animated: Bool, popHandler: ButtonAction?)
}

extension ModalNavigationControlling {
    func pushViewController(_ viewController: UIViewController, animated: Bool, popHandler: ButtonAction? = nil) {
        pushViewController(viewController, animated: animated, popHandler: popHandler)
    }
}

final class ModalNavigationController: UINavigationController, ModalNavigationControlling {

    private var popHandlers: [UIViewController: PopHandler] = [:]
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool, popHandler: ButtonAction? = nil) {
        self.pushViewController(viewController, animated: animated)
        if let popHandler = popHandler {
            popHandlers[viewController] = PopHandler(viewController: viewController, action: popHandler)
        }
    }
    
}

extension ModalNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        triggerHandlers(for: navigationController.viewControllers)
        
        guard let popHandler = popHandlers[viewController] else { return }
        popHandler.state = .displayed
    }

    private func triggerHandlers(for stack: [UIViewController]) {
        let currentViewControllers: Set<UIViewController> = .init(stack)
        let shownViewControllers: Set<UIViewController> = .init(popHandlers.filter {
            $0.value.state == .displayed }.keys)
        shownViewControllers.subtracting(currentViewControllers).forEach {
            popHandlers[$0]?.action()
            popHandlers[$0] = nil
        }
    }
}


