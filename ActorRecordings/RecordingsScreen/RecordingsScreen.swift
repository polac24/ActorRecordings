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
        case userInputRefresh
        
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
        case refreshIndicator(visible: Bool)
        
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
            case .refreshIndicator(let visible):
                externals.vc.refreshIndicator(enabled: visible)
            }
        }
    }
    
    enum Actor:Actorable {
        case starting
        case initial(title:String)
        case initailizing(title:String, root:String)
        case initailized(title:String, folders:[String], root:String)
        case uninitailized(title:String, root:String)
        
        mutating func onReceive(_ message: Message) -> [Command] {
            switch(message, self){
            case (.initialize(let title),.starting):
                self = .initial(title: title)
                return [.setTitle(title: title), .getRoot]
            case (.foldersRootReady(let root), .initial(let title)):
                self = .initailizing(title: title, root: root)
                return [.fetchFolders(path: root)]
            case (.foldersReady(let paths), .initailizing(let title, let root)):
                self = .initailized(title: title, folders: paths, root: root)
                return [.presentPaths(paths: paths), .refreshIndicator(visible: false)]
            case (.userInputEvent(.tappedSearch), _):
                return [.presentSearch, .refreshIndicator(visible: false)]
            case (.userInputRefresh, .initailized(let title, _, let root)),
                 (.userInputRefresh, .uninitailized(let title, let root)):
                self = .initailizing(title: title, root: root)
                return [.fetchFolders(path: root)]
            case (.userInputRefresh, _):
                return [.refreshIndicator(visible: false)]
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
