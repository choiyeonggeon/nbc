//
//  ViewController.swift
//  nbc
//
//  Created by 최영건 on 8/20/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 10
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        
        view.addSubview(startButton)
        
        startButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc private func didTapStartButton() {
        let loginVC = LoginVC()
        let nav = UINavigationController(rootViewController: loginVC)
        present(nav, animated: true)
    }
    
}

