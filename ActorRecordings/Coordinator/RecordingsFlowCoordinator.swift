//
//  RecordingsFlowCoordinator.swift
//  ActorRecordings
//
//  Created by Bartosz Polaczyk on 01/08/2018.
//  Copyright © 2018 Bartosz Polaczyk. All rights reserved.
//
import UIKit

protocol RecordingsFlowCoordinatorable{
    func presentSearch()
    func presentAddSelection(feedback: @escaping AnyActorDriver<RecordingsScreen.Message>)
    func presentAdd(type: RecordingsScreen.Command.AddType, feedback: @escaping AnyActorDriver<RecordingsScreen.Message>)
}

class RecordingsFlowCoordinator:RecordingsFlowCoordinatorable {
    
    private(set) var root = UINavigationController()
    
    init(){
        root.viewControllers = [buildRecordingsVC()]
    }
    
    private func buildRecordingsVC() -> UIViewController{
        let vc = RecordingsViewController()
        let ex = RecordingsScreen.Externals(folder: FileManager.default, vc: vc, flowCoordinator: self)
        let driver = UIActorDriver(actor: RecordingsScreen.Actor.starting, externals: ex)
        vc.delegateActor = driver.send
        
        driver.send(.initialize(title: "Hello"))

        return vc
    }
    
    private func buildSearchVC() -> UIViewController{
        let vc = SearchViewController()
        let ex = SearchScreen.Externals()
        let driver = UIActorDriver(actor: SearchScreen.Actor.initial, externals: ex)
        vc.delegateActor = driver.send
        
        return vc
    }
    
    private func buildAddVC(feedback: @escaping AnyActorDriver<RecordingsScreen.Message>) -> UIViewController{
        let vc = UIAlertController(title: "Create new:", message: nil, preferredStyle: .actionSheet)
        let directory = UIAlertAction(title: "Directory", style: .default) { (action) in
            feedback(.directoryCreationIntent)
        }
        let file = UIAlertAction(title: "File", style: .default) { (action) in
            feedback(.fileCreationIntent)
        }
        let cancel = UIAlertAction(title: "Canel", style: .cancel) { _ in }
        vc.addAction(directory)
        vc.addAction(file)
        vc.addAction(cancel)
        return vc
    }
    
    private func buildAddVC(_ type: RecordingsScreen.Command.AddType, feedback: @escaping AnyActorDriver<RecordingsScreen.Message>) -> UIViewController{
        let vc = UIAlertController(title: "Create new", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            guard let name = vc.textFields?.first?.text, !name.isEmpty else {
                return;
            }
            feedback(.createItem(type, name))
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        vc.addAction(ok)
        vc.addAction(cancel)
        vc.addTextField(configurationHandler: nil)
        return vc
    }
    
    func presentSearch() {
        root.pushViewController(buildSearchVC(), animated: true)
    }
    func presentAddSelection(feedback: @escaping AnyActorDriver<RecordingsScreen.Message>) {
        root.present(buildAddVC(feedback: feedback), animated: true, completion: nil)
    }
    func presentAdd(type: RecordingsScreen.Command.AddType, feedback: @escaping AnyActorDriver<RecordingsScreen.Message>) {
        root.present(buildAddVC(type, feedback: feedback), animated: true, completion: nil)
    }
}
