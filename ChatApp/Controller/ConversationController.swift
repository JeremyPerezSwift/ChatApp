//
//  ConversationController.swift
//  ChatApp
//
//  Created by Jérémy Perez on 10/08/2023.
//

import UIKit
import Firebase

private let reuseIdentifier = "ConversationCell"

class ConversationController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private var conversations = [Conversation]()
    
    private lazy var newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.imageView?.setDimensions(height: 24, width: 24)
        button.setDimensions(height: 56, width: 56)
        button.layer.cornerRadius = 56 / 2
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authentificationUser()
        fetchConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar(withTitle: "Messages", prefersLArgeTitle: true)
    }
    
    // MARK: - Selector
    
    @objc func showProfile() {
        let controller = ProfileController(style: .insetGrouped)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc func showNewMessage() {
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    // MARK: - API
    
    func authentificationUser() {
        if Auth.auth().currentUser?.uid == nil {
            print("DEBUG: User is not logged in.")
            presentLoginScreen()
        } else {
            print("DEBUG: User is logged in.")
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.presentLoginScreen()
        } catch {
            print("DEBUG: Error signing out")
        }
    }
    
    func fetchConversations() {
        Service.fetchConversations { conversations in
            self.conversations = conversations
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        configureTableView()
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
        view.addSubview(newMessageButton)
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    func showChatController(forUser user: User) {
        let chat = ChatController(user: user)
        navigationController?.pushViewController(chat, animated: true)
    }
    
}

extension ConversationController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ConversationCell else { return UITableViewCell() }
        cell.conversation = conversations[indexPath.row]
        return cell
    }
    
}

extension ConversationController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        showChatController(forUser: user)
    }
    
}

// MARK: - NewMessageControllerDelegate

extension ConversationController: NewMessageControllerDelegate {
    
    func controller(_ controller: NewMessageController, wantsTotStartChatWith user: User) {
        controller.dismiss(animated: true)
        showChatController(forUser: user)
    }
    
}

extension ConversationController: ProfileControllerDelegate {
    func handleLougout() {
        logout()
    }
}
