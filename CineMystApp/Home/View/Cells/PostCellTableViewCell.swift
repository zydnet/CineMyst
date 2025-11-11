//
//  PostCellTableViewCell.swift
//  CineMystApp
//
//  Created by Devanshi on 11/11/25.
//

import UIKit

final class PostCellTableViewCell: UITableViewCell {
    
    static let reuseId = "PostCellTableViewCell"
    
    // MARK: - UI Components
    private let avatar = UIImageView()
    private let usernameLabel = UILabel()
    private let titleLabel = UILabel()
    private let captionLabel = UILabel()
    private let postImage = UIImageView()
    
    private let likeButton = UIButton(type: .system)
    private let commentButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    
    private let likeCountLabel = UILabel()
    private let commentCountLabel = UILabel()
    private let shareCountLabel = UILabel()
    
    // MARK: - State
    private var isLiked = false
    private var post: Post?
    
    // MARK: - Callbacks
    var commentTapped: (() -> Void)?
    var shareTapped: (() -> Void)?
    var profileTapped: (() -> Void)?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        // Avatar setup
        avatar.layer.cornerRadius = 20
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFill
        avatar.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatar.addGestureRecognizer(tap)
        
        // Labels
        usernameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.textColor = .secondaryLabel
        
        captionLabel.font = .systemFont(ofSize: 14)
        captionLabel.numberOfLines = 0
        
        // Post image
        postImage.layer.cornerRadius = 12
        postImage.contentMode = .scaleAspectFill
        postImage.clipsToBounds = true
        
        // Buttons
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .label
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        
        commentButton.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        commentButton.tintColor = .label
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        
        shareButton.setImage(UIImage(systemName: "arrowshape.turn.up.forward"), for: .normal)
        shareButton.tintColor = .label
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        
        [likeCountLabel, commentCountLabel, shareCountLabel].forEach {
            $0.font = .systemFont(ofSize: 13)
            $0.textColor = .secondaryLabel
        }
    }

    private func layoutUI() {
        let stack = UIStackView(arrangedSubviews: [
            likeButton, likeCountLabel,
            commentButton, commentCountLabel,
            shareButton, shareCountLabel
        ])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        
        [avatar, usernameLabel, titleLabel, captionLabel, postImage, stack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 40),
            avatar.heightAnchor.constraint(equalToConstant: 40),
            
            usernameLabel.topAnchor.constraint(equalTo: avatar.topAnchor, constant: 2),
            usernameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            
            captionLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 12),
            captionLabel.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            captionLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            
            postImage.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 10),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            postImage.heightAnchor.constraint(equalToConstant: 220),
            
            stack.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configure
    func configure(with post: Post) {
        self.post = post
        usernameLabel.text = post.username
        titleLabel.text = post.title
        captionLabel.text = post.caption
        postImage.image = UIImage(named: post.imageName)
        
        if let avatarName = post.userImageName, let img = UIImage(named: avatarName) {
            avatar.image = img
        } else {
            avatar.image = UIImage(systemName: "person.circle.fill")
            avatar.tintColor = .secondaryLabel
        }
        
        likeCountLabel.text = "\(post.likes)"
        commentCountLabel.text = "\(post.comments)"
        shareCountLabel.text = "\(post.shares)"
    }
    
    // MARK: - Button Actions
    @objc private func didTapLike() {
        isLiked.toggle()
        
        let heartImage = UIImage(systemName: isLiked ? "heart.fill" : "heart")
        likeButton.setImage(heartImage, for: .normal)
        likeButton.tintColor = isLiked ? UIColor.systemRed : UIColor.label
        
        if let post = post {
            let currentLikes = Int(likeCountLabel.text ?? "\(post.likes)") ?? post.likes
            let updatedLikes = isLiked ? currentLikes + 1 : currentLikes - 1
            likeCountLabel.text = "\(updatedLikes)"
        }
        
        // Add a pop animation
        UIView.animate(withDuration: 0.1,
                       animations: {
                           self.likeButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                       }, completion: { _ in
                           UIView.animate(withDuration: 0.1) {
                               self.likeButton.transform = .identity
                           }
                       })
    }
    
    @objc private func didTapComment() {
        commentTapped?()
    }

    @objc private func didTapShare() {
        shareTapped?()
    }
    
    @objc private func didTapAvatar() {
        profileTapped?()
    }
}
