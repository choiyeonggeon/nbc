//
//  SignUpVC.swift
//  nbc
//
//  Created by 최영건 on 8/21/25.
//

import UIKit
import SnapKit
import CoreData

class SignupVC: UIViewController {
    
    private let emailTextField = UITextField()
    private let nicknameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let passwordConfirmTextField = UITextField()
    private let signupButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapgesture)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        emailTextField.placeholder = "이메일"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.placeholder = "비밀번호 (8자 이상, 특수문자 포함)"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        
        passwordConfirmTextField.placeholder = "비밀번호 확인"
        passwordConfirmTextField.isSecureTextEntry = true
        passwordConfirmTextField.borderStyle = .roundedRect
        
        nicknameTextField.placeholder = "닉네임"
        nicknameTextField.borderStyle = .roundedRect
        
        signupButton.setTitle("회원가입", for: .normal)
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.layer.cornerRadius = 8
        signupButton.backgroundColor = .systemBlue
        signupButton.addTarget(self, action: #selector(didTapSignupButton), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            passwordConfirmTextField,
            nicknameTextField,
            signupButton
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        [emailTextField, passwordTextField, passwordConfirmTextField, signupButton].forEach {
            $0.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didTapSignupButton() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = passwordConfirmTextField.text, !confirmPassword.isEmpty,
              let nickname = nicknameTextField.text, !nickname.isEmpty else {
            showAlert(message: "모든 항목을 입력해주세요.")
            return
        }
        
        if !isValidEmail(email) {
            showAlert(message: "올바른 이메일 형식이 아닙니다.")
            return
        }
        
        if !isValidPassword(password) {
            showAlert(message: "비밀번호는 8자 이상이며 특수문자를 포함해야 합니다.")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(message: "비밀번호가 일치하지 않습니다.")
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let existingUsers = try context.fetch(fetchRequest)
            if !existingUsers.isEmpty {
                showAlert(message: "이미 가입된 이메일입니다.")
                return
            }
        } catch {
            print("중복 체크 실패: \(error)")
            showAlert(message: "회원가입 실패. 다시 시도해주세요.")
            return
        }
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        user.setValue(email, forKey: "email")
        user.setValue(nickname, forKey: "nickname")
        user.setValue(password, forKey: "password")
        
        do {
            try context.save()
            
            let mainVC = MainVC()
            mainVC.currentUser = user
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = UINavigationController(rootViewController: mainVC)
                window.makeKeyAndVisible()
            }
            
        } catch {
            showAlert(message: "회원가입 실패. 다시 시도해주세요.")
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: password)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension SignupVC {
    func fetchUsers() -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            let users = try context.fetch(fetchRequest)
            return users
        } catch {
            print("유저 불러오기 실패: \(error)")
            return []
        }
    }
}
