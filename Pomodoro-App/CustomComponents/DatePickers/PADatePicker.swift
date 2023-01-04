//
//  PADatePicker.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 4.01.2023.
//

import UIKit

class PADatePicker: UIDatePicker {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        datePickerMode = .countDownTimer
    }
    
    
}
