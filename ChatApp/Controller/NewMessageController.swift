//
//  NewMessageController.swift
//  ChatApp
//
//  Created by Jérémy Perez on 28/08/2023.
//

import UIKit

class NewMessageController: UITableViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemPurple
    }
    
}
