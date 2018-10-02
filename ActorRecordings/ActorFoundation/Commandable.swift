//
//  Commandable.swift
//  ActorRecordings
//
//  Created by Bartosz Polaczyk on 31/07/2018.
//  Copyright © 2018 Bartosz Polaczyk. All rights reserved.
//

protocol Commandable:Equatable{
    associatedtype Message:Messagable
    associatedtype Externals
    
    func interpret(externals: Externals, feedback: @escaping AnyActorDriver<Message> )
}
