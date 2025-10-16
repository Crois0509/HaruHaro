//
//  WriteReactorTest.swift
//  HaruHaroTests
//
//  Created by 장상경 on 10/16/25.
//

import XCTest
import RxSwift
import RxCocoa
@testable import HaruHaro

final class WriteReactorTest: XCTestCase {
    
    var sut: WriteReactor!

    override func setUpWithError() throws {
        let repository = DiaryRepositoryImpl(coreDataStack: CoreDataStack(isTesting: true))
        let diaryUseCase = DiaryCRUDUseCase(repository: repository)
        sut = WriteReactor(diaryUseCase: diaryUseCase)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_writeReactor() {
        // given: 테스트 기본 준비
        let reactor = sut
        let disposeBag = DisposeBag()
        var content: String = ""
        var isSaving: Bool = true
        
        reactor!.state.map(\.content)
            .subscribe(onNext: {
                content = $0
            })
            .disposed(by: disposeBag)
        
        reactor!.state.map(\.isSaving)
            .subscribe(onNext: {
                isSaving = $0
            })
            .disposed(by: disposeBag)
        
        // when: Reactor에 이벤트를 방출하여 테스트
        
        Observable.just(.updateContent("Test"))
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        Observable.just(.saveButtonTapped)
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        // then: 값이 잘 변화하였는지 확인
        XCTAssertEqual(content, "Test")
        XCTAssertFalse(isSaving)
    }

}
