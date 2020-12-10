//
//  CustomError.swift
//  ToDoList
//
//  Created by Serkan Bekir on 9.12.2020.
//

import Foundation

enum CustomError: String, Error {

    case appDelegateError = "App Delegate Error"
    case fetchError = "Could not fetch the entities"
    case saveError = "Item cannot be saved"
}
