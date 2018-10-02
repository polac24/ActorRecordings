//
//  ActorRecordingsTests.swift
//  ActorRecordingsTests
//
//  Created by Bartosz Polaczyk on 31/07/2018.
//  Copyright © 2018 Bartosz Polaczyk. All rights reserved.
//

import XCTest
@testable import ActorRecordings

class RecordingsScreenActorTests: XCTestCase {
    func testInitialization_setsTitle(){
        // Arrange
        var actor = RecordingsScreen.Actor.starting
        // Act
        let commands = actor.onReceive(.initialize(title: "Home"))
        // Assert
        XCTAssert(commands.contains(.setTitle(title: "Home")))
    }
    func testInitialization_beginsSearchFromRoot(){
        // Arrange
        var actor = RecordingsScreen.Actor.starting
        // Act
        let commands = actor.onReceive(.initialize(title: "Home"))
        // Assert
        XCTAssert(commands.contains(.getRoot))
    }
    func testReadyRootFolder_beginsSearch(){
        // Arrange
        var actor = RecordingsScreen.Actor.starting
        _ = actor.onReceive(.initialize(title: "Home"))
        // Act
        let commands = actor.onReceive(.foldersRootReady(path: "DCMI"))
        // Assert
        XCTAssertEqual(commands, [.fetchFolders(path: "DCMI")])
    }
}
