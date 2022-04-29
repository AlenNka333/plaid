//
//  ViewController.swift
//  Plaid
//
//  Created by Alena Nesterkina on 21.04.22.
//

import UIKit
import LinkKit
import LinkPresentation
import SnapKit

protocol LinkOAuthHandling {
    var linkHandler: Handler? { get }
}

class ViewController: UIViewController {
    var viewModel: ViewModel?
    var linkHandler: Handler?

    private lazy var sigInToInvestmentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open Plaid Link", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.text = "You're successfully connected your bank"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var openInfoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(openUserInfo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See Your Info", for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [successLabel, openInfoButton])
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 10
        stack.isHidden = viewModel?.session.publicToken.isEmpty ?? true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(sigInToInvestmentButton)
        sigInToInvestmentButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(312)
            make.height.equalTo(56)
        }

        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }

        openInfoButton.snp.makeConstraints { make in
            make.width.equalTo(stackView.snp.width)
            make.height.equalTo(56)
        }
    
        setupBindings()
    }

    private func setupBindings() {
        viewModel?.configurationCreated = { [weak self] conf in
            guard let configuration = conf else {
                return
            }

            self?.presentPlaidLinkUsingLinkToken(configuration: configuration)
        }

        viewModel?.connectedToBank = { [weak self] in
            self?.stackView.isHidden = self?.viewModel?.session.publicToken.isEmpty ?? true
        }
    }
}

extension ViewController {
    func presentPlaidLinkUsingLinkToken(configuration: LinkTokenConfiguration) {
        let result = Plaid.create(configuration)
        switch result {
        case .failure(let error):
            print("Unable to create Plaid handler due to: \(error)")
        case .success(let handler):
            DispatchQueue.main.async {
                handler.open(presentUsing: .viewController(self))
                self.linkHandler = handler
            }
        }
    }

    @objc func openUserInfo() {
        let newController = UserInfoViewController()
        newController.viewModel = UserInfoViewModel(manager: PlaidAPIManager(), data: viewModel?.linkData ?? LinkModel(), session: viewModel?.session ?? UserSession())
        self.navigationController?.pushViewController(newController, animated: true)
    }

    @objc func loginTapped() {
        viewModel?.createLinkToken()
    }
}
