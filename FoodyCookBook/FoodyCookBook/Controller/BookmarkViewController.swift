//
//  BookmarkViewController.swift
//  FoodyCookBook
//
//  Created by Tim on 27/06/2021.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    let isHome = UserDefaults.standard.bool(forKey: "isHome")
    let isSearch = UserDefaults.standard.bool(forKey: "isSearch")
    let isSaved = UserDefaults.standard.bool(forKey: "isSaved")
    
    var savedDataArray: [Meals?] = []
    var bookMarkedFoodArray: [Meals?] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(isHome, isSearch, isSaved, "<<<<<>")
        setupCachedData()
        setuoBookmarkTableView()
    }
    
    func setuoBookmarkTableView() {
        bookmarkTableView.register(UINib(nibName: SearchTableViewCell().identifier, bundle: nil), forCellReuseIdentifier: SearchTableViewCell().identifier)
    }
    
    func setupCachedData() {
        do {
             bookMarkedFoodArray = try UserDefaults.standard.getObject(forKey: "savedFood", castTo: [Meals?].self)
            bookMarkedFoodArray.removeLast()
            print(type(of: bookMarkedFoodArray), "skjbhvc")
            savedDataArray = bookMarkedFoodArray.reversed()
            bookmarkTableView.reloadData()
        } catch {
            print(error.localizedDescription, "localizdError2")
        }
    }
}


extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SearchTableViewCell?  = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell().identifier, for: indexPath) as? SearchTableViewCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed(SearchTableViewCell().identifier, owner: self, options: nil)?.first as? SearchTableViewCell
        }
        cell?.food = savedDataArray[indexPath.row]
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
        UserDefaults.standard.set(true, forKey: "isSaved")
        UserDefaults.standard.set(false, forKey: "isHome")
        UserDefaults.standard.set(false, forKey: "isSearch")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailedVc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        detailedVc.detailMeal = savedDataArray[indexPath.row]
        self.navigationController?.pushViewController(detailedVc, animated: true)
    }
}
