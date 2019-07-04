//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Frank Mortensen on 02/07/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        loadCategories()
        
    }
    
    // MARK: -- TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
        
    }
    
    
    // MARK: -- TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if  let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: -- Data Manipulation Methods
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: -- Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(
            title: "Add New Category",
            message: "",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (field) in
            field.placeholder = "Add a new category"
            textField = field
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}
