//
//  SearchViewController.swift
//  ActorRecordings
//
//  Created by Bartosz Polaczyk on 01/08/2018.
//  Copyright © 2018 Bartosz Polaczyk. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataSource: RecordingsTableDelegate!
    
    var delegateActor:AnyActorDriver<SearchScreen.Message>?

    func setValues(_ paths: [RecordingsScreen.Element]) {
        dataSource.paths = paths
        tableView.reloadData()
    }

}
