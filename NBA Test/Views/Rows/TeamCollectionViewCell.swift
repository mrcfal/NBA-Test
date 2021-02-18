//
//  TeamCollectionViewCell.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import UIKit
import Combine

class TeamCollectionViewCell: UICollectionViewCell {
    var teamVM: TeamViewModel! {
        didSet {
            #if DEBUG
            testHelper?.onSet()
            #endif
            
            titleLabel.text = teamVM.titleName
            
            if let url = teamVM.imageUrl {
                imageLoader = ImageLoader(url: url, errorImage: UIImage(systemName: "photo"))
                imageLoader.load()
                imageLoader.$image.assign(to: \.image, on: logoImageView).store(in: &subscriptions)
            }
        }
    }
    
    var imageLoader: ImageLoader!
    
    private var vStack: UIStackView!
    private var shadowView: UIView!
    private var logoImageView: UIImageView!
    private var titleLabel: UILabel!
    
    private var subscriptions: Set<AnyCancellable> = []
    
    #if DEBUG
    var testHelper: TestHelper?
    #endif
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
    }
    
    private func configure() {
        vStack = UIStackView(frame: .zero)
        logoImageView = UIImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        shadowView = UIView(frame: .zero)
        
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "logo")
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        titleLabel.numberOfLines = 3
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.distribution = .fillProportionally
        
        addSubview(shadowView)
        shadowView.backgroundColor = .systemBackground
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        shadowView.layer.cornerRadius = 20
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowRadius = 10
        
        addSubview(vStack)
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        vStack.addArrangedSubview(logoImageView)
        vStack.addArrangedSubview(titleLabel)
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    }
}
