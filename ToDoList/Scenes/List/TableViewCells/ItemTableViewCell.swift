//
//  ItemTableViewCell.swift
//  ToDoList
//
//  Created by Serkan Bekir on 9.12.2020.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    // MARK: Cell Identifier

    static let cellIdentifier = "ItemTableViewCell"

    // MARK: Outlets

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!

    // MARK: Life Cycles
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    // MARK: Configure

    func configure(with model: ItemModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subTitle
        priorityLabel.text = model.priority?.displayValue
    }
}
