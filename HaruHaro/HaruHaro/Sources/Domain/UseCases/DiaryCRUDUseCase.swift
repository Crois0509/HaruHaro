//
//  DiaryCRUDUseCase.swift
//  HaruHaro
//
//  Created by 장상경 on 10/15/25.
//

import Foundation
import RxSwift

enum DiaryUseCaseError: LocalizedError {
    case emptyContent
    case saveFailed(Error)
    case deleteFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .emptyContent:
            return "일기 내용이 비어있기 때문에 저장할 수 없습니다."
        case .saveFailed(let error):
            return "일기를 저장할 수 없습니다. \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "일기를 삭제할 수 없습니다. \(error.localizedDescription)"
        }
    }
}

final class DiaryCRUDUseCase {
    private let repository: DiaryRepository
    
    init(repository: DiaryRepository) {
        self.repository = repository
    }
    
    func saveNewDiary(content: String) -> Completable {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return .error(DiaryUseCaseError.emptyContent) }
        
        let diary = DiaryEntry(
            id: UUID(),
            date: Date(),
            content: content
        )
        
        return repository.save(entry: diary)
            .catch { error in
                return .error(DiaryUseCaseError.saveFailed(error))
            }
    }
    
    func deleteDiary(_ diary: DiaryEntry) -> Completable {
        repository.delete(entry: diary)
            .catch { error in
                return .error(DiaryUseCaseError.deleteFailed(error))
            }
    }
    
    func fetchAllDiaries() -> Observable<[DiaryEntry]> {
        repository.fetchAllEntries()
    }
    
    func fetchAllDiariesForDate(_ date: Date) -> Observable<[DiaryEntry]> {
        repository.fetchEntries(for: date)
    }
    
    func fetchAllDiariesForContent(_ content: String) -> Observable<[DiaryEntry]> {
        repository.fetchEntries(for: content)
    }
}
