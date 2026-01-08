//
//  SignUpViewController.swift
//  CineMystApp
//
//  Created by user@50 on 19/11/25.
//

import UIKit
import Supabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Gradient Layer
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradientBackground()
        setupUI()
        setupActivityIndicator()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientFrame()
    }
    
    // MARK: - Gradient Background
    private func applyGradientBackground() {
        let gradient = CAGradientLayer()
        
        gradient.colors = [
            UIColor(red: 54/255, green: 18/255, blue: 52/255, alpha: 1).cgColor, // top
            UIColor(red: 22/255, green: 8/255, blue: 35/255, alpha: 1).cgColor   // bottom
        ]
        
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        
        // Remove old gradient if present
        view.layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.removeFromSuperlayer() }

        view.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    private func updateGradientFrame() {
        gradientLayer?.frame = view.bounds
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        passwordTextField.isSecureTextEntry = true
        emailTextField.autocapitalizationType = .none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let fullName = fullNameTextField.text, !fullName.isEmpty,
              let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please fill all fields")
            return
        }

        guard isValidEmail(email) else {
            showAlert(message: "Enter a valid email")
            return
        }

        // Call the actual implemented method
        performSignUp(username: username, fullName: fullName, email: email, password: password)
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Sign Up (updated with onboarding flow)
    private func performSignUp(username: String, fullName: String, email: String, password: String) {
        showLoading(true)

        Task {
            do {
                let _ = try await supabase.auth.signUp(
                    email: email,
                    password: password,
                    data: [
                        "username": AnyJSON(username),
                        "full_name": AnyJSON(fullName)
                    ]
                )

                await MainActor.run {
                    showLoading(false)
                    
                    // Check if email confirmation is required
                    // If your Supabase project requires email confirmation, show alert
                    // Otherwise, navigate directly to onboarding
                    
                    if self.requiresEmailConfirmation() {
                        self.showAlert(
                            title: "Account Created",
                            message: "Please check your email to verify your account, then sign in to continue."
                        )
                    } else {
                        // Navigate directly to onboarding flow
                        self.navigateToOnboarding(username: username, fullName: fullName)
                    }
                }

            } catch {
                await MainActor.run {
                    showLoading(false)
                    showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Navigation to Onboarding
    private func navigateToOnboarding(username: String, fullName: String) {
        // Create onboarding coordinator
        let coordinator = OnboardingCoordinator()
        
        // Pre-fill username and full name if you want to store them
        // You can extend ProfileData to include these fields
        
        // Create first onboarding screen (Birthday)
        let birthdayVC = BirthdayViewController()
        birthdayVC.coordinator = coordinator
        
        // Navigate to birthday screen
        navigationController?.pushViewController(birthdayVC, animated: true)
    }
    
    // MARK: - Email Confirmation Check
    private func requiresEmailConfirmation() -> Bool {
        // Check your Supabase project settings
        // If you have email confirmation enabled, return true
        // Otherwise return false to go directly to onboarding
        
        // For now, let's assume you DON'T require email confirmation
        // Change this to true if your Supabase has email confirmation enabled
        return true
    }

    // MARK: - Helpers
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }

    private func showLoading(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        view.isUserInteractionEnabled = !show
    }

    private func showAlert(title: String = "CineMyst", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
