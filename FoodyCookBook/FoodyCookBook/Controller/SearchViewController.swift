//
//  SearchViewController.swift
//  FoodyCookBook
//
//  Created by Tim on 26/06/2021.
//

import UIKit

class SearchViewController: UIViewController, SearchFoodProtocols {
    func getFood(food: Food?) {
        DispatchQueue.main.async { [self] in
            searchFoodArray = food?.meals ?? [Meals]()
            loadingLblParentView.isHidden = true
            searchResultTableView.reloadData()
        }
    }
    
    @IBOutlet weak var textFieldParentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var loadingLblParentView: UIView!
    
    
    let isHome = UserDefaults.standard.bool(forKey: "isHome")
    let isSearch = UserDefaults.standard.bool(forKey: "isSearch")
    let isSaved = UserDefaults.standard.bool(forKey: "isSaved")
    
    var searchFoodArray: [Meals?] = []
    var backupSearchFoodArray: [Meals?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldParentView()
        setupSearchResultTableView()
        setupServerLoader(text: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(isHome, isSearch, isSaved, "<<<<<>")
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupServerLoader(text: String){
        let foodLoader = DataService()
        foodLoader.searchDelegate = self
        foodLoader.loadSearchData(query: text)
    }
    
    func setupSearchResultTableView() {
        searchResultTableView.register(UINib(nibName: SearchTableViewCell().identifier, bundle: nil), forCellReuseIdentifier: SearchTableViewCell().identifier)
    }
    
    func setupTextFieldParentView() {
        textFieldParentView.layer.cornerRadius = 20
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.backgroundColor = .systemBackground
        bar.setItems([flexibleSpace, done], animated: false)
        bar.tintColor = .label
        bar.sizeToFit()
        textField.inputAccessoryView = bar
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func doneTapped() {
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        loadingLblParentView.isHidden = false
        guard let text = textField.text?.lowercased() else { return  }
        setupServerLoader(text: text)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFoodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SearchTableViewCell?  = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell().identifier, for: indexPath) as? SearchTableViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed(SearchTableViewCell().identifier, owner: self, options: nil)?.first as? SearchTableViewCell
        }
        cell?.food = searchFoodArray[indexPath.row]
        cell?.selectionStyle = .none
        cell?.preservesSuperviewLayoutMargins = false
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(true, forKey: "isSearch")
        UserDefaults.standard.set(false, forKey: "isSaved")
        UserDefaults.standard.set(false, forKey: "isHome")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailedVc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        detailedVc.detailMeal = searchFoodArray[indexPath.row]
        self.navigationController?.pushViewController(detailedVc, animated: true)
    }
}

