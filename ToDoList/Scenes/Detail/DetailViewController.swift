//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Serkan Bekir on 9.12.2020.
//

import UIKit

protocol DetailViewControllerProtocol: class {
    ///
    ///Show error to user if something went wrong.
    ///
    func showError(error: CustomError)
}

class DetailViewController: UIViewController {

    // MARK: Constants {

    private enum Constants {
        static let save = "Save"
        static let update = "Update"
        static let done = "Done"
        static let error = "Error"
        static let okTitle = "OK"
    }

    // MARK: Outlets

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subTitleTextField: UITextField!
    @IBOutlet weak var priorityTextField: UITextField!
    @IBOutlet weak var saveUpdateButton: UIButton!
    
    // MARK: Dependencies
    
    private var presenter: DetailPresenterProtocol!

    // MARK: Properties

    var todoModel: Todo?
    let priorityPickerView = UIPickerView()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        injectDependencies()
        configurePickerView()
        setInitialValues()
        setButtonTitle()
    }

    // MARK: Configurations

    private func injectDependencies() {
        presenter = DetailPresenter(viewController: self)
    }

    private func setInitialValues() {
        titleTextField.text = todoModel?.title
        subTitleTextField.text = todoModel?.subTitle

        let priorityIndex = Int(todoModel?.priority ?? 0)
        let priority = PriorityType(rawValue: priorityIndex)
        priorityTextField.text = priority?.pickerValue
        priorityPickerView.selectRow(priorityIndex, inComponent: 0, animated: true)
    }

    private func configurePickerView() {
        priorityPickerView.delegate = self
        priorityPickerView.dataSource = self
        priorityTextField.inputView = priorityPickerView
        configureToolBar()
    }

    private func configureToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: Constants.done, style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneTapped))
        toolBar.setItems([spaceButton, doneButton], animated: false)
        priorityTextField.inputAccessoryView = toolBar
    }

    private func setButtonTitle() {
        saveUpdateButton.setTitle(todoModel != nil ? Constants.update : Constants.save, for: .normal)
    }

    // MARK: Button Actions

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let pickerRow = priorityPickerView.selectedRow(inComponent: 0)
        if let todoModel = todoModel {
            todoModel.title = titleTextField.text ?? ""
            todoModel.subTitle = subTitleTextField.text ?? ""
            todoModel.priority = Int16(pickerRow)
            presenter.updateCoreData()
        } else {
            let priority = PriorityType(rawValue: pickerRow)
            presenter.saveCoreData(title: titleTextField.text, subTitle: subTitleTextField.text, priority: priority ?? .low)
        }
        navigationController?.popViewController(animated: true)
    }

    @objc func doneTapped() {
        let row = priorityPickerView.selectedRow(inComponent: 0)
        priorityTextField.text = PriorityType.allCases[row].pickerValue
        priorityTextField.resignFirstResponder()
    }
}

extension DetailViewController: DetailViewControllerProtocol {

    func showError(error: CustomError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Constants.error, message: error.rawValue, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Constants.okTitle, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension DetailViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PriorityType.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PriorityType.allCases[row].pickerValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priorityTextField.text = PriorityType.allCases[row].pickerValue
    }
}
