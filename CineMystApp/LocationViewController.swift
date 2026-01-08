//
//  LocationViewController.swift
//  CineMystApp
//
//  Created by user@50 on 08/01/26.
//

import UIKit

class LocationViewController: UIViewController {
    private let headerView = OnboardingProgressHeader()
    private let stateTextField = UITextField()
    private let postalCodeTextField = UITextField()
    private let cityTextField = UITextField()
    
    var coordinator: OnboardingCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        headerView.configure(title: "Where are you based?", currentStep: 4)
        navigationItem.hidesBackButton = true
        
        setupUI()
        
        // Dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupUI() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // State
        let stateLabel = createLabel(text: "Location (State in India) *")
        stateTextField.placeholder = "Select state"
        stateTextField.borderStyle = .roundedRect
        stateTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Postal Code
        let postalLabel = createLabel(text: "Postal Code *")
        postalCodeTextField.placeholder = "Enter postal code"
        postalCodeTextField.borderStyle = .roundedRect
        postalCodeTextField.keyboardType = .numberPad
        postalCodeTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // City
        let cityLabel = createLabel(text: "Location within this area *")
        cityTextField.placeholder = "Enter city/area"
        cityTextField.borderStyle = .roundedRect
        cityTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        stackView.addArrangedSubview(stateLabel)
        stackView.addArrangedSubview(stateTextField)
        stackView.addArrangedSubview(postalLabel)
        stackView.addArrangedSubview(postalCodeTextField)
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(cityTextField)
        
        // Next Button
        let nextButton = createNextButton()
        stackView.addArrangedSubview(nextButton)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }
    
    private func createNextButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.backgroundColor = UIColor(red: 0.3, green: 0.1, blue: 0.2, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return button
    }
    
    @objc private func nextTapped() {
        // Validate required fields
        guard let state = stateTextField.text, !state.isEmpty,
              let postal = postalCodeTextField.text, !postal.isEmpty,
              let city = cityTextField.text, !city.isEmpty else {
            showAlert(message: "Please fill all location fields")
            return
        }
        
        // Save location data to coordinator
        coordinator?.profileData.locationState = state
        coordinator?.profileData.postalCode = postal
        coordinator?.profileData.locationCity = city
        coordinator?.nextStep()
        
        // Navigate to profile picture screen
        navigateToProfilePicture()
    }
    
    private func navigateToProfilePicture() {
        let profilePictureVC = ProfilePictureViewController()
        profilePictureVC.coordinator = coordinator
        navigationController?.pushViewController(profilePictureVC, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Required", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
