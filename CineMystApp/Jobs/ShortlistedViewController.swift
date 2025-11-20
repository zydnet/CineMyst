//
//  ShortlistedViewController.swift
//  CineMystApp
//
import UIKit

// MARK: - Model
struct ShortlistedCandidate {
    let name: String
    let experience: String
    let location: String
    let daysAgo: String
    let isConnected: Bool
    let isTaskSubmitted: Bool
    let profileImage: UIImage?
}


// MARK: - Custom Cell
final class ShortlistedCell: UITableViewCell {

    static let id = "ShortlistedCell"

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 28
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textColor = UIColor(red: 67/255, green: 22/255, blue: 49/255, alpha: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let experienceLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = .darkGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = .gray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let clockLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textColor = .gray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let connectedTag: UILabel = {
        let lbl = UILabel()
        lbl.text = "Connected"
        lbl.textColor = UIColor(red: 160/255, green: 80/255, blue: 235/255, alpha: 1)
        lbl.font = .systemFont(ofSize: 11, weight: .semibold)
        lbl.textAlignment = .center
        lbl.backgroundColor = UIColor(red: 245/255, green: 235/255, blue: 255/255, alpha: 1)
        lbl.layer.cornerRadius = 10
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let taskSubmittedTag: UILabel = {
        let lbl = UILabel()
        lbl.text = "Task Submitted"
        lbl.textColor = UIColor(red: 61/255, green: 160/255, blue: 80/255, alpha: 1)
        lbl.font = .systemFont(ofSize: 11, weight: .semibold)
        lbl.textAlignment = .center
        lbl.backgroundColor = UIColor(red: 225/255, green: 255/255, blue: 230/255, alpha: 1)
        lbl.layer.cornerRadius = 10
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let chatButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "bubble.left.and.bubble.right"), for: .normal)
        btn.tintColor = UIColor(red: 67/255, green: 22/255, blue: 49/255, alpha: 1)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }


    // MARK: Configure
    func configure(with candidate: ShortlistedCandidate) {
        profileImageView.image = candidate.profileImage
        nameLabel.text = candidate.name
        experienceLabel.text = candidate.experience
        locationLabel.attributedText = iconText("mappin.and.ellipse", text: candidate.location)
        clockLabel.attributedText = iconText("clock", text: candidate.daysAgo)

        connectedTag.isHidden = !candidate.isConnected
        taskSubmittedTag.isHidden = !candidate.isTaskSubmitted
    }


    // MARK: Tag + Icon builder
    private func iconText(_ icon: String, text: String) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: icon)
        attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)

        let attr = NSMutableAttributedString(attachment: attachment)
        attr.append(NSAttributedString(string: "  \(text)"))
        return attr
    }


    // MARK: Layout
    private func setupUI() {

        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(experienceLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(clockLabel)
        contentView.addSubview(connectedTag)
        contentView.addSubview(taskSubmittedTag)
        contentView.addSubview(chatButton)

        NSLayoutConstraint.activate([

            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            profileImageView.widthAnchor.constraint(equalToConstant: 56),
            profileImageView.heightAnchor.constraint(equalToConstant: 56),

            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),

            experienceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            experienceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),

            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            locationLabel.topAnchor.constraint(equalTo: experienceLabel.bottomAnchor, constant: 6),

            clockLabel.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 14),
            clockLabel.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),

            connectedTag.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            connectedTag.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            connectedTag.heightAnchor.constraint(equalToConstant: 20),
            connectedTag.widthAnchor.constraint(equalToConstant: 85),

            taskSubmittedTag.leadingAnchor.constraint(equalTo: connectedTag.trailingAnchor, constant: 10),
            taskSubmittedTag.centerYAnchor.constraint(equalTo: connectedTag.centerYAnchor),
            taskSubmittedTag.heightAnchor.constraint(equalToConstant: 20),
            taskSubmittedTag.widthAnchor.constraint(equalToConstant: 110),

            chatButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chatButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            contentView.bottomAnchor.constraint(equalTo: connectedTag.bottomAnchor, constant: 16)
        ])
    }
}



// MARK: - ShortlistedViewController
final class ShortlistedViewController: UIViewController {

    private var tableView = UITableView(frame: .zero, style: .plain)

    private let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "2 applications"
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .gray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let candidates: [ShortlistedCandidate] = [
        ShortlistedCandidate(
            name: "Aisha Sharma",
            experience: "8 years experience",
            location: "Mumbai, India",
            daysAgo: "21 days ago",
            isConnected: false,
            isTaskSubmitted: true,
            profileImage: UIImage(named: "cand3")
        ),
        ShortlistedCandidate(
            name: "Aisha Sharma",
            experience: "8 years experience",
            location: "Mumbai, India",
            daysAgo: "21 days ago",
            isConnected: true,
            isTaskSubmitted: true,
            profileImage: UIImage(named: "cand3")
        )
    ]


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupNavBar()
        setupUI()
        setupTable()
    }


    // MARK: Navigation Bar
    private func setupNavBar() {

        navigationItem.title = "Shortlisted"
        navigationController?.navigationBar.prefersLargeTitles = false

        let backBtn = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backAction)
        )

        backBtn.tintColor = UIColor(red: 67/255, green: 22/255, blue: 49/255, alpha: 1)
        navigationItem.leftBarButtonItem = backBtn
    }

    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }


    // MARK: UI
    private func setupUI() {
        view.addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2)
        ])
    }


    // MARK: Table Setup
    private func setupTable() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(ShortlistedCell.self, forCellReuseIdentifier: ShortlistedCell.id)
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


// MARK: - Table DataSource
extension ShortlistedViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ShortlistedCell.id, for: indexPath) as! ShortlistedCell

        cell.configure(with: candidates[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
