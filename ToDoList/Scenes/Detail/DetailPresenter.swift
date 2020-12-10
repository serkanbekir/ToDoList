//
//  DetailPresenter.swift
//  ToDoList
//
//  Created by Serkan Bekir on 9.12.2020.
//

import Foundation

protocol DetailPresenterProtocol {
    ///
    /// Saves corresponding variables to core data.
    /// - parameters:
    ///     * title: Title of the to do item
    ///     * subTitle: Subtitle of the to do item
    ///     * Priority: Priority of the to do item; can be low, medium or high.
    ///
    func saveCoreData(title: String?, subTitle: String?, priority: PriorityType)
    ///
    /// Updates corresponding variables in core data.
    ///
    func updateCoreData()
}

class DetailPresenter: Presenter {

    // MARK: - Dependencies
    
    private weak var viewController: DetailViewControllerProtocol!
    
    // MARK: - Initializers
    
    convenience init(viewController: DetailViewControllerProtocol, coreDataService: CoreDataServiceProtocol = CoreDataService()) {
        self.init(coreDataService: coreDataService)
        
        self.viewController = viewController
    }
}

extension DetailPresenter: DetailPresenterProtocol {

    func updateCoreData() {
        coreDataService.updateItem() { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let message):
                print(message)
            case .failure(let error):
                self.viewController.showError(error: error)
            }
        }
    }

    func saveCoreData(title: String?, subTitle: String?, priority: PriorityType) {
        guard let title = title, let subTitle = subTitle else { return }

        let itemModel = ItemModel(title: title, subTitle: subTitle, priority: priority)
        coreDataService.saveItem(itemModel: itemModel) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                print(message)
            case .failure(let error):
                self.viewController.showError(error: error)
            }
        }
    }
}
