import UIKit

class jobsViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let staticHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore jobs"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(red: 47/255, green: 9/255, blue: 32/255, alpha: 1)
        label.alpha = 0 // hidden initially, fades in on scroll
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Explore jobs"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = UIColor(red: 47/255, green: 9/255, blue: 32/255, alpha: 1)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover your next role"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let searchField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search opportunities..."
        tf.backgroundColor = UIColor.systemGray6
        tf.layer.cornerRadius = 10
        tf.setLeftPaddingPoints(12)
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return tf
    }()
    
    private let categoryStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let postButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let curatedLabel: UILabel = {
        let label = UILabel()
        label.text = "Curated for you"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(red: 47/255, green: 9/255, blue: 32/255, alpha: 1)
        return label
    }()
    
    private let curatedSubtitle: UILabel = {
        let label = UILabel()
        label.text = "Opportunities that match your expertise and aspirations"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 2
        return label
    }()
    
    private let jobListStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupLayout()
        setupCategories()
        setupPostButtons()
        addJobCards()
    }
    
    // MARK: - Setup ScrollView
    private func setupScrollView() {
        // Sticky header label
        view.addSubview(staticHeaderLabel)
        
        staticHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            staticHeaderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            staticHeaderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // ScrollView setup
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
[
            scrollView.topAnchor.constraint(equalTo: staticHeaderLabel.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]
)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        [titleLabel, subtitleLabel, searchField, categoryStack, postButtonsStack,
         curatedLabel, curatedSubtitle, jobListStack].forEach { contentView.addSubview($0) }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchField.translatesAutoresizingMaskIntoConstraints = false
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
        postButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        curatedLabel.translatesAutoresizingMaskIntoConstraints = false
        curatedSubtitle.translatesAutoresizingMaskIntoConstraints = false
        jobListStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            searchField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
            searchField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            searchField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            categoryStack.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 16),
            categoryStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            postButtonsStack.topAnchor.constraint(equalTo: categoryStack.bottomAnchor, constant: 20),
            postButtonsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            postButtonsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            curatedLabel.topAnchor.constraint(equalTo: postButtonsStack.bottomAnchor, constant: 24),
            curatedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            curatedSubtitle.topAnchor.constraint(equalTo: curatedLabel.bottomAnchor, constant: 4),
            curatedSubtitle.leadingAnchor.constraint(equalTo: curatedLabel.leadingAnchor),
            curatedSubtitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            jobListStack.topAnchor.constraint(equalTo: curatedSubtitle.bottomAnchor, constant: 16),
            jobListStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            jobListStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            jobListStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Categories
    private func setupCategories() {
        let categories = ["All", "Web Series", "Feature Film"]
        for (index, title) in categories.enumerated() {
            let button = createCategoryButton(title: title, selected: index == 0)
            categoryStack.addArrangedSubview(button)
        }
    }
    
    private func createCategoryButton(title: String, selected: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.layer.cornerRadius = 14
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.setTitleColor(selected ? .white : .black, for: .normal)
        button.backgroundColor = selected
            ? UIColor(red: 47/255, green: 9/255, blue: 32/255, alpha: 1)
            : .clear
        return button
    }
    
    // MARK: - Post Buttons
    private func setupPostButtons() {
        let buttonTitles = ["Post a job", "My Jobs", "Posted"]
        
        for title in buttonTitles {
            let btn = UIButton(type: .system)
            btn.setTitle(title, for: .normal)
            btn.backgroundColor = .white
            btn.setTitleColor(.black, for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            btn.layer.cornerRadius = 12
            btn.layer.shadowColor = UIColor.black.cgColor
            btn.layer.shadowOpacity = 0.15
            btn.layer.shadowOffset = CGSize(width: 0, height: 3)
            btn.layer.shadowRadius = 4
            btn.contentEdgeInsets = UIEdgeInsets(top: 14, left: 18, bottom: 14, right: 18)
            
            if title == "Post a job" {
                btn.addTarget(self, action: #selector(postJobTapped), for: .touchUpInside)
            }
            postButtonsStack.addArrangedSubview(btn)
        }
        postButtonsStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc private func postJobTapped() {
        let profileVC = ProfileInfoViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    // MARK: - Job Cards
    private func addJobCards() {
        let jobs = [
            ("Lead Actor - Drama Series “City of …”", "YRF Casting", "Mumbai, India", "₹ 5k/day", "2 days left", "Web Series"),
            ("Assistant Director - Feature Film", "Red Chillies Entertainment", "Delhi, India", "₹ 8k/day", "5 days left", "Feature Film"),
            ("Background Dancer", "T-Series", "Pune, India", "₹ 3k/day", "1 day left", "Music Video"),
            ("Camera Operator", "Balaji Motion Pictures", "Hyderabad, India", "₹ 6k/day", "3 days left", "Web Series")
        ]
        
        for job in jobs {
            let card = JobCardView()
            card.configure(
                image: UIImage(named: "rani2"),
                title: job.0,
                company: job.1,
                location: job.2,
                salary: job.3,
                daysLeft: job.4,
                tag: job.5
            )
            jobListStack.addArrangedSubview(card)
        }
    }
    
    // MARK: - ScrollView Delegate for Sticky Header
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let alpha = min(max((offsetY - 40) / 30, 0), 1) // smoother fade
        staticHeaderLabel.alpha = alpha
    }
}

// MARK: - UITextField Padding Helper
extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

