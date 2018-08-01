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
}

class RecordingsFlowCoordinator:RecordingsFlowCoordinatorable {
    
    private(set) var root = UINavigationController()
    
    init(){
        root.viewControllers = [buildRecordingsVC()]
    }
    
    private func buildRecordingsVC() -> UIViewController{
        let vc = RecordingsViewController()
        let ex = RecordingsScreen.Externals(folder: FileManager.default, vc: vc, flowCoordinator: self)
        let driver = UIActorDriver(actor: RecordingsScreen.Actor.initial, externals: ex)
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
    
    func presentSearch(){
        root.pushViewController(buildSearchVC(), animated: true)
    }
}
