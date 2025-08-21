//
//  MainVC.swift
//  nbc
//
//  Created by 최영건 on 8/21/25.
//

import UIKit
import CoreData

class MainVC: UIViewController {
    
    private let welcomeLabel = UILabel()
    private let logoutButton = UIButton()
    private let deleteAccountButton = UIButton()
    
    var currentUser: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        if let nickname = currentUser?.value(forKey: "nickname") as? String {
            welcomeLabel.text = "\(nickname) 님 환영합니다!"
        } else {
            welcomeLabel.text = "환영합니다!"
        }
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.backgroundColor = .systemGray
        logoutButton.layer.cornerRadius = 8
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        
        deleteAccountButton.setTitle("회원탈퇴", for: .normal)
        deleteAccountButton.backgroundColor = .systemRed
        deleteAccountButton.layer.cornerRadius = 8
        deleteAccountButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [welcomeLabel, logoutButton, deleteAccountButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
    }
    
    @objc private func didTapLogoutButton() {
        moveToStartVC()
    }
    
    @objc private func didTapDeleteButton() {
        guard let user = currentUser,
              let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(user)
        
        do {
            try context.save()
            moveToStartVC()
        } catch {
            print("회원탈퇴 실패: \(error)")
        }
    }
    
    private func moveToStartVC() {
        let startVC = ViewController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            window.rootViewController = UINavigationController(rootViewController: startVC)
            window.makeKeyAndVisible()
        }
    }
}
