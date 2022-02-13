//
//  SelectVehiclesViewController.swift
//  FindingFalcone
//
//  Created by Hanh Do on 12/02/2022.
//

import UIKit

class SelectVehiclesViewController: UIViewController {

    private var sections: [TableViewSectionItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .lightGray
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var presenter: SelectVehiclesPresenting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Verhicles!"
        self.view.backgroundColor = .white
        
        // Do any additional setup after loading the view.
        setupView()
        
        presenter.displayDidLoad()
    }
}

private extension SelectVehiclesViewController {
    func setupView() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension SelectVehiclesViewController: SelectVehiclesDisplaying {
    func set(sections: [TableViewSectionItem]) {
        self.sections = sections
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSelectVehicle(_ selectVehicleItems: [SelectVehicleItem]) {
        let alert = UIAlertController(title: "Select a vehicle", message: nil, preferredStyle: .actionSheet)

        selectVehicleItems.forEach { (item) in
            alert.addAction(UIAlertAction(title: item.text, style: .default , handler:{ (UIAlertAction)in
                    item.action()
                }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SelectVehiclesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section]
            .items[indexPath.row]
            .extracCell(from: tableView, for: indexPath)
    }
}

extension SelectVehiclesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard sections[section].header != nil else {
            return .leastNormalMagnitude
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section]
            .header?
            .extractView(from: tableView, for: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard sections[section].footer != nil else {
            return .leastNormalMagnitude
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections[section]
            .footer?
            .extractView(from: tableView, for: section)
    }
}
