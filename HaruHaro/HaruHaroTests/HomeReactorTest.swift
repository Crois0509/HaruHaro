//
//  HomeReactorTest.swift
//  HaruHaroTests
//
//  Created by 장상경 on 10/17/25.
//

import XCTest
import RxSwift
import RxCocoa
@testable import HaruHaro

final class HomeReactorTest: XCTestCase {
    
    var sut: HomeReactor!

    override func setUpWithError() throws {
        let repository = DiaryRepositoryImpl(coreDataStack: CoreDataStack(isTesting: true))
        let useCase = DiaryCRUDUseCase(repository: repository)
        sut = HomeReactor(diaryUseCase: useCase)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_fetchDiaries() {
        // given: 기본 세팅 및 테스트 다이어리 저장
        let reactor = sut
        let disposeBag = DisposeBag()
        let diary = DiaryEntry(id: UUID(), date: Date(), content: "test")
        
        var diaries: [DiaryEntry] = [diary, diary, diary]
        var isLoading = true
        var isSearching = true
        
        reactor!.state.map(\.diaries)
            .subscribe(onNext: {
                diaries = $0
            })
            .disposed(by: disposeBag)
        
        reactor!.state.map(\.isLoading)
            .subscribe(onNext: {
                isLoading = $0
            })
            .disposed(by: disposeBag)
        
        reactor!.state.map(\.isSearching)
            .subscribe(onNext: {
                isSearching = $0
            })
            .disposed(by: disposeBag)
        
        // when: reactor에 이벤트 전달
        Observable.just(.fetchAllDiaries)
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
//        Observable.just(.fetchDiaryForDate(Date()))
//            .bind(to: reactor!.action)
//            .disposed(by: disposeBag)
        
//        Observable.just(.searchDiaryForContent("test"))
//            .bind(to: reactor!.action)
//            .disposed(by: disposeBag)
        
        // then: 결과 확인
        XCTAssertTrue(diaries.isEmpty)
        XCTAssertFalse(isLoading)
        XCTAssertFalse(isSearching)
    }
}
