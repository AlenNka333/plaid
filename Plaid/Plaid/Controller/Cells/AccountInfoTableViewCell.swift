//
//  AccountInfoTableViewCell.swift
//  Plaid
//
//  Created by Alena Nesterkina on 28.04.22.
//

import Foundation
import UIKit

class AccountInfoTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private lazy var costBasisLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()

    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()

    private lazy var tickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()

    var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.setNeedsLayout()
        }
    }

    var balance: Double? {
        didSet {
            balanceLabel.text = "Balance: \(balance ?? 0)"
            balanceLabel.setNeedsLayout()
        }
    }

    var costBasis: Double? {
        didSet {
            costBasisLabel.text = "cost_basis: \(costBasis ?? 0)"
            costBasisLabel.setNeedsLayout()
        }
    }

    var quantity: Double? {
        didSet {
            quantityLabel.text = "quantity: \(quantity ?? 0)"
            quantityLabel.setNeedsLayout()
        }
    }

    var ticker: (String, String)? {
        didSet {
            tickerLabel.text = "ticker_symbol: \(ticker?.0 ?? "none"), name: \(ticker?.1 ?? "no name")"
            tickerLabel.setNeedsLayout()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        arrangeView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func arrangeView() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
        }

        contentView.addSubview(costBasisLabel)
        costBasisLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
        }

        contentView.addSubview(quantityLabel)
        quantityLabel.snp.makeConstraints { make in
            make.top.equalTo(costBasisLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
        }

        contentView.addSubview(tickerLabel)
        tickerLabel.snp.makeConstraints { make in
            make.top.equalTo(quantityLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
        }

        contentView.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(tickerLabel.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.leading.equalTo(titleLabel)
        }
    }

}
