import UIKit
import PhotosUI

// MARK: - Custom Color
extension UIColor {
    static let appPurple = UIColor(red: 67/255, green: 22/255, blue: 49/255, alpha: 1) // #431631
}

class PostJobViewController: UIViewController {

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let formStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let assignTaskButton = UIButton.createFilledButton(title: "Assign Task")
    private let cancelButton = UIButton.createOutlineButton(title: "Cancel")
    
    // MARK: - Form Data Properties
    private var dueDateTextField: UITextField?
    private var applicationDeadlineTextField: UITextField?
    private var genreLabel: UILabel?
    private var uploadedFileName: UILabel?
    private var selectedDueDate: Date?
    private var selectedDeadlineDate: Date?
    private var selectedGenre: String?
    private var uploadedFileURL: URL?
    
    // MARK: - Date Pickers
    private let dueDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.minimumDate = Date()
        return picker
    }()
    
    private let deadlineDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.minimumDate = Date()
        return picker
    }()
    
    // MARK: - Animation Components
    private let successOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let successAnimationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 20
        view.alpha = 0
        view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let checkmarkView: CheckmarkView = {
        let view = CheckmarkView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let successLabel: UILabel = {
        let label = UILabel()
        label.text = "Task Assigned Successfully!"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .appPurple
        label.textAlignment = .center
        label.numberOfLines = 0
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let successSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Actor will be notified"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupScrollView()
        buildForm()
        setupBottomButtons()
        setupSuccessAnimation()
        setupDatePickers()
        setupKeyboardDismissal()
        
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


    // MARK: - Navigation Bar
    private func setupNavBar() {
        title = "Post a job"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
    }

    // MARK: - ScrollView + Content
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(formStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),

            formStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            formStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            formStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            formStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)
        ])
    }
    
    // MARK: - Date Picker Setup
    private func setupDatePickers() {
        dueDatePicker.addTarget(self, action: #selector(dueDateChanged), for: .valueChanged)
        deadlineDatePicker.addTarget(self, action: #selector(deadlineDateChanged), for: .valueChanged)
    }
    
    // MARK: - Keyboard Dismissal
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Date Picker Actions
    @objc private func dueDateChanged() {
        selectedDueDate = dueDatePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dueDateTextField?.text = formatter.string(from: dueDatePicker.date)
    }
    
    @objc private func deadlineDateChanged() {
        selectedDeadlineDate = deadlineDatePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        applicationDeadlineTextField?.text = formatter.string(from: deadlineDatePicker.date)
    }
    
    // MARK: - Genre Selection
    @objc private func genreDropdownTapped() {
        let genres = ["Drama", "Comedy", "Action", "Horror", "Sci-Fi", "Romance"]
        
        let alert = UIAlertController(title: "Select Genre", message: nil, preferredStyle: .actionSheet)
        
        for genre in genres {
            alert.addAction(UIAlertAction(title: genre, style: .default, handler: { [weak self] _ in
                self?.selectedGenre = genre
                self?.genreLabel?.text = genre
                self?.genreLabel?.textColor = .label
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - File Upload
    @objc private func uploadFileTapped() {
        let alert = UIAlertController(title: "Upload Reference Material", message: "Choose source", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            self?.presentImagePicker()
        }))
        
        alert.addAction(UIAlertAction(title: "Document", style: .default, handler: { [weak self] _ in
            self?.presentDocumentPicker()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }
    
    private func presentImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images, .videos])
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func presentDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .text, .plainText, .data])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }

    // MARK: - Success Animation Setup
    private func setupSuccessAnimation() {
        view.addSubview(successOverlay)
        view.addSubview(successAnimationView)
        successAnimationView.addSubview(checkmarkView)
        successAnimationView.addSubview(successLabel)
        successAnimationView.addSubview(successSubLabel)
        
        NSLayoutConstraint.activate([
            successOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            successOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            successOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            successOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            successAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            successAnimationView.widthAnchor.constraint(equalToConstant: 240),
            successAnimationView.heightAnchor.constraint(equalToConstant: 260),
            
            checkmarkView.centerXAnchor.constraint(equalTo: successAnimationView.centerXAnchor),
            checkmarkView.topAnchor.constraint(equalTo: successAnimationView.topAnchor, constant: 50),
            checkmarkView.widthAnchor.constraint(equalToConstant: 80),
            checkmarkView.heightAnchor.constraint(equalToConstant: 80),
            
            successLabel.topAnchor.constraint(equalTo: checkmarkView.bottomAnchor, constant: 30),
            successLabel.leadingAnchor.constraint(equalTo: successAnimationView.leadingAnchor, constant: 24),
            successLabel.trailingAnchor.constraint(equalTo: successAnimationView.trailingAnchor, constant: -24),
            
            successSubLabel.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 8),
            successSubLabel.leadingAnchor.constraint(equalTo: successAnimationView.leadingAnchor, constant: 24),
            successSubLabel.trailingAnchor.constraint(equalTo: successAnimationView.trailingAnchor, constant: -24)
        ])
        
        // Add tap gesture to dismiss animation
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSuccessAnimation))
        successOverlay.addGestureRecognizer(tapGesture)
        
        // Add button actions
        assignTaskButton.addTarget(self, action: #selector(assignTaskTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }

    // MARK: - Assign Task Action
    @objc private func assignTaskTapped() {
        // Disable button during animation
        assignTaskButton.isEnabled = false
        cancelButton.isEnabled = false
        
        // Add haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Simulate API call/processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showSuccessAnimation()
        }
    }
    
    // MARK: - Success Animation
    private func showSuccessAnimation() {
        // Show overlay
        UIView.animate(withDuration: 0.3, animations: {
            self.successOverlay.alpha = 1
        })
        
        // Animate card appearance with spring effect
        UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.successAnimationView.alpha = 1
            self.successAnimationView.transform = .identity
        }) { _ in
            // Animate checkmark
            self.checkmarkView.animateCheckmark()
            
            // Add success haptic
            let successGenerator = UINotificationFeedbackGenerator()
            successGenerator.notificationOccurred(.success)
            
            // Animate labels
            UIView.animate(withDuration: 0.4, delay: 0.3, options: .curveEaseIn, animations: {
                self.successLabel.alpha = 1
            })
            
            UIView.animate(withDuration: 0.4, delay: 0.4, options: .curveEaseIn, animations: {
                self.successSubLabel.alpha = 1
            }) { _ in
                // Auto dismiss after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.dismissSuccessAnimation()
                }
            }
        }
    }
    
    @objc private func dismissSuccessAnimation() {
        // Animate card disappearance
        UIView.animate(withDuration: 0.3, animations: {
            self.successAnimationView.alpha = 0
            self.successAnimationView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.successOverlay.alpha = 0
        }) { _ in
            // Reset animation views
            self.successAnimationView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.successLabel.alpha = 0
            self.successSubLabel.alpha = 0
            self.checkmarkView.reset()
            
            // Reset buttons
            self.assignTaskButton.isEnabled = true
            self.cancelButton.isEnabled = true
            
            // Navigate to JobsViewController
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.navigateToJobsViewController()
            }
        }
    }
    
    private func navigateToJobsViewController() {
        // Find JobsViewController in navigation stack
        if let navController = self.navigationController {
            // Look for JobsViewController in the navigation stack
            for viewController in navController.viewControllers {
                if viewController is jobsViewController {
                    navController.popToViewController(viewController, animated: true)
                    return
                }
            }
            // If JobsViewController not found in stack, pop to root
            navController.popToRootViewController(animated: true)
        }
        // If presented modally, dismiss
        else if self.presentingViewController != nil {
            self.dismiss(animated: true) {
                // Post notification or use delegate to navigate to JobsViewController
                NotificationCenter.default.post(name: NSNotification.Name("NavigateToJobsViewController"), object: nil)
            }
        }
    }

    // MARK: - Build Form
    private func buildForm() {
        formStack.addArrangedSubview(createSectionHeader("TASK INFORMATION"))
        formStack.addArrangedSubview(
            createCardContainer {
                $0.addArrangedSubview(createTextField(title: "Task Title", placeholder: "e.g., Dramatic Monologue"))
                $0.addArrangedSubview(createTextView(title: "Description", placeholder: "Describe what the actor needs..."))
                $0.addArrangedSubview(createDateField(title: "Due Date", placeholder: "dd/mm/yyyy", datePicker: dueDatePicker, textField: &dueDateTextField))
            }
        )

        formStack.addArrangedSubview(createSectionHeader("CHARACTER INFORMATION"))
        formStack.addArrangedSubview(
            createCardContainer {
                $0.addArrangedSubview(createTextField(title: "Character Name", placeholder: "e.g., Alex Carter"))
                $0.addArrangedSubview(createTextView(title: "Character Description", placeholder: "Describe the character..."))

                let horizontal = UIStackView()
                horizontal.axis = .horizontal
                horizontal.distribution = .fillEqually
                horizontal.spacing = 12

                horizontal.addArrangedSubview(createTextField(title: "Age", placeholder: "e.g., 28–35"))
                horizontal.addArrangedSubview(createDropdown(title: "Genre", placeholder: "Select", label: &genreLabel))

                $0.addArrangedSubview(horizontal)
                $0.addArrangedSubview(createTextView(title: "Personality Traits", placeholder: "e.g., confident, emotional"))
            }
        )

        formStack.addArrangedSubview(createSectionHeader("SCENE INFORMATION"))
        formStack.addArrangedSubview(
            createCardContainer {
                $0.addArrangedSubview(createTextField(title: "Scene Title", placeholder: "e.g., Opening Sequence"))
                $0.addArrangedSubview(createTextView(title: "Setting Description", placeholder: "Describe the setting"))
                $0.addArrangedSubview(createTextField(title: "Expected Duration", placeholder: "e.g., 3–5 minutes"))
                $0.addArrangedSubview(createUploadField(title: "Upload Reference Material", subtitle: "Video or script", fileNameLabel: &uploadedFileName))
                $0.addArrangedSubview(createDateField(title: "Application Deadline", placeholder: "dd/mm/yyyy", datePicker: deadlineDatePicker, textField: &applicationDeadlineTextField))
                $0.addArrangedSubview(createPaymentField(title: "Payment Amount/Day", placeholder: "5000/day"))
            }
        )
    }

    // MARK: Bottom Buttons
    private func setupBottomButtons() {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemGroupedBackground

        let stack = UIStackView(arrangedSubviews: [cancelButton, assignTaskButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)
        view.addSubview(container)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            container.heightAnchor.constraint(equalToConstant: 85),

            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
        ])
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension PostJobViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.movie") { [weak self] url, error in
            if let url = url {
                DispatchQueue.main.async {
                    self?.uploadedFileURL = url
                    self?.uploadedFileName?.text = url.lastPathComponent
                    self?.uploadedFileName?.textColor = .appPurple
                }
            } else {
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { [weak self] url, error in
                    if let url = url {
                        DispatchQueue.main.async {
                            self?.uploadedFileURL = url
                            self?.uploadedFileName?.text = url.lastPathComponent
                            self?.uploadedFileName?.textColor = .appPurple
                        }
                    }
                }
            }
        }
    }
}

// MARK: - UIDocumentPickerDelegate
extension PostJobViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        uploadedFileURL = url
        uploadedFileName?.text = url.lastPathComponent
        uploadedFileName?.textColor = .appPurple
    }
}

// MARK: - Checkmark View
class CheckmarkView: UIView {
    private let circleLayer = CAShapeLayer()
    private let checkmarkLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayers()
    }
    
    private func setupLayers() {
        circleLayer.removeFromSuperlayer()
        checkmarkLayer.removeFromSuperlayer()
        
        // Circle background
        let circlePath = UIBezierPath(ovalIn: bounds)
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.appPurple.withAlphaComponent(0.1).cgColor
        circleLayer.strokeColor = UIColor.appPurple.cgColor
        circleLayer.lineWidth = 4
        circleLayer.strokeEnd = 0
        
        // Checkmark
        let checkmarkPath = UIBezierPath()
        let size = bounds.size
        checkmarkPath.move(to: CGPoint(x: size.width * 0.25, y: size.height * 0.5))
        checkmarkPath.addLine(to: CGPoint(x: size.width * 0.42, y: size.height * 0.67))
        checkmarkPath.addLine(to: CGPoint(x: size.width * 0.75, y: size.height * 0.33))
        
        checkmarkLayer.path = checkmarkPath.cgPath
        checkmarkLayer.fillColor = UIColor.clear.cgColor
        checkmarkLayer.strokeColor = UIColor.appPurple.cgColor
        checkmarkLayer.lineWidth = 5
        checkmarkLayer.lineCap = .round
        checkmarkLayer.lineJoin = .round
        checkmarkLayer.strokeEnd = 0
        
        layer.addSublayer(circleLayer)
        layer.addSublayer(checkmarkLayer)
    }
    
    func animateCheckmark() {
        // Animate circle drawing
        let circleAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circleAnimation.duration = 0.4
        circleAnimation.fromValue = 0
        circleAnimation.toValue = 1
        circleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        circleLayer.strokeEnd = 1
        circleLayer.add(circleAnimation, forKey: "circleAnimation")
        
        // Animate checkmark after circle
        let checkmarkAnimation = CABasicAnimation(keyPath: "strokeEnd")
        checkmarkAnimation.duration = 0.3
        checkmarkAnimation.fromValue = 0
        checkmarkAnimation.toValue = 1
        checkmarkAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        checkmarkAnimation.beginTime = CACurrentMediaTime() + 0.3
        
        checkmarkLayer.strokeEnd = 1
        checkmarkLayer.add(checkmarkAnimation, forKey: "checkmarkAnimation")
        
        // Add scale animation for extra polish
        UIView.animate(withDuration: 0.15, delay: 0.6, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }) { _ in
            UIView.animate(withDuration: 0.15, animations: {
                self.transform = .identity
            })
        }
    }
    
    func reset() {
        circleLayer.strokeEnd = 0
        checkmarkLayer.strokeEnd = 0
        transform = .identity
    }
}

// MARK: - Helpers
extension PostJobViewController {
    private func createSectionHeader(_ text: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = .systemFont(ofSize: 13, weight: .semibold)
        lbl.textColor = .secondaryLabel
        return lbl
    }

    private func createCardContainer(_ content: (UIStackView) -> Void) -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemGroupedBackground
        card.layer.cornerRadius = 14
        card.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false

        content(stack)

        card.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20)
        ])

        return card
    }

    private func createFieldTitle(_ text: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = .systemFont(ofSize: 15, weight: .regular)
        return lbl
    }

    private func createUnderline() -> UIView {
        let line = UIView()
        line.backgroundColor = UIColor.systemGray4
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return line
    }

    private func createTextField(title: String, placeholder: String) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 6

        let titleLabel = createFieldTitle(title)

        let field = UITextField()
        field.placeholder = placeholder
        field.font = .systemFont(ofSize: 16)

        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(field)
        container.addArrangedSubview(createUnderline())
        return container
    }

    private func createTextView(title: String, placeholder: String) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 6

        let titleLabel = createFieldTitle(title)

        let tv = UITextView()
        tv.text = placeholder
        tv.textColor = .placeholderText
        tv.font = .systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.heightAnchor.constraint(equalToConstant: 40).isActive = true

        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(tv)
        container.addArrangedSubview(createUnderline())
        return container
    }

    private func createDateField(title: String, placeholder: String, datePicker: UIDatePicker, textField: inout UITextField?) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 6

        let titleLabel = createFieldTitle(title)

        let fieldStack = UIStackView()
        fieldStack.axis = .horizontal
        fieldStack.alignment = .center

        let field = UITextField()
        field.placeholder = placeholder
        field.font = .systemFont(ofSize: 16)
        field.inputView = datePicker
        
        // Create toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: false)
        field.inputAccessoryView = toolbar
        
        textField = field

        let icon = UIImageView(image: UIImage(systemName: "calendar"))
        icon.tintColor = .systemGray
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true

        fieldStack.addArrangedSubview(field)
        fieldStack.addArrangedSubview(icon)

        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(fieldStack)
        container.addArrangedSubview(createUnderline())
        return container
    }

    private func createDropdown(title: String, placeholder: String, label: inout UILabel?) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 6

        let titleLabel = createFieldTitle(title)

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center

        let genreLabel = UILabel()
        genreLabel.text = placeholder
        genreLabel.textColor = .placeholderText
        genreLabel.font = .systemFont(ofSize: 16)
        
        label = genreLabel

        let icon = UIImageView(image: UIImage(systemName: "chevron.down"))
        icon.tintColor = .systemGray

        stack.addArrangedSubview(genreLabel)
        stack.addArrangedSubview(icon)
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(genreDropdownTapped))
        stack.addGestureRecognizer(tapGesture)
        stack.isUserInteractionEnabled = true

        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(stack)
        container.addArrangedSubview(createUnderline())
        return container
    }

    private func createUploadField(title: String, subtitle: String, fileNameLabel: inout UILabel?) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 6

        let fieldStack = UIStackView()
        fieldStack.axis = .horizontal
        fieldStack.spacing = 10
        fieldStack.alignment = .center

        let icon = UIImageView(image: UIImage(systemName: "square.and.arrow.up"))
        icon.tintColor = .appPurple
        icon.widthAnchor.constraint(equalToConstant: 24).isActive = true

        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 2

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16)

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .secondaryLabel
        
        fileNameLabel = subtitleLabel

        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .appPurple
        chevron.contentMode = .scaleAspectFit
        chevron.widthAnchor.constraint(equalToConstant: 20).isActive = true
        chevron.heightAnchor.constraint(equalToConstant: 20).isActive = true

        fieldStack.addArrangedSubview(icon)
        fieldStack.addArrangedSubview(textStack)
        fieldStack.addArrangedSubview(chevron)
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadFileTapped))
        fieldStack.addGestureRecognizer(tapGesture)
        fieldStack.isUserInteractionEnabled = true

        container.addArrangedSubview(fieldStack)
        container.addArrangedSubview(createUnderline())
        return container
    }

    private func createPaymentField(title: String, placeholder: String) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 6

        let titleLabel = createFieldTitle(title)

        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4

        let rupee = UILabel()
        rupee.text = "₹"
        rupee.font = .systemFont(ofSize: 16)
        rupee.textColor = .appPurple

        let field = UITextField()
        field.placeholder = placeholder
        field.font = .systemFont(ofSize: 16)
        field.keyboardType = .numberPad
        
        // Create toolbar with Done button for number pad
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: false)
        field.inputAccessoryView = toolbar

        stack.addArrangedSubview(rupee)
        stack.addArrangedSubview(field)

        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(stack)
        container.addArrangedSubview(createUnderline())

        return container
    }
}

// MARK: - Buttons
extension UIButton {
    static func createFilledButton(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.backgroundColor = .appPurple
        btn.tintColor = .white
        btn.layer.cornerRadius = 10
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        return btn
    }

    static func createOutlineButton(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.tintColor = .appPurple
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor.appPurple.cgColor
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        return btn
    }
}
