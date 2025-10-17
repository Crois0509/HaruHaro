//
//  WriteReactor.swift
//  HaruHaro
//
//  Created by 장상경 on 10/16/25.
//

import Foundation
import ReactorKit
import RxSwift

final class WriteReactor: Reactor {
    var initialState = State()
    private let diaryUseCase: DiaryCRUDUseCase
    
    init(diaryUseCase: DiaryCRUDUseCase) {
        self.diaryUseCase = diaryUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateContent(let content):
            return .just(.setContent(content))
        case .saveButtonTapped:
            let saveTask = diaryUseCase.saveNewDiary(content: currentState.content)
                .asObservable()
                .map { _ in Void() }
                .map { _ in Mutation.setSaveResult(.success(())) }
                .catch { error in
                    return .just(.setSaveResult(.failure(error)))
                }
            
            return .concat(
                .just(.setSaving(true)),
                saveTask,
                .just(.setSaving(false))
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setContent(let content):
            newState.content = content
        case .setSaving(let isSaving):
            newState.isSaving = isSaving
        case .setSaveResult(let result):
            newState.saveResult = result
        }
        
        return newState
    }
    
}

extension WriteReactor {
    
    struct State {
        var content: String = ""
        var isSaving: Bool = false
        var saveResult: Result<Void, Error>? = nil
    }
    
    enum Action {
        case updateContent(String)
        case saveButtonTapped
    }
    
    enum Mutation {
        case setContent(String)
        case setSaving(Bool)
        case setSaveResult(Result<Void, Error>)
    }
    
}
