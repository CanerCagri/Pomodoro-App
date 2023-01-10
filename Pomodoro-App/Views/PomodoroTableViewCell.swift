//
//  PomodoroTableViewCell.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 27.12.2022.
//

import UIKit

class PomodoroTableViewCell: UITableViewCell {
    
    static let identifier = "PomodoroTableViewCell"

    var nameLabel = PATitleLabel(textAlignment: .left, fontSize: 18)
    var workTimeLabel = PALabel(textAlignment: .center, fontSize: 13)
    var breakTimeLabel = PALabel(textAlignment: .center, fontSize: 13)
    var repeatedTimeLabel = PALabel(textAlignment: .center, fontSize: 13)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.numberOfLines = 0
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        contentView.addSubviews(nameLabel, workTimeLabel, breakTimeLabel, repeatedTimeLabel)
        accessoryType = .disclosureIndicator
        
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 150),
            nameLabel.heightAnchor.constraint(equalToConstant: 100),
        ]
        
        let workTimeLabelConstraints = [
            workTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            workTimeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 70),
        ]
        
        let breakTimeLabelConstarints = [
            breakTimeLabel.topAnchor.constraint(equalTo: workTimeLabel.bottomAnchor, constant: 7),
            breakTimeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 70),
        ]
        
        let repeatedTimeLabelConstraints = [
            repeatedTimeLabel.topAnchor.constraint(equalTo: breakTimeLabel.bottomAnchor, constant: 7),
            repeatedTimeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 70),

        ]
        
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(workTimeLabelConstraints)
        NSLayoutConstraint.activate(breakTimeLabelConstarints)
        NSLayoutConstraint.activate(repeatedTimeLabelConstraints)
    }
}
