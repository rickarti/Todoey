//
//  ViewController.swift
//  Todoey
//
//  Created by Richard Johnson on 9/3/19.
//  Copyright © 2019 Richard Johnson. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Dogs", "Cats", "Mice"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items: [String] = self.defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }
    
    //MARK - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

    // MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add Button Items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        var textField : UITextField?
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when we press add
            
            self.itemArray.append(textField!.text!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
            print("Success")
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

