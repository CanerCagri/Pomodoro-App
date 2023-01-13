//
//  UIViewController+Ext.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 13.01.2023.
//

import UIKit


extension UIViewController {
    
    func presentAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = PAAlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalTransitionStyle = .crossDissolve
            alertVC.modalPresentationStyle = .overFullScreen
            self.present(alertVC, animated: true)
        }
    }
    
    func presentDefaultError() {
        let alertVC = PAAlertViewController(alertTitle: "Something Went Wrong",
                                            message: "Please try again",
                                            buttonTitle: "Ok")
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.modalPresentationStyle = .overFullScreen
        present(alertVC, animated: true)
    }
    
//    func showEmptyState(message: String, view: UIView) {
//        let emptyState = GFEmptyStateView(message: message)
//        emptyState.frame = view.bounds
//        view.addSubview(emptyState)
//    }
}

