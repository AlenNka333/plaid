//
//  InstitutionViewController.swift
//  Plaid
//
//  Created by Alena Nesterkina on 28.04.22.
//

import UIKit

class InstitutionViewController: UIViewController {
    var viewModel: InstitutionViewModel?

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.alwaysBounceVertical = false
        table.register(AccountInfoTableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        activityIndicator.startAnimating()

        setupBindings()
    }

    func setupBindings() {
        viewModel?.dataReceived = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}

extension InstitutionViewController {
    func openInstitutionInfo() {
        let newController = UserInfoViewController()
        newController.viewModel = UserInfoViewModel(manager: PlaidAPIManager(), data: viewModel?.linkData ?? LinkModel(), session: viewModel?.session ?? UserSession())
        self.navigationController?.pushViewController(newController, animated: true)
    }
}

extension InstitutionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel, let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AccountInfoTableViewCell else {
            return UITableViewCell()
        }
        cell.title = viewModel.getAccountName(indexPath: indexPath)
        cell.costBasis = viewModel.getCostBasisData(indexPath: indexPath)
        cell.ticker = viewModel.getTicker(indexPath: indexPath)
        cell.quantity = viewModel.getQuantity(indexPath: indexPath)
        cell.balance = viewModel.getAccountBalance(indexPath: indexPath)
        return cell
    }
}

extension InstitutionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getNumberOfAccounts() ?? 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Accounts"
    }
}


