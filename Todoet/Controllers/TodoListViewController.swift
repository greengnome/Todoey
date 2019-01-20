//
//  ViewController.swift
//  Todoet
//
//  Created by KirillGladkov on 12/16/18.
//  Copyright © 2018 KirillGladkov. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    let realm = try! Realm()
    
    var todos: Results<TodoItem>?
    var dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var selectedCategory : Category? {
        didSet {
            loadTodos()
            navigationItem.title = selectedCategory?.value(forKey: "name") as? String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }

    // MARK - Table View DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let todoItem = todos?[indexPath.row] {
            cell.textLabel?.text = todoItem.title
            cell.accessoryType = todoItem.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No TodoItems Added"
        }
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 1
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let todoItem = todos?[indexPath.row] {
            do {
                try realm.write {
                    todoItem.done = !todoItem.done
                }
            } catch {
                print("Error in updateing Todo Item \(error)")
            }
        }
        
        tableView.reloadData();

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK -  Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var localTextField = UITextField()
        
        let alert = UIAlertController(title: "Create Item", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Create", style: .default) { (action) in
            

            if localTextField.text != "" {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newTodoItem = TodoItem()
                            newTodoItem.title = localTextField.text!
                            newTodoItem.dateCreated = Date()
                            currentCategory.items.append(newTodoItem)
                        }
                    } catch {
                        print("Error in saveng new todoItem \(error)")
                    }
                }

                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addTextField { (alertTextField) in
            localTextField = alertTextField
            localTextField.placeholder = "Enter your`s task here..."
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK - Model manipiulation methods
    func loadTodos() {
        todos = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}

// MARK: Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todos = todos?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTodos()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
