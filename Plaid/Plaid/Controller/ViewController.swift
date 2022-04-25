//
//  ViewController.swift
//  Plaid
//
//  Created by Alena Nesterkina on 21.04.22.
//

import UIKit
import LinkKit
import LinkPresentation

protocol LinkOAuthHandling {
    var linkHandler: Handler? { get }
}

class ViewController: UIViewController {
    var viewModel: ViewModel?
    var linkHandler: Handler?

    private lazy var openLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get investment data", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray
        openLinkButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(openLinkButton)
        openLinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openLinkButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        openLinkButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
}

extension ViewController {
    @objc func buttonTapped() {
        viewModel?.createLinkToken()
    }
}
