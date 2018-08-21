//
//  Search.swift
//  ActorRecordings
//
//  Created by Bartosz Polaczyk on 02/08/2018.
//  Copyright © 2018 Bartosz Polaczyk. All rights reserved.
//
import Foundation

extension Int:Messagable{}

class Searcher {
    
    enum Message:Messagable{
        case retrievePath(String)
        case contents([String])
        case contentError(Error)
        case exists(String, exists:Bool, isDir: Bool)
        case childResponse(Int)
    }
    
    enum Command:Commandable{
        case content(String)
        case fileExists(String)
        case retrievePath(String)
        
        func interpret(externals: Externals, feedback: @escaping AnyActorDriver<Message>){
            switch self {
            case .content(let path):
                do {
                    let contents = try externals.fileManager.contentsOfDirectory(atPath: path).compactMap({"\(path)/\($0)"})
                    feedback(.contents(contents))
                }catch{
                    feedback(.contentError(error))
                }
            case .fileExists(let path):
                var isDir : ObjCBool = false
                let exists = externals.fileManager.fileExists(atPath: path, isDirectory: &isDir)
                feedback(.exists(path, exists: exists, isDir: isDir.boolValue))
            case .retrievePath(let path):
                let childActor = externals.workerFactory({feedback(.childResponse($0))})
                childActor(.retrievePath(path))
            }
        }
    }
    
    struct Actor:Actorable {
        let action:(Int) -> Void
        private var waitingResponses = 0
        private var count = 0
        
        
        mutating func onReceive(_ message: Message) -> [Command] {
            switch message{
            case .retrievePath(let path):
                return [.content(path)]
            case .contents(let contents):
                let existCommands = contents.map {
                    return Command.fileExists($0)
                }
                waitingResponses = existCommands.count
                return existCommands
            case .exists(let path, let exists, let isDir):
                if exists && !isDir{
                    count += 1
                } else if exists {
                    waitingResponses += 1
                    return [.retrievePath(path)]
                }
            case .childResponse(let childCount):
                count += childCount
            case .contentError(_):
                action(-1)
                waitingResponses = 0
            }
            waitingResponses -= 1
            if waitingResponses == 0 {
                action(count)
            }
            return []
        }
    }
    
    struct Externals {
        let fileManager:FileManagerable
        var workerFactory:(AnyActorDriver<Int>) -> AnyActorDriver<Searcher.Message>
    }
}

