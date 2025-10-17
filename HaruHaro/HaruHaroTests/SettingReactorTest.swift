//
//  SettingReactorTest.swift
//  HaruHaroTests
//
//  Created by 장상경 on 10/17/25.
//

import XCTest
import RxSwift
@testable import HaruHaro

final class SettingReactorTest: XCTestCase {
    
    var sut: SettingReactor!

    override func setUpWithError() throws {
        sut = SettingReactor()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_reactor() {
        // given: 기본 세팅
        let reactor = sut
        let disposeBag = DisposeBag()
        
//        var synciCloud: Bool? = nil
        var alarm: Bool? = nil
        var url: String? = nil
        
//        reactor!.state.map(\.isSynciCloud)
//            .bind { isSync in
//                synciCloud = isSync
//            }
//            .disposed(by: disposeBag)
        
        reactor!.state.map(\.isOnAlarm)
            .bind { isOn in
                alarm = isOn
            }
            .disposed(by: disposeBag)
        
        reactor!.state.map(\.pushURL)
            .bind { pushUrl in
                url = pushUrl
            }
            .disposed(by: disposeBag)
        
        // when: reactor에 이벤트 전달
        
        Observable.just(.pushOption(.setAlarm(true)))
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        Observable.just(.pushOption(.review("http://example.com")))
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        // then: 결과 확인
        XCTAssertNotNil(alarm)
        XCTAssertNotNil(url)
        XCTAssertEqual(alarm, true)
        XCTAssertEqual(url, "http://example.com")
    }
}
