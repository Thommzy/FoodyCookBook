//
//  HomeViewController+Extension.swift
//  FoodyCookBook
//
//  Created by Tim on 26/06/2021.
//

import UIKit

extension HomeViewController: FoodProtocols {
    func getFood(food: Food?) {
        
        if let foodArray = food {
            print(type(of: foodArray), "saving!!!")
            savedFoodTempContainer = foodArray.meals
            DispatchQueue.main.async { [self] in
                let meal = foodArray.meals?[0]
                IngredientArray(meal: meal)
                mealLbl.text = meal?.strMeal
                instructionsLbl.text = meal?.strInstructions
                categoryLbl.text = meal?.strCategory
                countryLbl.text = meal?.strArea
                let url = meal?.strMealThumb
                let fileUrl = URL(string: url!)!
                imageView.downloaded(from: fileUrl)
                imageView.layer.cornerRadius = 20
            }
        }
    }
}



//MARK:- Ingredient Array
extension HomeViewController {
    func IngredientArray(meal: Meals?) {
        let ingredientTuple = [(meal?.strIngredient1, meal?.strMeasure1), (meal?.strIngredient2, meal?.strMeasure2), (meal?.strIngredient3, meal?.strMeasure3), (meal?.strIngredient4, meal?.strMeasure4), (meal?.strIngredient5, meal?.strMeasure5), (meal?.strIngredient6, meal?.strMeasure6), (meal?.strIngredient7, meal?.strMeasure7), (meal?.strIngredient8, meal?.strMeasure8), (meal?.strIngredient9, meal?.strMeasure9), (meal?.strIngredient10, meal?.strMeasure10), (meal?.strIngredient11, meal?.strMeasure11), (meal?.strIngredient12, meal?.strMeasure12), (meal?.strIngredient13, meal?.strMeasure13), (meal?.strIngredient14, meal?.strMeasure14), (meal?.strIngredient15, meal?.strMeasure15), (meal?.strIngredient16, meal?.strMeasure16), (meal?.strIngredient17, meal?.strMeasure17), (meal?.strIngredient18, meal?.strMeasure18), (meal?.strIngredient19, meal?.strMeasure19), (meal?.strIngredient20, meal?.strMeasure20)]
        let filteredIngredientTuple = ingredientTuple.filter { (data) -> Bool in
            return data.0 != ""
        }
        dataArray = filteredIngredientTuple
        ingredientTableView.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: IngredientTableViewCell?  = tableView.dequeueReusableCell(withIdentifier: IngredientTableViewCell().identifier, for: indexPath) as? IngredientTableViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed(IngredientTableViewCell().identifier, owner: self, options: nil)?.first as? IngredientTableViewCell
        }
        cell?.data = dataArray[indexPath.row]
        cell?.selectionStyle = .none
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//MARK: - Tableview Observer
extension HomeViewController {
    func addTableviewOberver() {
        self.ingredientTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func removeTableviewObserver() {
        if self.ingredientTableView.observationInfo != nil {
            self.ingredientTableView.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    
    /**
     This method is used to observeValue in table view.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let obj = object as? UITableView {
            if obj == self.ingredientTableView && keyPath == "contentSize" {
                self.tbvConst.constant = self.ingredientTableView.contentSize.height
                self.view.updateConstraints()
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension HomeViewController {
    func setupSearchDetails() {
        if let detailMeal = detailMeal {
            let meal = detailMeal
            savedFoodTempContainer?.append(meal)
            IngredientArray(meal: meal)
            mealLbl.text = meal.strMeal
            instructionsLbl.text = meal.strInstructions
            categoryLbl.text = meal.strCategory
            countryLbl.text = meal.strArea
            let url = meal.strMealThumb
            let fileUrl = URL(string: url!)!
            imageView.downloaded(from: fileUrl)
            imageView.layer.cornerRadius = 20
        }
    }
}
