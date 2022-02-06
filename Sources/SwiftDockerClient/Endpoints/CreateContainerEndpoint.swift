//
//  CreateContainerEndpoint.swift
//  
//
//  Created by Luis Abraham on 2022-02-05.
//

import Foundation
import NIOHTTP1
import SwiftDockerClientModel

public struct CreateContainerResponse: Codable {
    public let id: ContainerId
    public let warnings: [String]
    
    public init(id: ContainerId,
                warnings: [String]) {
        self.id = id
        self.warnings = warnings
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case warnings = "Warnings"
    }
}

public struct CreateContainerEndpoint: Endpoint {
    
    public typealias Request = ContainerConfig
    public typealias Response = CreateContainerResponse
    
    private let containerName: ContainerName
    private let containerConfig: ContainerConfig
    
    public init(containerName: ContainerName,
                containerConfig: ContainerConfig) {
        self.containerName = containerName
        self.containerConfig = containerConfig
    }
    
    public var path: String {
        "/containers/create?name=\(containerName)"
    }
    
    public var method: HTTPMethod {
        .POST
    }
    
    public var requestBody: ContainerConfig? {
        containerConfig
    }
    
}
