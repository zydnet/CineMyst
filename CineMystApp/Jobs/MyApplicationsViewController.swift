import UIKit

class MyApplicationsViewController: UIViewController {

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "My Applications"
        lbl.font = UIFont.boldSystemFont(ofSize: 26)
        lbl.textColor = UIColor(red: 67/255, green: 0, blue: 34/255, alpha: 1)
        return lbl
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Active", "Pending", "Completed"])
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .white
        sc.selectedSegmentTintColor = UIColor.white
        sc
            .setTitleTextAttributes(
                [.foregroundColor: UIColor.black],
                for: .selected
            )
        sc.setTitleTextAttributes([.foregroundColor: UIColor.darkGray], for: .normal)
        sc.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return sc
    }()
    
    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Track your casting journey in one place"
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .gray
        return lbl
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        return sv
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        loadCardsFor(segment: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            // Hide tab bar only
            tabBarController?.tabBar.isHidden = true

            // If you also have a floating button on your custom TabBarController,
            // you'll need to hide/show it here as well. Example:
            // (Assuming your tabBar controller has a `floatingButton` property)
            //
            // if let tb = tabBarController as? CineMystTabBarController {
            //     tb.setFloatingButton(hidden: true)
            // }
        }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            // Restore tab bar only
            tabBarController?.tabBar.isHidden = false

            // Restore floating button if you hid it above:
            // if let tb = tabBarController as? CineMystTabBarController {
            //     tb.setFloatingButton(hidden: false)
            // }
        }


    // MARK: - Layout Setup
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, segmentedControl, subtitleLabel, stackView].forEach {
            contentView.addSubview($0)
        }

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 42),
            
            subtitleLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }

    // MARK: - Segment Changed
    @objc private func segmentChanged() {
        loadCardsFor(segment: segmentedControl.selectedSegmentIndex)
    }

    // MARK: - Load Cards
    private func loadCardsFor(segment: Int) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        switch segment {
        case 0: loadActiveCards()
        case 1: loadPendingCards()
        case 2: loadCompletedCards()
        default: break
        }
    }

    // MARK: - Cards Data
    private func loadActiveCards() {
        for _ in 0..<3 {
            stackView.addArrangedSubview(makeJobCard(statusButtonTitle: "View Task", statusColor: UIColor(red: 67/255, green: 0, blue: 34/255, alpha: 1)))
        }
    }
    
    private func loadPendingCards() {
        stackView.addArrangedSubview(makeJobCard(statusButtonTitle: "Submitted", statusColor: .gray))
    }
    
    private func loadCompletedCards() {
        stackView.addArrangedSubview(makeJobCard(statusButtonTitle: "Booked", statusColor: .systemGreen))
    }

    // MARK: - Card View Builder
    private func makeJobCard(statusButtonTitle: String, statusColor: UIColor) -> UIView {
        
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowOffset = CGSize(width: 0, height: 3)
        card.layer.shadowRadius = 6
        
        let title = UILabel()
        title.text = "Lead Actor - Drama Series “City of Dreams”"
        title.numberOfLines = 2
        title.font = UIFont.boldSystemFont(ofSize: 16)
        
        let company = UILabel()
        company.text = "YRF Casting"
        company.font = UIFont.systemFont(ofSize: 14)
        company.textColor = .gray
        
        let locationIcon = UIImageView(image: UIImage(systemName: "location.fill"))
        locationIcon.tintColor = .gray
        locationIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        let locationLabel = UILabel()
        locationLabel.text = "Mumbai, India"
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        let payLabel = UILabel()
        payLabel.text = "₹ 5k/day"
        payLabel.font = UIFont.systemFont(ofSize: 14)

        let tag1 = makeTag("Series Regular")
        let tag2 = makeTag("Under Review")

        let appliedLabel = UILabel()
        appliedLabel.text = "Applied 3 days ago"
        appliedLabel.font = UIFont.systemFont(ofSize: 13)
        appliedLabel.textColor = .gray
        
        let statusButton = UIButton(type: .system)
        statusButton.setTitle(statusButtonTitle, for: .normal)
        statusButton.setTitleColor(.white, for: .normal)
        statusButton.backgroundColor = statusColor
        statusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        statusButton.layer.cornerRadius = 10
        statusButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
        
        statusButton.addTarget(self, action: #selector(viewTaskTapped), for: .touchUpInside)


        let h1 = UIStackView(arrangedSubviews: [locationIcon, locationLabel, payLabel])
        h1.axis = .horizontal
        h1.spacing = 6
        h1.alignment = .center
        
        let tagsRow = UIStackView(arrangedSubviews: [tag1, tag2, UIView()])
        tagsRow.axis = .horizontal
        tagsRow.spacing = 8
        tagsRow.alignment = .center
        
        
        let footer = UIStackView(arrangedSubviews: [appliedLabel, UIView(), statusButton])
        footer.axis = .horizontal
        footer.alignment = .center

        let stack = UIStackView(arrangedSubviews: [title, company, h1, tagsRow, footer])
        stack.axis = .vertical
        stack.spacing = 10
        
        card.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        return card
    }
    
    @objc private func viewTaskTapped() {
        let vc = TaskDetailsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }


    private func makeTag(_ text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(white: 0.95, alpha: 1)
        container.layer.cornerRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)

        container.setContentHuggingPriority(.required, for: .horizontal)
        container.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -6)

        ])

        return container
    }
}

extension UILabel {
    func padding(_ vertical: CGFloat, _ horizontal: CGFloat) {
        self.drawText(in: self.bounds.insetBy(dx: -horizontal, dy: -vertical))
    }
}

