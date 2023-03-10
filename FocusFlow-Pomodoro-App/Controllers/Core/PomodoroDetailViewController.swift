//
//  PomodoroDetailViewController.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 29.12.2022.
//

import UIKit
import AVFoundation

class PomodoroDetailViewController: UIViewController {
    
    //Variables
    
    var audioPlayer: AVAudioPlayer?
    var isStartTapped = false
    var isStopTapped = false
    var isBreakTime = false
    var repeatCounter = 0
    
    // Animation
    
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval = 0
    var endTime: Date?
    var animationTimer: Timer!
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    var offSetTime = 0
    
    // UI Components
    
    private let titleLabel = PATitleLabel(textAlignment: .center, fontSize: 34)
    private let pomodoroLabel = PALabel(textAlignment: .center, fontSize: 30)
    private let nextTimeLabel = PALabel(textAlignment: .center, fontSize: 21, textColor: .systemGray)
    private let repeatedTimeLabel = PALabel(textAlignment: .center, fontSize: 25, textColor: .systemGreen)
    
    private let startButton = PAButton(title: "Start", color: .systemPink, systemImageName: SFSymbols.play)
    private let stopButton = PAButton(title: "Pause", color: .systemPink, systemImageName: SFSymbols.stop)
    private let resetButton = PAButton(title: "Restart", color: .systemPink, systemImageName: SFSymbols.restart)
    
    var selectedPomodoro: PomodoroItem? {
        didSet {
            title = selectedPomodoro?.name
            pomodoroLabel.text = "\(selectedPomodoro?.work_time_hour ?? ""):\(selectedPomodoro?.work_time_min ?? "")"
            nextTimeLabel.text = "\(selectedPomodoro?.break_time_hour ?? ""):\(selectedPomodoro?.break_time_min ?? "")"
            convertTextToMin(pomodoroTime: pomodoroLabel.text!)
            repeatedTimeLabel.text = (selectedPomodoro?.repeat_time)!
        }
    }
    
    // Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        addConstraints()
        addAnimation()
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    // Functions
    
    private func addAnimation() {
        
        let topConstarintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8PlusZoomed || DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone8Zoomed || DeviceTypes.isiPhone8PlusStandard ? 50 : 100
        
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY - topConstarintConstant), radius: 100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        bgShapeLayer.strokeColor = UIColor.systemBlue.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 15
        view.layer.addSublayer(bgShapeLayer)
        
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY - topConstarintConstant), radius: 100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        timeLeftShapeLayer.strokeColor = UIColor.gray.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 15
        
        view.layer.addSublayer(timeLeftShapeLayer)
    }
    
    private func animationTitleLabel() {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        let size = CGFloat.random(in: 30...37)
        
        UIView.animate(withDuration: timeLeft) { [weak self] in
            self?.titleLabel.textColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            self?.titleLabel.font = self?.titleLabel.font.withSize(size)
        }
    }
    
    private func convertTextToMin(pomodoroTime: String) {
        let timeArr = pomodoroTime.components(separatedBy: ":")
        let hours = Int(timeArr[0]) ?? 0
        let minutes = Int(timeArr[1]) ?? 0
        let totalMinutes = hours * 60 + minutes
        timeLeft = TimeInterval(totalMinutes * 60)
        offSetTime = totalMinutes * 60
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
            audioPlayer?.stop()
            startSound(with: Sounds.ringing, withExtension: "mp3")
            
            if titleLabel.text == "Break Time! 👏" {
                repeatCounter = Int(repeatedTimeLabel.text!)! + 1
                PersistenceManager.shared.saveRepeatTime(newRepeatedValue: String(repeatCounter), id: (selectedPomodoro?.id)!)
                repeatedTimeLabel.text = String(repeatCounter)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.audioPlayer?.stop()
                self?.tabBarController!.tabBar.items![1].isEnabled = true
                if self?.isBreakTime == true {
                    self?.updateUI(isBreakTime: true)
                    
                } else {
                    self?.updateUI(isBreakTime: false)
                }
            }
        }
    }
    
    private func updateUI(isBreakTime: Bool) {
        audioPlayer?.stop()
        titleLabel.text = isBreakTime ? "Break Time! 👏" : "Time To FOCUS! 💪"
        let hour = isBreakTime ? selectedPomodoro?.break_time_hour : selectedPomodoro?.work_time_hour
        let min = isBreakTime ? selectedPomodoro?.break_time_min : selectedPomodoro?.work_time_min
        pomodoroLabel.text = "\(hour ?? ""):\(min ?? "")"
        let nextHour = isBreakTime ? selectedPomodoro?.work_time_hour : selectedPomodoro?.break_time_hour
        let nextMin = isBreakTime ? selectedPomodoro?.work_time_min : selectedPomodoro?.break_time_min
        nextTimeLabel.text = "\(nextHour ?? ""):\(nextMin ?? "")"
        convertTextToMin(pomodoroTime: (pomodoroLabel.text!))
        isStartTapped = false
    }
    
    private func startSound(with name: String, withExtension: String) {
        guard let soundURL = Bundle.main.url(forResource: name, withExtension: withExtension) else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            presentDefaultError()
        }
    }
    
    @objc func startButtonTapped() {
        let defaults = UserDefaults.standard
        tabBarController!.tabBar.items![1].isEnabled = false
        
        let sounds = ["Noone": ["", ""] , "Nature": [Sounds.nature, "mp3"] , "Rain": [Sounds.rain, "mp3"] , "Water Stream": [Sounds.waterStream, "wav"]]
        if let sound = defaults.string(forKey: UserDefaultConstants.musicName) , let details = sounds[sound] {
            startSound(with: details[0], withExtension: details[1])
        }
        
        if !isStartTapped {
            strokeIt.fromValue = 0
            strokeIt.toValue = 1
            strokeIt.duration = timeLeft
            strokeIt.timeOffset = Double(offSetTime) - timeLeft
            
            timeLeftShapeLayer.add(strokeIt, forKey: "countDown")
            
            endTime = Date().addingTimeInterval(timeLeft)
            
            animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                self?.updateTime()
                self?.animationTitleLabel()
            }
        }
        
        isStartTapped = true
    }
    
    @objc func stopButtonTapped() {
        if isStartTapped {
            tabBarController!.tabBar.items![1].isEnabled = true
            isStartTapped = false
            isStopTapped = true
            audioPlayer?.stop()
            animationTimer.invalidate()
            timeLeftShapeLayer.removeAnimation(forKey: "countDown")
        }
    }
    
    @objc func resetButtonTapped() {
        if isStartTapped || isStopTapped {
            tabBarController!.tabBar.items![1].isEnabled = true
            isStartTapped = false
            isStopTapped = false
            animationTimer.invalidate()
            timeLeftShapeLayer.removeAnimation(forKey: "countDown")
            if isBreakTime == true {
                updateUI(isBreakTime: true)
                
            } else {
                updateUI(isBreakTime: false)
            }
        }
    }
    
    // Layout Constraints
    
    private func addConstraints() {
        view.addSubviews(titleLabel, pomodoroLabel, nextTimeLabel, repeatedTimeLabel, startButton, stopButton, resetButton)
        
        let topConstarintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8PlusZoomed || DeviceTypes.isiPhone8Standard || DeviceTypes.isiPhone8Zoomed || DeviceTypes.isiPhone8PlusStandard ? -40 : -100
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
        
            pomodoroLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pomodoroLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: topConstarintConstant),
            pomodoroLabel.widthAnchor.constraint(equalToConstant: 300),

            nextTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextTimeLabel.topAnchor.constraint(equalTo: pomodoroLabel.bottomAnchor, constant: 1),
            nextTimeLabel.widthAnchor.constraint(equalToConstant: 300),
        
            repeatedTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            repeatedTimeLabel.topAnchor.constraint(equalTo: nextTimeLabel.bottomAnchor, constant: 1),
            repeatedTimeLabel.widthAnchor.constraint(equalToConstant: 300),
        
            startButton.topAnchor.constraint(equalTo: repeatedTimeLabel.bottomAnchor, constant: 50),
            startButton.leadingAnchor.constraint(equalTo: repeatedTimeLabel.leadingAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 85),
            startButton.widthAnchor.constraint(equalTo: repeatedTimeLabel.widthAnchor, multiplier: 0.47),
        
            stopButton.topAnchor.constraint(equalTo: repeatedTimeLabel.bottomAnchor, constant: 50),
            stopButton.trailingAnchor.constraint(equalTo: repeatedTimeLabel.trailingAnchor),
            stopButton.heightAnchor.constraint(equalToConstant: 85),
            stopButton.widthAnchor.constraint(equalTo: repeatedTimeLabel.widthAnchor, multiplier: 0.47),
        
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 10),
            resetButton.heightAnchor.constraint(equalToConstant: 85),
            resetButton.widthAnchor.constraint(equalTo: repeatedTimeLabel.widthAnchor, multiplier: 0.47),
        ])
    }
}
