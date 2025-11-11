import UIKit
import UniformTypeIdentifiers

// MARK: - Mentorship Enum
enum MentorshipArea: String, CaseIterable {
    case acting = "Acting"
    case dubbing = "Dubbing"
    case portfolio = "Portfolio"
}

final class ScheduleSessionViewController: UIViewController {

    // MARK: - Theme
    private let plum = UIColor(red: 0x43/255.0, green: 0x16/255.0, blue: 0x31/255.0, alpha: 1.0)
    private let accentGray = UIColor(white: 0.4, alpha: 1.0)

    // MARK: - State
    private var selectedArea: MentorshipArea?
    private var selectedTimeButton: UIButton?

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Schedule Session"
        l.font = .systemFont(ofSize: 28, weight: .bold)
        return l
    }()

    // Mentorship (chips)
    private let mentorshipTitle = ScheduleSessionViewController.sectionTitle("Mentorship Area")
    private let mentorshipStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 10
        return s
    }()

    // Choose Date
    private let chooseDateTitle = ScheduleSessionViewController.sectionTitle("Choose Date")
    private let datePicker: UIDatePicker = {
        let p = UIDatePicker()
        p.datePickerMode = .date
        if #available(iOS 14.0, *) { p.preferredDatePickerStyle = .inline }
        p.minimumDate = Date()
        return p
    }()

    // Available Time
    private let availableTitle: UILabel = {
        let l = ScheduleSessionViewController.sectionTitle("Available Time")
        l.isHidden = true
        return l
    }()
    private let timeSlotsStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.alignment = .leading
        s.spacing = 12
        s.distribution = .fillProportionally
        s.isHidden = true
        return s
    }()

    // Upload
    private let attachTitle = ScheduleSessionViewController.sectionTitle("Attach Materials (Optional)")
    private let uploadButton: UIButton = {
        var c = UIButton.Configuration.bordered()
        c.title = "Upload Files"
        c.image = UIImage(systemName: "arrow.up.doc")
        c.imagePadding = 8
        c.cornerStyle = .large
        let b = UIButton(configuration: c)
        b.contentEdgeInsets = .init(top: 10, left: 14, bottom: 10, right: 14)
        return b
    }()
    private let uploadHint: UILabel = {
        let l = UILabel()
        l.text = "Self-tapes, headshots, or scripts for review"
        l.font = .systemFont(ofSize: 12)
        l.textColor = .secondaryLabel
        return l
    }()

    // Info box
    private let infoBox: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.08)
        v.layer.cornerRadius = 14
        return v
    }()
    private let infoTitle: UILabel = {
        let l = UILabel()
        l.text = "Session Information"
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.textColor = .systemBlue
        return l
    }()
    private let infoBullets: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = .systemFont(ofSize: 13)
        l.textColor = .systemBlue
        l.text = "• Google Meet link will be sent to your email\n• Cancellation allowed up to 24 hours before"
        return l
    }()

    // Bottom button
    private let bookButton: UIButton = {
        var c = UIButton.Configuration.filled()
        c.title = "Book Session"
        c.cornerStyle = .capsule
        c.baseForegroundColor = .white
        let b = UIButton(configuration: c)
        b.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return b
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = ""
        navigationItem.backButtonDisplayMode = .minimal

        view.tintColor = accentGray // subtle accent tone
        setupLayout()
        buildMentorshipChips()
        wireActions()
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

    // MARK: - Mentorship chips
    private func buildMentorshipChips() {
        mentorshipStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for area in MentorshipArea.allCases {
            let btn = makeChipButton(title: area.rawValue)
            btn.tag = areaTag(area)
            mentorshipStack.addArrangedSubview(btn)
        }
    }

    private func makeChipButton(title: String) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 15)
        b.setTitleColor(accentGray, for: .normal)
        b.contentHorizontalAlignment = .left
        b.contentEdgeInsets = .init(top: 10, left: 14, bottom: 10, right: 14)
        b.layer.cornerRadius = 14
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor.separator.cgColor
        b.addTarget(self, action: #selector(chooseMentorship(_:)), for: .touchUpInside)
        return b
    }

    @objc private func chooseMentorship(_ sender: UIButton) {
        mentorshipStack.arrangedSubviews.compactMap { $0 as? UIButton }.forEach { setChip($0, selected: false) }
        setChip(sender, selected: true)
        selectedArea = areaFromTag(sender.tag)
    }

    private func setChip(_ b: UIButton, selected: Bool) {
        if selected {
            b.backgroundColor = plum.withAlphaComponent(0.10)
            b.layer.borderColor = plum.cgColor
            b.setTitleColor(plum, for: .normal)
        } else {
            b.backgroundColor = .clear
            b.layer.borderColor = UIColor.separator.cgColor
            b.setTitleColor(accentGray, for: .normal)
        }
    }

    private func areaTag(_ a: MentorshipArea) -> Int { a == .acting ? 1 : (a == .dubbing ? 2 : 3) }
    private func areaFromTag(_ t: Int) -> MentorshipArea? { [1:.acting,2:.dubbing,3:.portfolio][t] }

    // MARK: - Actions
    private func wireActions() {
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        uploadButton.addTarget(self, action: #selector(didTapUpload), for: .touchUpInside)
        bookButton.addTarget(self, action: #selector(didTapFinalBook), for: .touchUpInside)
    }

    @objc private func dateChanged() {
        showTimeSlots(for: datePicker.date)
    }

    @objc private func didTapUpload() {
        var types: [UTType] = [.pdf, .image, .plainText]
        if #available(iOS 14.0, *) { types.append(.data) }
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        picker.allowsMultipleSelection = true
        present(picker, animated: true)
    }

    // ✅ Updated: Navigate to Payment Screen
    @objc private func didTapFinalBook() {
        guard let selectedArea else {
            return alert("Choose mentorship area", "Please select a mentorship area to continue.")
        }
        guard let selectedTimeButton else {
            return alert("Pick a time", "Please choose an available time slot.")
        }

        let vc = PaymentViewController(
            area: selectedArea.rawValue,
            date: datePicker.date,
            time: selectedTimeButton.currentTitle ?? ""
        )

        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Time Slots
    private func showTimeSlots(for date: Date) {
        let slots = generatedSlots(for: date)
        timeSlotsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        selectedTimeButton = nil

        for s in slots {
            let b = UIButton(type: .system)
            b.setTitle(s, for: .normal)
            b.titleLabel?.font = .systemFont(ofSize: 14)
            b.setTitleColor(accentGray, for: .normal)
            b.layer.cornerRadius = 16
            b.layer.borderWidth = 1
            b.layer.borderColor = UIColor.separator.cgColor
            b.contentEdgeInsets = .init(top: 6, left: 12, bottom: 6, right: 12)
            b.addTarget(self, action: #selector(selectTime(_:)), for: .touchUpInside)
            timeSlotsStack.addArrangedSubview(b)
        }

        availableTitle.isHidden = slots.isEmpty
        timeSlotsStack.isHidden = slots.isEmpty
    }

    @objc private func selectTime(_ sender: UIButton) {
        if let prev = selectedTimeButton {
            prev.backgroundColor = .clear
            prev.setTitleColor(accentGray, for: .normal)
            prev.layer.borderColor = UIColor.separator.cgColor
        }
        selectedTimeButton = sender
        sender.backgroundColor = plum
        sender.setTitleColor(.white, for: .normal)
        sender.layer.borderColor = plum.cgColor
    }

    private func generatedSlots(for date: Date) -> [String] {
        let weekday = Calendar.current.component(.weekday, from: date)
        return (weekday == 1 || weekday == 7)
            ? ["10:00 am", "1:00 pm", "3:00 pm"]
            : ["9:00 am", "11:00 am"]
    }

    // MARK: - Layout
    private func setupLayout() {
        // Bottom button
        view.addSubview(bookButton)
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bookButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bookButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            bookButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        bookButton.configuration?.baseBackgroundColor = plum

        // ScrollView
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bookButton.topAnchor, constant: -12)
        ])

        // Content
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        // Info box internals
        infoBox.addSubview(infoTitle)
        infoBox.addSubview(infoBullets)
        infoTitle.translatesAutoresizingMaskIntoConstraints = false
        infoBullets.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoTitle.topAnchor.constraint(equalTo: infoBox.topAnchor, constant: 12),
            infoTitle.leadingAnchor.constraint(equalTo: infoBox.leadingAnchor, constant: 12),
            infoBullets.topAnchor.constraint(equalTo: infoTitle.bottomAnchor, constant: 6),
            infoBullets.leadingAnchor.constraint(equalTo: infoBox.leadingAnchor, constant: 12),
            infoBullets.trailingAnchor.constraint(equalTo: infoBox.trailingAnchor, constant: -12),
            infoBullets.bottomAnchor.constraint(equalTo: infoBox.bottomAnchor, constant: -12)
        ])

        // Main stack
        let main = UIStackView(arrangedSubviews: [
            titleLabel,
            UIView(height: 8),
            mentorshipTitle,
            mentorshipStack,
            UIView(height: 12),
            chooseDateTitle,
            datePicker,
            UIView(height: 8),
            availableTitle,
            timeSlotsStack,
            UIView(height: 16),
            attachTitle,
            uploadButton,
            uploadHint,
            UIView(height: 12),
            infoBox
        ])
        main.axis = .vertical
        main.spacing = 10

        contentView.addSubview(main)
        main.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            main.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            main.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            main.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            main.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            infoBox.heightAnchor.constraint(greaterThanOrEqualToConstant: 96)
        ])
    }

    // MARK: - Helpers
    private static func sectionTitle(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.textColor = UIColor(white: 0.15, alpha: 1.0)
        return l
    }

    private func alert(_ title: String, _ message: String) {
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }
}

// Spacer helper
private extension UIView {
    convenience init(height: CGFloat) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
