import UIKit

class SavedPostViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Saved Jobs"   // ← MOVED TITLE TO NAV BAR
        
        setupNavigationBar()
        setupScrollView()
        loadSavedJobCards()
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(handleBack)
        )
        navigationController?.navigationBar.tintColor = .black
    }

    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - ScrollView + Stack Setup
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // stack inside scrollView
        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.spacing = 20
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }

    // MARK: - Load JobCardView from Model
    private func loadSavedJobCards() {

        // Example saved jobs list → replace with your actual data array
        let savedJobs: [(title: String, company: String, location: String, salary: String, daysLeft: String, tag: String)] = [
            ("Lead Actor - Drama Series “City of Dreams”", "YRF Casting", "Mumbai, India", "₹ 5k/day", "2 days left", "Web Series"),
            ("Assistant Director - Feature Film", "Red Chillies Entertainment", "Delhi, India", "₹ 8k/day", "5 days left", "Feature Film")
        ]

        for job in savedJobs {
            let card = JobCardView()
            card.translatesAutoresizingMaskIntoConstraints = false

            card.configure(
                image: UIImage(named: "rani2"),
                title: job.title,
                company: job.company,
                location: job.location,
                salary: job.salary,
                daysLeft: job.daysLeft,
                tag: job.tag,
                appliedCount: "Applied 3 days ago"
            )

            // Optional: Add actions
            card.onTap = { print("Card tapped") }
            card.onApplyTap = { print("Apply tapped") }
            card.onBookmarkTap = { print("Bookmark tapped") }

            contentView.addArrangedSubview(card)
        }
    }
}

