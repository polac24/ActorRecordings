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
    func refreshIndicator(enabled: Bool)
}


class RecordingsViewController: UIViewController, RecordingsViewControllerable {
    func setValues(_ paths: [RecordingsTableDelegate.DataType]) {
        dataType.paths = paths
        tableView?.reloadData()
    }

    func refreshIndicator(enabled: Bool) {
        refresh.endRefreshing()
    }
    
    var delegateActor:AnyActorDriver<RecordingsScreen.Message>?
    let dataType = RecordingsTableDelegate()
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet var searchItem: UIBarButtonItem!
    @IBOutlet var addItem: UIBarButtonItem!
    private lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshEvent(_:)), for: .valueChanged)
        return refresh
    }()

    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = addItem
        navigationItem.leftBarButtonItem = searchItem
        tableView?.dataSource = dataType
        tableView?.refreshControl = refresh
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
    
    @objc private func refreshEvent(_ sender: Any) {
        delegateActor?(.userInputRefresh)
    }
}
