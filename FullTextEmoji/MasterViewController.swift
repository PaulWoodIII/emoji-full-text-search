//
//  MasterViewController.swift
//  FullTextEmoji
//
//  Created by Paul Wood on 10/26/16.
//  Copyright © 2016 Paul Wood. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    var emojis = [Emoji]()
    var filteredEmojis = [Emoji]()
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            return controller
        })()

        self.tableView.tableHeaderView = searchController.searchBar
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        let url = Bundle.main.url(forResource: "emojis", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        guard let emojiDict = json as? [String: Any] else {
            fatalError()
        }
        for key in emojiDict.keys {
            let dict = emojiDict[key] as! [String:Any]
            let e = Emoji(title: key, dictionary:dict)
            emojis.append(e)
        }
        print(emojis)
        
    
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = emojis[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredEmojis.count
        } else {
            return emojis.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        var object : Emoji

        if searchController.isActive {
            object = filteredEmojis[indexPath.row]
        } else {
            object = emojis[indexPath.row]
        }
        
        
        cell.textLabel!.text = object.description
        return cell
    }
    
}

extension MasterViewController : UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let text = searchController.searchBar.text ,
            text != "",
            searchController.isActive {
            filteredEmojis = emojis.filter() {
                return ($0.fts as NSString).localizedCaseInsensitiveContains(text)
            }
            print(filteredEmojis)
        }
        tableView.reloadData()
    }
}
