//
//  SearchScreen.swift
//  ActorRecordings
//
//  Created by Bartosz Polaczyk on 01/08/2018.
//  Copyright © 2018 Bartosz Polaczyk. All rights reserved.
//

import Foundation

class SearchScreen {

    enum Message:Messagable{
        case none
    }
    
    enum Command:Commandable{
        case none
        func interpret(externals: Externals, feedback: AnyActorDriver<Message>){
        }
    }
    enum Actor:Actorable {
        case initial
        
        mutating func onReceive(_ message: Message) -> [Command] {
            return []
        }
    }
    
    struct Externals {
    }
}
