//
//  MainTabBarVc.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 26.12.2022.
//

import UIKit

class MainTabBarVc: UITabBarController {
    
    // TabBar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: PomodoroViewController())
        let vc2 = UINavigationController(rootViewController: AddMusicViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: SFSymbols.pomodoroIcon)
        vc2.tabBarItem.image = UIImage(systemName: SFSymbols.musicIcon)
        
        vc1.title = Constants.tab0Title
        vc2.title = Constants.tab1Title
        
        tabBar.tintColor = .label
        tabBar.backgroundColor = .secondarySystemBackground
        
        setViewControllers([vc1, vc2], animated: true)
    }
}
