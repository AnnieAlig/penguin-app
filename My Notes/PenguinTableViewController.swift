//
//  PenguinTableViewController.swift
//  My Notes
//
//  Created by Mac User on 19.04.2018.
//  Copyright © 2018 Annie Alig. All rights reserved.
//

import UIKit
import os.log

class PenguinTableViewController: UITableViewController {

    //MARK: Properties
    
    var penguins = [Penguin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use  the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        //Load any saved penguins, otherwise load sample data.
        if let savedPenguins = loadPenguins() {
            penguins += savedPenguins
        } else{
            //Load sample data.
            loadSamplePenguins()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return penguins.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PenguinTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PenguinTableViewCell else{
            fatalError("The desqueued cell is not an instance of PenguinTableViewCell.")
        }

        //Fetches the approproate penguin for the dara source layout.
        let penguin = penguins[indexPath.row]
        
        cell.nameLabel.text = penguin.name
        cell.photoImageView.image = penguin.photo
        cell.ratingControl.rating = penguin.rating

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            penguins.remove(at: indexPath.row)
            savePenguins()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new penguin", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let penguinDetailViewController = segue.destination as? PenguinViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedPenguinCell = sender as? PenguinTableViewCell else{
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedPenguinCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedPenguin = penguins[indexPath.row]
            penguinDetailViewController.penguin = selectedPenguin
            
        default:
            fatalError("Unexpected Segue Identifier: \(segue.identifier ?? "")")
        }
        
    }
    
    
    //MARK: Actions
    
    @IBAction func unwindToPenguinsList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? PenguinViewController, let penguin = sourceViewController.penguin {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Update an existing penguin.
                penguins[selectedIndexPath.row] = penguin
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else{
                //Add new penguin.
                let newIndexPath = IndexPath(row: penguins.count, section: 0)
                
                penguins.append(penguin)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            //Save the penguins.
            savePenguins()
        }
    }
    
    
    //MARK: Private Methods
    
    private func loadSamplePenguins() {
        let photo1 = UIImage(named: "penguin1")
        let photo2 = UIImage(named: "penguin2")
        let photo3 = UIImage(named: "penguin3")
        
        guard let penguin1 = Penguin(name:"Doris", photo: photo1, rating: 2) else{
            fatalError("Unable to instantiate penguin1")
        }
        guard let penguin2 = Penguin(name:"Roy", photo: photo2, rating: 5) else{
            fatalError("Unable to instantiate penguin2")
        }
        guard let penguin3 = Penguin(name:"Meryl", photo: photo3, rating: 3) else{
            fatalError("Unable to instantiate penguin3")
        }
        
        penguins += [penguin1, penguin2, penguin3]
    }
    
    private func savePenguins() {
        let isSuccessfullySave = NSKeyedArchiver.archiveRootObject(penguins, toFile: Penguin.ArchiveUrl.path)
        
        if isSuccessfullySave {
            os_log("Penguins successfully saved.", log: OSLog.default, type: .debug)
        } else{
            os_log("Failed to save penguins...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadPenguins() -> [Penguin]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Penguin.ArchiveUrl.path) as? [Penguin]
    }

}
