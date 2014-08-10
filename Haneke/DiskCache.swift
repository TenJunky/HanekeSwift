//
//  DiskCache.swift
//  Haneke
//
//  Created by Hermes Pique on 8/10/14.
//  Copyright (c) 2014 Haneke. All rights reserved.
//

import Foundation

// TODO: Eventually move to Haneke.swift or similar.
public let HanekeDomain = "io.haneke"

public class DiskCache {
    
    public class func basePath() -> String {
        let cachesPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        let hanekePathComponent = HanekeDomain;
        let basePath = cachesPath.stringByAppendingPathComponent(hanekePathComponent)
        // TODO: Do not recaculate basePath value
        return basePath
    }
    
    let cachePath : String
    let cacheQueue : dispatch_queue_t
    
    public init(_ name : String) {
        let basePath = DiskCache.basePath();
        cachePath = basePath.stringByAppendingPathComponent(name);

        let queueName = HanekeDomain + "." + name
        cacheQueue = dispatch_queue_create(queueName, nil)
    }
    
    public func setData(getData : @autoclosure () -> NSData?, key : String) {
        dispatch_async(cacheQueue, {
            let path = self.cachePath.stringByAppendingPathComponent(key);
            var error: NSError? = nil
            if let data = getData() {
                let success = data.writeToFile(path, options: NSDataWritingOptions.AtomicWrite, error: &error)
                if (!success) {
                    NSLog("Failed to write key %@ with error", key, error!);
                }
            } else {
                NSLog("Failed to get data for key %@", key);
            }
        })
    }
}
