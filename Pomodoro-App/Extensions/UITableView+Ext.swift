//
//  UITableView+Ext.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 4.01.2023.
//

import UIKit


extension UITableView {
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
