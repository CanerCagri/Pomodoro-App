//
//  AddMusicViewController.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 26.12.2022.
//

import UIKit

class AddMusicViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        addPopup()
    }
    
    private func configureViewController() {
        title = "Add Music"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func addPopup() {
        let popupVC = AddMusicPopupVc()
        addChild(popupVC)
        view.addSubview(popupVC.view)
        popupVC.didMove(toParent: self)
    }
}
