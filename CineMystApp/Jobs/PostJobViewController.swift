import UIKit

class PostJobViewController: UIViewController {
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Post a job"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Section Titles
    private func sectionTitle(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text.uppercased()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .darkGray
        return label
    }
    
    // MARK: - TextFields
    private func makeTextField(_ placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 15)
        tf.backgroundColor = .white
        return tf
    }
    
    // MARK: - TextView
    private func makeTextView(_ placeholder: String) -> UITextView {
        let tv = UITextView()
        tv.text = placeholder
        tv.textColor = .lightGray
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.layer.cornerRadius = 10
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.isScrollEnabled = false
        return tv
    }
    
    // MARK: - Buttons
    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload Reference Material", for: .normal)
        button.setImage(UIImage(systemName: "arrow.up.doc"), for: .normal)
        button.tintColor = UIColor.systemPurple
        button.backgroundColor = UIColor.systemGray6
        button.layer.cornerRadius = 10
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 8)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.backgroundColor = .white
        return button
    }()
    
    private let assignButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Assign Task", for: .normal)
        button.backgroundColor = UIColor(red: 47/255, green: 9/255, blue: 32/255, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGray6
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // MARK: - Sections
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        // Task Info Section
        stack.addArrangedSubview(sectionTitle("Task Information"))
        stack.addArrangedSubview(makeCardView(fields: [
            makeTextField("Task Title * eg., Dramatic Monologue Scene"),
            makeTextView("Description * Describe what the actor needs to perform..."),
            makeTextField("Due Date * dd/mm/yyyy")
        ]))
        
        // Character Info Section
        stack.addArrangedSubview(sectionTitle("Character Information"))
        stack.addArrangedSubview(makeCardView(fields: [
            makeTextField("Character Name * eg., Dramatic Monologue Scene"),
            makeTextView("Character Description * Describe what the actor needs to perform..."),
            makeTextField("Age eg., 28–35"),
            makeTextField("Genre Select…"),
            makeTextView("Personality Traits Describe the character’s personality...")
        ]))
        
        // Scene Info Section
        stack.addArrangedSubview(sectionTitle("Scene Information"))
        stack.addArrangedSubview(makeCardView(fields: [
            makeTextField("Scene Title * eg., Opening Sequence"),
            makeTextView("Setting Description * Describe the scene setting..."),
            makeTextField("Expected Duration eg., 3–5 minutes"),
            uploadButton,
            makeTextField("Application Deadline dd/mm/yyyy"),
            makeTextField("Payment Amount/Day ₹ 5k/day")
        ]))
        
        // Footer buttons
        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, assignButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        stack.addArrangedSubview(buttonStack)
    }
    
    private func makeCardView(fields: [UIView]) -> UIView {
        let card = UIStackView(arrangedSubviews: fields)
        card.axis = .vertical
        card.spacing = 12
        card.alignment = .fill
        card.layoutMargins = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        card.isLayoutMarginsRelativeArrangement = true
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.05
        container.layer.shadowRadius = 4
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: container.topAnchor),
            card.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            card.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        return container
    }
}

