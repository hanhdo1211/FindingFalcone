import UIKit

class FindingResultCell: UITableViewCell, Reusable {

    private lazy var holderView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 4
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var lblResult: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private lazy var lblTime: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var lblPlanet: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var btnPlayAgain: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Play Again", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        button.backgroundColor = .blue
        button.setContentHuggingPriority(.init(251), for: .horizontal)
        return button
    }()
    
    private var action: ButtonAction?
    
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
    
    func configure(with item: FindingResultItem) {
        
        lblTime.text = "Time taken: \(item.timeTaken)"
        lblResult.text = item.result
        lblPlanet.isHidden = item.planetFound == nil
        lblPlanet.text = "Planet found: \(item.planetFound ?? "")"
        
        self.action = item.primaryAction
    }

}

private extension FindingResultCell {
    func setupSubViews() {
        self.contentView.addSubview(holderView)
        holderView.addArrangedSubview(lblResult)
        holderView.addArrangedSubview(lblTime)
        holderView.addArrangedSubview(lblPlanet)
        holderView.addArrangedSubview(btnPlayAgain)
        
        holderView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(10)
            make.height.greaterThanOrEqualTo(50)
        }
    }
    
    func setupTapAction() {
        btnPlayAgain.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    @objc func tapped() {
        self.action?()
    }
}

