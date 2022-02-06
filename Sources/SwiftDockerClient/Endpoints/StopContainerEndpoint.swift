//
//  StopContainerEndpoint.swift
//  
//
//  Created by Luis Abraham on 2022-02-06.
//

import Foundation
import NIOHTTP1
import SwiftDockerClientModel

public struct StopContainerEndpoint: Endpoint {
   
    public typealias Request = EmptyBody
    public typealias Response = EmptyBody
    
    private let containerId: ContainerId
    private let killWaitTime: Seconds?
    
    public init(containerId: ContainerId,
                killWaitTime: Seconds? = nil) {
        self.containerId = containerId
        self.killWaitTime = killWaitTime
    }
    
    public var path: String {
        var path = "/containers/\(containerId)/stop"
        
        if let killWaitTime = killWaitTime {
            path += "?t=\(killWaitTime)"
        }
        
        return path
    }
    
    public var method: HTTPMethod {
        .POST
    }
    
    public var requestBody: EmptyBody? {
        nil
    }
}
