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
            print("way!!!", food)
            searchFoodArray = food?.meals ?? [Meals]()
            searchResultTableView.reloadData()
        }
    }
    
    @IBOutlet weak var textFieldParentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    var searchFoodArray: [Meals?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldParentView()
        setupSearchResultTableView()
        
        setupServerLoader()
    }
    
    func setupServerLoader(){
        let foodLoader = DataService()
        foodLoader.searchDelegate = self
        foodLoader.loadSearchData(query: "")
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
    }
    
    @objc func doneTapped() {
        view.endEditing(true)
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
}

