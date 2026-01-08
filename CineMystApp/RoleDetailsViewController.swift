//
//  RoleDetailsViewController.swift
//  CineMystApp
//
//  Created by user@50 on 08/01/26.
//

import UIKit

class RoleDetailsViewController: UIViewController {
    
    private let headerView = OnboardingProgressHeader()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    var coordinator: OnboardingCoordinator?
    
    // Form data storage
    private var selectedEmploymentStatus: String?
    private var selectedPrimaryRoles: Set<String> = []
    private var selectedCareerStage: String?
    private var selectedExperience: String?
    private var travelWillingSwitch: UISwitch?
    
    private var specificRoleTextField: UITextField?
    private var companyNameTextField: UITextField?
    private var selectedCastingTypes: Set<String> = []
    private var castingRadiusTextField: UITextField?
    
    // Button references for selection tracking
    private var employmentButtons: [UIButton] = []
    private var careerStageButtons: [UIButton] = []
    private var experienceButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Configure header based on role
        let title = coordinator?.profileData.role == .artist ?
            "Tell us about yourself" :
            "Tell us about your work"
        headerView.configure(title: title, currentStep: 3)
        
        setupScrollView()
        navigationItem.hidesBackButton = true
        
        if coordinator?.profileData.role == .artist {
            setupArtistForm()
        } else {
            setupCastingProfessionalForm()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupScrollView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupArtistForm() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        // Employment Status
        stackView.addArrangedSubview(createLabel(text: "Employment Status", fontSize: 18, weight: .semibold))
        let employmentOptions = ["Freelancer", "Agency-Represented", "In-House / Full-time", "Project-based", "Student / Recent Graduate"]
        for option in employmentOptions {
            let button = createOptionButton(title: option)
            button.addTarget(self, action: #selector(employmentStatusSelected(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            employmentButtons.append(button)
        }
        
        // Primary Roles
        stackView.addArrangedSubview(createLabel(text: "Primary Roles", fontSize: 18, weight: .semibold))
        let rolesChipView = createChipSelectionView(options: ["Actor", "Dancer", "Singer", "Model", "Voice Artist"], isMultiSelect: true)
        stackView.addArrangedSubview(rolesChipView)
        
        // Career Stage
        stackView.addArrangedSubview(createLabel(text: "Career Stage", fontSize: 18, weight: .semibold))
        let careerStageOptions = ["Beginner", "Intermediate", "Pro", "Student"]
        for option in careerStageOptions {
            let button = createOptionButton(title: option)
            button.addTarget(self, action: #selector(careerStageSelected(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            careerStageButtons.append(button)
        }
        
        // Experience
        stackView.addArrangedSubview(createLabel(text: "Experience", fontSize: 18, weight: .semibold))
        let experienceOptions = ["0", "1-2", "3-5", "5+"]
        for option in experienceOptions {
            let button = createOptionButton(title: option + " years")
            button.tag = experienceOptions.firstIndex(of: option) ?? 0
            button.addTarget(self, action: #selector(experienceSelected(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            experienceButtons.append(button)
        }
        
        // Travel Willingness
        let travelSwitch = UISwitch()
        travelSwitch.addTarget(self, action: #selector(travelSwitchChanged(_:)), for: .valueChanged)
        self.travelWillingSwitch = travelSwitch
        let travelContainer = createSwitchRow(label: "Willing to travel", switchControl: travelSwitch)
        stackView.addArrangedSubview(travelContainer)
        
        // Next Button
        let nextButton = createNextButton()
        stackView.addArrangedSubview(nextButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupCastingProfessionalForm() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        // Employment Status
        stackView.addArrangedSubview(createLabel(text: "Employment Status", fontSize: 18, weight: .semibold))
        let employmentOptions = ["Freelancer", "Agency-Represented", "In-House / Full-time", "Project-based"]
        for option in employmentOptions {
            let button = createOptionButton(title: option)
            button.addTarget(self, action: #selector(employmentStatusSelected(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            employmentButtons.append(button)
        }
        
        // Specific Role
        stackView.addArrangedSubview(createLabel(text: "Specific Role", fontSize: 18, weight: .semibold))
        let roleTextField = createTextField(placeholder: "Director / Assistant / Producer / Agency")
        self.specificRoleTextField = roleTextField
        stackView.addArrangedSubview(roleTextField)
        
        // Company Name
        stackView.addArrangedSubview(createLabel(text: "Company / Production Name", fontSize: 18, weight: .semibold))
        let companyTextField = createTextField(placeholder: "Enter company name")
        self.companyNameTextField = companyTextField
        stackView.addArrangedSubview(companyTextField)
        
        // Casting Types
        stackView.addArrangedSubview(createLabel(text: "Casting Types", fontSize: 18, weight: .semibold))
        let castingChipView = createChipSelectionView(options: ["Film", "TV", "Ads", "Theater", "Web Series"], isMultiSelect: true)
        stackView.addArrangedSubview(castingChipView)
        
        // Casting Radius
        stackView.addArrangedSubview(createLabel(text: "Casting Radius (km)", fontSize: 18, weight: .semibold))
        let radiusTextField = createTextField(placeholder: "Enter radius")
        radiusTextField.keyboardType = .numberPad
        self.castingRadiusTextField = radiusTextField
        stackView.addArrangedSubview(radiusTextField)
        
        // Next Button
        let nextButton = createNextButton()
        stackView.addArrangedSubview(nextButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Selection Actions
    @objc private func employmentStatusSelected(_ sender: UIButton) {
        selectedEmploymentStatus = sender.title(for: .normal)
        highlightButton(sender, in: employmentButtons)
    }
    
    @objc private func careerStageSelected(_ sender: UIButton) {
        selectedCareerStage = sender.title(for: .normal)
        highlightButton(sender, in: careerStageButtons)
    }
    
    @objc private func experienceSelected(_ sender: UIButton) {
        let experienceOptions = ["0", "1-2", "3-5", "5+"]
        selectedExperience = experienceOptions[sender.tag]
        highlightButton(sender, in: experienceButtons)
    }
    
    @objc private func travelSwitchChanged(_ sender: UISwitch) {
        // Value is automatically tracked
    }
    
    private func highlightButton(_ selectedButton: UIButton, in buttons: [UIButton]) {
        buttons.forEach {
            $0.backgroundColor = UIColor.systemGray6
            $0.setTitleColor(.black, for: .normal)
        }
        selectedButton.backgroundColor = UIColor(red: 0.3, green: 0.1, blue: 0.2, alpha: 1.0)
        selectedButton.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - Helper Methods
    private func createLabel(text: String, fontSize: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: fontSize, weight: weight)
        return label
    }
    
    private func createOptionButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.systemGray6
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.contentHorizontalAlignment = .leading
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return button
    }
    
    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }
    
    private func createChipSelectionView(options: [String], isMultiSelect: Bool) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        var currentRow: UIStackView?
        for (index, option) in options.enumerated() {
            if index % 2 == 0 {
                currentRow = UIStackView()
                currentRow?.axis = .horizontal
                currentRow?.spacing = 8
                currentRow?.distribution = .fillEqually
                stackView.addArrangedSubview(currentRow!)
            }
            
            let chipButton = createChipButton(title: option, isMultiSelect: isMultiSelect)
            currentRow?.addArrangedSubview(chipButton)
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    private func createChipButton(title: String, isMultiSelect: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.systemGray6
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if isMultiSelect {
            button.addTarget(self, action: #selector(chipMultiSelected(_:)), for: .touchUpInside)
        }
        
        return button
    }
    
    @objc private func chipMultiSelected(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        
        if sender.backgroundColor == UIColor(red: 0.3, green: 0.1, blue: 0.2, alpha: 1.0) {
            sender.backgroundColor = UIColor.systemGray6
            sender.setTitleColor(.black, for: .normal)
            selectedPrimaryRoles.remove(title)
            selectedCastingTypes.remove(title)
        } else {
            sender.backgroundColor = UIColor(red: 0.3, green: 0.1, blue: 0.2, alpha: 1.0)
            sender.setTitleColor(.white, for: .normal)
            
            if coordinator?.profileData.role == .artist {
                selectedPrimaryRoles.insert(title)
            } else {
                selectedCastingTypes.insert(title)
            }
        }
    }
    
    private func createSwitchRow(label: String, switchControl: UISwitch) -> UIView {
        let container = UIView()
        let labelView = createLabel(text: label, fontSize: 16, weight: .regular)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(labelView)
        container.addSubview(switchControl)
        
        NSLayoutConstraint.activate([
            labelView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            labelView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            switchControl.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            container.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return container
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
        guard validateForm() else {
            showAlert(message: "Please fill all required fields")
            return
        }
        
        saveFormData()
        
        let locationVC = LocationViewController()
        locationVC.coordinator = coordinator
        navigationController?.pushViewController(locationVC, animated: true)
    }
    
    private func validateForm() -> Bool {
        guard selectedEmploymentStatus != nil else { return false }
        
        if coordinator?.profileData.role == .artist {
            return !selectedPrimaryRoles.isEmpty && selectedCareerStage != nil && selectedExperience != nil
        } else {
            return specificRoleTextField?.text?.isEmpty == false &&
                   companyNameTextField?.text?.isEmpty == false &&
                   !selectedCastingTypes.isEmpty
        }
    }
    
    private func saveFormData() {
        coordinator?.profileData.employmentStatus = selectedEmploymentStatus
        
        if coordinator?.profileData.role == .artist {
            coordinator?.profileData.primaryRoles = selectedPrimaryRoles
            coordinator?.profileData.careerStage = selectedCareerStage
            coordinator?.profileData.experienceYears = selectedExperience
            coordinator?.profileData.travelWilling = travelWillingSwitch?.isOn ?? false
        } else {
            coordinator?.profileData.specificRole = specificRoleTextField?.text
            coordinator?.profileData.companyName = companyNameTextField?.text
            coordinator?.profileData.castingTypes = selectedCastingTypes
            coordinator?.profileData.castingRadius = Int(castingRadiusTextField?.text ?? "0")
        }
        
        coordinator?.nextStep()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Required", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
