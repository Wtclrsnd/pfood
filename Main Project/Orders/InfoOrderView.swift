//
//  InfoOrderView.swift
//  Main Project
//
//  Created by Тимур Бакланов on 15.03.2020.
//  Copyright © 2020 Тимур Бакланов. All rights reserved.
//

import UIKit

class InfoOrderView: UITableViewCell {
    
    //MARK: - Properties
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 8
        return stack
    }()
    
    let userNameLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.text = "test"
        return label
    }()
    
    let dataLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = "test"
        return label
    }()
    
    let userAndDataStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    let phoneNumberLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = "test"
        return label
    }()
    
    let adressLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "test"
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.widthAnchor.constraint(equalToConstant: 50).isActive = true
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Получен"
        label.textAlignment = .center
        label.textColor = .none
        return label
    }()
    
    let moreButton: UIButton = {
       let button = UIButton()
        button.setTitle("Подробнее", for: .normal)
        return button
    }()
    
    let seperator: UIView = {
        let view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGray5
        } else {
            view.backgroundColor = .gray
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
       return view
    }()

    
    fileprivate func setUpStackConstraints() {
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(stack)
        stack.addArrangedSubview(userAndDataStack)
        userAndDataStack.addArrangedSubview(userNameLabel)
        userAndDataStack.addArrangedSubview(dataLabel)
        stack.addArrangedSubview(phoneNumberLabel)
        stack.addArrangedSubview(adressLabel)
        stack.addArrangedSubview(statusLabel)
        stack.addArrangedSubview(seperator)
        setUpStackConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
