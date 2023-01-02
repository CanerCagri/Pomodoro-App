//
//  Popup.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 27.12.2022.
//

import UIKit

class PomodoroPopup: UIView {
    
    private let containerView: UIView = {
        var v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        return v
    }()
    
    private let addPomodoroLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.text = "Add Pomodoro"
        return label
    }()
    
    private let pomodoroNameTextField: UITextField = {
        var text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.leftViewMode = .always
        text.textAlignment = .center
        text.layer.borderWidth = 2
        text.layer.borderColor = UIColor.systemGray4.cgColor
        text.layer.cornerRadius = 10
        text.textColor = .label
        text.tintColor = .label
        text.font = UIFont.preferredFont(forTextStyle: .title2)
        text.adjustsFontSizeToFitWidth = true
        text.minimumFontSize = 12
        text.backgroundColor = .tertiarySystemBackground
        text.autocorrectionType = .no
        text.returnKeyType = .go
        text.clearButtonMode = .whileEditing
        text.attributedPlaceholder = NSAttributedString(string:"Enter a name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font :UIFont(name: "Times New Roman", size: 20)!])
        return text
    }()
    
    private let pomodoroPicker: UIDatePicker = {
        var picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let breakTimeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.text = "Choose Break Time"
        return label
    }()
    
    private let breakTimePicker: UIDatePicker = {
        var picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let saveButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.configuration?.cornerStyle = .medium
        button.configuration?.baseBackgroundColor = .blue
        button.configuration?.baseForegroundColor = .white
        button.configuration?.title = "SAVE"
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        self.frame = UIScreen.main.bounds
        containerView.largeContentTitle = "Add Pomodoro"
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
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
        
        if pomoMin != 0 || breakMin != 0 {
            
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
            return
        }
    }
    
    private func applyConstraints() {
        self.addSubview(containerView)
        
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.82).isActive = true
        containerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.62).isActive = true
        
        containerView.addSubview(pomodoroNameTextField)
        containerView.addSubview(addPomodoroLabel)
        containerView.addSubview(pomodoroPicker)
        containerView.addSubview(breakTimeLabel)
        containerView.addSubview(breakTimePicker)
        containerView.addSubview(saveButton)
        
        addPomodoroLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        addPomodoroLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        addPomodoroLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        addPomodoroLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        pomodoroNameTextField.topAnchor.constraint(equalTo: addPomodoroLabel.bottomAnchor, constant: 5).isActive = true
        pomodoroNameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        pomodoroNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        pomodoroNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        pomodoroPicker.topAnchor.constraint(equalTo: pomodoroNameTextField.bottomAnchor, constant: 5).isActive = true
        pomodoroPicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        pomodoroPicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        pomodoroPicker.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        breakTimeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        breakTimeLabel.topAnchor.constraint(equalTo: pomodoroPicker.bottomAnchor, constant: 10).isActive = true
        breakTimeLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        breakTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        breakTimePicker.topAnchor.constraint(equalTo: breakTimeLabel.bottomAnchor, constant: 5).isActive = true
        breakTimePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        breakTimePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        breakTimePicker.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        saveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
}
