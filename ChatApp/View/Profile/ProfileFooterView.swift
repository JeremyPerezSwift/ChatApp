//
//  ProfileFooterView.swift
//  ChatApp
//
//  Created by Jérémy Perez on 06/09/2023.
//

import UIKit

protocol ProfileFooterDelegate: AnyObject {
    func handleLogout()
}

class ProfileFooterView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ProfileFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 32, paddingRight: 32)
        logoutButton.setHeight(height: 50)
        logoutButton.centerY(inView: self)
    }
    
}
