//
//  MainTabBarVc.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 26.12.2022.
//

import UIKit

class MainTabBarVc: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        let vc1 = UINavigationController(rootViewController: PomodoroViewController())
        let vc2 = UINavigationController(rootViewController: ToDoListViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "timer")
        vc2.tabBarItem.image = UIImage(systemName: "list.bullet.clipboard")
        
        vc1.title = "Pomodoro"
        vc2.title = "ToDo List"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2], animated: true)
    }
}
