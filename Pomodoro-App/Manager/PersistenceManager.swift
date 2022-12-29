//
//  PersistenceManager.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 28.12.2022.
//

import UIKit
import CoreData

class PersistenceManager {
    
    enum DatabaseError: Error {
        case failedToDataSave
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = PersistenceManager()
    
    func downloadWithModel(model: PomodoroViewModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
       
        let item = PomodoroItem(context: context)
        
        item.name = model.name
        item.work_time_hour = Int64(model.workTimeHour)
        item.work_time_min = Int64(model.workTimeMin)
        item.break_time_hour = Int64(model.breakTimeHour)
        item.break_time_min = Int64(model.breakTimeMin)
    
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDataSave))
        }
    }
    
    func fetchPomodoros(completion: @escaping(Result<[PomodoroItem], Error> )-> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<PomodoroItem>
        
        request = PomodoroItem.fetchRequest()
        
        do {
            
            let pomodoros = try context.fetch(request)
            completion(.success(pomodoros))
            
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
}

