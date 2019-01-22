//
//  CategoryViewController.swift
//  Todoet
//
//  Created by KirillGladkov on 1/13/19.
//  Copyright © 2019 KirillGladkov. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    var dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }
    
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories?[indexPath.row]
        let bgColor = category?.bgColor
        
        guard let categoryColor = UIColor(hexString: bgColor!) else { fatalError("Category color error") }
        
        cell.textLabel?.text = category?.name ?? "No Categories Added Yet"
        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    // MARK: - Data Manipulation Methods
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error in saving categories \(error)")
        }
        
        tableView.reloadData()
    }

    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDelete = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDelete)
                }
            } catch {
                print("Error on deleting category item \(error)")
            }
        
        }
    }
    
    // MARK: - Add New Categories Method
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var localTextField = UITextField()
        
        let alert = UIAlertController(title: "Create Category", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let addAction = UIAlertAction(title: "Create", style: .default) { (action) in
            
            if localTextField.text != "" {
                let newCategory = Category()
                newCategory.name = localTextField.text!
                newCategory.bgColor = UIColor.randomFlat.hexValue()
                
                self.save(category: newCategory)
            }
        }
        
        alert.addTextField { (alerttextField) in
            localTextField = alerttextField
            localTextField.placeholder = "Category name..."
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    


}

