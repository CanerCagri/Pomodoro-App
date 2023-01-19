//
//  PATextField.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 4.01.2023.
//

import UIKit

class PATextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeholder: String) {
        super.init(frame: .zero)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font :UIFont(name: Constants.timesNewRoman, size: 10)!])
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.cornerRadius = 10
        textColor = .label
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title3)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        returnKeyType = .go
        clearButtonMode = .whileEditing
    }
}
