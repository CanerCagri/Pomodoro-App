//
//  PALabel.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 3.01.2023.
//

import UIKit

class PATitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont(name: "GillSans-SemiBold", size: fontSize)
        self.textColor = .label
        configure()
    }
    
    init(textAlignment: NSTextAlignment, fontSize: CGFloat, textColor: UIColor) {
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont(name: "GillSans-SemiBold", size: fontSize)
        self.textColor = textColor
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        text = "Time To FOCUS! 💪"
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
    }
}
