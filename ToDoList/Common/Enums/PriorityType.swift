//
//  PriorityType.swift
//  ToDoList
//
//  Created by Serkan Bekir on 9.12.2020.
//

import Foundation

enum PriorityType: Int, CaseIterable {
    case low
    case medium
    case high

    var displayValue: String {
        switch self {
        case .low:
            return "!"
        case .medium:
            return "!!"
        case .high:
            return "!!!"
        }
    }

    var pickerValue: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
}
