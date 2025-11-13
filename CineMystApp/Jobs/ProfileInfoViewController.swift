//
//  ProfileInfoViewController.swift
//  CineMystApp
//
//  Created by user@55 on 13/11/25.
//

import UIKit

class ProfileInfoViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile Information"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor(red: 67/255, green: 0, blue: 34/255, alpha: 1) // deep maroon
        label.textAlignment = .center
        return label
    }()
    
    private func sectionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text.uppercased()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }
    
    private func textField(title: String, placeholder: String) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .darkGray
        
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.backgroundColor = UIColor.systemGray6
        tf.layer.cornerRadius = 8
        tf.setLeftPaddingPoints(10)
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, tf])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }
    
    private func selectionRow(title: String, value: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 8
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        valueLabel.textColor = .gray
        
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .gray
        
        let inner = UIStackView(arrangedSubviews: [label, UIView(), valueLabel, chevron])
        inner.axis = .horizontal
        inner.spacing = 6
        inner.alignment = .center
        container.addSubview(inner)
        
        inner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inner.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            inner.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            inner.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            inner.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
        
        return container
    }
    
    private func tagGroup(tags: [String]) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fillProportionally
        
        for tag in tags {
            let label = UILabel()
            label.text = tag
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = .darkGray
            label.backgroundColor = UIColor.systemGray5
            label.layer.cornerRadius = 14
            label.clipsToBounds = true
            label.textAlignment = .center
            label.setContentHuggingPriority(.required, for: .horizontal)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 28).isActive = true
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
            stack.addArrangedSubview(label)
        }
        return stack
    }
    
    private let verificationCard: UIView = {
        let card = UIView()
        card.backgroundColor = UIColor.systemGray6
        card.layer.cornerRadius = 12
        
        let icon = UIImageView(image: UIImage(systemName: "shield.fill"))
        icon.tintColor = .darkGray
        icon.contentMode = .scaleAspectFit
        
        let title = UILabel()
        title.text = "Professional Verification"
        title.font = UIFont.boldSystemFont(ofSize: 15)
        
        let desc = UILabel()
        desc.text = "Your profile will be reviewed for verification. Verified profiles get priority visibility and build trust with talent. This helps maintain our community’s professional standards."
        desc.font = UIFont.systemFont(ofSize: 13)
        desc.textColor = .gray
        desc.numberOfLines = 0
        
        let bullet = UILabel()
        bullet.text = "• Review typically takes 24-48 hours"
        bullet.font = UIFont.systemFont(ofSize: 13)
        bullet.textColor = .gray
        
        let stack = UIStackView(arrangedSubviews: [title, desc, bullet])
        stack.axis = .vertical
        stack.spacing = 4
        
        card.addSubview(icon)
        card.addSubview(stack)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            icon.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            icon.widthAnchor.constraint(equalToConstant: 30),
            icon.heightAnchor.constraint(equalToConstant: 30),
            
            stack.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
        ])
        return card
    }()
    
    private let nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next  →", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.backgroundColor = UIColor(red: 67/255, green: 0, blue: 34/255, alpha: 1)
        btn.layer.cornerRadius = 10
        btn.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return btn
    }()
    
    // MARK: - Actions
    @objc private func nextButtonTapped() {
        let postJobVC = PostJobViewController()
        navigationController?.pushViewController(postJobVC, animated: true)
    }

    private let skipButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Skip for now", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupLayout()
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Layout
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false

       
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
    
    private func setupLayout() {
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .fill
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(mainStack)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            mainStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // --- Add Sections ---
        mainStack.addArrangedSubview(sectionLabel("Basic Information"))
        mainStack.addArrangedSubview(textField(title: "Professional Title *", placeholder: "e.g. Producer, Production Manager, Studio"))
        
        mainStack.addArrangedSubview(sectionLabel("Company Details"))
        mainStack.addArrangedSubview(textField(title: "Production House *", placeholder: "Your production company name"))
        mainStack.addArrangedSubview(selectionRow(title: "Company Type", value: "Select company"))
        mainStack.addArrangedSubview(selectionRow(title: "Years of Experience", value: "Select experience"))
        
        mainStack.addArrangedSubview(sectionLabel("Location and Reach"))
        mainStack.addArrangedSubview(textField(title: "Primary Location *", placeholder: "Your production company name"))
        mainStack.addArrangedSubview(selectionRow(title: "Additional Locations", value: "Select company"))
        
        mainStack.addArrangedSubview(sectionLabel("Professional Expertise"))
        mainStack.addArrangedSubview(tagGroup(tags: ["Feature Films", "TV Series", "Commercials", "Documentary"]))
        mainStack.addArrangedSubview(tagGroup(tags: ["DGA", "PGA", "CSA", "IATSE", "WGA"]))
        
        mainStack.addArrangedSubview(sectionLabel("Professional Links"))
        mainStack.addArrangedSubview(textField(title: "Website/Portfolio", placeholder: "https://your-website.com"))
        mainStack.addArrangedSubview(textField(title: "IMDb Profile", placeholder: "https://imdb.com/name/..."))
        mainStack.addArrangedSubview(selectionRow(title: "Preferred Contract", value: "Select contract"))
        mainStack.addArrangedSubview(selectionRow(title: "Budget Range", value: "Select budget range"))
        
        mainStack.addArrangedSubview(verificationCard)
        mainStack.addArrangedSubview(nextButton)
        mainStack.addArrangedSubview(skipButton)
    }
}

// MARK: - Padding Extension
extension UITextField {
    func setPaddingLeft(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

