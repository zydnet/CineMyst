import UIKit

class CandidateCardView: UIView {

    private let model: CandidateModel

    init(model: CandidateModel) {
        self.model = model
        super.init(frame: .zero)

        layer.cornerRadius = 20
        layer.masksToBounds = true   // IMPORTANT → ensures image clips
        backgroundColor = .clear

        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - UI Elements

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // Dark gradient overlay for better text visibility
    private let gradientLayer = CAGradientLayer()

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 22)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15)
        lbl.textColor = UIColor(white: 0.9, alpha: 0.9)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let experienceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 15)
        lbl.textColor = UIColor(white: 0.9, alpha: 0.9)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let verifyIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "checkmark.seal.fill"))
        iv.tintColor = .systemBlue
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let submittedBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Task Submitted", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let profileBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("View Profile", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.backgroundColor = UIColor(red: 70/255, green: 0, blue: 70/255, alpha: 0.9)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Setup UI

    private func setupUI() {

        // FULL SCREEN IMAGE
        addSubview(imageView)
        imageView.image = UIImage(named: model.imageName)

        // GRADIENT
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]
        gradientLayer.locations = [0.4, 1.0]
        layer.addSublayer(gradientLayer)

        // TEXT OVER IMAGE
        addSubview(nameLabel)
        addSubview(verifyIcon)
        addSubview(locationLabel)
        addSubview(experienceLabel)
        addSubview(submittedBtn)
        addSubview(profileBtn)

        nameLabel.text = model.name
        locationLabel.text = model.location
        experienceLabel.text = model.experience

        // MARK: Constraints

        NSLayoutConstraint.activate([

            // IMAGE → FILL ENTIRE CARD
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -6),

            verifyIcon.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 6),
            verifyIcon.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            verifyIcon.widthAnchor.constraint(equalToConstant: 18),
            verifyIcon.heightAnchor.constraint(equalToConstant: 18),

            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            locationLabel.bottomAnchor.constraint(equalTo: experienceLabel.topAnchor, constant: -6),

            experienceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            experienceLabel.bottomAnchor.constraint(equalTo: submittedBtn.topAnchor, constant: -12),

            submittedBtn.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            submittedBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            submittedBtn.widthAnchor.constraint(equalToConstant: 120),
            submittedBtn.heightAnchor.constraint(equalToConstant: 32),

            profileBtn.leadingAnchor.constraint(equalTo: submittedBtn.trailingAnchor, constant: 12),
            profileBtn.centerYAnchor.constraint(equalTo: submittedBtn.centerYAnchor),
            profileBtn.widthAnchor.constraint(equalToConstant: 120),
            profileBtn.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds   // ensures gradient covers entire image
    }
}

