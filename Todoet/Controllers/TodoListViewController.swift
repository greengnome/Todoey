//
//  ViewController.swift
//  Todoet
//
//  Created by KirillGladkov on 12/16/18.
//  Copyright © 2018 KirillGladkov. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var todos = [TodoItem]()
    var dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var selectedCategory : Category? {
        didSet {
            loadTodos()
            navigationItem.title = selectedCategory?.name
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }

    // MARK - Table View DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = todos[indexPath.row].title
        cell.accessoryType = todos[indexPath.row].done ? .checkmark : .none
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = todos[indexPath.row]
        selectedItem.done = !selectedItem.done
        
        saveTodos()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK -  Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var localTextField = UITextField()
        
        let alert = UIAlertController(title: "Create Item", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Create", style: .default) { (action) in
            

            if(localTextField.text != "") {
                let newTodoItem = TodoItem(context: self.context)
                newTodoItem.title = localTextField.text!
                newTodoItem.done = false
                newTodoItem.parentCategory = self.selectedCategory
                self.todos.append(newTodoItem)
                
                self.saveTodos()
                
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
    func saveTodos() {
        do {
            try context.save()
        } catch {
            print("-----Error in saving context ----- \(error)")
        }
        
        tableView.reloadData()

    }
    
    func loadTodos(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            let compaundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
            request.predicate = compaundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            todos =  try context.fetch(request)
        } catch {
            print("Fetching data error \(error)")
        }
        
        tableView.reloadData()
    }
    
}

// MARK: Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        if searchBar.text!.count > 0 {
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadTodos(with: request, predicate: predicate)
        }
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
