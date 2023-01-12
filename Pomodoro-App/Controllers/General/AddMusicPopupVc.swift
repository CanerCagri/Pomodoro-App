//
//  PopupViewController.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 10.01.2023.
//

import UIKit

class AddMusicPopupVc: UIViewController {
    
    let songTitles: [String] = ["Noone", "Nature", "Rain", "Water Stream"]

    private let popupView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.label.withAlphaComponent(0.7)
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 24
        return view
    }()
    
    private let addMusicTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AddMusicTableViewCell.self, forCellReuseIdentifier: AddMusicTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConstraints()
        configureTableView()
    }
    
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = songTitles[indexPath.row]
        
        PersistenceManager.shared.saveMusicToUserDefaults(with: selectedRow)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .systemBlue
        cell.tintColor = .systemBackground
        cell.layer.cornerRadius = 12
    }
}