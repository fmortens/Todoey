//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Frank Mortensen on 01/07/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var items = [Item]()
    
    let context = (
        UIApplication.shared.delegate as! AppDelegate
    ).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    // MARK: Core Data methods
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            items = try context.fetch(request)
            
            tableView.reloadData()
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func saveItems() {
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    //MARK: Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if (textField.text! != "") {
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                
                self.items.append(newItem)
                
                
                self.saveItems()
            }
            
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
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].done = !items[indexPath.row].done
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - Extension Search methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
            request.predicate = NSPredicate(
                format: "title CONTAINS[cd] %@", searchBar.text!
            )
        
            request.sortDescriptors = [
                NSSortDescriptor(key: "title", ascending: true)
            ]
        
        loadItems(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }

    }
    
}

