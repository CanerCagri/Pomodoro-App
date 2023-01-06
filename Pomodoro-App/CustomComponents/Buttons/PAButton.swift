//
//  PAButton.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 3.01.2023.
//

import UIKit

class PAButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, color: UIColor, systemImageName: String) {
        super.init(frame: .zero)
        configure()
        set(color: color, title: title, systemImageName: systemImageName)
    }
    
    private func configure() {
        configuration = .filled()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(color: UIColor, title: String, systemImageName: String) {
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = .white
        
        var container = AttributeContainer()
        container.font = UIFont(name: "GillSans-SemiBold", size: 22)
        configuration?.attributedTitle = AttributedString(title, attributes: container)
        
        configuration?.image = UIImage(systemName: systemImageName)
        configuration?.imagePadding = 5
        configuration?.imagePlacement = .leading
    }
}
