// Inspired by http://www.michaelbabiy.com/swift-generics-cache/

import Foundation
import UIKit

public
class Cache<T>
{
    private var lock = ReadWriteLock(name: "com.quri.Cache.lock")

    private var database: [String : T]
    private var transactions: NSMutableOrderedSet
    private var memoryWarningObserver: NSObjectProtocol!
    private let size: Int

    public var isEmpty: Bool { return transactions.count == 0 }

    public
    subscript(key: String) -> T?
    {
        get
        {
            return lock.read
            {
                [unowned self] in
                return self.read(key: key)
            }
        }

        set (newValue)
        {
            lock.write
            {
                [unowned self] in
                self.write(newValue, key: key)
            }
        }
    }

    public
    init(capacity: Int)
    {
        database = Dictionary(minimumCapacity: capacity)
        transactions = NSMutableOrderedSet(capacity: capacity)
        size = capacity

        // Memory warning

        let notificationCenter = NotificationCenter.default

        memoryWarningObserver = notificationCenter.addObserver(forName: .UIApplicationDidReceiveMemoryWarning,
                                                               object: nil,
                                                               queue: OperationQueue.main)
        {
            [unowned self] _ in
            self.onMemoryWarning()
        }
    }

    deinit
    {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(memoryWarningObserver,
                                          name: .UIApplicationDidReceiveMemoryWarning,
                                          object: nil)
    }

    private
    func onMemoryWarning()
    {
        lock.write
        {
            [unowned self] in
            self.database.removeAll()
            self.transactions.removeAllObjects()
        }
    }

    private
    func write(_ data: T?, key: String)
    {
        guard
            let data = data
            else
        {
            database.removeValue(forKey: key)
            transactions.removeObject(at: transactions.index(of: key))
            return
        }

        if transactions.count < size
        {
            database[key] = data
            transactions.add(key)
        }
        else
        {
            if let top = self.transactions.firstObject as? String
            {
                database.removeValue(forKey: top)
                transactions.removeObject(at: 0)
            }

            write(data, key: key)
        }
    }

    private
    func read(key: String) -> T?
    {
        guard let data = database[key] else { return nil }

        if self.transactions.contains(key)
        {
            transactions.removeObject(at: transactions.index(of: key))
            transactions.add(key)
        }
        
        return data
    }
}

public
struct ReadWriteLock
{
    private let queue: DispatchQueue

    public
    init(name: String)
    {
        queue = DispatchQueue(label: name, attributes: .concurrent)
    }

    public
    func read<T>(block: () -> T?) -> T?
    {
        return queue.sync { return block() }
    }

    public
    func write(_ block: @escaping () -> Void)
    {
        queue.async(flags: .barrier) { block() }
    }
}

// Time to play!

let cache = Cache<Int>(capacity: 5)

cache.isEmpty

cache["a"] = 0
cache["b"] = 1
cache["c"] = 2
cache["d"] = 3
cache["e"] = 4

cache["a"]
cache["f"] = 5
cache["b"]

cache.isEmpty