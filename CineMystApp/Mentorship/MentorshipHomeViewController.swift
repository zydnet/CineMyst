import UIKit

final class MentorshipHomeViewController: UIViewController {
    
    // MARK: Theme
    private let plum = UIColor(red: 0x43/255, green: 0x16/255, blue: 0x31/255, alpha: 1)

    // MARK: UI
    private let scroll = UIScrollView()
    private let content = UIStackView()

    private let headerTitle: UILabel = {
        let l = UILabel()
        l.text = "Mentorship"
        l.font = .systemFont(ofSize: 34, weight: .bold)
        return l
    }()

    private let headerSubtitle: UILabel = {
        let l = UILabel()
        l.text = "Discover & learn from your mentor"
        l.font = .systemFont(ofSize: 15)
        l.textColor = .secondaryLabel
        return l
    }()

    private let becomeMentorButton: UIButton = {
        var c = UIButton.Configuration.filled()
        c.title = "Become Mentor"
        c.cornerStyle = .capsule
        c.baseBackgroundColor = UIColor(red: 0x43/255, green: 0x16/255, blue: 0x31/255, alpha: 1)
        c.baseForegroundColor = .white
        let b = UIButton(configuration: c)
        return b
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = ""
        navigationItem.backButtonDisplayMode = .minimal

        setupLayout()
        buildSections()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the floating + button when entering Mentorship screens
        (tabBarController as? CineMystTabBarController)?.setFloatingButtonVisible(false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the + button again when leaving Mentorship tab
        (tabBarController as? CineMystTabBarController)?.setFloatingButtonVisible(true)
    }


    // MARK: Build UI
    private func setupLayout() {
        // scroll
        view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // vertical stack
        content.axis = .vertical
        content.spacing = 16
        content.isLayoutMarginsRelativeArrangement = true
        content.layoutMargins = .init(top: 16, left: 16, bottom: 24, right: 16)
        scroll.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            content.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            content.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor)
        ])

        // header row
        let headerRow = UIStackView(arrangedSubviews: [
            UIStackView.vertical(spacing: 4, headerTitle, headerSubtitle),
            UIView()
        ])
        headerRow.axis = .horizontal
        headerRow.alignment = .center

        // trailing action
        let headerContainer = UIStackView(arrangedSubviews: [headerRow, becomeMentorButton])
        headerContainer.axis = .horizontal
        headerContainer.alignment = .center
        headerContainer.spacing = 12

        content.addArrangedSubview(headerContainer)
    }

    private func buildSections() {
        // MARK: My Session
        // Pass selector to handle "See all" tap
        content.addArrangedSubview(sectionHeader(title: "My Session", actionTitle: "See all", target: self, selector: #selector(didTapSeeAllSessions)))

        let sessionList = UIStackView()
        sessionList.axis = .vertical
        sessionList.spacing = 12
        content.addArrangedSubview(sessionList)

        sessionList.addArrangedSubview(sessionCard(
            name: "Amit Sawi",
            role: "Senior Director",
            dateText: "May 15 2025 , 3:00 PM",
            image: UIImage(named : "Image" )
        ))
        sessionList.addArrangedSubview(sessionCard(
            name: "Amit Sawi",
            role: "Senior Director",
            dateText: "May 15 2025 , 3:00 PM",
            image: UIImage(named : "Image" )
        ))

        // MARK: Mentors grid (2 columns)
        content.addArrangedSubview(sectionHeader(title: "Mentors", actionTitle: "See all", target: nil, selector: nil))

        let grid = UIStackView()
        grid.axis = .horizontal
        grid.spacing = 12
        grid.distribution = .fillEqually
        content.addArrangedSubview(grid)

        // Mentor 1 (tappable → BookViewController)
        let m1 = mentorCard(
            name: "Nathan Hales",
            role: "Actor",
            rating: "4.9",
            image: UIImage(named: "Image") ?? UIImage(systemName: "person.fill")!
        )
        m1.isUserInteractionEnabled = true
        m1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapFirstMentor)))

        // Mentor 2
        let m2 = mentorCard(
            name: "Nathan Hales",
            role: "Casting Director",
            rating: "4.8",
            image: UIImage(named: "Image") ?? UIImage(systemName: "person.fill")!
        )

        grid.addArrangedSubview(m1)
        grid.addArrangedSubview(m2)
    }

    // MARK: Actions
    @objc private func didTapFirstMentor() {
        let vc = BookViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    // Handler for "See all" sessions
    @objc private func didTapSeeAllSessions() {
        let sessionsVC = SessionsViewController() // ensure this file exists
        sessionsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(sessionsVC, animated: true)
    }

    // MARK: Helpers (views)
    // Fixed: renamed button variable and selector parameter to avoid shadowing
    private func sectionHeader(title: String, actionTitle: String, target: Any?, selector: Selector?) -> UIView {
        let t = UILabel()
        t.text = title
        t.font = .systemFont(ofSize: 20, weight: .semibold)

        let button = UIButton(type: .system)
        button.setTitle(actionTitle, for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)

        // Only add target if both provided
        if let target = target, let selector = selector {
            button.addTarget(target, action: selector, for: .touchUpInside)
        }

        let row = UIStackView(arrangedSubviews: [t, UIView(), button])
        row.axis = .horizontal
        row.alignment = .center
        return row
    }

    private func sessionCard(name: String, role: String, dateText: String, image: UIImage?) -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 16

        // avatar
        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: 48).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 48).isActive = true

        // texts
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        let roleLabel = UILabel()
        roleLabel.text = role
        roleLabel.font = .systemFont(ofSize: 13)
        roleLabel.textColor = .secondaryLabel

        let dateIcon = UIImageView(image: UIImage(systemName: "calendar")!)
        dateIcon.tintColor = .secondaryLabel
        dateIcon.translatesAutoresizingMaskIntoConstraints = false
        dateIcon.widthAnchor.constraint(equalToConstant: 14).isActive = true
        dateIcon.heightAnchor.constraint(equalToConstant: 14).isActive = true

        let dateLabel = UILabel()
        dateLabel.text = dateText
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel

        let dateRow = UIStackView(arrangedSubviews: [dateIcon, dateLabel])
        dateRow.axis = .horizontal
        dateRow.spacing = 6
        dateRow.alignment = .center

        let textCol = UIStackView(arrangedSubviews: [nameLabel, roleLabel, dateRow])
        textCol.axis = .vertical
        textCol.spacing = 2

        // rating (right side)
        let star = UIImageView(image: UIImage(systemName: "star.fill"))
        star.tintColor = .systemBlue
        star.translatesAutoresizingMaskIntoConstraints = false
        star.widthAnchor.constraint(equalToConstant: 12).isActive = true
        star.heightAnchor.constraint(equalToConstant: 12).isActive = true

        let rating = UILabel()
        rating.text = "4.8"
        rating.font = .systemFont(ofSize: 12, weight: .semibold)

        let ratingRow = UIStackView(arrangedSubviews: [star, rating])
        ratingRow.axis = .horizontal
        ratingRow.alignment = .center
        ratingRow.spacing = 4

        let row = UIStackView(arrangedSubviews: [iv, textCol, UIView(), ratingRow])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 12

        container.addSubview(row)
        row.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            row.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            row.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            row.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])

        return container
    }

    private func mentorCard(name: String, role: String, rating: String, image: UIImage) -> UIView {
        let card = UIView()
        card.backgroundColor = .systemBackground
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowRadius = 6
        card.layer.shadowOffset = CGSize(width: 0, height: 2)

        let iv = UIImageView(image: image)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 120).isActive = true

        // bottom meta
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        let roleLabel = UILabel()
        roleLabel.text = role
        roleLabel.font = .systemFont(ofSize: 12)
        roleLabel.textColor = .secondaryLabel

        let star = UIImageView(image: UIImage(systemName: "star.fill"))
        star.tintColor = .systemBlue
        star.translatesAutoresizingMaskIntoConstraints = false
        star.widthAnchor.constraint(equalToConstant: 12).isActive = true
        star.heightAnchor.constraint(equalToConstant: 12).isActive = true

        let ratingLabel = UILabel()
        ratingLabel.text = rating
        ratingLabel.font = .systemFont(ofSize: 12, weight: .semibold)

        let ratingRow = UIStackView(arrangedSubviews: [star, ratingLabel])
        ratingRow.axis = .horizontal
        ratingRow.spacing = 4
        ratingRow.alignment = .center

        let bottomRow = UIStackView(arrangedSubviews: [
            UIStackView.vertical(spacing: 2, nameLabel, roleLabel),
            UIView(),
            ratingRow
        ])
        bottomRow.axis = .horizontal
        bottomRow.alignment = .center

        let vstack = UIStackView(arrangedSubviews: [iv, bottomRow])
        vstack.axis = .vertical
        vstack.spacing = 8
        vstack.isLayoutMarginsRelativeArrangement = true
        vstack.layoutMargins = .init(top: 0, left: 10, bottom: 10, right: 10)

        card.addSubview(vstack)
        vstack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vstack.topAnchor.constraint(equalTo: card.topAnchor),
            vstack.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            vstack.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            vstack.bottomAnchor.constraint(equalTo: card.bottomAnchor)
        ])
        return card
    }
}

// MARK: - Tiny Stack helpers
private extension UIStackView {
    static func vertical(spacing: CGFloat, _ views: UIView...) -> UIStackView {
        let s = UIStackView(arrangedSubviews: views)
        s.axis = .vertical
        s.spacing = spacing
        return s
    }
}
