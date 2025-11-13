import UIKit

class JobCardView: UIView {
    
    private let profileImageView = UIImageView()
    private let titleLabel = UILabel()
    private let companyTagContainer = UIView()
    private let companyTagLabel = UILabel()
    private let bookmarkButton = UIButton(type: .system)
    private let locationIcon = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
    private let locationLabel = UILabel()
    private let salaryLabel = UILabel()
    private let clockIcon = UIImageView(image: UIImage(systemName: "clock"))
    private let daysLeftLabel = UILabel()
    private let tagLabel = UILabel()
    private let appliedLabel = UILabel()
    private let applyButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(
        image: UIImage?,
        title: String,
        company: String,
        location: String,
        salary: String,
        daysLeft: String,
        tag: String,
        appliedCount: String = "0 applied"
    ) {
        profileImageView.image = image
        titleLabel.text = title
        companyTagLabel.text = company
        locationLabel.text = location
        salaryLabel.text = salary
        daysLeftLabel.text = daysLeft
        tagLabel.text = "• \(tag)"
        appliedLabel.text = appliedCount
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // MARK: Profile Image
        profileImageView.layer.cornerRadius = 22
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .systemGray5
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: Title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.numberOfLines = 2
        
        // MARK: Company Tag — fixed width issue (now hugs content)
        companyTagLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        companyTagLabel.textColor = UIColor(red: 113/255, green: 30/255, blue: 96/255, alpha: 1)
        companyTagLabel.backgroundColor = .clear
        companyTagLabel.textAlignment = .center
        
        companyTagContainer.backgroundColor = UIColor.systemGray6
        companyTagContainer.layer.cornerRadius = 10
        companyTagContainer.addSubview(companyTagLabel)
        companyTagContainer.translatesAutoresizingMaskIntoConstraints = false
        companyTagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            companyTagLabel.topAnchor.constraint(equalTo: companyTagContainer.topAnchor, constant: 4),
            companyTagLabel.bottomAnchor.constraint(equalTo: companyTagContainer.bottomAnchor, constant: -4),
            companyTagLabel.leadingAnchor.constraint(equalTo: companyTagContainer.leadingAnchor, constant: 10),
            companyTagLabel.trailingAnchor.constraint(equalTo: companyTagContainer.trailingAnchor, constant: -10),
            companyTagContainer.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        // MARK: Bookmark
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmarkButton.tintColor = .black
        
        // MARK: Info Row
        locationIcon.tintColor = .gray
        clockIcon.tintColor = .gray
        [locationIcon, clockIcon].forEach { $0.contentMode = .scaleAspectFit }
        
        locationLabel.font = UIFont.systemFont(ofSize: 13)
        locationLabel.textColor = .darkGray
        
        salaryLabel.font = UIFont.boldSystemFont(ofSize: 13)
        salaryLabel.textColor = UIColor(red: 113/255, green: 30/255, blue: 96/255, alpha: 1)
        
        daysLeftLabel.font = UIFont.systemFont(ofSize: 13)
        daysLeftLabel.textColor = .darkGray
        
        // MARK: Tag & Applied
        tagLabel.font = UIFont.systemFont(ofSize: 13)
        tagLabel.textColor = .darkGray
        tagLabel.backgroundColor = UIColor.systemGray6
        tagLabel.layer.cornerRadius = 12
        tagLabel.clipsToBounds = true
        tagLabel.textAlignment = .center
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        appliedLabel.font = UIFont.systemFont(ofSize: 13)
        appliedLabel.textColor = .darkGray
        appliedLabel.textAlignment = .right
        
        // MARK: Apply Button
        applyButton.setTitle("Apply Now", for: .normal)
        applyButton.backgroundColor = UIColor(red: 47/255, green: 9/255, blue: 32/255, alpha: 1)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        applyButton.layer.cornerRadius = 10
        
        // MARK: Layout Structure
        let topRow = UIStackView(arrangedSubviews: [profileImageView, titleLabel, bookmarkButton])
        topRow.axis = .horizontal
        topRow.spacing = 10
        topRow.alignment = .top
        
        let companyRow = UIStackView(arrangedSubviews: [companyTagContainer])
        companyRow.axis = .horizontal
        companyRow.alignment = .leading
        
        let infoRow = UIStackView(arrangedSubviews: [
            iconLabelStack(icon: locationIcon, label: locationLabel),
            salaryLabel,
            iconLabelStack(icon: clockIcon, label: daysLeftLabel)
        ])
        infoRow.axis = .horizontal
        infoRow.distribution = .equalSpacing
        infoRow.alignment = .center
        
        let bottomRow = UIStackView(arrangedSubviews: [tagLabel, appliedLabel])
        bottomRow.axis = .horizontal
        bottomRow.distribution = .equalSpacing
        bottomRow.alignment = .center
        
        let mainStack = UIStackView(arrangedSubviews: [topRow, companyRow, infoRow, bottomRow, applyButton])
        mainStack.axis = .vertical
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 44),
            profileImageView.heightAnchor.constraint(equalToConstant: 44),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 24),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 24),
            
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            applyButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    private func iconLabelStack(icon: UIImageView, label: UILabel) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }
}

