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
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataType: RecordingsTableDelegate!

}
