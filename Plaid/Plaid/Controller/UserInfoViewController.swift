import UIKit

class UserInfoViewController: UIViewController {
    var viewModel: UserInfoViewModel?

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.alwaysBounceVertical = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension UserInfoViewController {
    func openInstitutionInfo(indexPath: IndexPath) {
        let newController = InstitutionViewController()
        let publicToken = viewModel?.getPublicToken(indexPath: indexPath)
        newController.viewModel = InstitutionViewModel(manager: PlaidAPIManager(),
                                                       data: viewModel?.linkData ?? LinkModel(),
                                                       session: viewModel?.session ?? UserSession(),
                                                       publicToken: publicToken ?? "")
        self.navigationController?.pushViewController(newController, animated: true)
    }
}

extension UserInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        openInstitutionInfo(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = viewModel?.getDataFor(indexPath: indexPath).institution.name
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension UserInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getListOfInstitutions().count ?? 1
    }
}

