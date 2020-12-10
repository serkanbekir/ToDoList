//
//  ColorStyle.swift
//  ToDoList
//
//  Created by Serkan Bekir on 9.12.2020.
//

import UIKit

enum ColorStyle: String {

    case backgroundApp = "BackgroundApp"
    case backgroundComponents = "BackgroundComponents"
    case textPrimary = "TextPrimary"
    case priority = "Priority"

    var color: UIColor {
        return UIColor(named: rawValue) ?? .black
    }
}
