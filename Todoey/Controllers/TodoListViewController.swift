//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Frank Mortensen on 01/07/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    var items: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
           loadItems()
        }
    }
    
    
    // MARK: Core Data methods
    func loadItems() {
        
        items = selectedCategory?.items.sorted(
            byKeyPath: "title",
            ascending: true
        )
        
    }
    
    
    //MARK: Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(
            title: "Add New Todoey Item",
            message: "",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                    
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
}

// MARK: - Table View methods
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No item has been created yet"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
    }
    
}

// MARK: - Extension Search methods
//extension TodoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [
//            NSSortDescriptor(key: "title", ascending: true)
//        ]
//
//        loadItems(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//
//    }
//
//}

