//
//  PomodoroViewController.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 26.12.2022.
//

import UIKit

class PomodoroViewController: UIViewController {
    
    private var pomodoros: [PomodoroItem] = []
    private var filteredPomodoros: [PomodoroItem] = []
    
    var isSearching = false
    
    private let pomodoroTableView: UITableView = {
        var tableView = UITableView()
        tableView.register(PomodoroTableViewCell.self, forCellReuseIdentifier: PomodoroTableViewCell.identifier)
        return tableView
    }()
    
    private let searchController: UISearchController = {
        var controller = UISearchController()
        controller.searchBar.placeholder = "Search for a pomodoro with name"
        controller.searchBar.searchBarStyle = .minimal
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    // ViewController Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        fetchFromDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pomodoroTableView.frame = view.bounds
    }
    
    // Functions
    
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
        pomodoroTableView.removeExcessCells()
        pomodoroTableView.rowHeight = 100
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("added"), object: nil, queue: nil) { _ in
            self.fetchFromDatabase()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("animateOut"), object: nil, queue: nil) { _ in
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc func leftBarButtonTapped() {
        if pomodoros.count != 0 {
            let alertController = UIAlertController(title: "Deleting All Pomodoros", message: nil, preferredStyle: .alert)
            
            let deleteButton = UIAlertAction(title: "Delete", style: .default) { _ in
                PersistenceManager.shared.deleteAllPomodoros()
                self.pomodoros.removeAll()
                self.pomodoroTableView.reloadData()
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(deleteButton)
            alertController.addAction(cancelButton)
            present(alertController, animated: true)
        } else {
            return
        }
    }
    
    @objc func rightBarButtonTapped() {
        navigationItem.rightBarButtonItem?.isEnabled = false
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

// Tableview delegate and datasource

extension PomodoroViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pomodoros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PomodoroTableViewCell.identifier, for: indexPath) as? PomodoroTableViewCell else { return UITableViewCell() }
        
        let pomodoro = pomodoros[indexPath.row]
        
        cell.nameLabel.text = pomodoro.name
        cell.workTimeLabel.text = "Work Time: \(pomodoro.work_time_hour!):\(pomodoro.work_time_min!)"
        cell.breakTimeLabel.text = "Break Time: \(pomodoro.break_time_hour!):\(pomodoro.break_time_min!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVc = PomodoroDetailViewController()
        detailVc.selectedPomodoro = pomodoros[indexPath.row]
        navigationController?.pushViewController(detailVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            PersistenceManager.shared.deletePomodoroWith(model: pomodoros[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Pomodoro Deleted Succesfully")
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
                self?.pomodoros.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
            
        }
    }
}

extension PomodoroViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredPomodoros.removeAll()
            isSearching = false
            fetchFromDatabase()
            return
        }
        
        isSearching = true
        fetchFromDatabase()
        filteredPomodoros = pomodoros.filter { $0.name!.contains(filter) }
        pomodoros = filteredPomodoros
        
        pomodoroTableView.reloadData()
    }
}
