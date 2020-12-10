//
//  ListPresenter.swift
//  ToDoList
//
//  Created by Serkan Bekir on 9.12.2020.
//

import Foundation

protocol ListPresenterProtocol {
    ///
    /// Saves corresponding variables to core data.
    /// - parameters:
    ///     * title: Title of the to do item
    ///     * subTitle: Subtitle of the to do item
    ///     * priority: Priority of the to do item; can be low, medium or high.
    ///
    func saveToCoreData(title: String?, subTitle: String?, priority: PriorityType)
    ///
    /// Deletes corresponding variables from core data.
    /// - parameters:
    ///     * index: Index of the item
    ///
    func deleteFromCoreData(index: Int)
    ///
    /// Fetch all entity from core data.
    ///
    func fetchFromCoreData()
    ///
    /// Todo item count
    ///
    func numberOfRows() -> Int
    ///
    /// Item at index
    ///
    func getItem(at index: Int) -> ItemModel?
    ///
    /// TodoModel at index
    ///
    func getTodoModel(at index: Int) -> Todo?
}

class ListPresenter: Presenter {
    
    // MARK: - Dependencies
    
    private weak var viewController: ListViewControllerProtocol!

    // MARK: - Properties

    private var todos: [Todo]?
    
    // MARK: - Initializers
    
    convenience init(viewController: ListViewControllerProtocol, coreDataService: CoreDataServiceProtocol = CoreDataService()) {
        self.init(coreDataService: coreDataService)
        
        self.viewController = viewController
    }
}

extension ListPresenter: ListPresenterProtocol {

    func getTodoModel(at index: Int) -> Todo? {
        return self.todos?[index]
    }

    func deleteFromCoreData(index: Int) {
        guard let todoModel = self.todos?[index] else { return }
    
        coreDataService.deleteItem(todoModel: todoModel) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let message):
                print(message)
                self.fetchFromCoreData()
            case .failure(let error):
                self.viewController.showError(error: error)
            }
        }
    }

    func getItem(at index: Int) -> ItemModel? {
        guard let todos = todos else { return nil }

        return ItemModel(title: todos[index].title ?? "", subTitle: todos[index].subTitle ?? "", priority: PriorityType(rawValue: Int(todos[index].priority)))
    }

    func numberOfRows() -> Int {
        return self.todos?.count ?? 0
    }
    
    func saveToCoreData(title: String?, subTitle: String?, priority: PriorityType) {
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
    
    func fetchFromCoreData() {
        coreDataService.getItems { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let todos):
                self.todos = todos
                self.viewController.reloadData()
            case .failure(let error):
                self.viewController.showError(error: error)
            }
        }
    }
}
