//
//  Conformances.swift
//  BiMap
//
//  Created by Marcus Rossel on 22.03.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

// MARK: - Equatable

extension BiMap: Equatable {
    
    // Two bimaps are equal iff all of their key-value pairs are equal.
    public static func ==(left: BiMap, right: BiMap) -> Bool {
        left.keysToValues == right.keysToValues
    }
}

// MARK: - Expressible By Dictionary Literal

extension BiMap: ExpressibleByDictionaryLiteral {
    
    /// Creates a bimap from a dictionary literal.
    /// The literal must only contain unique key-value pairs, or else a runtime error occurs.
    ///
    /// - Complexity: O(elements.count)
    public init(dictionaryLiteral elements: (Key, Value)...) {
        // Initializes the dictionaries as empty.
        self.init()
        
        // Processes the key-value pairs.
        for (key, value) in elements {
            // Performs precondition checks.
            guard !keysToValues.keys.contains(key) && !keysToValues.values.contains(value) else {
                fatalError("Attempted to create a `Bimap` from non-unique key-value pairs.")
            }
            
            // Sets the dictionaries' key-value pairs.
            keysToValues[key] = value
            valuesToKeys[value] = key
        }
    }
}

// MARK: - Sequence

extension BiMap: Sequence {
    
    /// The iterator used by a `BiMap` to generate its sequence.
    public typealias Iterator = Dictionary<Key, Value>.Iterator
    
    /// Creates the bimap's iterator.
    public func makeIterator() -> Iterator { keysToValues.makeIterator() }
}

// MARK: - Collection

extension BiMap: Collection {
    
    /// The type used by a `BiMap` to index it as a collection.
    public typealias Index = Dictionary<Key, Value>.Index
    
    /// The bimap's start index.
    public var startIndex: Index { keysToValues.startIndex }
    
    /// The bimap's end index.
    public var endIndex: Index { keysToValues.endIndex }
    
    /// Returns the element at a given index.
    public subscript(position: Index) -> Iterator.Element { keysToValues[position] }
    
    /// Returns the index after a given index.
    public func index(after index: Index) -> Index { keysToValues.index(after: index) }
}
