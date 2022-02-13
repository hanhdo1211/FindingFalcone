import UIKit

class SelectPlanetsFooterView: UITableViewHeaderFooterView, Reusable {
    
    private lazy var holderView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 4
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var lblNote: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private lazy var btnNext: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.titleLabel?.textAlignment = .center
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        return button
    }()

    private var action: ButtonAction?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        setupSubViews()
        setupTapAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func configure(with item: SelectPlanetsFooterItem) {
        lblNote.text = item.note
        btnNext.setTitle(item.buttonName, for: .normal)
        self.action = item.action
    }
}

private extension SelectPlanetsFooterView {
    func setupSubViews() {
        self.contentView.addSubview(holderView)
        holderView.addArrangedSubview(lblNote)
        holderView.addArrangedSubview(btnNext)
        
        holderView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func setupTapAction() {
        btnNext.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc func tapped() {
        self.action?()
    }
}
