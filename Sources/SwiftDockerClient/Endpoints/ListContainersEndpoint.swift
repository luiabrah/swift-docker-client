//
//  ListContainersEndpoint.swift
//  
//
//  Created by Luis Abraham on 2022-01-16.
//

import Foundation
import NIOHTTP1
import SwiftDockerClientModel

public struct ListContainersResponse: Codable {
    public let containers: Containers
    
    public init(containers: Containers) {
        self.containers = containers
    }
}

public struct ListContainersEndpoint: Endpoint {

    public typealias Request = EmptyBody
    public typealias Response = Containers
    
    private let all: Bool
    
    public init(all: Bool = false) {
        self.all = all
    }
    
    public var path: String {
        "containers/json?all=\(all)"
    }
    
    public var method: HTTPMethod {
        .GET
    }
    
    public var requestBody: EmptyBody? {
        nil
    }
}
