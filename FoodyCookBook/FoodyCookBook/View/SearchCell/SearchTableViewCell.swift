//
//  SearchTableViewCell.swift
//  FoodyCookBook
//
//  Created by Tim on 26/06/2021.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    let identifier = String(describing: SearchTableViewCell.self)

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var food: Meals? {
        didSet {
            foodNameLbl.text = food?.strMeal
            let url = food?.strMealThumb
            let fileUrl = URL(string: url!)!
            foodImageView.downloaded(from: fileUrl)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
