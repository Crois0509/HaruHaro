//
//  CoreDataStackTests.swift
//  HaruHaroTests
//
//  Created by 장상경 on 10/14/25.
//

import XCTest
import CoreData
@testable import HaruHaro

final class CoreDataStackTests: XCTestCase {
    
    var sut: CoreDataStack!
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        sut = CoreDataStack(isTesting: true)
        context = sut.mainContext
    }

    override func tearDownWithError() throws {
        sut = nil
        context = nil
    }

    // 스택 초기화 테스트
    func test_persistentContainer_shouldLoadStoreWithoutError() {
        XCTAssertNotNil(sut.persistentContainer.persistentStoreCoordinator.persistentStores.first, "Core Data Persistent Store should be loaded.")
    }
    
    // 데이터 생성 및 저장 테스트
    func test_createAndSaveDiaryEntry_shouldPersistData() throws {
        // given: 새로운 일기 데이터 준비
        let newDiary = Diary(context: context)
        let unipueID = UUID()
        newDiary.id = unipueID
        newDiary.title = "테스트 일기"
        newDiary.content = "CoreData 저장 테스트"
        newDiary.date = Date()
        
        // when: 컨텍스트 저장
        sut.saveContext()
        
        // then: 저장된 데이터를 조회하여 확인
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", unipueID as CVarArg)
        
        let fetchedResults = try context.fetch(fetchRequest)
        
        XCTAssertEqual(fetchedResults.count, 1, "저장 후 정확히 하나의 엔티티가 조회되어야 합니다.")
        
        let savedDiary = fetchedResults.first
        XCTAssertEqual(savedDiary?.title, "테스트 일기")
        XCTAssertEqual(savedDiary?.content, "CoreData 저장 테스트")
    }

    // 데이터 삭제 테스트
    func test_deleteDiaryEntry_shouldRemoveData() throws {
        // given: 삭제할 데이터 생성 및 저장
        let diaryToDelete = Diary(context: context)
        diaryToDelete.id = UUID()
        sut.saveContext()
        
        // when: 엔티티 삭제 및 컨텍스트 저장
        context.delete(diaryToDelete)
        sut.saveContext()
        
        // then: 해당 데이터가 조회되지 않아야 함
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        let fetchedResults = try context.fetch(fetchRequest)
        
        XCTAssertEqual(fetchedResults.count, 0, "엔티티 삭제 후 데이터베이스에 남아있는 엔티티가 없어야 합니다.")
    }
}
