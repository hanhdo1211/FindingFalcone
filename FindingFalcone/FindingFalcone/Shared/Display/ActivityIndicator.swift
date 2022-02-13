import UIKit
import SnapKit

enum ActivityIndicator {
    private static var window: UIWindow?
}

//extension ActivityIndicator {
//    final class IndicatorViewController: UIViewController {
//        
//    }
//}
private extension ActivityIndicator {
    final class IndicatorViewController: UIViewController {
        
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func commonInit(){
            modalPresentationStyle = .overFullScreen
            let indicator = IndicatorView()
            view = indicator
        }
    }
    
    final class IndicatorView: UIView {
        
        private lazy var activityIndicator: UIActivityIndicatorView = {
            let indicator: UIActivityIndicatorView
            if #available(iOS 13.0, *) {
                indicator = .init(style: UIActivityIndicatorView.Style.large)
            } else {
                indicator = .init(style: .whiteLarge)
            }
            indicator.startAnimating()
            return indicator
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }
        
        private func commonInit() {
            backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            addSubview(activityIndicator)
            
            activityIndicator.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
        }
    }
    
    final class DummyView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("unavailable")
        }
        
        private func commonInit() {
            backgroundColor = .clear
        }
        
        static func show(on view: UIView) {
            let dummyView: DummyView = .init()
            view.addSubview(dummyView)
            dummyView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        
        static func remove(from view: UIView) {
            view.subviews.compactMap { $0 as? DummyView }.forEach { $0.removeFromSuperview() }
        }
    }
}

extension ActivityIndicator {
    static func show(on viewController: UIViewController) {
        let indicatorViewController = IndicatorViewController()
        let dummy = UIViewController()
        dummy.view.backgroundColor = .clear
        
        if window != nil {
            dismiss(from: viewController)
        }
        
        if #available(iOS 13.0, *) {
            DummyView.show(on: viewController.view)
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .clear
        window?.rootViewController = dummy
        window?.isHidden = false
        window?.makeKeyAndVisible()
        
        dummy.present(indicatorViewController, animated: false)
    }
    
    private static func dismiss() {
        window?.rootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
        window?.isHidden = true
        window = nil
    }
    
    static func dismiss(from viewController: UIViewController) {
        if #available(iOS 13.0, *) {
            DummyView.remove(from: viewController.view)
        }
        dismiss()
    }
}
