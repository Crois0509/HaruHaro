//
//  SettingReactor.swift
//  HaruHaro
//
//  Created by 장상경 on 10/17/25.
//

import Foundation
import ReactorKit
import RxSwift

enum SettingOption {
    case setiCloud
    case setAlarm(Bool)
    case inquire(String?)
    case review(String?)
    case setShortCut(String?)
}

final class SettingReactor: Reactor {
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .pushOption(let option):
            switch option {
            case .setiCloud:
                return .just(.setSynciCloud)
            case .setAlarm(let isOn):
                return .just(.setAlarm(isOn))
            case .inquire(let url):
                return .just(.setURL(url))
            case .review(let url):
                return .just(.setURL(url))
            case .setShortCut(let url):
                return .just(.setURL(url))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSynciCloud: break
            // TODO: #01 iCloud Logic
            // 추후 iCloud 기능 추가 후 구현
        case .setAlarm(let isOn):
            newState.isOnAlarm = isOn
        case .setURL(let url):
            newState.pushURL = url
        }
        
        return newState
    }
}

extension SettingReactor {
    
    struct State {
        var isSynciCloud: Bool? = nil
        var isOnAlarm: Bool? = nil
        var pushURL: String? = nil
    }
    
    enum Action {
        case pushOption(SettingOption)
    }
    
    enum Mutation {
        case setSynciCloud
        case setAlarm(Bool)
        case setURL(String?)
    }
    
}
