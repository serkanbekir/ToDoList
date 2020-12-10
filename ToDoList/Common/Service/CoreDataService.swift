//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Serkan Bekir on 9.12.2020.
//

import UIKit
import CoreData

protocol CoreDataServiceProtocol {

    func getItems(complition: @escaping (Result<[Todo], CustomError>) -> Void)
    func saveItem(itemModel: ItemModel, complition: @escaping (Result<String, CustomError>) -> Void)
    func deleteItem(todoModel: Todo, complition: @escaping (Result<String, CustomError>) -> Void)
    func updateItem(complition: @escaping (Result<String, CustomError>) -> Void)
}

class CoreDataService: CoreDataServiceProtocol {

    private enum Constants {
        static let successSave = "Item saved successfully."
        static let successDelete = "Item deleted successfully."
        static let successUpdate = "Item updated successfully."
    }

    func getItems(complition: @escaping (Result<[Todo], CustomError>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            complition(.failure(.appDelegateError))
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            let todos: [Todo] = try managedContext.fetch(Todo.fetchRequest())
            complition(.success(todos))
          } catch {
            complition(.failure(.fetchError))
          }
    }

    func saveItem(itemModel: ItemModel, complition: @escaping (Result<String, CustomError>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            complition(.failure(.appDelegateError))
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let newItem = Todo(context: managedContext)
        newItem.title = itemModel.title
        newItem.subTitle = itemModel.subTitle
        newItem.priority = Int16(itemModel.priority?.rawValue ?? 0)

        do {
            try managedContext.save()
            complition(.success(Constants.successSave))
        } catch {
            complition(.failure(.saveError))
        }
    }

    func updateItem(complition: @escaping (Result<String, CustomError>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            complition(.failure(.appDelegateError))
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        do {
            try managedContext.save()
            complition(.success(Constants.successUpdate))
        } catch {
            complition(.failure(.saveError))
        }
        
    }

    func deleteItem(todoModel: Todo, complition: @escaping (Result<String, CustomError>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            complition(.failure(.appDelegateError))
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        managedContext.delete(todoModel)

        do {
            try managedContext.save()
            complition(.success(Constants.successDelete))
        } catch {
            complition(.failure(.saveError))
        }
    }
}
