//
//  gallaryChooserTableViewController.swift
//  image gallary
//
//  Created by Moutaz_Hegazy on 6/7/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import UIKit

class gallaryChooserTableViewController: UITableViewController
{
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != UISplitViewController.DisplayMode.primaryOverlay{
            splitViewController?.preferredDisplayMode = UISplitViewController.DisplayMode.primaryOverlay
        }
    }

    var imagesGallaries = [tableViewModel]()
    
    var recentlyDeleted = [tableViewModel]()
    
    // MARK: - Table view data source
    @IBAction func addNewGallary(_ sender: UIBarButtonItem) {
        
        var newGallary = tableViewModel()
        newGallary.title = "Untitled \(newNumber.getNew())"
        
        imagesGallaries += [newGallary]
        tableView.reloadData()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if recentlyDeleted.count > 0{
            return 2
        }else{
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return imagesGallaries.count
        }else{
            return recentlyDeleted.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gallaryCell", for: indexPath)

        if let gallaryCell = cell as? gallaryTableViewCell{
            if indexPath.section == 0{
                gallaryCell.titleLabel?.text = imagesGallaries[indexPath.row].title
                
                let doubleTap = UITapGestureRecognizer(target: gallaryCell, action: #selector(gallaryCell.editCellTitle(_:)))
                doubleTap.numberOfTapsRequired = 2
                gallaryCell.addGestureRecognizer(doubleTap)
                
                gallaryCell.editTitle = {
                    [weak self ](cell) in
                    
                    if let indexPath = self!.tableView.indexPath(for: cell) , let text = cell.textField.text
                    {
                        print("wezza : \(self!.imagesGallaries[indexPath.row].title)")
                        if indexPath.section == 0{
                            self?.imagesGallaries[indexPath.row].title = text
                        }else{
                            self?.recentlyDeleted[indexPath.row].title = text
                        }
                    }
                    cell.textField.isHidden = true
                    cell.titleLabel.isHidden = false
                    
                    tableView.reloadData()
                }
                
                let singleTap = UITapGestureRecognizer(target: self, action: #selector(configureTapAction(_:)))
                singleTap.numberOfTapsRequired = 1
                gallaryCell.addGestureRecognizer(singleTap)
                
            }else{
                gallaryCell.titleLabel?.text = recentlyDeleted[indexPath.row].title
            }
        }

        return cell
    }
    
    @objc func configureTapAction(_ tap: UITapGestureRecognizer){

        switch tap.state{
        case .ended :
            let location = tap.location(in: tableView)
            
            if let indexPath = tableView.indexPathForRow(at: location) ,
                let cell = tableView.cellForRow(at: indexPath) as? gallaryTableViewCell , indexPath.section == 0
            {
                print("wezza : trying to segue")
                performSegue(withIdentifier: "openGallary", sender: cell)
            }
            
            
        default : break
        }
    }
 
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let view = tableViewCustomHeader()
            view.headerLabel.text = "current gallaries"
            return view
        }else{
            let view = tableViewCustomHeader()
            view.headerLabel.text = "recently deleted"
            return view
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0{
                let cellModel = imagesGallaries[indexPath.row]
                imagesGallaries.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                recentlyDeleted += [cellModel]
                tableView.reloadData()
            }else{
                recentlyDeleted.remove(at: indexPath.row)
                if recentlyDeleted.count == 0{
                    tableView.reloadData()
                }else{
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            return nil
        }else{
            let action = UIContextualAction(style: .normal, title: "Undelete") { [weak self](action, view, handler) in
                
                let cellModel = self?.recentlyDeleted[indexPath.row]
                
                self?.recentlyDeleted.remove(at: indexPath.row)
                self?.imagesGallaries += [cellModel!]
                
                self?.tableView.reloadData()
            }
            action.backgroundColor = .green
            
            let swipe = UISwipeActionsConfiguration(actions: [action])
            
            return swipe
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
        
        print("wezza : iam in prepare for segue!")
        
        if let cell = sender as? gallaryTableViewCell ,
            let indexPath = tableView.indexPath(for: cell){
            print("wezza : iam in prepare for segue!")
            if segue.identifier == "openGallary"{
                if indexPath.section == 0 ,
                    let collectionVC = segue.destination.contents as? imageGallaryCollectionViewController
                {
                    collectionVC.imageURLs = imagesGallaries[indexPath.row].imageObjects
                    collectionVC.title = imagesGallaries[indexPath.row].title
                    collectionVC.sendURLsBack = {
                        [weak self, unowned collectionVC] in
                        self?.imagesGallaries[indexPath.row].imageObjects = collectionVC.imageURLs
                    }
                }
            }
        }
    }
}

struct newNumber {
    static var new = 0
    
    static func getNew() -> String{
        new += 1
        return String(new)
    }
}

extension UIViewController{
    
    var contents : UIViewController {
        if let navcon = self as? UINavigationController{
            return navcon.visibleViewController ?? self
        }else{
            return self
        }
    }
    
}

