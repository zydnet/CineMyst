//
//  CineMystTabBarController.swift
//  CineMystApp
//
//  Created by user@50 on 11/11/25.
//

import UIKit

class CineMystTabBarController: UITabBarController, UITabBarControllerDelegate {

    private let floatingButton: UIButton = {
        let button = UIButton(type: .system)
        let color = UIColor(red: 67/255, green: 22/255, blue: 49/255, alpha: 1)
        button.backgroundColor = color
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 6
        return button
    }()

    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemThinMaterialDark)
        let view = UIVisualEffectView(effect: blur)
        view.alpha = 0
        view.isHidden = true
        return view
    }()

    private var isMenuOpen = false
    private var optionButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupFloatingButton()
        setupBlurView()
        delegate = self
    }

    // MARK: - Tab Bar
    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = UIColor(white: 0, alpha: 0.2)

        let activeColor = UIColor(red: 67/255, green: 22/255, blue: 49/255, alpha: 1)
        appearance.stackedLayoutAppearance.selected.iconColor = activeColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: activeColor]
        appearance.stackedLayoutAppearance.normal.iconColor = .systemGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = activeColor
        tabBar.unselectedItemTintColor = .systemGray

        let homeVC = UINavigationController(rootViewController: HomeDashboardViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)

        let flicksVC = UIViewController()
        flicksVC.view.backgroundColor = .systemBackground
        flicksVC.tabBarItem = UITabBarItem(title: "Flicks", image: UIImage(systemName: "popcorn.fill"), tag: 1)

        let chatVC = UIViewController()
        chatVC.view.backgroundColor = .systemBackground
        chatVC.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "bubble.left.and.bubble.right.fill"), tag: 2)
        // 🔹 Mentorship tab → full flow lives under this nav stack
            let mentorHome = MentorshipHomeViewController()          // <-- make sure this file is in the target
            let mentorVC = UINavigationController(rootViewController: mentorHome)
            mentorVC.tabBarItem = UITabBarItem(title: "Mentorship",
                                               image: UIImage(systemName: "person.2.fill"),
                                               tag: 3)

        let jobsVC = UINavigationController(rootViewController: jobsViewController())
        jobsVC.tabBarItem = UITabBarItem(title: "Jobs", image: UIImage(systemName: "briefcase.fill"), tag: 4)

        viewControllers = [homeVC, flicksVC, chatVC, mentorVC, jobsVC]
    }

    // MARK: - Floating Button
    private func setupFloatingButton() {
        view.addSubview(floatingButton)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            floatingButton.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -16),
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        floatingButton.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
    }

    // MARK: - Blur View Setup
    private func setupBlurView() {
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurView, belowSubview: floatingButton)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        blurView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Floating Menu
    @objc private func didTapFloatingButton() {
        isMenuOpen ? dismissMenu() : openMenu()
    }

    
    
    func setFloatingButtonVisible(_ visible: Bool, animated: Bool = true) {
            // Close the menu if we’re hiding the FAB
            if !visible { dismissMenu() }

            let changes = {
                self.floatingButton.alpha = visible ? 1 : 0
            }
            if animated {
                UIView.animate(withDuration: 0.2, animations: changes) { _ in
                    self.floatingButton.isHidden = !visible
                }
            } else {
                changes()
                self.floatingButton.isHidden = !visible
            }
        }
    
    private func openMenu() {
        isMenuOpen = true
        blurView.isHidden = false

        UIView.animate(withDuration: 0.25) {
            self.blurView.alpha = 1
            self.floatingButton.transform = CGAffineTransform(rotationAngle: .pi / 4)
        }

        let titles = ["Post", "Story", "Flick"]
        let icons = ["square.and.pencil", "camera", "film.fill"]

        for i in 0..<titles.count {
            let optionButton = createOptionButton(title: titles[i], icon: icons[i])
            view.addSubview(optionButton)
            optionButtons.append(optionButton)

            NSLayoutConstraint.activate([
                optionButton.trailingAnchor.constraint(equalTo: floatingButton.trailingAnchor),
                optionButton.bottomAnchor.constraint(equalTo: floatingButton.topAnchor, constant: CGFloat(-80 * (i + 1))),
                optionButton.widthAnchor.constraint(equalToConstant: 120),
                optionButton.heightAnchor.constraint(equalToConstant: 50)
            ])

            optionButton.alpha = 0
            optionButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

            UIView.animate(withDuration: 0.3, delay: 0.05 * Double(i),
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.8,
                           options: []) {
                optionButton.alpha = 1
                optionButton.transform = .identity
            }
        }
    }

    private func createOptionButton(title: String, icon: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("  \(title)", for: .normal)
        button.setImage(UIImage(systemName: icon), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 67/255, green: 22/255, blue: 49/255, alpha: 1)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleOptionTap(_:)), for: .touchUpInside)
        return button
    }

    @objc private func handleOptionTap(_ sender: UIButton) {
        guard let title = sender.title(for: .normal)?.trimmingCharacters(in: .whitespaces) else { return }
        dismissMenu()

        switch title {
        case "Post":
            presentDummyScreen(title: "Create Post", color: .systemIndigo)

        case "Story", "Flick":
            let cameraVC = CameraViewController()
            cameraVC.modalPresentationStyle = .fullScreen
            cameraVC.modalTransitionStyle = .crossDissolve

            let transitionView = UIView(frame: view.bounds)
            transitionView.backgroundColor = UIColor.black
            transitionView.alpha = 0
            transitionView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            view.addSubview(transitionView)

            UIView.animate(withDuration: 0.3, animations: {
                transitionView.alpha = 1
                transitionView.transform = .identity
            }) { _ in
                self.present(cameraVC, animated: false) {
                    UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut]) {
                        transitionView.alpha = 0
                    } completion: { _ in
                        transitionView.removeFromSuperview()
                    }
                }
            }

        default:
            break
        }
    }

    private func presentDummyScreen(title: String, color: UIColor) {
        let vc = UIViewController()
        vc.view.backgroundColor = color
        vc.title = title
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }

    @objc private func dismissMenu() {
        isMenuOpen = false

        UIView.animate(withDuration: 0.25) {
            self.blurView.alpha = 0
            self.floatingButton.transform = .identity
        } completion: { _ in
            self.blurView.isHidden = true
        }

        optionButtons.forEach { button in
            UIView.animate(withDuration: 0.2) {
                button.alpha = 0
                button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            } completion: { _ in
                button.removeFromSuperview()
            }
        }

        optionButtons.removeAll()
    }

    // MARK: - Floating Button Visibility
    func setFloatingButtonVisible(_ visible: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.floatingButton.alpha = visible ? 1 : 0
            self.floatingButton.isHidden = !visible
        }
    }

    // MARK: - Tab Bar Controller Delegate Hooks
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.bringSubviewToFront(floatingButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFloatingButtonVisible(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setFloatingButtonVisible(false)
    }
}
