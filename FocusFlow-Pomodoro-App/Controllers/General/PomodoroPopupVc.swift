//
//  PomodoroPopupVc.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 12.01.2023.
//

import UIKit


class PomodoroPopupVc: UIViewController {
    
    //Variables
    
    let moodSelectionVc = PomodoroBottomSheetVc()
    var viewModel: PomodoroViewModel?
    var pomodoroHour: String!
    var pomodoroMin: String!
    var breakHour: String!
    var breakMin: String!
    var saveButtonBottomAnchorConstraint: NSLayoutConstraint!
    var breakLabelBottomAnchorConstraint: NSLayoutConstraint!
    var isBottomSheetOpen = false
    
    // UI Components
    
    private let containerView = PAContainerView()
    private let addPomodoroLabel = PALabel(textAlignment: .center, fontSize: 20)
    private let pomodoroNameTextField = PATextField(placeholder: "Enter a Pomodoro name")
    private let pomodoroTimeLabel = PALabel(textAlignment: .left, fontSize: 17)
    private let pomodoroTextField = PATextField(placeholder: "00:00")
    private let pomodoroPicker = PADatePicker()
    private let breakTimeLabel = PALabel(textAlignment: .left, fontSize: 17)
    private let breakTimeTextField = PATextField(placeholder: "00:00")
    private let breakTimePicker = PADatePicker()
    private let saveButton = PAButton(title: "SAVE", color: .systemPink, systemImageName: SFSymbols.save)
    
    private var closeButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.imageView?.widthAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()
    
    // Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        applyConstraints()
        addGestureRecognizers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Methods
    
    private func configureViewController() {
        view.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        view.frame = UIScreen.main.bounds
        containerView.largeContentTitle = "Add Pomodoro"
        pomodoroTimeLabel.text = "Enter Focus Time:"
        breakTimeLabel.text = "Enter Break Time:"
        addPomodoroLabel.text = "Add Pomodoro"
        pomodoroTextField.delegate = self
        breakTimeTextField.delegate = self
        pomodoroNameTextField.delegate = self
        
        closeButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(
           self,
           selector: #selector(keyboardWillShow),
           name: UIResponder.keyboardWillShowNotification,
           object: nil
        )
        
        NotificationCenter.default.addObserver(
           self,
           selector: #selector(keyboardWillHide),
           name: UIResponder.keyboardWillHideNotification,
           object: nil
        )
    }
    
    private func addGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateOut))
        view.addGestureRecognizer(tapGesture)
        
        let dontTapGesture = UITapGestureRecognizer(target: self, action: #selector(dontAnimateOut))
        containerView.addGestureRecognizer(dontTapGesture)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        pomodoroTextField.addTarget(self, action: #selector(pomodoroTextFieldTapped), for: .touchDown)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(Notifications.addedPomodoroTime), object: nil, queue: nil) { [weak self] (notification) in
            self?.isBottomSheetOpen = false
            self?.pomodoroHour = notification.userInfo?["pomodoroHour"] as? String
            self?.pomodoroMin = notification.userInfo?["pomodoroMin"] as? String
            let calculatedTime = "\(self?.pomodoroHour! ?? "00"):\(self?.pomodoroMin! ?? "00")"
            self?.pomodoroTextField.text = calculatedTime
        }
        
        breakTimeTextField.addTarget(self, action: #selector(breakTextFieldTapped), for: .touchDown)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(Notifications.addedBreakTime), object: nil, queue: nil) { [weak self] (notification) in
            self?.isBottomSheetOpen = false
            self?.breakHour = notification.userInfo?["breakTimeHour"] as? String
            self?.breakMin = notification.userInfo?["breakTimeMin"] as? String
            let calculatedTime = "\(self?.breakHour! ?? "00"):\(self?.breakMin! ?? "00")"
            self?.breakTimeTextField.text = calculatedTime
        }
        
        animateIn()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let saveButtonBottomSpace: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8PlusZoomed || DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone8Zoomed || DeviceTypes.isiPhone8PlusStandard ? 210 : 255
        let saveButtonBottomAnchor = self.saveButton.frame.height - saveButtonBottomSpace
        
        let breakLabelBottomSpace: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8PlusZoomed || DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone8Zoomed || DeviceTypes.isiPhone8PlusStandard ? 30 : 50
        let breakLabelBottomAnchor = self.breakTimeLabel.frame.height - breakLabelBottomSpace
        
     
        UIView.animate(withDuration: 0.3) {
            self.saveButtonBottomAnchorConstraint.constant = saveButtonBottomAnchor
            self.breakLabelBottomAnchorConstraint.constant = breakLabelBottomAnchor
            self.containerView.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        let breakButtonBottomSpace: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8PlusZoomed || DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone8Zoomed || DeviceTypes.isiPhone8PlusStandard ? -130 : -250
        
        UIView.animate(withDuration: 0.3) {
            self.saveButtonBottomAnchorConstraint.constant = -10
            self.breakLabelBottomAnchorConstraint.constant = breakButtonBottomSpace
            self.containerView.layoutIfNeeded()
        }
    }
    
    private func dismissBottomSheet() {
        isBottomSheetOpen = false
        if pomodoroNameTextField.isFirstResponder {
               pomodoroNameTextField.resignFirstResponder()
           }
           moodSelectionVc.dismiss(animated: true)
    }
    
    @objc func closePopup() {
        animateOut()
    }
    
    @objc func pomodoroTextFieldTapped() {
        if !isBottomSheetOpen {
            isBottomSheetOpen = true
            view.endEditing(true)
            openBottomSheet(with: "pomodoro")
        }
        
    }
    
    @objc func breakTextFieldTapped() {
        if !isBottomSheetOpen {
            isBottomSheetOpen = true
            view.endEditing(true)
            openBottomSheet(with: "break")
        }
    }
    
    @objc func dontAnimateOut(){
   
    }
    
    @objc func openBottomSheet(with name: String) {
        moodSelectionVc.name = name
        if let sheet = moodSelectionVc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.preferredCornerRadius = 24
        }
        
        present(moodSelectionVc, animated: true)
    }
    
    @objc func animateOut() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) { [weak self] in
            self?.containerView.transform = CGAffineTransform(translationX: 0, y: -(self?.view.frame.height)!)
            self?.view.alpha = 0
        } completion: { complete in
            if complete {
                self.view.removeFromSuperview()
            }
        }
        NotificationCenter.default.post(Notification(name: Notification.Name(Notifications.animateOut)))
    }
    
    @objc func animateIn() {
        self.containerView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
        self.view.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.containerView.transform = .identity
            self.view.alpha = 1
        }
        
    }
    
    @objc func saveButtonTapped() {
        guard let name = pomodoroNameTextField.text, !name.isEmpty else {
            presentAlert(title: "Warning", message: "Please enter a Pomodoro name", buttonTitle: "Ok")
            return
            
        }
        guard let focusTime = pomodoroTextField.text, !focusTime.isEmpty else {
            presentAlert(title: "Warning", message: "Please enter a Focus time", buttonTitle: "Ok")
            return
            
        }
        guard let breakTime = breakTimeTextField.text, !breakTime.isEmpty else {
            presentAlert(title: "Warning", message: "Please enter a Break time", buttonTitle: "Ok")
            return
            
        }
        
        if pomodoroTextField.text != "00:00" && breakTimeTextField.text != "00:00" {
            let viewModel = PomodoroViewModel(name: name, workTimeHour: pomodoroHour, workTimeMin: pomodoroMin, breakTimeHour: breakHour, breakTimeMin: breakMin, repeatTime: "0")
            
            PersistenceManager.shared.downloadWithModel(model: viewModel) { result in
                switch result {
                case .success():
                    NotificationCenter.default.post(Notification(name: Notification.Name(Notifications.added)))
                    self.animateOut()
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        } else {
            presentAlert(title: "Error", message: "Focus time or Break time cannot be equal to 0", buttonTitle: "Ok")
            return
        }
    }
    
    private func applyConstraints() {
        view.addSubview(containerView)
        
        let containerViewWidthMultiplier: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8PlusZoomed || DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone8Zoomed || DeviceTypes.isiPhone8PlusStandard ? 0.72 : 0.82
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: containerViewWidthMultiplier).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.62).isActive = true
        
        containerView.addSubviews(closeButton, addPomodoroLabel, pomodoroNameTextField, pomodoroTimeLabel, pomodoroTextField, breakTimeLabel, breakTimeTextField, saveButton)
        
        let breakButtonBottomSpace: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8PlusZoomed || DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone8Zoomed || DeviceTypes.isiPhone8PlusStandard ? -130 : -250
        
        closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 2).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        addPomodoroLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        addPomodoroLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        addPomodoroLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        addPomodoroLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        addPomodoroLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        pomodoroNameTextField.topAnchor.constraint(equalTo: addPomodoroLabel.bottomAnchor, constant: 20).isActive = true
        pomodoroNameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        pomodoroNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        pomodoroNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        pomodoroTimeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        pomodoroTimeLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        pomodoroTimeLabel.bottomAnchor.constraint(equalTo: breakTimeLabel.topAnchor, constant: -40).isActive = true
        
        pomodoroTextField.leadingAnchor.constraint(equalTo: pomodoroTimeLabel.trailingAnchor, constant: 10).isActive = true
        pomodoroTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        pomodoroTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pomodoroTextField.bottomAnchor.constraint(equalTo: pomodoroTimeLabel.bottomAnchor, constant: 5).isActive = true
        
        breakTimeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        breakTimeLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        breakLabelBottomAnchorConstraint =  breakTimeLabel.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: breakButtonBottomSpace)
        breakLabelBottomAnchorConstraint.isActive = true
        
        breakTimeTextField.leadingAnchor.constraint(equalTo: breakTimeLabel.trailingAnchor, constant: 10).isActive = true
        breakTimeTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        breakTimeTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        breakTimeTextField.bottomAnchor.constraint(equalTo: breakTimeLabel.bottomAnchor, constant: 5).isActive = true
        
        saveButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        saveButtonBottomAnchorConstraint = saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        saveButtonBottomAnchorConstraint.isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
}

extension PomodoroPopupVc: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == pomodoroNameTextField {
            dismissBottomSheet()
            return true
            
        }
        return false
    }
}
