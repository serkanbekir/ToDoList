//
//  Presenter.swift
//  ToDoList
//
//  Created by Serkan Bekir on 9.12.2020.
//

import Foundation

protocol PresenterProtocol {
    
}

class Presenter {
    
    // MARK: - Properties
    
    let coreDataService: CoreDataServiceProtocol
    
    // MARK: - Initializers
    
    init(coreDataService: CoreDataServiceProtocol = CoreDataService()) {
        self.coreDataService = coreDataService
    }
}

extension Presenter: PresenterProtocol {
    
}
