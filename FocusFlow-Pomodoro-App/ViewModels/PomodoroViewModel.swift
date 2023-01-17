//
//  PomodoroViewModel.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 27.12.2022.
//

import Foundation


struct PomodoroViewModel {
    let id = UUID()
    let name: String
    let workTimeHour: String
    let workTimeMin: String
    let breakTimeHour: String
    let breakTimeMin: String
    let repeatTime: String
}
