//
//  CoreDataCloudStack.swift
//  HaruHaro
//
//  Created by 장상경 on 10/14/25.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DiaryModel")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                debugPrint("Unresolved error \(error)")
            }
        }
        
        return container
    }()
    
    /// 메인 스레드에서 UI 관련 작업을 처리하는 관리 객체
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - 데이터 저장 메서드
    
    func saveContext() {
        let context = mainContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            debugPrint(nserror.localizedDescription)
        }
    }
}
