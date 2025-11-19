//
//  LoginViewController.swift
//  CineMystApp
//
//  Created by user@50 on 11/11/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        applyGradientBackground()
      }
      
      override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          // ensure gradient resizes on rotation or layout changes
          updateGradientFrame()
      }
      
      // MARK: - Gradient Layer
      
      private var gradientLayer: CAGradientLayer?
      
      private func applyGradientBackground() {
          let gradient = CAGradientLayer()
          
          gradient.colors = [
            UIColor(red: 54/255, green: 18/255, blue: 52/255, alpha: 1).cgColor, // top color
            UIColor(red: 22/255, green: 8/255, blue: 35/255, alpha: 1).cgColor   // bottom color
          ]
          gradient.startPoint = CGPoint(x: 0, y: 0)
          gradient.endPoint = CGPoint(x: 1, y: 1)
          gradient.frame = view.bounds
          
          // Clean old layers if you hot-reload
          view.layer.sublayers?
              .filter { $0 is CAGradientLayer }
              .forEach { $0.removeFromSuperlayer() }
          
          view.layer.insertSublayer(gradient, at: 0)
          gradientLayer = gradient
      }
      
      private func updateGradientFrame() {
          gradientLayer?.frame = view.bounds
      }
    
    
    
    
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func forgetPasswordButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
    }
    
    
    
    @IBAction func facebookLoginTapped(_ sender: UIButton) {
    }
    
    
    
    @IBAction func instagramLoginTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func appleLoginTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func googleLoginTapped(_ sender: UIButton) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
