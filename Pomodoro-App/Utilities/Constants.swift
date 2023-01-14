//
//  Constants.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 13.01.2023.
//

import UIKit


enum Constants {
    static let tab0Title = "Pomodoro"
    static let tab1Title = "Add/Choose Music"
    static let timesNewRoman = "Times New Roman"
    static let entityName = "PomodoroItem"
    static let persistenceContainerName = "PomodoroModel"
}

enum Images {
    static let emptyState = UIImage(named: "pomodoro")
}

enum Identifiers {
    static let pomodoroTableViewCell = "PomodoroTableViewCell"
    static let addMusicTableViewCell = "AddMusicTableViewCell"
}

enum Colors {
    static let PAButtonColor = "GillSans-SemiBold"
    static let PATitleLabelColor = "GillSans-SemiBold"
}

enum UserDefaultConstants {
    static let musicName = "musicName"
}

enum SFSymbols {
    static let play = "play.fill"
    static let stop = "stop.fill"
    static let restart = "restart.circle.fill"
    static let save = "checkmark.circle"
    static let pomodoroIcon = "timer"
    static let musicIcon = "music.note.list"
}

enum Sounds {
    static let ringing = "ringing"
    static let nature = "nature"
    static let rain = "rain"
    static let waterStream = "water-stream"
}

enum Notifications {
    static let added = "added"
    static let addedPomodoroTime = "addedPomodoroTime"
    static let addedBreakTime = "addedBreakTime"
    static let animateOut = "animateOut"
}

enum ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom                    = UIDevice.current.userInterfaceIdiom
    static let nativeScale              = UIScreen.main.nativeScale
    static let scale                    = UIScreen.main.scale
    
    static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad                   = idiom == .pad && ScreenSize.maxLength >= 1024.0
    
    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}
