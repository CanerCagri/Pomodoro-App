//
//  PomodoroViewController.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 26.12.2022.
//

import UIKit

class PomodoroViewController: UIViewController {
    
    private var pomodoros: [PomodoroItem] = [PomodoroItem]()
    
    private let pomodoroTableView: UITableView = {
        
        var tableView = UITableView()
        tableView.register(PomodoroTableViewCell.self, forCellReuseIdentifier: PomodoroTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        fetchFromDatabase()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("added"), object: nil, queue: nil) { _ in
            self.fetchFromDatabase()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pomodoroTableView.frame = view.bounds
    }
    
    private func configureViewController() {
        title = "Pomodoro"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonTapped))
        
        view.addSubview(pomodoroTableView)
        pomodoroTableView.delegate = self
        pomodoroTableView.dataSource = self
    }
    
    @objc func leftBarButtonTapped() {
        print("left button tapped")
    }
    
    @objc func rightBarButtonTapped() {
        view.backgroundColor = .gray
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
            let popup = PomodoroPopup()
            self.view.addSubview(popup)
        }
    }
    
    private func fetchFromDatabase() {
        PersistenceManager.shared.fetchPomodoros { [weak self] result in
            switch result {
            case .success(let success):
                self?.pomodoros = success
                
                DispatchQueue.main.async {
                    self?.pomodoroTableView.reloadData()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

extension PomodoroViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pomodoros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PomodoroTableViewCell.identifier, for: indexPath) as? PomodoroTableViewCell else { return UITableViewCell() }
        
        let pomodoro = pomodoros[indexPath.row]
        
        cell.nameLabel.text = pomodoro.name
        cell.workTimeLabel.text = "Work Time: \(pomodoro.work_time_hour):\(pomodoro.work_time_min)"
        cell.breakTimeLabel.text = "Break Time: \(pomodoro.break_time_hour):\(pomodoro.break_time_min)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
