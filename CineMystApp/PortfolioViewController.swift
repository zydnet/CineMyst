//
//  PortfolioViewController.swift
//  CineMystApp
//
//  Created by Devanshi on 11/11/25.
//

import UIKit

final class PortfolioViewController: UIViewController {

    private var collectionView: UICollectionView!

    // MARK: - Dummy Data
    private let portfolioData = PortfolioData(
        name: "Nitanshi Goel",
        role: "TV, Film, Theater Actress",
        about: """
        • IFA Award for Best Actress in Cadillac Label (2020)
        • Festival Award for Best Female Debut (2021)
        • Nominated for Teen Actress of the Year (2021)
        • Performed on the "Star Academy" of Star Plus in 2020
        • Performed at Miss India (2019), Main Kahani Hoon
        """,
        achievements: [],
        workshops: [
            Workshop(title: "Performing Arts Academy", type: "Drama and Theater Arts", location: "City, New York", duration: "Jan 2020 - July 2022"),
            Workshop(title: "Advanced Acting Workshop", type: "Drama and Theater Arts", location: "City, Mumbai", duration: "May 2019 - Jan 2020"),
            Workshop(title: "The Globe Theatre, Mumbai", type: "Shakespeare (2019), Titus Andronicus, Shakespeare (2016), Actor/Drama", location: "", duration: ""),
            Workshop(title: "Monkey Theatre Company, Mumbai", type: "A Mughal by Chance (2020), Heer, Love between Heer-Ranjha (Punjabi), Shakespeare (2017), Actor/Drama", location: "", duration: "")
        ],
        films: [
            Film(title: "Veer-Zaara", year: "2023", role: "Susan Cooper", duration: "20 MIN", production: "Paramount Pictures", imageName: "veerzaara"),
            Film(title: "Dust and Honor", year: "2024", role: "Susan Cooper - Yashoera", duration: "10 MIN", production: "Paramount Pictures", imageName: "dustandhonor")
        ]
    )

    // MARK: - Gallery Images
    private let galleryImages = ["rani1", "rani2", "rani3", "rani4", "rani5", "rani6"]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - UI Setup
    private func setupView() {
        view.backgroundColor = .black
        navigationItem.title = ""
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isHidden = true

        // Extend black background behind status bar
        if #available(iOS 13.0, *) {
            if let statusBarFrame = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame {
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.backgroundColor = .black
                view.addSubview(statusBarView)
            }
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            switch section {
            case 0: return PortfolioLayout.headerSection()
            case 1: return PortfolioLayout.workshopsSection()
            case 2: return PortfolioLayout.filmSection()
            case 3: return PortfolioLayout.gallerySection()
            default: return nil
            }
        }

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false

        // Register all cells
        collectionView.register(PortfolioHeaderCell.self, forCellWithReuseIdentifier: PortfolioHeaderCell.reuseId)
        collectionView.register(WorkshopCell.self, forCellWithReuseIdentifier: WorkshopCell.reuseId)
        collectionView.register(FilmCell.self, forCellWithReuseIdentifier: FilmCell.reuseId)
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.reuseId)

        view.addSubview(collectionView)
    }
}

// MARK: - Data Source & Delegate
extension PortfolioViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 4 }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return portfolioData.workshops.count
        case 2: return portfolioData.films.count
        case 3: return galleryImages.count
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PortfolioHeaderCell.reuseId, for: indexPath) as! PortfolioHeaderCell
            cell.configure(with: portfolioData)
            return cell

        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkshopCell.reuseId, for: indexPath) as! WorkshopCell
            cell.configure(with: portfolioData.workshops[indexPath.row])
            return cell

        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCell.reuseId, for: indexPath) as! FilmCell
            cell.configure(with: portfolioData.films[indexPath.row])
            return cell

        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.reuseId, for: indexPath) as! GalleryCell
            cell.configure(imageName: galleryImages[indexPath.row])
            return cell

        default:
            return UICollectionViewCell()
        }
    }
}
