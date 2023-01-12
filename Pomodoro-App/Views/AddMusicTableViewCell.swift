//
//  AddMusicTableViewCell.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 10.01.2023.
//

import UIKit

class AddMusicTableViewCell: UITableViewCell {
    
    static let identifier = "AddMusicTableViewCell"
    
    var nameLabel = PATitleLabel(textAlignment: .left, fontSize: 18, textColor: .label)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        applyConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        contentView.addSubview(nameLabel)
        
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 250),
            nameLabel.heightAnchor.constraint(equalToConstant: 100),
        ]
        
        NSLayoutConstraint.activate(nameLabelConstraints)
    }
}
