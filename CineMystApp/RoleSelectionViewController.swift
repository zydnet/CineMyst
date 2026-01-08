//
//  RoleSelectionViewController.swift
//  CineMystApp
//
//  Created by user@50 on 08/01/26.
//

import UIKit

class RoleSelectionViewController: UIViewController {
    
    private let headerView = OnboardingProgressHeader()
    
    private var roleButtons: [UIButton] = []
    private var selectedRole: UserRole?
    
    var coordinator: OnboardingCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        // Configure header
        headerView.configure(title: "What brings you here?", currentStep: 2)
        
        // Hide back button
        navigationItem.hidesBackButton = true
    }
    
    private func setupUI() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        for role in UserRole.allCases {
            let button = createRoleButton(title: role.rawValue, role: role)
            stackView.addArrangedSubview(button)
            roleButtons.append(button)
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func createRoleButton(title: String, role: UserRole) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.systemGray6
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        button.tag = UserRole.allCases.firstIndex(of: role) ?? 0
        button.addTarget(self, action: #selector(roleSelected(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func roleSelected(_ sender: UIButton) {
        let role = UserRole.allCases[sender.tag]
        selectedRole = role
        coordinator?.profileData.role = role
        coordinator?.nextStep()
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.roleButtons.forEach {
                $0.backgroundColor = UIColor.systemGray6
                $0.setTitleColor(.black, for: .normal)
            }
            sender.backgroundColor = UIColor(red: 0.3, green: 0.1, blue: 0.2, alpha: 1.0)
            sender.setTitleColor(.white, for: .normal)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.navigateToRoleDetails()
        }
    }
    
    private func navigateToRoleDetails() {
        let roleDetailsVC = RoleDetailsViewController()
        roleDetailsVC.coordinator = coordinator
        navigationController?.pushViewController(roleDetailsVC, animated: true)
    }
}
