import UIKit

class PlanetVehicleCell: UITableViewCell, Reusable {

    private lazy var holderView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 4
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var textHolderView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 4
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var lblPlanet: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var lblVehicle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var btnSelect: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Select", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        button.backgroundColor = .blue
        button.setContentHuggingPriority(.init(251), for: .horizontal)
        return button
    }()
    
    private lazy var btnRemove: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Remove", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
        button.backgroundColor = .red
        button.setContentHuggingPriority(.init(251), for: .horizontal)
        return button
    }()
    
    private var selectAction: ButtonAction?
    private var removeAction: ButtonAction?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        setupSubViews()
        setupTapAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: PlanetVehicleItem) {
        lblPlanet.text = item.planet
        lblVehicle.text = item.vehicle ?? "Not Selected"
        btnRemove.isHidden = item.vehicle == nil
        
        selectAction = item.primaryAction
        removeAction = item.removeAction
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

private extension PlanetVehicleCell {
    func setupSubViews() {
        self.contentView.addSubview(holderView)
        holderView.addArrangedSubview(textHolderView)
        holderView.addArrangedSubview(btnRemove)
        holderView.addArrangedSubview(btnSelect)
        
        textHolderView.addArrangedSubview(lblPlanet)
        textHolderView.addArrangedSubview(lblVehicle)
        
        holderView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
            make.height.greaterThanOrEqualTo(50)
        }
    }
    
    func setupTapAction() {
        btnSelect.addTarget(self, action: #selector(tappedSelect), for: .touchUpInside)
        btnRemove.addTarget(self, action: #selector(tappedRemove), for: .touchUpInside)
    }
    
    @objc func tappedSelect() {
        self.selectAction?()
    }
    
    @objc func tappedRemove() {
        self.removeAction?()
    }
}

