//
//  TimeInterval+Ext.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 2.01.2023.
//

import Foundation

extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d:%02d", Int(self/3600), Int(ceil(truncatingRemainder(dividingBy: 3600))) / 60,  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}
