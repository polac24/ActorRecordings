//
//  AnyActorDriver.swift
//  ActorRecordings
//
//  Created by Bartosz Polaczyk on 31/07/2018.
//  Copyright © 2018 Bartosz Polaczyk. All rights reserved.
//


typealias AnyActorDriver<Message:Messagable> = (Message) -> ()
