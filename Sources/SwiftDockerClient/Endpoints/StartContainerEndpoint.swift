//
//  StartContainerEndpoint.swift
//  
//
//  Created by Luis Abraham on 2022-02-06.
//

import Foundation
import NIOHTTP1
import SwiftDockerClientModel

public struct StartContainerEndpoint: Endpoint {
   
    public typealias Request = EmptyBody
    public typealias Response = EmptyBody
    
    private let containerId: ContainerId
    private let detachKeys: DetachKeys?
    
    public init(containerId: ContainerId,
                detachKeys: DetachKeys? = nil) {
        self.containerId = containerId
        self.detachKeys = detachKeys
    }
    
    public var path: String {
        var path = "/containers/\(containerId)/start"
        
        if let detachKeys = detachKeys {
            path += "?detachKeys=\(detachKeys)"
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
