//
//  Actorable.swift
//  ActorRecordings
//
//  Created by Bartosz Polaczyk on 31/07/2018.
//  Copyright © 2018 Bartosz Polaczyk. All rights reserved.
//

protocol Actorable {
    associatedtype Message
    associatedtype Command:Commandable where Command.Message == Message
    mutating func onReceive(_ : Message) -> [Command]
}
