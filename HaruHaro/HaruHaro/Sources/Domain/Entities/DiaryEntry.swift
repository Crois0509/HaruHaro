//
//  DiaryEntry.swift
//  HaruHaro
//
//  Created by 장상경 on 10/15/25.
//

import Foundation

/// 데이터 저장 및 관리를 위한 기본 엔티티 (Domain Model)
struct DiaryEntry {
    let id: UUID
    let date: Date
    let content: String
}
