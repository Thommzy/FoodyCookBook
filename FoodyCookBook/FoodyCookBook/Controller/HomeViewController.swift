//
//  HomeViewController.swift
//  FoodyCookBook
//
//  Created by Tim on 26/06/2021.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var instructionsLbl: UILabel!
    @IBOutlet weak var mealLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var tbvConst: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    var dataArray: [(String?, String?)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIngredientTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupServerLoader()
        addTableviewOberver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeTableviewObserver()
    }
    
    func setupIngredientTableView() {
        ingredientTableView.register(UINib(nibName: IngredientTableViewCell().identifier, bundle: nil), forCellReuseIdentifier: IngredientTableViewCell().identifier)
    }
    
    func setupServerLoader(){
        let foodLoader = DataService()
        foodLoader.delegate = self
        foodLoader.loadData()
    }
}

