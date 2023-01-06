//
//  Popup.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 27.12.2022.
//

import UIKit

class PomodoroPopup: UIView {
    
    private let containerView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.label.withAlphaComponent(0.7)
        view.layer.cornerRadius = 24
        return view
    }()
    
    private let addPomodoroLabel = PALabel(textAlignment: .center, fontSize: 20, textColor: .tertiarySystemBackground)
    private let pomodoroNameTextField = PATextField(placeholder: "Enter a pomodoro name")
    private let pomodoroTimeLabel = PALabel(textAlignment: .center, fontSize: 20)
    private let pomodoroPicker = PADatePicker()
    private let breakTimeLabel = PALabel(textAlignment: .center, fontSize: 17, textColor: .tertiarySystemBackground)
    private let breakTimePicker = PADatePicker()
    
    private let saveButton = PAButton(title: "SAVE", color: .systemPink, systemImageName: "checkmark.circle")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        self.frame = UIScreen.main.bounds
        containerView.largeContentTitle = "Add Pomodoro"
        breakTimeLabel.text = "Choose Break Time"
        addPomodoroLabel.text = "Add Pomodoro"
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        applyConstraints()
        animateIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func animateOut() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        } completion: { complete in
            if complete {
                self.removeFromSuperview()
            }
        }
        NotificationCenter.default.post(Notification(name: Notification.Name("animateOut")))
    }
    
    @objc func animateIn() {
        self.containerView.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.containerView.transform = .identity
            self.alpha = 1
        }
    
    }
    
    @objc func saveButtonTapped() {
        guard let name = pomodoroNameTextField.text, !name.isEmpty else { return }
        
        let calendar = Calendar.current
        let pomodoroComponents = calendar.dateComponents([.hour, .minute], from: pomodoroPicker.date)
        let pomoHour = pomodoroComponents.hour
        let pomoMin = pomodoroComponents.minute
        
        let breakTimeComponents = calendar.dateComponents([.hour, .minute], from: breakTimePicker.date)
        let breakHour = breakTimeComponents.hour
        let breakMin = breakTimeComponents.minute

        if pomoMin != 0 && breakMin != 0 {
            
            let pomodoroHour = String(format: "%02d", pomoHour!)
            let pomodoroMin = String(format: "%02d", pomoMin!)
            
            let breakTimeHour = String(format: "%02d", breakHour!)
            let breakTimeMin = String(format: "%02d", breakMin!)
            
            let viewModel = PomodoroViewModel(name: name, workTimeHour: pomodoroHour, workTimeMin: pomodoroMin, breakTimeHour: breakTimeHour, breakTimeMin: breakTimeMin)
            
            PersistenceManager.shared.downloadWithModel(model: viewModel) { result in
                switch result {
                case .success():
                    NotificationCenter.default.post(Notification(name: Notification.Name("added")))
                    self.animateOut()
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        } else {
            return // TODO
        }
    }
    
    private func applyConstraints() {
        self.addSubview(containerView)
        
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.82).isActive = true
        containerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.62).isActive = true
    
        containerView.addSubviews(pomodoroNameTextField, addPomodoroLabel, pomodoroPicker, breakTimeLabel, breakTimePicker, saveButton)
        
        addPomodoroLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        addPomodoroLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        addPomodoroLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        addPomodoroLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        pomodoroNameTextField.topAnchor.constraint(equalTo: addPomodoroLabel.bottomAnchor, constant: 5).isActive = true
        pomodoroNameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        pomodoroNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        pomodoroNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        pomodoroPicker.topAnchor.constraint(equalTo: pomodoroNameTextField.bottomAnchor, constant: 5).isActive = true
        pomodoroPicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        pomodoroPicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        pomodoroPicker.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        breakTimeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        breakTimeLabel.topAnchor.constraint(equalTo: pomodoroPicker.bottomAnchor, constant: 10).isActive = true
        breakTimeLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        breakTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        breakTimePicker.topAnchor.constraint(equalTo: breakTimeLabel.bottomAnchor, constant: 5).isActive = true
        breakTimePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        breakTimePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        breakTimePicker.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        saveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
}
