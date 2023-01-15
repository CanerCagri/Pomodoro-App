//
//  PomodoroBottomSheetVc.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 12.01.2023.
//

import UIKit

class PomodoroBottomSheetVc: UIViewController {
    
    // UI Components
    
    private let timePicker = PADatePicker()
    private let saveButton = PAButton(title: "Next", color: .systemPink, systemImageName: SFSymbols.save)
    
    var name: String?
    
    // Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        addConstraints()
    }
    
    // Methods
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.hour, .minute], from: timePicker.date)
        let hour = String(format: "%02d", components.hour!)
        let min = String(format: "%02d", components.minute!)
        let notificationName = name == "pomodoro" ? Notifications.addedPomodoroTime : Notifications.addedBreakTime
        let userInfo = name == "pomodoro" ? ["pomodoroHour": hour, "pomodoroMin": min] : ["breakTimeHour": hour, "breakTimeMin": min]
        NotificationCenter.default.post(Notification(name: Notification.Name(notificationName), userInfo: userInfo))
        dismiss(animated: true)

    }
    
    private func addConstraints() {
        view.addSubviews(saveButton, timePicker)
        
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        timePicker.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20).isActive = true
        timePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
