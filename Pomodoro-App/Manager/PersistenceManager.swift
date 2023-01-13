//
//  PersistenceManager.swift
//  Pomodoro-App
//
//  Created by Caner Çağrı on 28.12.2022.
//

import UIKit
import CoreData

class PersistenceManager {
    
    enum DatabaseError: String, Error {
        case failedToDataSave = "Failed to save data. Please try again."
        case failedToFetchData = "Failed to fetch data. Please try again."
        case failedToDeleteData = "Failed to deleting data. Please try again."
    }
    
    static let shared = PersistenceManager()
    
    func saveMusicToUserDefaults(with name: String = "Noone") {
        let defaults = UserDefaults.standard
        defaults.set(name, forKey: UserDefaultConstants.musicName)
    }
    
    func downloadWithModel(model: PomodoroViewModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let item = PomodoroItem(context: context)
        
        item.id = UUID()
        item.name = model.name
        item.work_time_hour = String(model.workTimeHour)
        item.work_time_min = String(model.workTimeMin)
        item.break_time_hour = String(model.breakTimeHour)
        item.break_time_min = String(model.breakTimeMin)
        item.repeat_time = String(model.repeatTime)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDataSave))
        }
    }
    
    func saveRepeatTime(newRepeatedValue: String, id: UUID) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<PomodoroItem>(entityName: Constants.entityName)
        fetchRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "id = %@", id as CVarArg)
        ])
        
        do {
            let object: [PomodoroItem] = try context.fetch(fetchRequest)
            guard let objectFirst = object.first else { return }
            objectFirst.repeat_time = newRepeatedValue
            
            try context.save()
        } catch let error as NSError {
            print("Error updating attribute: \(error), \(error.userInfo)")
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
    
    func deletePomodoroWith(model: PomodoroItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
    func deleteAllPomodoros() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
}
