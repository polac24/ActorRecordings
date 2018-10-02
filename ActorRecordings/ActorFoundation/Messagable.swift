//
//  Messagable.swift
//  ActorRecordings
//
//  Created by Bartosz Polaczyk on 31/07/2018.
//  Copyright © 2018 Bartosz Polaczyk. All rights reserved.
//


// Mental model for Messagable is: Would it be possible to
// represent given Message into a "serialized" version?
// e.g. into JSON object?
//
// protocol Messagable:Codable {}
protocol Messagable:Equatable {}
