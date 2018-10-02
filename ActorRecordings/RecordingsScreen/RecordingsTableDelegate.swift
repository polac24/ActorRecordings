//
//  RecordingsTableDelegate.swift
//  ActorRecordings
//
//  Created by Bartosz Polaczyk on 31/07/2018.
//  Copyright © 2018 Bartosz Polaczyk. All rights reserved.
//

import UIKit

class RecordingsTableDelegate: NSObject, UITableViewDataSource {
    typealias DataType = String
    var paths:[DataType] = []

    override init() {
        super.init()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "test") ?? UITableViewCell()
        cell.textLabel?.text = paths[indexPath.row]
        return cell
    }
    

}
