//
//  DiaryRepositoryProtocols.swift
//  HaruHaro
//
//  Created by 장상경 on 10/14/25.
//

import Foundation
import RxSwift

/// iCloud 연결 상태 관리 모델
enum CloudSyncStatus {
    case available
    case syncing
    case error(Error)
    case notConfigured
}

protocol DiaryRepository {
    
    // MARK: - CRUD Operations
    
    func save(entry: DiaryEntry) -> Completable
    func fetchAllEntries() -> Observable<[DiaryEntry]>
    func fetchEntries(for date: Date) -> Observable<[DiaryEntry]>
    func delete(entry: DiaryEntry) -> Completable
    
    // MARK: - Sync Status
    
//    func syncStatus() -> Observable<CloudSyncStatus>
}
