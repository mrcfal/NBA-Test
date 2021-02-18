//
//  PlayerTableViewCell.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    var playerVM: PlayerViewModel! {
        didSet {
            #if DEBUG
            testHelper?.onSet()
            #endif
            titleLabel.text = playerVM.fullName
            subtitleLabel.text = playerVM.secondaryString
        }
    }
    
    private var vStack: UIStackView!
    private var playerImageView: UIImageView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    
    #if DEBUG
    var testHelper: TestHelper?
    #endif
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        //TODO - handle player image in the futurue
    }
    
    private func configure() {
        
        selectionStyle = .none
        
        vStack = UIStackView(frame: .zero)
        playerImageView = UIImageView(frame: .zero)
        titleLabel = UILabel(frame: .zero)
        subtitleLabel = UILabel(frame: .zero)
        
        playerImageView.contentMode = .scaleAspectFit
        playerImageView.image = UIImage(systemName: "person.circle")
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        titleLabel.numberOfLines = 3
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .left
        
        subtitleLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        subtitleLabel.numberOfLines = 1
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.textColor = UIColor.secondaryLabel
        subtitleLabel.textAlignment = .left
        
        vStack.axis = .vertical
        vStack.spacing = 5
        vStack.distribution = .fillProportionally
        
        addSubview(playerImageView)
        playerImageView.translatesAutoresizingMaskIntoConstraints = false
        playerImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        playerImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playerImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        playerImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(vStack)
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        vStack.leadingAnchor.constraint(equalTo: playerImageView.trailingAnchor, constant: 10).isActive = true
        vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        
        vStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .lightGray
        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        separator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
    }
}
