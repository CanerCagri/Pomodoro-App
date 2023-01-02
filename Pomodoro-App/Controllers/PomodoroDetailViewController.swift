//
//  PomodoroDetailViewController.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 29.12.2022.
//

import UIKit
import AVFoundation

class PomodoroDetailViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?
    let soundURL = URL(fileURLWithPath: "/path/to/sound/file.mp3") // TO DO
    
    // Animation
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval = 0
    var endTime: Date?
    var animationTimer: Timer!
    
    var temp = 0
   
    // here you create your basic animation object to animate the strokeEnd
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")

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
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.text = ""
        return label
    }()
    
    private let startButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.configuration?.cornerStyle = .medium
        button.configuration?.baseBackgroundColor = .systemPink
        button.configuration?.baseForegroundColor = .white
        
        var container = AttributeContainer()
        container.font = UIFont(name: "GillSans-SemiBold", size: 22)
        
        button.configuration?.attributedTitle = AttributedString("Start", attributes: container)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let stopButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.configuration?.cornerStyle = .medium
        button.configuration?.baseBackgroundColor = .systemPink
        button.configuration?.baseForegroundColor = .white

        var container = AttributeContainer()
        container.font = UIFont(name: "GillSans-SemiBold", size: 22)
        
        button.configuration?.attributedTitle = AttributedString("Pause", attributes: container)
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let resetButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.configuration?.cornerStyle = .medium
        button.configuration?.baseBackgroundColor = .systemPink
        button.configuration?.baseForegroundColor = .white
        var container = AttributeContainer()
        container.font = UIFont(name: "GillSans-SemiBold", size: 22)
        
        button.configuration?.attributedTitle = AttributedString("Reset", attributes: container)
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.red.cgColor
        layer.lineWidth = 10.0
        return layer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
       
        addConstraints()
        addAnimation()
    }
    
    private func addAnimation() {
        bgShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY - 100), radius:
            100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        bgShapeLayer.strokeColor = UIColor.systemPink.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 15
        view.layer.addSublayer(bgShapeLayer)
        
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX , y: view.frame.midY - 100), radius:
            100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        timeLeftShapeLayer.strokeColor = UIColor.gray.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 15
        view.layer.addSublayer(timeLeftShapeLayer)
        
        
        
    
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
        temp = totalMinutes * 60
    }
    
    @objc func updateTime() {
        if timeLeft > 0 {
            timeLeft = endTime?.timeIntervalSinceNow ?? 0
            pomodoroLabel.text = timeLeft.time
        } else {
            pomodoroLabel.text = "00:00"
            finishSound()
            animationTimer.invalidate()
        }
    }
    
    private func finishSound() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }

    @objc func startButtonTapped() {
        if !startTapped {
            strokeIt.fromValue = 0
            strokeIt.toValue = 1
            strokeIt.duration = timeLeft
            strokeIt.timeOffset = Double(temp) - timeLeft
            
            timeLeftShapeLayer.add(strokeIt, forKey: "countDown")
            // define the future end time by adding the timeLeft to now Date()
            endTime = Date().addingTimeInterval(timeLeft)
            
            animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                self?.updateTime()
            }
        }
        startTapped = true
    }
    
    @objc func stopButtonTapped() {
        startTapped = false
        animationTimer.invalidate()
        timeLeftShapeLayer.removeAnimation(forKey: "countDown")
       
    }
    
    @objc func resetButtonTapped() {
        startTapped = false
        animationTimer.invalidate()
        timeLeftShapeLayer.removeAnimation(forKey: "countDown")
        pomodoroLabel.text = "\(selectedPomodoro?.work_time_hour ?? ""):\(selectedPomodoro?.work_time_min ?? "")"
        convertTextToMin(pomodoroTime: pomodoroLabel.text!)
    }
    
    private func addConstraints() {
        view.addSubview(pomodoroLabel)
        view.addSubview(startButton)
        view.addSubview(stopButton)
        view.addSubview(resetButton)
        
        let pomodoroLabelConstraints = [
            
            pomodoroLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pomodoroLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
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
}
