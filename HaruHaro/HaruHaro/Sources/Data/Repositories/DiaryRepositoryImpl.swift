//
//  DiaryRepositoryImpl.swift
//  HaruHaro
//
//  Created by 장상경 on 10/16/25.
//

import CoreData
import Foundation
import RxSwift

final class DiaryRepositoryImpl: DiaryRepository {

    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    // MARK: - Create & Update

    func save(entry: DiaryEntry) -> Completable {
        return .create { [weak self] observer in
            guard let self else { return Disposables.create() }
            let context = self.coreDataStack.mainContext

            // 기존 항목 조회
            let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "id == %@",
                entry.id as CVarArg
            )

            do {
                let existingDiaries = try context.fetch(fetchRequest)
                let diaryToSave = existingDiaries.first ?? Diary(context: context)

                diaryToSave.id = entry.id
                diaryToSave.date = entry.date
                diaryToSave.content = entry.content

                self.coreDataStack.saveContext()
                observer(.completed)
            } catch {
                observer(.error(error))
            }

            return Disposables.create()
        }
    }

    // MARK: - Read
    
    func fetchAllEntries() -> Observable<[DiaryEntry]> {
        return .create { [weak self] observer in
            guard let self else { return Disposables.create() }
            let context = self.coreDataStack.mainContext
            let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()

            do {
                let diaries = try context.fetch(fetchRequest)
                let entries = self.mapToDiaryEntries(diaries)

                observer.onNext(entries)
            } catch {
                observer.onError(error)
            }

            observer.onCompleted()
            return Disposables.create()
        }
    }

    func fetchEntries(for date: Date) -> Observable<[DiaryEntry]> {
        return .create { [weak self] observer in
            guard let self else { return Disposables.create() }
            let context = self.coreDataStack.mainContext
            let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
            
            do {
                let diaries = try context.fetch(fetchRequest)
                let entries = self.mapToDiaryEntries(diaries)
                let filteredEntries = entries.filter { Calendar.current.isDate($0.date, equalTo: date, toGranularity: .day) }
                
                observer.onNext(filteredEntries)
            } catch {
                observer.onError(error)
            }
            
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func fetchEntries(for content: String) -> Observable<[DiaryEntry]> {
        return .create { [weak self] observer in
            guard let self else { return Disposables.create() }
            let context = self.coreDataStack.mainContext
            let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
            
            do {
                let diaries = try context.fetch(fetchRequest)
                let entries = self.mapToDiaryEntries(diaries)
                let filteredEntries = entries.filter {
                    $0.content.contains(content)
                }
                
                observer.onNext(filteredEntries)
            } catch {
                observer.onError(error)
            }
            
            observer.onCompleted()
            return Disposables.create()
        }
    }

    // MARK: - Delete
    
    func delete(entry: DiaryEntry) -> Completable {
        return .create { [weak self] observer in
            guard let self else { return Disposables.create() }
            let context = self.coreDataStack.mainContext
            let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", entry.id as CVarArg)
            
            do {
                if let diaryToDelte = try context.fetch(fetchRequest).first {
                    context.delete(diaryToDelte)
                    self.coreDataStack.saveContext()
                    observer(.completed)
                } else {
                    observer(.completed)
                }
            } catch {
                observer(.error(error))
            }
            
            return Disposables.create()
        }.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
    }

}

// MARK: - DiaryRepositoryImpl Private Method

private extension DiaryRepositoryImpl {
    
    func mapToDiaryEntries(_ diaries: [Diary]) -> [DiaryEntry] {
        diaries.compactMap { diary -> DiaryEntry? in
            guard let id = diary.id,
                  let date = diary.date,
                  let content = diary.content
            else { return nil }

            return DiaryEntry(id: id, date: date, content: content)
        }
    }
    
}
