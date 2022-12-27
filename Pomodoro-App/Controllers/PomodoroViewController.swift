//
//  PomodoroViewController.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 26.12.2022.
//

import UIKit

class PomodoroViewController: UIViewController {
    
    private let pomodoroTableView: UITableView = {
        
        var tableView = UITableView()
        tableView.register(PomodoroTableViewCell.self, forCellReuseIdentifier: PomodoroTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

       configureViewController()
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
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonTapped))
        
        navigationController?.navigationBar.tintColor = .label
        
        view.addSubview(pomodoroTableView)
        pomodoroTableView.delegate = self
        pomodoroTableView.dataSource = self
    }
    
    @objc func leftBarButtonTapped() {
        print("left button tapped")
    }
    
    @objc func rightBarButtonTapped() {
        print("right button tapped")
    }
    
}

extension PomodoroViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PomodoroTableViewCell.identifier, for: indexPath) as? PomodoroTableViewCell else { return UITableViewCell() }
        
        cell.textLabel?.text = "test"
        return cell
    }
    
    
}
