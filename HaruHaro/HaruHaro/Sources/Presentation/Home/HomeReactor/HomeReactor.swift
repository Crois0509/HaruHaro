//
//  HomeReactor.swift
//  HaruHaro
//
//  Created by 장상경 on 10/17/25.
//

import Foundation
import ReactorKit
import RxSwift

final class HomeReactor: Reactor {
    var initialState = State()
    private let diaryUseCase: DiaryCRUDUseCase
    
    init(diaryUseCase: DiaryCRUDUseCase) {
        self.diaryUseCase = diaryUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchAllDiaries:
            let fetched = diaryUseCase.fetchAllDiaries()
                .map { Mutation.setDiaries($0) }
            return .concat(
                .just(.setLoading(true)),
                fetched,
                .just(.setLoading(false))
            )
        case .fetchDiaryForDate(let date):
            let fetched = diaryUseCase.fetchAllDiariesForDate(date)
                .map { Mutation.setDiaries($0) }
            return .concat(
                .just(.setLoading(true)),
                fetched,
                .just(.setLoading(false))
            )
        case .searchDiaryForContent(let search):
            let fetched = diaryUseCase.fetchAllDiariesForContent(search)
                .map { Mutation.setDiaries($0) }
            return .concat(
                .just(.setSearchLoading(true)),
                fetched,
                .just(.setSearchLoading(false))
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setDiaries(let diaries):
            newState.diaries = diaries
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setSearchLoading(let isSearching):
            newState.isSearching = isSearching
        }
        
        return newState
    }
}

extension HomeReactor {
    
    struct State {
        var diaries: [DiaryEntry] = []
        var isLoading: Bool = false
        var isSearching: Bool = false
    }
    
    enum Action {
        case fetchAllDiaries
        case fetchDiaryForDate(Date)
        case searchDiaryForContent(String)
    }
    
    enum Mutation {
        case setDiaries([DiaryEntry])
        case setLoading(Bool)
        case setSearchLoading(Bool)
    }
    
}
