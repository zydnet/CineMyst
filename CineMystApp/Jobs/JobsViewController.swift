import UIKit

// MARK: - Colors & Helpers
fileprivate extension UIColor {
    static let themePlum = UIColor(red: 67/255, green: 22/255, blue: 49/255, alpha: 1)
    static let softGrayBg = UIColor(red: 247/255, green: 245/255, blue: 247/255, alpha: 1)
}

fileprivate func makeShadow(on view: UIView, radius: CGFloat = 6, yOffset: CGFloat = 4, opacity: Float = 0.12) {
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = opacity
    view.layer.shadowRadius = radius
    view.layer.shadowOffset = CGSize(width: 0, height: yOffset)
    view.layer.masksToBounds = false
}

// Simple padding extension for UITextField used in search
extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: 36))
        leftView = padding
        leftViewMode = .always
    }
}

// MARK: - CategoryChipView
final class CategoryChipView: UIControl {
    private let iconView = UIImageView()
    private let label = UILabel()
    private let container = UIView()
    var isSelectedChip: Bool = false {
        didSet { updateAppearance() }
    }
    
    init(icon: UIImage?, title: String) {
        super.init(frame: .zero)
        iconView.image = icon?.withRenderingMode(.alwaysTemplate)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = .systemGray
        
        label.text = title
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        container.layer.cornerRadius = 18
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemGray5.cgColor
        container.backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(iconView)
        container.addSubview(label)
        addSubview(container)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 16),
            
            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            container.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        updateAppearance()
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    @objc private func handleTap() {
        sendActions(for: .primaryActionTriggered)
    }
    
    private func updateAppearance() {
        if isSelectedChip {
            container.backgroundColor = .themePlum
            label.textColor = .white
            iconView.tintColor = .white
            container.layer.borderColor = UIColor.clear.cgColor
        } else {
            container.backgroundColor = .white
            label.textColor = .themePlum
            iconView.tintColor = .systemGray
            container.layer.borderColor = UIColor.systemGray4.cgColor
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}



// MARK: - JobsViewController
final class jobsViewController: UIViewController, UIScrollViewDelegate {
    
    // Theme
    private let themeColor = UIColor.themePlum
    
    // Core UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    
    // Title bar
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Explore jobs"
        l.font = UIFont.boldSystemFont(ofSize: 34)
        return l
    }()
    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Discover your next role"
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = UIColor.systemGray
        return l
    }()
    private lazy var bookmarkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        return btn
    }()
    private lazy var filterButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: 26).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 26).isActive = true
        return btn
    }()
    
    // Search
    private let searchField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search opportunities"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor.systemGray6
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 0.6
        tf.layer.borderColor = UIColor.systemGray4.cgColor
        tf.clipsToBounds = true
        tf.heightAnchor.constraint(equalToConstant: 44).isActive = true

        // SF Symbol search icon on left
        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = .systemGray2
        icon.contentMode = .scaleAspectFit
        icon.frame = CGRect(x: 0, y: 0, width: 34, height: 18)

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 44))
        icon.center = container.center
        container.addSubview(icon)
        tf.leftView = container
        tf.leftViewMode = .always

        // Clear button like native search bars
        tf.clearButtonMode = .whileEditing

        // Slight padding for text
        tf.textColor = .label
        tf.font = UIFont.systemFont(ofSize: 16)

        return tf
    }()

    
    // Categories (scrollable)
    private let categoriesScroll = UIScrollView()
    private let categoriesStack = UIStackView()
    private var categoryChips: [CategoryChipView] = []
    private let categoriesData: [(String, String)] = [
        ("All", "chart.line.uptrend.xyaxis"),
        ("Web Series", "tv"),
        ("Feature Film", "film"),
        ("Music Video", "music.note.list")
    ]
    
    // Post buttons
    private let postButtonsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.spacing = 12
        s.distribution = .fillEqually
        return s
    }()
    
    // Curated header
    private let curatedLabel: UILabel = {
        let l = UILabel()
        l.text = "Curated for you"
        l.font = UIFont.boldSystemFont(ofSize: 22)
        return l
    }()
    private let curatedSubtitle: UILabel = {
        let l = UILabel()
        l.text = "Opportunities that match your expertise and aspirations"
        l.font = UIFont.systemFont(ofSize: 13)
        l.textColor = .systemGray
        l.numberOfLines = 2
        return l
    }()
    
    // Job list
    private let jobListStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 16
        return s
    }()
    
    // Dim + Filter
    private var dimView = UIView()
    private var filterVC: FilterScrollViewController?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        applyTheme()
        
        setupScrollView()
        setupTitleBar()
        setupSearchAndCategories()
        setupPostButtons()
        setupCuratedAndJobs()
        setupBottomSpacing()
        
        filterButton.addTarget(self, action: #selector(openFilter), for: .touchUpInside)
        bookmarkButton.addTarget(self, action: #selector(openSavedPosts), for: .touchUpInside)
        
        // Add sample job cards
        addJobCards()
    }
    
    private func applyTheme() {
        
        titleLabel.textColor = themeColor
        curatedLabel.textColor = themeColor
        bookmarkButton.tintColor = themeColor
        filterButton.tintColor = themeColor
    }
    
    
    
    // MARK: - ScrollView & Content
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    // Title bar at top of content
    private func setupTitleBar() {
        let titleBar = UIStackView(arrangedSubviews: [titleLabel, UIView(), bookmarkButton, filterButton])
        titleBar.axis = .horizontal
        titleBar.alignment = .center
        titleBar.spacing = 12
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleBar)
        contentView.addSubview(subtitleLabel)
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleBar.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleBar.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    // Search and category chips
    private func setupSearchAndCategories() {
        contentView.addSubview(searchField)
        contentView.addSubview(categoriesScroll)
        
        searchField.translatesAutoresizingMaskIntoConstraints = false
        categoriesScroll.translatesAutoresizingMaskIntoConstraints = false
        
        categoriesScroll.showsHorizontalScrollIndicator = false
        categoriesScroll.addSubview(categoriesStack)
        
        categoriesStack.axis = .horizontal
        categoriesStack.spacing = 12
        categoriesStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            searchField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            searchField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            categoriesScroll.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 16),
            categoriesScroll.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            categoriesScroll.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoriesScroll.heightAnchor.constraint(equalToConstant: 35),
            
            categoriesStack.topAnchor.constraint(equalTo: categoriesScroll.topAnchor),
            categoriesStack.bottomAnchor.constraint(equalTo: categoriesScroll.bottomAnchor),
            categoriesStack.leadingAnchor.constraint(equalTo: categoriesScroll.leadingAnchor, constant: 12),
            categoriesStack.trailingAnchor.constraint(equalTo: categoriesScroll.trailingAnchor, constant: -12),
            categoriesStack.heightAnchor.constraint(equalTo: categoriesScroll.heightAnchor)
        ])
        
        // Build chips
        for (i, item) in categoriesData.enumerated() {
            let icon = UIImage(systemName: item.1)
            let chip = CategoryChipView(icon: icon, title: item.0)
            chip.layer.cornerRadius = 16
            chip.isSelectedChip = (i == 0) // "All" selected by default
            chip.addTarget(self, action: #selector(categoryTapped(_:)), for: .primaryActionTriggered)
            categoryChips.append(chip)
            categoriesStack.addArrangedSubview(chip)
        }
    }
    
    // Post buttons row
    private func setupPostButtons() {
        contentView.addSubview(postButtonsStack)
        postButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postButtonsStack.topAnchor.constraint(equalTo: categoriesStack.bottomAnchor, constant: 18),
            postButtonsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            postButtonsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            postButtonsStack.heightAnchor.constraint(equalToConstant: 42),
            postButtonsStack.widthAnchor.constraint(equalToConstant: 102)
        ])
        
        let titles = ["Post a job", "My Jobs", "Posted"]
        for t in titles {
            let btn = UIButton(type: .system)
            btn.setTitle(t, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            btn.layer.cornerRadius = 12
            btn.backgroundColor = .white
            btn.setTitleColor(UIColor(red: 83/255, green: 26/255, blue: 87/255, alpha: 1), for: .normal)
            btn.contentEdgeInsets = UIEdgeInsets(top: 16, left: 18, bottom: 16, right: 18)
            // shadow
            makeShadow(on: btn, radius: 6, yOffset: 4, opacity: 0.12)
            btn.layer.borderWidth = 0.6
            btn.layer.borderColor = UIColor.systemGray4.cgColor
            
            switch t {
            case "Post a job": btn.addTarget(self, action: #selector(postJobTapped), for: .touchUpInside)
            case "My Jobs": btn.addTarget(self, action: #selector(myJobsTapped), for: .touchUpInside)
            case "Posted": btn.addTarget(self, action: #selector(didTapPosted), for: .touchUpInside)
            default: break
            }
            
            postButtonsStack.addArrangedSubview(btn)
        }
    }
    
    // Curated header + job list
    private func setupCuratedAndJobs() {
        [curatedLabel, curatedSubtitle, jobListStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            curatedLabel.topAnchor.constraint(equalTo: postButtonsStack.bottomAnchor, constant: 26),
            curatedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            curatedSubtitle.topAnchor.constraint(equalTo: curatedLabel.bottomAnchor, constant: 6),
            curatedSubtitle.leadingAnchor.constraint(equalTo: curatedLabel.leadingAnchor),
            curatedSubtitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            jobListStack.topAnchor.constraint(equalTo: curatedSubtitle.bottomAnchor, constant: 16),
            jobListStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            jobListStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    // Ensure bottom spacing
    private func setupBottomSpacing() {
        // add a spacer view so contentView has a bottom constraint for scrolling
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spacer)
        NSLayoutConstraint.activate([
            spacer.topAnchor.constraint(equalTo: jobListStack.bottomAnchor),
            spacer.heightAnchor.constraint(equalToConstant: 160),
            spacer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spacer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            spacer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Sample job cards (uses your JobCardView)
    private func addJobCards() {
        let jobs = [
            ("Lead Actor - Drama Series “City of …”", "YRF Casting", "Mumbai, India", "₹ 5k/day", "2 days left", "Web Series"),
            ("Assistant Director - Feature Film", "Red Chillies Entertainment", "Delhi, India", "₹ 8k/day", "5 days left", "Feature Film"),
            ("Background Dancer", "T-Series", "Pune, India", "₹ 3k/day", "1 day left", "Music Video"),
            ("Camera Operator", "Balaji Motion Pictures", "Hyderabad, India", "₹ 6k/day", "3 days left", "Web Series")
        ]
        
        for job in jobs {
            let card = JobCardView() // <-- your existing view; keep as is
            card.configure(
                image: UIImage(named: "rani2"),
                title: job.0,
                company: job.1,
                location: job.2,
                salary: job.3,
                daysLeft: job.4,
                tag: job.5
            )
            
            card.onTap = { [weak self] in
                let vc = JobDetailsViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            card.onApplyTap = { [weak self] in
                let vc = ApplicationStartedViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            jobListStack.addArrangedSubview(card)
        }
    }
    
    // MARK: - Actions
    @objc private func categoryTapped(_ sender: CategoryChipView) {
        for chip in categoryChips { chip.isSelectedChip = (chip === sender) }
        // TODO: filter list if required
    }
    
    @objc private func postJobTapped() {
        let vc = ProfileInfoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func myJobsTapped() {
        let vc = MyApplicationsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func didTapPosted() {
        let vc = PostedJobsDashboardViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func openSavedPosts() {
        let vc = SavedPostViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Filter sheet
    @objc private func openFilter() {
        let vc = FilterScrollViewController()
        filterVC = vc
        
        dimView = UIView(frame: view.bounds)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        view.addSubview(dimView)
        dimView.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeFilter))
        dimView.addGestureRecognizer(tap)
        
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        let height: CGFloat = view.frame.height * 0.72
        vc.view.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
        vc.view.layer.cornerRadius = 20
        vc.view.clipsToBounds = true
        
        UIView.animate(withDuration: 0.28) {
            self.dimView.backgroundColor = UIColor.black.withAlphaComponent(0.32)
            self.dimView.alpha = 1
            vc.view.frame.origin.y = self.view.frame.height - height
        }
    }
    
    @objc private func closeFilter() {
        guard let vc = filterVC else { return }
        let height = vc.view.frame.height
        UIView.animate(withDuration: 0.25, animations: {
            self.dimView.alpha = 0
            vc.view.frame.origin.y = self.view.frame.height
        }) { _ in
            self.dimView.removeFromSuperview()
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
    }
    
    // Scroll fade header
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

