import UIKit
import AVFoundation

final class TaskDetailsViewController: UIViewController {
    
    // MARK: - Colors (matched from screenshot)
    private let plum = UIColor(hex: "#5A4459")
    private let deepPlum = UIColor(hex: "#2E0321")
    private let tagPurple = UIColor(hex: "#5A4459")
    private let lightBg = UIColor(hex: "#F5F5F5")
    private let cardGray = UIColor(hex: "#F0F0F0")
    private let textGray = UIColor(hex: "#8E8E93")
    
    // MARK: - Views
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stack = UIStackView()
    
    // MARK: - Upload Storage
    private var selectedMediaThumbnail: UIImage?
    private var selectedMediaURL: URL?
    private var uploadContainer: UIStackView?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = lightBg
        navigationItem.title = "Task Details"
        setupScrollView()
        setupStack()
        buildContent()
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

    private func showSubmissionSuccess() {
        let dim = UIView(frame: view.bounds)
        dim.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dim.alpha = 0
        dim.tag = 5001
        view.addSubview(dim)
        
        let popup = UIView()
        popup.backgroundColor = .white
        popup.layer.cornerRadius = 18
        popup.clipsToBounds = true
        popup.alpha = 0
        popup.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        popup.tag = 5002
        
        view.addSubview(popup)
        popup.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            popup.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popup.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popup.widthAnchor.constraint(equalToConstant: 250),
            popup.heightAnchor.constraint(equalToConstant: 210)
        ])
        
        let check = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        check.tintColor = plum
        check.contentMode = .scaleAspectFit
        check.translatesAutoresizingMaskIntoConstraints = false
        
        let title = UILabel()
        title.text = "Task Submitted!"
        title.font = .boldSystemFont(ofSize: 18)
        title.textColor = .black
        title.textAlignment = .center
        
        let msg = UILabel()
        msg.text = "Your audition has been successfully submitted."
        msg.font = .systemFont(ofSize: 14)
        msg.textColor = .darkGray
        msg.textAlignment = .center
        msg.numberOfLines = 2
        
        let stack = UIStackView(arrangedSubviews: [check, title, msg])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        popup.addSubview(stack)
        
        NSLayoutConstraint.activate([
            check.heightAnchor.constraint(equalToConstant: 52),
            check.widthAnchor.constraint(equalToConstant: 52),
            
            stack.centerXAnchor.constraint(equalTo: popup.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: popup.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: popup.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: popup.trailingAnchor, constant: -16)
        ])
        
        UIView.animate(withDuration: 0.25) {
            dim.alpha = 1
            popup.alpha = 1
            popup.transform = .identity
        }
        
        check.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        UIView.animate(
            withDuration: 0.4,
            delay: 0.1,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: .curveEaseOut
        ) {
            check.transform = .identity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.25, animations: {
                dim.alpha = 0
                popup.alpha = 0
            }) { _ in
                dim.removeFromSuperview()
                popup.removeFromSuperview()
            }
        }
    }

    // MARK: - Scroll Setup
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func setupStack() {
        contentView.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Build UI
    private func buildContent() {
        stack.addArrangedSubview(makeTopTaskCard())
        stack.addArrangedSubview(makeSceneCard())
        stack.addArrangedSubview(makeCharacterCard())
        stack.addArrangedSubview(makeReferenceCard())
        stack.addArrangedSubview(makeUploadCard())
        stack.addArrangedSubview(makeSubmitButton())
    }
    
    // MARK: - Card Factory
    private func createCard() -> UIView {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.04
        v.layer.shadowRadius = 8
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        return v
    }
    
    private func makeTopTaskCard() -> UIView {
        let card = createCard()
        
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - Top Row (Icon + Title)
        let iconBG = UIView()
        iconBG.backgroundColor = plum
        iconBG.layer.cornerRadius = 10
        iconBG.translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImageView(image: UIImage(systemName: "video.fill"))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        iconBG.addSubview(icon)
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: iconBG.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconBG.centerYAnchor),
            iconBG.widthAnchor.constraint(equalToConstant: 46),
            iconBG.heightAnchor.constraint(equalToConstant: 46)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = "Lead Actor – “City of Dreams”"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 2
        
        let subtitle = UILabel()
        subtitle.text = "YRF Casting"
        subtitle.font = .systemFont(ofSize: 14)
        subtitle.textColor = textGray
        
        // Title + Subtitle stacked vertically
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, subtitle])
        titleStack.axis = .vertical
        titleStack.spacing = 2
        
        let topRow = UIStackView(arrangedSubviews: [iconBG, titleStack])
        topRow.axis = .horizontal
        topRow.spacing = 12
        topRow.alignment = .center
        
        // MARK: - Tag Row (Tag + Due Date)
        let tag = smallTag(text: "New Task")
        
        let calendarIcon = UIImageView(image: UIImage(systemName: "calendar"))
        calendarIcon.tintColor = textGray
        calendarIcon.translatesAutoresizingMaskIntoConstraints = false
        
       
        NSLayoutConstraint.activate([
            calendarIcon.widthAnchor.constraint(equalToConstant: 16),
            calendarIcon.heightAnchor.constraint(equalToConstant: 16)
        ])

        
        let dueLabel = UILabel()
        dueLabel.text = "Due: September 22, 2025"
        dueLabel.font = .systemFont(ofSize: 13)
        dueLabel.textColor = textGray
        
        let dueRow = UIStackView(arrangedSubviews: [calendarIcon, dueLabel])
        dueRow.axis = .horizontal
        dueRow.spacing = 8
        dueRow.alignment = .center
        dueRow.distribution = .fill

        
        let bottomRow = UIStackView(arrangedSubviews: [tag, dueRow])
        bottomRow.spacing = 12   // adjust this number

        
        // MARK: - Assemble
        container.addArrangedSubview(topRow)
        container.addArrangedSubview(bottomRow)
        
        card.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            container.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        return card
    }

    
    private func makeSceneCard() -> UIView {
        let card = createCard()
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 12
        v.translatesAutoresizingMaskIntoConstraints = false
        
        v.addArrangedSubview(sectionTitle("Dramatic Monologue Scene"))
        v.addArrangedSubview(paragraph("Perform the emotional breakdown scene from the pilot episode. Focus on the character's internal struggle and demonstrate your range in dramatic acting"))
        v.addArrangedSubview(sectionTitle("Requirements"))
        
        let reqs = [
            "Memorize the provided monologue",
            "Record in landscape mode with good lighting",
            "No costume changes needed - business casual",
            "Submit by deadline for review"
        ]
        
        let reqStack = UIStackView()
        reqStack.axis = .vertical
        reqStack.spacing = 8
        
        for r in reqs {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 10
            row.alignment = .top
            
            let check = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
            check.tintColor = .systemGreen
            check.widthAnchor.constraint(equalToConstant: 20).isActive = true
            check.heightAnchor.constraint(equalToConstant: 20).isActive = true
            check.translatesAutoresizingMaskIntoConstraints = false
            
            let label = paragraph(r)
            
            row.addArrangedSubview(check)
            row.addArrangedSubview(label)
            reqStack.addArrangedSubview(row)
        }
        
        v.addArrangedSubview(reqStack)
        
        card.addSubview(v)
        
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            v.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            v.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            v.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        return card
    }
    
    private func makeCharacterCard() -> UIView {
        let card = createCard()
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 12
        v.translatesAutoresizingMaskIntoConstraints = false
        
        v.addArrangedSubview(sectionTitle("Character: Marcus Wheeler"))
        v.addArrangedSubview(boldLabel("Description"))
        v.addArrangedSubview(paragraph("A dedicated detective haunted by a cold case that defined his career"))
        
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = 16
        
        row.addArrangedSubview(verticalSmall(title: "Age range", value: "28–35"))
        row.addArrangedSubview(verticalSmall(title: "Genre", value: "Crime Drama"))
        
        v.addArrangedSubview(row)
        v.addArrangedSubview(boldLabel("Personality"))
        v.addArrangedSubview(paragraph("A dedicated detective haunted by a cold case that defined his career"))
        
        card.addSubview(v)
        
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            v.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            v.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            v.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        return card
    }
    
    private func makeReferenceCard() -> UIView {
        let card = createCard()
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 12
        v.translatesAutoresizingMaskIntoConstraints = false
        
        v.addArrangedSubview(sectionTitle("Scene: The Confession Room - Pilot"))
        v.addArrangedSubview(boldLabel("Setting"))
        v.addArrangedSubview(paragraph("A dedicated detective haunted by a cold case that defined his career"))
        
        let durationRow = UIStackView()
        durationRow.axis = .horizontal
        durationRow.distribution = .fillEqually
        durationRow.spacing = 16
        
        durationRow.addArrangedSubview(verticalSmall(title: "Duration", value: "28-35"))
        durationRow.addArrangedSubview(verticalSmall(title: "Genre", value: "Crime Drama"))
        
        v.addArrangedSubview(durationRow)
        v.addArrangedSubview(boldLabel("Reference Scene"))
        
        let ref = UIView()
        ref.backgroundColor = cardGray
        ref.layer.cornerRadius = 12
        ref.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        let refStack = UIStackView()
        refStack.axis = .vertical
        refStack.spacing = 10
        refStack.alignment = .center
        refStack.translatesAutoresizingMaskIntoConstraints = false
        
        let play = UIImageView(image: UIImage(systemName: "play.fill"))
        play.tintColor = textGray
        play.widthAnchor.constraint(equalToConstant: 32).isActive = true
        play.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        refStack.addArrangedSubview(play)
        refStack.addArrangedSubview(smallLabel("5-minute reference video"))
        
        ref.addSubview(refStack)
        
        NSLayoutConstraint.activate([
            refStack.centerXAnchor.constraint(equalTo: ref.centerXAnchor),
            refStack.centerYAnchor.constraint(equalTo: ref.centerYAnchor)
        ])
        
        v.addArrangedSubview(ref)
        
        let watch = UIButton(type: .system)
        watch.setTitle("Watch Reference", for: .normal)
        watch.backgroundColor = .white
        watch.setTitleColor(.label, for: .normal)
        watch.layer.cornerRadius = 10
        watch.layer.borderColor = UIColor.systemGray4.cgColor
        watch.layer.borderWidth = 1
        watch.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        watch.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        v.addArrangedSubview(watch)
        
        card.addSubview(v)
        
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            v.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            v.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            v.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        return card
    }
    
    // MARK: - Upload Card
    private func makeUploadCard() -> UIView {
        let card = createCard()
        
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 12
        v.translatesAutoresizingMaskIntoConstraints = false
        uploadContainer = v
        
        v.addArrangedSubview(sectionTitle("Submit Your Performance"))
        
        let uploadBtn = UIButton(type: .system)
        uploadBtn.setTitle("  Upload Your Audition", for: .normal)
        uploadBtn.setTitleColor(.white, for: .normal)
        uploadBtn.backgroundColor = plum
        uploadBtn.layer.cornerRadius = 10
        uploadBtn.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        uploadBtn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        uploadBtn.tintColor = .white
        uploadBtn.heightAnchor.constraint(equalToConstant: 48).isActive = true
        uploadBtn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        uploadBtn.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
        
        v.addArrangedSubview(uploadBtn)
        v.addArrangedSubview(smallLabel("Upload your video, audio, or document files for review"))
        
        card.addSubview(v)
        
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            v.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            v.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            v.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        return card
    }
    
    @objc private func uploadTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = ["public.movie", "public.image"]
        picker.videoQuality = .typeMedium
        present(picker, animated: true)
    }
    
    private func updateUploadPreview() {
        guard let stack = uploadContainer else { return }
        
        if let old = stack.arrangedSubviews.first(where: { $0.tag == 999 }) {
            stack.removeArrangedSubview(old)
            old.removeFromSuperview()
        }
        
        let preview = UIStackView()
        preview.axis = .horizontal
        preview.spacing = 12
        preview.alignment = .center
        preview.tag = 999
        preview.backgroundColor = cardGray
        preview.layer.cornerRadius = 10
        preview.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        preview.isLayoutMarginsRelativeArrangement = true
        
        let thumb = UIImageView(image: selectedMediaThumbnail ?? UIImage(systemName: "photo"))
        thumb.contentMode = .scaleAspectFill
        thumb.clipsToBounds = true
        thumb.layer.cornerRadius = 8
        thumb.widthAnchor.constraint(equalToConstant: 80).isActive = true
        thumb.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.text = selectedMediaURL?.lastPathComponent ?? "Image Selected"
        
        preview.addArrangedSubview(thumb)
        preview.addArrangedSubview(label)
        
        stack.addArrangedSubview(preview)
    }
    
    private func generateVideoThumbnail(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let gen = AVAssetImageGenerator(asset: asset)
            gen.appliesPreferredTrackTransform = true
            
            if let cgImage = try? gen.copyCGImage(at: .zero, actualTime: nil) {
                completion(UIImage(cgImage: cgImage))
            } else {
                completion(nil)
            }
        }
    }
    
    private func makeSubmitButton() -> UIView {
        let container = UIView()
        let btn = UIButton(type: .system)
        btn.setTitle("Submit Application", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = deepPlum
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(btn)
        btn.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: container.topAnchor),
            btn.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            btn.heightAnchor.constraint(equalToConstant: 52),
            btn.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    @objc private func submitTapped() {
        showSubmissionSuccess()
    }
    
    // MARK: - UI Helpers
    private func sectionTitle(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 17, weight: .semibold)
        return l
    }
    
    private func boldLabel(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 15, weight: .semibold)
        return l
    }
    
    private func paragraph(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 15)
        l.textColor = textGray
        l.numberOfLines = 0
        return l
    }
    
    private func smallLabel(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 13)
        l.textColor = textGray
        l.numberOfLines = 0
        return l
    }
    
    private func smallTag(text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 12, weight: .semibold)
        l.textColor = .white
        l.backgroundColor = tagPurple
        l.textAlignment = .center
        l.layer.cornerRadius = 12
        l.clipsToBounds = true
        l.heightAnchor.constraint(equalToConstant: 26).isActive = true
        l.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        return l
    }

    private func verticalSmall(title: String, value: String) -> UIView {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 4
        
        let t = UILabel()
        t.text = title
        t.font = .systemFont(ofSize: 14)
        t.textColor = textGray
        
        let val = UILabel()
        val.text = value
        val.font = .systemFont(ofSize: 15)
        
        v.addArrangedSubview(t)
        v.addArrangedSubview(val)
        
        return v
    }
}

// MARK: - Picker Delegate
extension TaskDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        if let url = info[.mediaURL] as? URL {
            selectedMediaURL = url
            generateVideoThumbnail(from: url) { [weak self] img in
                DispatchQueue.main.async {
                    self?.selectedMediaThumbnail = img
                    self?.updateUploadPreview()
                }
            }
        }
        else if let img = info[.originalImage] as? UIImage {
            selectedMediaThumbnail = img
            selectedMediaURL = nil
            updateUploadPreview()
        }
    }
}

// MARK: - UIColor Hex Helper
fileprivate extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if s.hasPrefix("#") { s.remove(at: s.startIndex) }
        var rgb: UInt64 = 0
        Scanner(string: s).scanHexInt64(&rgb)
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255,
            blue: CGFloat(rgb & 0x0000FF) / 255,
            alpha: alpha
        )
    }
}
