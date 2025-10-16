//
//  Date+Formatting.swift
//  HaruHaro
//
//  Created by 장상경 on 10/15/25.
//

import Foundation

extension Date {
    
    var formattingDateForString: String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일(E) [HH:mm]"
        return formatter.string(from: self)
    }
    
}
