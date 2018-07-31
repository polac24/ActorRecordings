//
//  ActorDriver.swift
//  ActorRecordings
//
//  Created by Bartosz Polaczyk on 31/07/2018.
//  Copyright © 2018 Bartosz Polaczyk. All rights reserved.
//

import Foundation

class ActorDriver<Actor:Actorable>{
    private let queue:DispatchQueue
    private var actor:Actor
    private let externals:Actor.Command.Externals
    
    fileprivate init(actor:Actor, externals: Actor.Command.Externals, queue: DispatchQueue){
        self.actor = actor
        self.externals = externals
        self.queue = queue
    }
    
    convenience init(actor:Actor, externals: Actor.Command.Externals){
        self.init(actor: actor, externals: externals, queue: DispatchQueue(label:String(describing:ActorDriver<Actor>.self)))
    }
    
    func send(_ message:Actor.Message){
        queue.async{
            self.actor.onReceive(message).forEach{$0.interpret(externals: self.externals, feedback: self.send)}
        }
    }
}

class UIActorDriver<Actor:Actorable>:ActorDriver<Actor>{
    init(actor: Actor, externals: Actor.Command.Externals) {
        super.init(actor: actor, externals: externals, queue: .main)
    }
}

