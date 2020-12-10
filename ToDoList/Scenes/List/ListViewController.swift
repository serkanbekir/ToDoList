//
//  ListViewController.swift
//  ToDoList
//
//  Created by Serkan Bekir on 9.12.2020.
//

import UIKit

protocol ListViewControllerProtocol: class {
    ///
    /// Reloads TableView
    ///
    func reloadData()
    ///
    ///Show error to user if something went wrong.
    ///
    func showError(error: CustomError)
}

class ListViewController: UIViewController {

    // MARK: Constants

    private enum Constants {
        static let title = "To Do List"
        static let nibName = "ItemTableViewCell"
        static let storyboard = "Main"
        static let detail = "DetailViewController"
        static let delete = "Delete"
        static let error = "Error"
        static let okTitle = "OK"
    }

    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: Dependencies

    private var presenter: ListPresenterProtocol!
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Constants.title
        registerNibs()
        injectDependencies()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter.fetchFromCoreData()
    }

    // MARK: Configurations

    private func injectDependencies() {
        presenter = ListPresenter(viewController: self)
    }

    private func registerNibs() {
        tableView.register(UINib(nibName: Constants.nibName, bundle: nil), forCellReuseIdentifier: ItemTableViewCell.cellIdentifier)
    }

    // MARK: Button actions

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        guard let detailViewController = UIStoryboard(name: Constants.storyboard, bundle: nil).instantiateViewController(withIdentifier: Constants.detail) as? DetailViewController else { return }

        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ListViewController: ListViewControllerProtocol {

    func showError(error: CustomError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Constants.error, message: error.rawValue, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Constants.okTitle, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func reloadData() {
        tableView.reloadData()
    }
}

extension ListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = UIStoryboard(name: Constants.storyboard, bundle: nil).instantiateViewController(withIdentifier: Constants.detail) as? DetailViewController else { return }

        detailViewController.todoModel = presenter.getTodoModel(at: indexPath.row)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.cellIdentifier) as? ItemTableViewCell,
           let item = presenter.getItem(at: indexPath.row) {
            cell.configure(with: item)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .destructive, title: Constants.delete) { [weak self] (action, view, complitionHandler) in
            guard let self = self else { return }

            self.presenter.deleteFromCoreData(index: indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

