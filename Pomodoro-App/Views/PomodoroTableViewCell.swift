//
//  PomodoroTableViewCell.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 27.12.2022.
//

import UIKit

class PomodoroTableViewCell: UITableViewCell {
    
    static let identifier = "PomodoroTableViewCell"

    var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TEST"
        return label
    }()
    
    var workTimeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Work Time: 00:55"
        return label
    }()
    
    var breakTimeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Break Time: 00:10"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(workTimeLabel)
        contentView.addSubview(breakTimeLabel)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 150),
            nameLabel.heightAnchor.constraint(equalToConstant: 100),
        ]
        
        let workTimeLabelConstraints = [
            workTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            workTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            workTimeLabel.widthAnchor.constraint(equalToConstant: 150),
            workTimeLabel.heightAnchor.constraint(equalToConstant: 30),
        ]
        
        let breakTimeLabel = [
            breakTimeLabel.topAnchor.constraint(equalTo: workTimeLabel.bottomAnchor, constant: 5),
            breakTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            breakTimeLabel.heightAnchor.constraint(equalToConstant: 30),
            breakTimeLabel.widthAnchor.constraint(equalToConstant: 150),
        ]
        
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(workTimeLabelConstraints)
        NSLayoutConstraint.activate(breakTimeLabel)
    }
}
