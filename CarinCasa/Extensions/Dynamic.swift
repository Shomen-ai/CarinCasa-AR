//
// ProRead
// Copyright © 2022 Mediasoft. All rights reserved.
//

import Foundation

// MARK: - DisposableDynamic

protocol DisposableDynamic: AnyObject {
    @discardableResult
    func remove(subscriber: String) -> Bool
}

// MARK: - DynamicReadonlyProtocol

protocol DynamicReadonlyProtocol: AnyObject {
    associatedtype SourceType

    var value: SourceType { get } // Current SourceType value, holded by Dynamic

    func add(subscriber: String, fireRightWay: Bool, with subscription: @escaping (SourceType, SourceType) -> Void)
}

extension DynamicReadonlyProtocol {
    func add(subscriber: String, fireRightWay: Bool = false, with subscription: @escaping (SourceType, SourceType) -> Void) {
        add(subscriber: subscriber, fireRightWay: fireRightWay, with: subscription)
    }
}

// MARK: - DynamicProtocol

protocol DynamicProtocol: DynamicReadonlyProtocol {
    func update(with new: SourceType) // source setter
}

// MARK: - Dynamic

class Dynamic<Source>: DynamicProtocol, DisposableDynamic {
    // MARK: - Types

    typealias Subscription = (Source, Source) -> Void

    // MARK: - Properties

    private(set) var subscribers: [String: Subscription] = [:]

    private var _source: Source {
        didSet {
            subscribers.forEach { subscription in
                subscription.value(oldValue, _source)
            }
        }
    }

    var value: Source {
        _source
    }

    // MARK: - Lifecycle

    init(_ initial: Source) {
        _source = initial
    }

    // MARK: - DataProviderProtocol Methods

    func update(with new: Source) {
        _source = new
    }

    func add(subscriber: String, fireRightWay: Bool = false, with subscription: @escaping Subscription) {
        if fireRightWay {
            subscription(_source, _source)
        }
        subscribers[subscriber] = subscription
    }

    @discardableResult
    func remove(subscriber: String) -> Bool {
        subscribers.removeValue(forKey: subscriber) != nil
    }

    subscript<T>(key: WritableKeyPath<Source, T>) -> T {
        get {
            _source[keyPath: key]
        }
        set(newValue) {
            _source[keyPath: key] = newValue
        }
    }

    subscript<T>(key: WritableKeyPath<Source, T?>) -> T? {
        get {
            _source[keyPath: key]
        }
        set(newValue) {
            _source[keyPath: key] = newValue
        }
    }

    subscript<T>(key: KeyPath<Source, T>) -> T {
        _source[keyPath: key]
    }

    subscript<T>(key: KeyPath<Source, T?>) -> T? {
        _source[keyPath: key]
    }
}
