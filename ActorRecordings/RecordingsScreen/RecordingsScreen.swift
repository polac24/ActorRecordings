//
//  RecordingsScreenActor.swift
//  ActorRecordings
//
//  Created by Bartosz Polaczyk on 31/07/2018.
//  Copyright © 2018 Bartosz Polaczyk. All rights reserved.
//

import Foundation


struct RecordingsScreen{

    enum Message:Messagable{
        case initialize(title:String)
        case foldersRootReady(path:String)
        case foldersReady(paths:[String])
        case foldersFetchError
        case userInputEvent(UserInput)
        
        enum UserInput {
            case tappedAdd
            case tappedSearch
        }
    }
    
    enum Command:Commandable{
        case setTitle(title:String)
        case getRoot
        case fetchFolders(path:String)
        case presentPaths(paths:[String])
        case presentSearch
        
        func interpret(externals: Externals, feedback: AnyActorDriver<Message>){
            switch self {
            case .getRoot:
                let urls = externals.folder.urls(for: .documentDirectory , in: FileManager.SearchPathDomainMask.allDomainsMask)
                if let url = urls.first {
                    feedback(.foldersRootReady(path: url.path))
                }else {
                    feedback(.foldersFetchError)
                }
            case .fetchFolders(let path):
                do {
                    let paths = try externals.folder.contentsOfDirectory(atPath: path)
                    feedback(.foldersReady(paths: paths))
                } catch {
                    feedback(.foldersFetchError)
                }
            case .setTitle(let title):
                externals.vc.title = title
            case .presentPaths(let paths):
                externals.vc.setValues(paths)
            case .presentSearch:
                externals.flowCoordinator.presentSearch()
            }
        }
    }
    
    enum Actor:Actorable {
        case initial
        case initailizing(title:String)
        case initailized(title:String, folders:[String])
        case uninitailized(title:String)
        
        
        mutating func onReceive(_ message: Message) -> [Command] {
            switch(message, self){
            case (.initialize(let title),.initial):
                self = .initailizing(title: title)
                return [.setTitle(title: title), .getRoot]
            case (.foldersRootReady(let root), .initailizing):
                return [.fetchFolders(path: root)]
            case (.foldersReady(let paths), .initailizing(let title)):
                self = .initailized(title: title, folders: paths)
                return [.presentPaths(paths: paths)]
            case (.userInputEvent(.tappedSearch), _):
                return [.presentSearch]
            default:
                break
            }
            return []
        }
    }
    
    struct Externals {
        let folder:FileManagerable
        let vc:RecordingsViewControllerable
        let flowCoordinator:RecordingsFlowCoordinatorable
    }
}
