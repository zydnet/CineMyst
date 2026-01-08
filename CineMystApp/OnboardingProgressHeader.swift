//
//  OnboardingProgressHeader.swift
//  CineMystApp
//
//  Created by user@50 on 08/01/26.
//

import UIKit

class OnboardingProgressHeader: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let totalSteps = 4
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(progressStackView)
        addSubview(titleLabel)
        
        // Create progress dots
        for _ in 0..<totalSteps {
            let dot = createProgressDot()
            progressStackView.addArrangedSubview(dot)
        }
        
        NSLayoutConstraint.activate([
            progressStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            progressStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressStackView.heightAnchor.constraint(equalToConstant: 6),
            progressStackView.widthAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: progressStackView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),  // FIXED: trailingAnchor (was trailingAncor)
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func createProgressDot() -> UIView {
        let dot = UIView()
        dot.backgroundColor = UIColor.systemGray4
        dot.layer.cornerRadius = 3
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.heightAnchor.constraint(equalToConstant: 6).isActive = true
        return dot
    }
    
    func configure(title: String, currentStep: Int) {
        titleLabel.text = title
        
        // Update progress dots
        for (index, view) in progressStackView.arrangedSubviews.enumerated() {
            UIView.animate(withDuration: 0.3) {
                if index < currentStep {
                    view.backgroundColor = UIColor(red: 0.3, green: 0.1, blue: 0.2, alpha: 1.0)
                } else {
                    view.backgroundColor = UIColor.systemGray4
                }
            }
        }
    }
}
