//
//  DetailPlayerViewController.swift
//  NBA Test
//
//  Created by Marco Falanga on 18/02/21.
//

import UIKit

/// Presented when you tap on a player cell in DetailTeamViewController. It shows a specific player information. It is presented as a popup using a custom transition (see CardAnimator)
///
/// Its subviews are:
/// - stackView: vertical, containing a label for each info to display
/// - closeButton: to dismiss the popup
///
/// If you tap on the background view, the view controller is dismissed.
class DetailPlayerViewController: UIViewController {
    var playerInfoVM: PlayerInfoViewModel!
    
    private var contentView: UIView!
    private var vStack: UIStackView!
    private var bgView: UIView!
    private var titleLabel: UILabel!
    private var dismissButton: UIButton!
    
    #if DEBUG
    var setSubviewsCalled = false
    #endif
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubviews()
    }
    
    private func setSubviews() {
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(blurViewTapped(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        contentView = UIView()
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        bgView = UIView()
        bgView.backgroundColor = .myBlue
        contentView.addSubview(bgView)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        bgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        bgView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        bgView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        bgView.layer.cornerRadius = 20
        
        vStack = UIStackView(frame: .zero)
        vStack.axis = .vertical
        vStack.spacing = 10
        bgView.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.widthAnchor.constraint(equalTo: bgView.widthAnchor, constant: -20).isActive = true
        vStack.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        bgView.topAnchor.constraint(equalTo: vStack.topAnchor, constant: 10).isActive = true
        bgView.bottomAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 10).isActive = true
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        playerInfoVM.playerInfo.forEach { item in
            let attributedString = NSMutableAttributedString()
            attributedString.append(NSAttributedString(string: item.boldKey.uppercased() + " ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)]))
            attributedString.append(NSAttributedString(string: item.value, attributes: [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)]))
            let label = UILabel(frame: .zero)
            label.attributedText = attributedString
            label.textColor = .white
            vStack.addArrangedSubview(label)
        }
                
        titleLabel = UILabel(frame: .zero)
        titleLabel.text = playerInfoVM.title
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        vStack.insertArrangedSubview(titleLabel, at: 0)
        
        dismissButton = UIButton(frame: .zero, primaryAction: UIAction(handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.layer.cornerRadius = 15
        dismissButton.backgroundColor = .systemBackground
        dismissButton.tintColor = .label
        contentView.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.centerXAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        dismissButton.centerYAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.heightAnchor.constraint(equalTo: dismissButton.widthAnchor).isActive = true
        
        #if DEBUG
        setSubviewsCalled = true
        #endif
    }
    
    @objc private func blurViewTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

// avoid dismiss when tapping contentView
extension DetailPlayerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: contentView) == true {
            return false
        }
        
        return true
    }
}
