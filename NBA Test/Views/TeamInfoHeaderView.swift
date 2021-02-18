//
//  TeamInfoHeaderView.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import UIKit
import Combine

class TeamInfoHeaderView: UITableViewHeaderFooterView {
    
    var teamInfoVM: TeamInfoViewModel! {
        didSet {
            
            #if DEBUG
            testHelper?.onSet()
            #endif
            
            if let url = teamInfoVM.imageUrl {
                imageLoader = ImageLoader(url: url, errorImage: UIImage(systemName: "photo"))
                imageLoader.load()
                imageLoader.$image.assign(to: \.image, on: teamImageView).store(in: &subscriptions)
            }

            setVStack()
        }
    }
    
    private var imageLoader: ImageLoader!
    private var teamImageView: UIImageView!
    private var vStack: UIStackView!
    private var roundedView: UIView!
    private var subscriptions: Set<AnyCancellable> = []
    
    #if DEBUG
    var testHelper: TestHelper?
    #endif
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        teamImageView = UIImageView(frame: .zero)
        teamImageView.image = UIImage(named: "logo")
        teamImageView.contentMode = .scaleAspectFit
        
        addSubview(teamImageView)
        teamImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                teamImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                teamImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
                teamImageView.widthAnchor.constraint(equalTo: teamImageView.heightAnchor),
                teamImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            ]
        )
        
        vStack = UIStackView(frame: .zero)
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                vStack.centerYAnchor.constraint(equalTo: centerYAnchor),
                vStack.leadingAnchor.constraint(equalTo: teamImageView.trailingAnchor, constant: 10),
                vStack.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 1, constant: -10),
                vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            ]
        )
        
        roundedView = UIView()
        roundedView.backgroundColor = UIColor.myBlue
        roundedView.layer.cornerRadius = 20
        insertSubview(roundedView, belowSubview: vStack)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundedView.frame = vStack.frame
        roundedView.center = vStack.center
    }
    
    private func setVStack() {
        vStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = teamInfoVM.title
        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title2)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        vStack.addArrangedSubview(titleLabel)
        
        teamInfoVM.teamInfo.forEach { item in
            let attributedString = NSMutableAttributedString()
            attributedString.append(NSAttributedString(string: item.boldKey.uppercased() + " ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)]))
            attributedString.append(NSAttributedString(string: item.value, attributes: [NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)]))
            let label = UILabel(frame: .zero)
            label.attributedText = attributedString
            label.adjustsFontSizeToFitWidth = true
            label.textColor = .white
            vStack.addArrangedSubview(label)
        }
        
        #if DEBUG
        testHelper?.onCalled(function: #function, file: #fileID)
        #endif
    }
}
