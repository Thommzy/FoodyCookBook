//
//  IngredientTableViewCell.swift
//  FoodyCookBook
//
//  Created by Tim on 26/06/2021.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    let identifier = String(describing: IngredientTableViewCell.self)
    
    @IBOutlet weak var ingriedientLbl: UILabel!
    @IBOutlet weak var measureLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var data: (String?, String?) {
        didSet {
                ingriedientLbl?.text = data.0
                measureLbl?.text = data.1
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
