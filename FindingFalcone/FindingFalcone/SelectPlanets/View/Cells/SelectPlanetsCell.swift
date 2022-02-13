import UIKit

class SelectPlanetsCell: UITableViewCell, Reusable {

    private lazy var holderView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 4
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var lblName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var lblDistance: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private var isChecked: Bool = false {
        didSet {
            self.accessoryType = isChecked ? .checkmark : .none
        }
    }
    
    private var item: SelectPlanetsItem?
    
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
    
    func configure(with item: SelectPlanetsItem) {
        self.item = item
        lblName.text = item.name
        lblDistance.text = "Distance: \(item.distance)" 
        
        isChecked = item.isSelected
    }

}

private extension SelectPlanetsCell {
    func setupSubViews() {
        self.contentView.addSubview(holderView)
        holderView.addArrangedSubview(lblName)
        holderView.addArrangedSubview(lblDistance)
        
        holderView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
            make.height.greaterThanOrEqualTo(50)
        }
    }
    
    func setupTapAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapped() {
        self.isChecked.toggle()
        self.item?.isSelected = self.isChecked
        self.item?.primaryAction(self.isChecked)
    }
}

