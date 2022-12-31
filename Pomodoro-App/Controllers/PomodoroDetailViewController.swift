//
//  PomodoroDetailViewController.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 29.12.2022.
//

import UIKit

class PomodoroDetailViewController: UIViewController {
    
    var timer: Timer?
    var remainingTime = 0

    var startTapped = false
    
    var selectedPomodoro: PomodoroItem? {
        didSet {
            title = selectedPomodoro?.name
            pomodoroLabel.text = "\(selectedPomodoro?.work_time_hour ?? ""):\(selectedPomodoro?.work_time_min ?? "")"
            convertTextToMin(pomodoroTime: pomodoroLabel.text!)
        }
    }
    
    private let pomodoroLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .green
        label.textColor = .label
        label.text = "TESTTT"
        return label
    }()
    
    private let startButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.configuration?.cornerStyle = .medium
        button.configuration?.baseBackgroundColor = .systemBlue
        button.configuration?.baseForegroundColor = .white
        button.configuration?.title = "Start"
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let stopButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.configuration?.cornerStyle = .medium
        button.configuration?.baseBackgroundColor = .systemBlue
        button.configuration?.baseForegroundColor = .white
        button.configuration?.title = "Pause"
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let resetButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.configuration?.cornerStyle = .medium
        button.configuration?.baseBackgroundColor = .systemBlue
        button.configuration?.baseForegroundColor = .white
        button.configuration?.title = "Reset"
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
       
        addConstraints()
    }
    
    private func convertTextToMin(pomodoroTime: String) {
        let scanner = Scanner(string: pomodoroTime)

        var hours: Int = 0
        var minutes: Int = 0

        scanner.scanInt(&hours)
        scanner.scanCharacters(from: CharacterSet(charactersIn: ":"))
        scanner.scanInt(&minutes)

        let totalMinutes = hours * 60 + minutes
        remainingTime = totalMinutes * 60
    }
    
    private func updateLabel() {
        let hours = remainingTime / 3600
        let minutes = (remainingTime % 3600) / 60
        let seconds = remainingTime % 60
        pomodoroLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        remainingTime -= 1
    }

    private func addConstraints() {
        view.addSubview(pomodoroLabel)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(resetButton)
        
        let pomodoroLabelConstraints = [
            
            pomodoroLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pomodoroLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            pomodoroLabel.widthAnchor.constraint(equalToConstant: 300),
            pomodoroLabel.heightAnchor.constraint(equalToConstant: 300),
        ]
        
        let startButtonConstraints = [
            startButton.topAnchor.constraint(equalTo: pomodoroLabel.bottomAnchor, constant: 10),
            startButton.leadingAnchor.constraint(equalTo: pomodoroLabel.leadingAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 85),
            startButton.widthAnchor.constraint(equalTo: pomodoroLabel.widthAnchor, multiplier: 0.47),
        ]
        
        let stopButtonConstraints = [
            stopButton.topAnchor.constraint(equalTo: pomodoroLabel.bottomAnchor, constant: 10),
            stopButton.trailingAnchor.constraint(equalTo: pomodoroLabel.trailingAnchor),
            stopButton.heightAnchor.constraint(equalToConstant: 85),
            stopButton.widthAnchor.constraint(equalTo: pomodoroLabel.widthAnchor, multiplier: 0.47),
        ]
        
        let resetButtonConstraints = [
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 10),
            resetButton.heightAnchor.constraint(equalToConstant: 85),
            resetButton.widthAnchor.constraint(equalTo: pomodoroLabel.widthAnchor, multiplier: 0.47),
        ]
        
        NSLayoutConstraint.activate(pomodoroLabelConstraints)
        NSLayoutConstraint.activate(startButtonConstraints)
        NSLayoutConstraint.activate(stopButtonConstraints)
        NSLayoutConstraint.activate(resetButtonConstraints)

    }
    
    @objc func startButtonTapped() {
        if !startTapped {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                self?.updateLabel()
                if self?.remainingTime == 0 {
                    // i will add music here, pomodoro = work time is over
                    self?.pomodoroLabel.text = "00:00:00"
                    timer.invalidate()
                }
            }
        }
        
        startTapped = true
    }
    
    @objc func stopButtonTapped() {
        startTapped = false
        timer?.invalidate()
        
    }
    
    @objc func resetButtonTapped() {
        startTapped = false
        timer?.invalidate()
        pomodoroLabel.text = "\(selectedPomodoro?.work_time_hour ?? ""):\(selectedPomodoro?.work_time_min ?? "")"
        convertTextToMin(pomodoroTime: pomodoroLabel.text!)
    }
}
