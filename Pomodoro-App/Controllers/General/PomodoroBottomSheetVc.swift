//
//  PomodoroBottomSheetVc.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 12.01.2023.
//

import UIKit

class PomodoroBottomSheetVc: UIViewController {
    
    var name: String?
    
    private let timePicker = PADatePicker()
    private let saveButton = PAButton(title: "Next", color: .systemPink, systemImageName: "checkmark.circle")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        addConstraints()
    }
    
    @objc func saveButtonTapped() {
        
        let calendar = Calendar.current
        
        if name == "pomodoro" {
            let pomodoroComponents = calendar.dateComponents([.hour, .minute], from: timePicker.date)
            let pomoHour = pomodoroComponents.hour
            let pomoMin = pomodoroComponents.minute
            print("test")
            if pomoMin != 0 {
                let pomodoroHour = String(format: "%02d", pomoHour!)
                let pomodoroMin = String(format: "%02d", pomoMin!)
                let calculatedTime = "\(pomodoroHour):\(pomodoroMin)"
                
                NotificationCenter.default.post(Notification(name: Notification.Name("addedPomodoroTime"), userInfo: ["pomodoroHour": pomodoroHour, "pomodoroMin": pomodoroMin]))
                dismiss(animated: true)
            }
                
        } else if name == "break" {
            let breakTimeComponents = calendar.dateComponents([.hour, .minute], from: timePicker.date)
            let breakHour = breakTimeComponents.hour
            let breakMin = breakTimeComponents.minute
            
            if breakMin != 0 {
                let breakTimeHour = String(format: "%02d", breakHour!)
                let breakTimeMin = String(format: "%02d", breakMin!)
                let calculatedTime = "\(breakTimeHour):\(breakTimeMin)"
                
                NotificationCenter.default.post(Notification(name: Notification.Name("addedBreakTime"), userInfo: ["breakTimeHour": breakTimeHour, "breakTimeMin": breakTimeMin]))
                dismiss(animated: true)
            }
        }
        
    }
    
    private func addConstraints() {
        view.addSubviews(saveButton, timePicker)
        
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        timePicker.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20).isActive = true
        timePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    

    

}
