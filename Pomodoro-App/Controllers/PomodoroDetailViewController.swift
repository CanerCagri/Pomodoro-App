//
//  PomodoroDetailViewController.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 29.12.2022.
//

import UIKit
import AVFoundation

class PomodoroDetailViewController: UIViewController {
    
    // Timer finish sound
    
    var finishTimeAudioPlayer: AVAudioPlayer?
    let soundURL = URL(fileURLWithPath: "/path/to/sound/file.mp3") // TO DO
    
    // Animation
    
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval = 0
    var endTime: Date?
    var animationTimer: Timer!
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    
    //Variables
    
    var tempTime = 0
    var isStartTapped = false
    var isBreakTime = false
    
    //Selected pomodoro details
    
    var selectedPomodoro: PomodoroItem? {
        didSet {
            title = selectedPomodoro?.name
            pomodoroLabel.text = "\(selectedPomodoro?.work_time_hour ?? ""):\(selectedPomodoro?.work_time_min ?? "")"
            nextTimeLabel.text = "\(selectedPomodoro?.break_time_hour ?? ""):\(selectedPomodoro?.break_time_min ?? "")"
            convertTextToMin(pomodoroTime: pomodoroLabel.text!)
        }
    }
    
    // UI Components
    
    private let titleLabel = PATitleLabel(textAlignment: .center, fontSize: 25)
    private let pomodoroLabel = PALabel(textAlignment: .center, fontSize: 25)
    private let nextTimeLabel = PALabel(textAlignment: .center, fontSize: 21)
    
    private let startButton = PAButton(title: "Start", color: .systemPink, systemImageName: "play.fill")
    private let stopButton = PAButton(title: "Pause", color: .systemPink, systemImageName: "stop.fill")
    private let resetButton = PAButton(title: "Restart", color: .systemPink, systemImageName: "restart.circle.fill")
    

    // Viewcontroller Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addConstraints()
        addAnimation()
        configureActionsOfButtons()
    }
    
    // Functions
    
    private func configureActionsOfButtons() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    private func addAnimation() {
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY - 100), radius: 100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        bgShapeLayer.strokeColor = UIColor.systemBlue.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 15
        view.layer.addSublayer(bgShapeLayer)
        
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY - 100), radius: 100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        timeLeftShapeLayer.strokeColor = UIColor.gray.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 15
        
        view.layer.addSublayer(timeLeftShapeLayer)
    }
    
    private func animationTitleLabel() {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        let size = CGFloat.random(in: 20...25)
        
        UIView.animate(withDuration: timeLeft) { [weak self] in
            self?.titleLabel.textColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            self?.titleLabel.font = self?.titleLabel.font.withSize(size)
        }
    }
    
    private func convertTextToMin(pomodoroTime: String) {
        let scanner = Scanner(string: pomodoroTime)
        
        var hours: Int = 0
        var minutes: Int = 0
        
        scanner.scanInt(&hours)
        scanner.scanCharacters(from: CharacterSet(charactersIn: ":"))
        scanner.scanInt(&minutes)
        
        let totalMinutes = hours * 60 + minutes
        timeLeft = TimeInterval(totalMinutes * 60)
        tempTime = totalMinutes * 60
    }
    
    @objc func updateTime() {
        print(timeLeft)
        if timeLeft > 0 {
            timeLeft = endTime?.timeIntervalSinceNow ?? 0
            pomodoroLabel.text = timeLeft.time
        } else if timeLeft < 0 {
            isBreakTime.toggle()
            pomodoroLabel.text = "00:00:00"
            animationTimer.invalidate()
            finishSound()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                if self?.isBreakTime == true {
                    self?.breakTimeTrue()
                    
                } else {
                    self?.breakTimeFalse()
                }
            }
        }
    }
    
    private func breakTimeTrue() {
        finishTimeAudioPlayer?.stop()
        titleLabel.text = "Break Time! 👏"
        pomodoroLabel.text = "\(self.selectedPomodoro?.break_time_hour ?? ""):\(selectedPomodoro?.break_time_min ?? "")"
        nextTimeLabel.text = "\(selectedPomodoro?.work_time_hour ?? ""):\(self.selectedPomodoro?.work_time_min ?? "")"
        convertTextToMin(pomodoroTime: (pomodoroLabel.text!))
        isStartTapped = false
    }
    
    @objc func breakTimeFalse() {
        finishTimeAudioPlayer?.stop()
        titleLabel.text = "Time To FOCUS! 💪"
        pomodoroLabel.text = "\(selectedPomodoro?.work_time_hour ?? ""):\(self.selectedPomodoro?.work_time_min ?? "")"
        nextTimeLabel.text = "\(selectedPomodoro?.break_time_hour ?? ""):\(self.selectedPomodoro?.break_time_min ?? "")"
        convertTextToMin(pomodoroTime: (pomodoroLabel.text!))
        isStartTapped = false
    }
    
    private func buttonsControls() {
        
    }
    
    
    private func finishSound() {
        do {
            finishTimeAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            finishTimeAudioPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func startButtonTapped() {
        if !isStartTapped {
            strokeIt.fromValue = 0
            strokeIt.toValue = 1
            strokeIt.duration = timeLeft
            strokeIt.timeOffset = Double(tempTime) - timeLeft
            
            timeLeftShapeLayer.add(strokeIt, forKey: "countDown")
            // define the future end time by adding the timeLeft to now Date()
            endTime = Date().addingTimeInterval(timeLeft)
            
            animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                self?.updateTime()
                self?.animationTitleLabel()
            }
        }
        
        isStartTapped = true
    }
    
    @objc func stopButtonTapped() {
        isStartTapped = false
        animationTimer.invalidate()
        timeLeftShapeLayer.removeAnimation(forKey: "countDown")
        
    }
    
    @objc func resetButtonTapped() {
        isStartTapped = false
        animationTimer.invalidate()
        timeLeftShapeLayer.removeAnimation(forKey: "countDown")
        if isBreakTime == true {
            breakTimeTrue()
            
        } else {
            breakTimeFalse()
        }
    }
    
    // Layout Constraints
    
    private func addConstraints() {
        view.addSubviews(titleLabel, pomodoroLabel, nextTimeLabel, startButton, stopButton, resetButton)
        
        let titleLabelConstraints = [
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
        ]
        
        let pomodoroLabelConstraints = [
            pomodoroLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pomodoroLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            pomodoroLabel.widthAnchor.constraint(equalToConstant: 300),
            pomodoroLabel.heightAnchor.constraint(equalToConstant: 300),
        ]
        
        let nextTimeLabelConstraints = [
            nextTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextTimeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            nextTimeLabel.widthAnchor.constraint(equalToConstant: 300),
            nextTimeLabel.heightAnchor.constraint(equalToConstant: 300),
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
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(pomodoroLabelConstraints)
        NSLayoutConstraint.activate(nextTimeLabelConstraints)
        NSLayoutConstraint.activate(startButtonConstraints)
        NSLayoutConstraint.activate(stopButtonConstraints)
        NSLayoutConstraint.activate(resetButtonConstraints)
    }
}
