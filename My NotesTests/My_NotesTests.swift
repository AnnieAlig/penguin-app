//
//  My_NotesTests.swift
//  My NotesTests
//
//  Created by Mac User on 03.04.18.
//  Copyright © 2018 Annie Alig. All rights reserved.
//

import XCTest
@testable import My_Notes

class My_NotesTests: XCTestCase {
    
    //MARK: Penguin Class Tests
    
    //Confitm that the penguin initializer returns a Penguin object when passed valid paramentes.
    func testPenguinInitializationSucceeds() {
        
        //Zero rating
        let zeroRatingPenguin = Penguin.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingPenguin)
        
        //Highest positive rating
        let positiveRatingPenguin = Penguin.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingPenguin)
    }
    
    //Confirm that the Penguin initializer returns nil when passed a negative rating or an empty name.
    func testPenguinInitializationFails(){
        //Negative rating
        let negativeRatingPenguin = Penguin.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingPenguin)
        
        //Rating exceeds maximum
        let largeRatingPenguin = Penguin.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingPenguin)
        
        //Empty String
        let emptyStringPenguin = Penguin.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringPenguin)
    }
    
}
