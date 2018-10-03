//
//  RecordingsTableDelegate.swift
//  ActorRecordings
//
//  Created by Bartosz Polaczyk on 31/07/2018.
//  Copyright © 2018 Bartosz Polaczyk. All rights reserved.
//

import UIKit

class RecordingsTableDelegate: NSObject, UITableViewDataSource {
    var paths:[RecordingsScreen.Element] = []

    override init() {
        super.init()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "test") ?? UITableViewCell()
        let element = paths[indexPath.row]
        let name:String
        let dir:Bool
        switch element {
        case .dir(let n):
            dir = true
            name = n.name
        case .file(let n):
            dir = false
            name = n.name
        }
        cell.textLabel?.text = name
        cell.accessoryType = dir ? .disclosureIndicator : .none
        return cell
    }
    

}
