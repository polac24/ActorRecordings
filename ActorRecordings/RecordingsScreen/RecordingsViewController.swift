//
//  RecordingsViewController.swift
//  ActorRecordings
//
//  Created by Bartosz Polaczyk on 31/07/2018.
//  Copyright © 2018 Bartosz Polaczyk. All rights reserved.
//

import UIKit

protocol RecordingsViewControllerable:class {
    var title: String? {get set}
    func setValues(_ :[RecordingsTableDelegate.DataType])
}


class RecordingsViewController: UIViewController, RecordingsViewControllerable {
    func setValues(_ paths: [RecordingsTableDelegate.DataType]) {
        dataType.paths = paths
        tableView.reloadData()
    }
    
    var delegateActor:AnyActorDriver<RecordingsScreen.Message>?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataType: RecordingsTableDelegate!
    @IBOutlet var searchItem: UIBarButtonItem!
    @IBOutlet var addItem: UIBarButtonItem!

    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = addItem
        navigationItem.leftBarButtonItem = searchItem
    }
    
    @IBAction func tap(_ sender: Any) {
        let action:RecordingsScreen.Message.UserInput?
        switch (sender as? NSObject) {
        case addItem:
            action = .tappedAdd
        case searchItem:
            action = .tappedSearch
        default:
            action = nil
        }
        guard let actionInput = action else {
            return
        }
        delegateActor?(.userInputEvent(actionInput))
    }
}
