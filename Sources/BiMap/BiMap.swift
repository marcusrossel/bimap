//
//  BiMap.swift
//  BiMap
//
//  Created by Marcus Rossel on 22.03.18.
//  Copyright © 2018 Marcus Rossel. All rights reserved.
//

/// A bijective map between key and value elements.
/// The type ensures O(1) subscripting in both directions.
public struct BiMap<Key, Value> where Key: Hashable, Value: Hashable {
    
    /// The dictionary from keys to values, allowing O(1) lookup of a value from a key.
    internal var keysToValues: [Key: Value] = [:]
    
    /// The dictionary from values to keys, allowing O(1) lookup of a key from a value.
    internal var valuesToKeys: [Value: Key] = [:]
    
    /// A collection exposing all of the keys in the map.
    public var keys: Dictionary<Key, Value>.Keys { keysToValues.keys }
    
    /// A collection exposing all of the values in the map.
    public var values: Dictionary<Key, Value>.Values { keysToValues.values }
    
    /// Sets a given key-value pair.
    ///
    /// If either key or value are `nil`, the opposing key's or value's entry is removed.
    ///
    /// If neither value is `nil`, a new key-value pair is set (if this would break the
    /// bimap-invariant an error occurs).
    ///
    /// - Complexity: O(1)
    private mutating func setPair(key: Key?, value: Value?) {
        // Determines what needs to be done for different types of key-value pairs.
        switch (key, value) {
            
        // For a `nil` key-value pair nothing needs to be done.
        case (nil, nil): return
            
        // Removes the key-value pair belonging to the given key from the bimap.
        case (let key?, nil):
            guard let valueForKey = keysToValues[key] else { return }
            keysToValues[key] = nil
            valuesToKeys[valueForKey] = nil
            
        // Removes the key-value pair belonging to the given value from the bimap.
        case (nil, let value?):
            guard let keyForValue = valuesToKeys[value] else { return }
            valuesToKeys[value] = nil
            keysToValues[keyForValue] = nil
            
        // Checks that the key-value pair does not break the bimap's invariant, and inserts it if
        // possible.
        case (let key?, let value?):
            // Precondition checks.
            guard
                !keysToValues.keys.contains(key) &&
                !keysToValues.values.contains(value) ||
                keysToValues[key] == value
            else {
                fatalError("Attempted to set a non-unique key-value pair in a `BiMap`.")
            }
            
            // Inserts the key-value pair.
            keysToValues[key] = value
            valuesToKeys[value] = key
        }
    }
    
    /// A subscript to the bimap using a key.
    ///
    /// - Complexity: O(1)
    public subscript(_ key: Key) -> Value? {
        get { keysToValues[key] }
        set(newValue) { setPair(key: key, value: newValue) }
    }
    
    /// A subscript to the bimap using a value.
    ///
    /// - Complexity: O(1)
    public subscript(_ value: Value) -> Key? {
        get { valuesToKeys[value] }
        set(newKey) { setPair(key: newKey, value: value) }
    }
    
    /// Removes all elements from the bimap.
    ///
    /// - Complexity: O(`Dictionary.removeAll(keepingCapacity:)`)
    public mutating func removeAll(keepingCapacity: Bool = false) {
        keysToValues.removeAll(keepingCapacity: keepingCapacity)
        valuesToKeys.removeAll(keepingCapacity: keepingCapacity)
    }
    
    /// Creates an empty bimap.
    ///
    /// - Complexity: O(1)
    public init() { }
    
    /// Creates a bimap from a given dictionary.
    ///
    /// - Warning: The given dictionary must be bijective, or else an error is thrown.
    /// 
    /// - Complexity: O(elements.count)
    public init(dictionary: [Key: Value]) {
        // A container for recording which values of the dictionary have alreeady been inserted into
        // self.
        var usedValues: Set<Value> = []
        
        for (key, value) in dictionary {
            // Makes sure that no value is used more than once (keys are unique by virtue of the
            // dictionary type).
            guard !usedValues.contains(value) else {
                fatalError("Attempted to initialize a `BiMap` from a non-bijective dictionary.")
            }
            
            usedValues.insert(value)
            
            keysToValues[key] = value
            valuesToKeys[value] = key
        }
    }
}
