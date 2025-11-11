//
//  PortfolioViewController.swift
//  CineMystApp
//
//  Created by user@50 on 11/11/25.
//


import UIKit

final class PortfolioViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let gradientHeader = UIView()
    private let titleLabel = UILabel()
    private let backButton = UIButton(type: .system)

    private let profileImage = UIImageView()
    private let addStoryButton = UIButton(type: .system)

    private let connectedButton = UIButton(type: .system)
    private let portfolioButton = UIButton(type: .system)

    private let nameLabel = UILabel()
    private let handleLabel = UILabel()
    private let connectionsLabel = UILabel()
    private let divider = UIView()

    private let aboutLabel = UILabel()
    private let aboutText = UILabel()

    private let locationLabel = UILabel()
    private let locationValue = UILabel()
    private let experienceLabel = UILabel()
    private let experienceValue = UILabel()

    private let tabStack = UIStackView()
    private let galleryTab = UILabel()
    private let flicksTab = UILabel()
    private let taggedTab = UILabel()
    private let underline = UIView()

    private let galleryGrid = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private let galleryImages = ["rani_post1", "rani_post2", "rani_post3", "rani_post4", "rani_post5", "rani_post3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layoutUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Gradient Header
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1).cgColor,
                           UIColor(red: 174/255, green: 174/255, blue: 174/255, alpha: 1).cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 190)
        gradientHeader.layer.addSublayer(gradient)
        contentView.addSubview(gradientHeader)

        titleLabel.text = "Acting for Life"
        titleLabel.font = UIFont(name: "Akshar-Medium", size: 32) ?? UIFont.systemFont(ofSize: 32, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        gradientHeader.addSubview(titleLabel)

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        gradientHeader.addSubview(backButton)

        // Profile Image
        profileImage.image = UIImage(named: "rani_profile")
        profileImage.layer.cornerRadius = 45
        profileImage.layer.masksToBounds = true
        profileImage.contentMode = .scaleAspectFill
        contentView.addSubview(profileImage)

        // Add Story Button
        addStoryButton.setImage(UIImage(named: "add_story_button"), for: .normal)
        addStoryButton.layer.cornerRadius = 15
        contentView.addSubview(addStoryButton)

        // Buttons
        [connectedButton, portfolioButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            $0.layer.cornerRadius = 14
            $0.setTitleColor(.white, for: .normal)
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor(red: 129/255, green: 41/255, blue: 163/255, alpha: 0.9).cgColor,
                               UIColor(red: 87/255, green: 29/255, blue: 72/255, alpha: 1).cgColor]
            gradient.frame = CGRect(x: 0, y: 0, width: 160, height: 37)
            gradient.cornerRadius = 14
            $0.layer.insertSublayer(gradient, at: 0)
            contentView.addSubview($0)
        }
        connectedButton.setTitle("Connected", for: .normal)
        portfolioButton.setTitle("View Portfolio", for: .normal)

        // Labels
        nameLabel.text = "Rani HBO"
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nameLabel.textAlignment = .center

        handleLabel.text = "@raniaf234 • Professional Actor"
        handleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        handleLabel.textColor = .secondaryLabel
        handleLabel.textAlignment = .center

        connectionsLabel.text = "1.2K Connections"
        connectionsLabel.font = .systemFont(ofSize: 14)
        connectionsLabel.textColor = .gray
        connectionsLabel.textAlignment = .center

        divider.backgroundColor = UIColor(white: 0.85, alpha: 1)

        aboutLabel.text = "About"
        aboutLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        aboutText.text = "Professional actor with 10+ years of experience in theater, film, and television. Passionate about storytelling and bringing characters to life."
        aboutText.font = .systemFont(ofSize: 15)
        aboutText.textColor = .secondaryLabel
        aboutText.numberOfLines = 0

        locationLabel.text = "📍 Location"
        locationLabel.font = .systemFont(ofSize: 14, weight: .medium)
        locationValue.text = "Mumbai, India"
        experienceLabel.text = "🎞 Experience"
        experienceLabel.font = .systemFont(ofSize: 14, weight: .medium)
        experienceValue.text = "10+ years"

        // Tabs
        [galleryTab, flicksTab, taggedTab].forEach {
            $0.font = .systemFont(ofSize: 20, weight: .bold)
            $0.textColor = .label
        }
        galleryTab.text = "Gallery"
        flicksTab.text = "Flicks"
        taggedTab.text = "Tagged"

        underline.backgroundColor = UIColor.black

        tabStack.axis = .horizontal
        tabStack.spacing = 50
        tabStack.distribution = .equalSpacing
        [galleryTab, flicksTab, taggedTab].forEach { tabStack.addArrangedSubview($0) }

        // Gallery Grid
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        galleryGrid.collectionViewLayout = layout
        galleryGrid.dataSource = self
        galleryGrid.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        galleryGrid.isScrollEnabled = false
        galleryGrid.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(galleryGrid)

        // Add all to contentView
        [nameLabel, handleLabel, connectionsLabel, divider, aboutLabel, aboutText,
         locationLabel, locationValue, experienceLabel, experienceValue,
         tabStack, underline].forEach { contentView.addSubview($0) }
    }

    private func layoutUI() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),

            gradientHeader.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientHeader.heightAnchor.constraint(equalToConstant: 190),

            titleLabel.centerXAnchor.constraint(equalTo: gradientHeader.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: gradientHeader.topAnchor, constant: 100),

            backButton.leadingAnchor.constraint(equalTo: gradientHeader.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: gradientHeader.topAnchor, constant: 60),

            profileImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: gradientHeader.bottomAnchor, constant: -45),
            profileImage.widthAnchor.constraint(equalToConstant: 90),
            profileImage.heightAnchor.constraint(equalToConstant: 90),

            addStoryButton.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor),
            addStoryButton.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 6),
            addStoryButton.widthAnchor.constraint(equalToConstant: 30),
            addStoryButton.heightAnchor.constraint(equalToConstant: 30),

            connectedButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            connectedButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 50),
            connectedButton.widthAnchor.constraint(equalToConstant: 150),
            connectedButton.heightAnchor.constraint(equalToConstant: 37),

            portfolioButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            portfolioButton.topAnchor.constraint(equalTo: connectedButton.topAnchor),
            portfolioButton.widthAnchor.constraint(equalToConstant: 150),
            portfolioButton.heightAnchor.constraint(equalToConstant: 37),

            nameLabel.topAnchor.constraint(equalTo: connectedButton.bottomAnchor, constant: 25),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            handleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            handleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            connectionsLabel.topAnchor.constraint(equalTo: handleLabel.bottomAnchor, constant: 8),
            connectionsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            divider.topAnchor.constraint(equalTo: connectionsLabel.bottomAnchor, constant: 12),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            divider.heightAnchor.constraint(equalToConstant: 1),

            aboutLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 20),
            aboutLabel.leadingAnchor.constraint(equalTo: divider.leadingAnchor),

            aboutText.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 6),
            aboutText.leadingAnchor.constraint(equalTo: divider.leadingAnchor),
            aboutText.trailingAnchor.constraint(equalTo: divider.trailingAnchor),

            locationLabel.topAnchor.constraint(equalTo: aboutText.bottomAnchor, constant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: divider.leadingAnchor),

            locationValue.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 2),
            locationValue.leadingAnchor.constraint(equalTo: divider.leadingAnchor),

            experienceLabel.topAnchor.constraint(equalTo: locationLabel.topAnchor),
            experienceLabel.trailingAnchor.constraint(equalTo: divider.trailingAnchor, constant: -100),

            experienceValue.topAnchor.constraint(equalTo: experienceLabel.bottomAnchor, constant: 2),
            experienceValue.trailingAnchor.constraint(equalTo: experienceLabel.trailingAnchor),

            tabStack.topAnchor.constraint(equalTo: locationValue.bottomAnchor, constant: 30),
            tabStack.leadingAnchor.constraint(equalTo: divider.leadingAnchor),
            tabStack.trailingAnchor.constraint(equalTo: divider.trailingAnchor),

            underline.topAnchor.constraint(equalTo: tabStack.bottomAnchor, constant: 2),
            underline.leadingAnchor.constraint(equalTo: galleryTab.leadingAnchor),
            underline.widthAnchor.constraint(equalToConstant: 60),
            underline.heightAnchor.constraint(equalToConstant: 2),

            galleryGrid.topAnchor.constraint(equalTo: underline.bottomAnchor, constant: 20),
            galleryGrid.leadingAnchor.constraint(equalTo: divider.leadingAnchor),
            galleryGrid.trailingAnchor.constraint(equalTo: divider.trailingAnchor),
            galleryGrid.heightAnchor.constraint(equalToConstant: 400),
            galleryGrid.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension PortfolioViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = UIImageView(image: UIImage(named: galleryImages[indexPath.item]))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        cell.contentView.addSubview(imageView)
        imageView.frame = cell.contentView.bounds
        return cell
    }
}
