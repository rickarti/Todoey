//
//  ViewController.swift
//  Todoey
//
//  Created by Richard Johnson on 9/3/19.
//  Copyright © 2019 Richard Johnson. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        print(dataFilePath!)
    }
    
    //MARK - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }

    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.cellForRow(at: indexPath)?.accessoryType =
            tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark ? .none : .checkmark
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add Button Items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        var textField : UITextField?
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when we press add
            
            let newItem = Item(context: self.context)
            newItem.title = textField!.text!
            newItem.parentCategory = self.selectedCategory
            newItem.done = false
            self.itemArray.append(newItem)

            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        print("loadItems called")
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let passedPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, passedPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
}

extension TodoListViewController: UISearchBarDelegate {
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//
//        // select from Item
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        // where title like...
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@",  searchBar.text!)
//        //sorted ascending
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request)
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searching...")
        // select from Item
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // where title like...
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@",  searchBar.text!)
        //sorted ascending
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchBar textDidChange")
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

