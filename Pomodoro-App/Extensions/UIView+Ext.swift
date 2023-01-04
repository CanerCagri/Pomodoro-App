//
//  UIView+Ext.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 3.01.2023.
//

import UIKit


extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
