//
//  PopupViewController.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 10.01.2023.
//

import UIKit

class AddMusicPopupVc: UIViewController {
    
    // UI Components
    
    private let popupView = PAContainerView()
    private let addMusicTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AddMusicTableViewCell.self, forCellReuseIdentifier: AddMusicTableViewCell.identifier)
        return tableView
    }()
    
    let songTitles: [String] = ["Noone", "Nature", "Rain", "Water Stream"]
    
    // Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConstraints()
        configureTableView()
    }
    
    // Methods
    
    private func configureTableView() {
        addMusicTableView.isScrollEnabled = false
        addMusicTableView.delegate = self
        addMusicTableView.dataSource = self
        addMusicTableView.removeExcessCells()
        addMusicTableView.rowHeight = 50
    }
    
    private func setUpConstraints() {
        view.addSubview(popupView)
        popupView.addSubview(addMusicTableView)
        
        popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.82).isActive = true
        popupView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.62).isActive = true
        
        addMusicTableView.topAnchor.constraint(equalTo: popupView.topAnchor).isActive = true
        addMusicTableView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        addMusicTableView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        addMusicTableView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor).isActive = true
    }
}

// TableView Protocols

extension AddMusicPopupVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddMusicTableViewCell.identifier, for: indexPath) as? AddMusicTableViewCell else { return UITableViewCell()}
        let selectionView = UIView(frame: CGRect.zero)
        selectionView.backgroundColor = .red
        cell.selectedBackgroundView = selectionView
        cell.nameLabel.text = songTitles[indexPath.row]
        let defaults = UserDefaults.standard
        if let text = defaults.string(forKey: UserDefaultConstants.musicName) {
            let valueInRow = songTitles[indexPath.row]
            if valueInRow == text {
                cell.contentView.backgroundColor = .red
                cell.contentView.tintColor = .systemBackground
                cell.contentView.layer.cornerRadius = 12
            } else {
                cell.contentView.backgroundColor = .systemBlue
                cell.contentView.tintColor = .systemBackground
                cell.contentView.layer.cornerRadius = 12
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
            cell?.contentView.backgroundColor = .systemBlue
            cell?.contentView.tintColor = .systemBackground
            cell?.contentView.layer.cornerRadius = 12
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = .red
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedRow = songTitles[indexPath.row]
        PersistenceManager.shared.saveMusicToUserDefaults(with: selectedRow)
    }
}
