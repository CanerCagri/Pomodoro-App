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
        
        let vc1 = UINavigationController(rootViewController: PomodoroViewController())
        let vc2 = UINavigationController(rootViewController: ToDoListViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "timer")
        vc2.tabBarItem.image = UIImage(systemName: "list.bullet.clipboard")
        
        vc1.title = "Pomodoro"
        vc2.title = "ToDo List"
        
        tabBar.tintColor = .label
        tabBar.backgroundColor = .secondarySystemBackground
     
        setViewControllers([vc1, vc2], animated: true)
    }
}
