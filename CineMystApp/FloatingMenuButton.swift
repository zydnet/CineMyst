//
//  FloatingMenuButton.swift
//  CineMystApp
//
//  Created by user@50 on 18/11/25.
//


//
//  FloatingMenuButton.swift
//  CineMystApp
//
//  Created by user@50 on 18/11/25.
//

import SwiftUI

struct FloatingMenuButton: View {
    
    // MARK: - Public Action Closures
    var didTapStory: (() -> Void)?
    var didTapPost: (() -> Void)?
    var didTapGallery: (() -> Void)?
    
    @State private var isExpanded = false
    
    var body: some View {
        ZStack {
            // Story/Camera Button (Top-Right, 45°)
            MenuActionButton(
                icon: "camera.fill",
                isVisible: isExpanded,
                offset: calculateOffset(angle: 0, radius: 110)
            ) {
                collapseAndExecute(didTapStory)
            }
            
            // GIF/Gallery Button (Top-Center, 75°)
            MenuActionButton(
                icon: "photo.on.rectangle",
                isVisible: isExpanded,
                offset: calculateOffset(angle: 45, radius: 120)
            ) {
                collapseAndExecute(didTapGallery)
            }
            
            // Post Button (Left, 135°)
            MenuActionButton(
                icon: "square.and.pencil",
                isVisible: isExpanded,
                offset: calculateOffset(angle: 90, radius: 110)
            ) {
                collapseAndExecute(didTapPost)
            }
            
            // Main Plus/X Button
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: isExpanded ? "xmark" : "plus")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(isExpanded ? .accentColor : .white)

                    .frame(width: 60, height: 60)
                    .background(
                        LinearGradient(
                            colors: isExpanded
                            ? [Color(.systemGray5)]  // Red circle for X
                                : [Color.accentColor],  // Purple circle for plus
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    
                    )
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .frame(width: 60, height: 60)
    }
    
    // MARK: - Helper Methods
    private func calculateOffset(angle: Double, radius: Double) -> CGSize {
        let radians = angle * .pi / 180
        return CGSize(
            width: -cos(radians) * radius,
            height: -sin(radians) * radius
        )
    }
    
    private func collapseAndExecute(_ action: (() -> Void)?) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            isExpanded = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            action?()
        }
    }
}

// MARK: - Menu Action Button
struct MenuActionButton: View {
    let icon: String
    let isVisible: Bool
    let offset: CGSize
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    LinearGradient(
                        colors: [Color.accentColor.opacity(0.8), Color.accentColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .offset(isVisible ? offset : .zero)
        .opacity(isVisible ? 1 : 0)
        .scaleEffect(isVisible ? 1 : 0.1)
        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isVisible)
    }
}

// MARK: - UIKit Wrapper
import UIKit

final class FloatingMenuHostingController: UIViewController {
    
    var didTapStory: (() -> Void)?
    var didTapPost: (() -> Void)?
    var didTapGallery: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swiftUIView = FloatingMenuButton(
            didTapStory: { [weak self] in
                self?.didTapStory?()
            },
            didTapPost: { [weak self] in
                self?.didTapPost?()
            },
            didTapGallery: { [weak self] in
                self?.didTapGallery?()
            }
        )
        
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.backgroundColor = .clear
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.widthAnchor.constraint(equalToConstant: 60),
            hostingController.view.heightAnchor.constraint(equalToConstant: 250),
            hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}
