//
//  loginVC.swift
//  nbc
//
//  Created by 최영건 on 8/21/25.
//

import UIKit
import SnapKit
import CoreData

class LoginVC: UIViewController, UITextFieldDelegate {
    
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let signupButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.placeholder = "이메일"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.keyboardType = .default
        passwordTextField.isSecureTextEntry = true
        
        loginButton.setTitle("로그인", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        
        signupButton.setTitle("회원가입", for: .normal)
        signupButton.backgroundColor = .systemGray
        signupButton.layer.cornerRadius = 8
        signupButton.addTarget(self, action: #selector(didTapSignupButton), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, signupButton])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            signupButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func didTapLoginButton() {
        guard let emeil = emailTextField.text, !emeil.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "이메일 또는 비밀번호를 입력해주세요.")
            return
        }
        
        guard let appDelgate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelgate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", emeil, password)
        
        
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                let mainVC = MainVC()
                mainVC.currentUser = user
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let sceneDelegate = windowScene.delegate as? SceneDelegate,
                   let window = sceneDelegate.window {
                    window.rootViewController = UINavigationController(rootViewController: mainVC)
                    window.makeKeyAndVisible()
                }
            } else {
                showAlert(message: "이메일 또는 비밀번호가 올바르지 않습니다.")
            }
        } catch {
            showAlert(message: "로그인 중 오류가 발생했습니다.")
        }
    }
    
    @objc private func didTapSignupButton() {
        let signVC = SignupVC()
        navigationController?.pushViewController(signVC, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
