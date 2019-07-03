//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Frank Mortensen on 02/07/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (
        UIApplication.shared.delegate as! AppDelegate
    ).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    // MARK: -- TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: -- Data Manipulation Methods
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching categories from context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func saveCategories() {
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: -- Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(
            title: "Add new category",
            message: "",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text!.count > 0 {
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                
                self.categories.append(newCategory)
                self.saveCategories()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: -- TableView Delegate Methods
    
    
    
}
