//
//  ViewController.swift
//  Todoet
//
//  Created by KirillGladkov on 12/16/18.
//  Copyright © 2018 KirillGladkov. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var todos = [TodoItem]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todos.append(TodoItem(text: "First"))
        todos.append(TodoItem(text: "Second"))
        todos.append(TodoItem(text: "Third"))
        
        if let items = defaults.array(forKey: "Todos") as? [TodoItem] {
            todos = items
        }
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
//        let accessoryTypeVal = tableView.cellForRow(at: indexPath)?.accessoryType
        let selectedItem = todos[indexPath.row]
        selectedItem.done = !selectedItem.done
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK -  Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var localTextField = UITextField()

        let alert = UIAlertController(title: "Create New Todoey", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if(localTextField.text != "") {
                let newTodoItem = TodoItem(text: localTextField.text!)
                self.todos.append(newTodoItem)
                
                self.defaults.set(self.todos, forKey: "Todos")
                
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addTextField { (alertTextField) in
            localTextField = alertTextField
            localTextField.placeholder = "Enter your`s task here..."
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    

}
