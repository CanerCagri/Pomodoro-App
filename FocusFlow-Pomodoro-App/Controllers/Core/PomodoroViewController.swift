//
//  PomodoroViewController.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 26.12.2022.
//

import UIKit

class PomodoroViewController: UIViewController {
    
    // UI Components
    
    private let pomodoroTableView: UITableView = {
        var tableView = UITableView()
        tableView.register(PomodoroTableViewCell.self, forCellReuseIdentifier: PomodoroTableViewCell.identifier)
        return tableView
    }()
    
    let searchController: UISearchController = {
        var controller = UISearchController()
        controller.searchBar.placeholder = "Search with a pomodoro name"
        controller.searchBar.searchBarStyle = .minimal
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    private var pomodoros: [PomodoroItem] = []
    private var filteredPomodoros: [PomodoroItem] = []
    var emptyState: PAEmptyStateView?
    var isSearching = false
    
    // ViewController Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureTableView()
        fetchFromDatabase()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        pomodoroTableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pomodoroTableView.frame = view.bounds
    }
    
    // Functions
    
    private func configureViewController() {
        title = Constants.tab0Title
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarButtonTapped))
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(Notifications.added), object: nil, queue: nil) { [weak self] _ in
            self?.fetchFromDatabase()
            self?.configureSearchController()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(Notifications.animateOut), object: nil, queue: nil) { [weak self] _ in
            self?.navigationItem.rightBarButtonItem?.isEnabled = true
            self?.pomodoroTableView.isHidden = false
            
            if self?.pomodoros.isEmpty == true {
                self?.searchController.searchBar.isHidden = true
            } else {
                self?.searchController.searchBar.isHidden = false
            }
            
        }
    }
    
    private func configureTableView() {
        view.addSubview(pomodoroTableView)
        pomodoroTableView.delegate = self
        pomodoroTableView.dataSource = self
        pomodoroTableView.removeExcessCells()
        pomodoroTableView.rowHeight = 100
    }
    
    private func configureSearchController() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        if !pomodoros.isEmpty {
            searchController.searchBar.isHidden = false
            
        } else {
            searchController.searchBar.isHidden = true
        }
    }
    
    @objc func leftBarButtonTapped() {
        if pomodoros.isEmpty {
            presentAlert(title: "Warning", message: "Don't have Pomodoro to be removed.", buttonTitle: "Ok")
            
        } else {
            let alertController = UIAlertController(title: "Deleting All Pomodoro's", message: nil, preferredStyle: .alert)
            
            let deleteButton = UIAlertAction(title: "OK", style: .default) { _ in
                PersistenceManager.shared.deleteAllPomodoros()
                self.pomodoros.removeAll()
                self.pomodoroTableView.reloadData()
                self.emptyState = PAEmptyStateView(message: "Currently don't have a Pomodoro\nAdd from (+) ")
                self.emptyState?.frame = self.view.bounds
                self.view.addSubview(self.emptyState!)
                self.configureSearchController()
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(deleteButton)
            alertController.addAction(cancelButton)
            present(alertController, animated: true)
        }
    }
    
    @objc func rightBarButtonTapped() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        view.backgroundColor = .gray
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 ) {
            let popupVc = PomodoroPopupVc()
            self.addChild(popupVc)
            self.view.addSubview(popupVc.view)
            popupVc.didMove(toParent: self)
            self.pomodoroTableView.isHidden = true
            self.searchController.searchBar.isHidden = true
        }
    }
    
    private func fetchFromDatabase() {
        PersistenceManager.shared.fetchPomodoros { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let success):
                
                if success.isEmpty {
                    self.emptyState = PAEmptyStateView(message: "Currently don't have a Pomodoro\nAdd from (+) ")
                    self.emptyState?.frame = self.view.bounds
                    self.view.addSubview(self.emptyState!)
                    
                } else {
                    self.emptyState?.removeFromSuperview()
                    self.pomodoros = success
                    
                    DispatchQueue.main.async {
                        self.pomodoroTableView.reloadData()
                    }
                }
                
            case .failure(_):
                self.presentDefaultError()
            }
        }
    }
}

// TableView Protocols

extension PomodoroViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pomodoros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PomodoroTableViewCell.identifier, for: indexPath) as? PomodoroTableViewCell else { return UITableViewCell() }
        
        let pomodoro = pomodoros[indexPath.row]
        
        cell.nameLabel.text = pomodoro.name
        cell.workTimeLabel.text = "💪 \(pomodoro.work_time_hour!):\(pomodoro.work_time_min!)"
        cell.breakTimeLabel.text = "👏 \(pomodoro.break_time_hour!):\(pomodoro.break_time_min!)"
        cell.repeatedTimeLabel.text = "🔁      \(pomodoro.repeat_time!)"
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
                guard let self = self else { return }
                
                switch result {
                case .success():
                    self.pomodoros.remove(at: indexPath.row)
                    if self.pomodoros.isEmpty {
                        self.configureSearchController()
                        self.emptyState = PAEmptyStateView(message: "Currently don't have a Pomodoro\nAdd from (+) ")
                        self.emptyState?.frame = self.view.bounds
                        self.view.addSubview(self.emptyState!)
                    }

                case .failure(_):
                    self.presentDefaultError()
                }
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
}

// SearchController Protocol

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
