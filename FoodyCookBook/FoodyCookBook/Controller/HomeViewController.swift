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
    @IBOutlet weak var favBtn: UIButton!
    
    var dataArray: [(String?, String?)] = []
    let isHome = UserDefaults.standard.bool(forKey: "isHome")
    let isSearch = UserDefaults.standard.bool(forKey: "isSearch")
    let isSaved = UserDefaults.standard.bool(forKey: "isSaved")
    var isFavTapped: Bool = false
    var savedFoodTempContainer: [Meals?]? = []
    var saveFoodPermanentContainer: [Meals] = []
    
    var detailMeal: Meals?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIngredientTableView()
        setupSearchDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDefaults.standard.set(true, forKey: "isHome")
        favBtn.isSelected = false
        if isHome && !isSearch && !isSaved {
            setupServerLoader()
        }
        if !isHome && !isSearch && !isSaved {
            setupServerLoader()
        }
        if isSaved {
            favBtn.isHidden = true
        }
        addTableviewOberver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeTableviewObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDefaults.standard.set(false, forKey: "isSearch")
        UserDefaults.standard.set(true, forKey: "isHome")
        UserDefaults.standard.set(false, forKey: "isSaved")
    }
    
    
    
    func setupIngredientTableView() {
        ingredientTableView.register(UINib(nibName: IngredientTableViewCell().identifier, bundle: nil), forCellReuseIdentifier: IngredientTableViewCell().identifier)
    }
    
    func setupServerLoader(){
        let foodLoader = DataService()
        foodLoader.delegate = self
        foodLoader.loadData()
    }
    
    
    @IBAction func favBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if let unwrappedSavedFoodTempContainer = savedFoodTempContainer {
                do {
                    print(unwrappedSavedFoodTempContainer, "sknsln")
                    try UserDefaults.standard.setObject(unwrappedSavedFoodTempContainer, forKey: "savedFood")
                    var foodCacheData = try UserDefaults.standard.getObject(forKey: "savedFood", castTo: [Meals?].self)
                    foodCacheData += unwrappedSavedFoodTempContainer
                    try UserDefaults.standard.setObject(foodCacheData, forKey: "savedFood")
                    sender.isUserInteractionEnabled = false
                } catch {
                    print(error.localizedDescription, "localizdError")
                }
            }
        } else {
            sender.isUserInteractionEnabled = false
        }
    }
}



