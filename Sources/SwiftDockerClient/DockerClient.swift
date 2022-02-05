//
//  DockerClient.swift
//  
//
//  Created by Luis Abraham on 2022-01-07.
//

import Foundation
import Logging
import NIO
import SwiftDockerClientModel

public protocol DockerClientProtocol {
    func listContainers(all: Bool) async throws -> Containers
}

public class DockerClient: DockerClientProtocol {
    internal let socketPath = "/var/run/docker.sock"
    internal let httpNetwork: HTTPNetworking
    internal let logger: Logger
    
    public init(eventLoopGroup: EventLoopGroup? = nil,
         decoder: JSONDecoder = JSONDecoder(),
         logger: Logger) {
        self.httpNetwork = HTTPNetwork(eventLoopGroup: eventLoopGroup,
                                       decoder: decoder,
                                       logger: logger)
        self.logger = logger
    }
    
    public init(httpNetwork: HTTPNetworking,
         decoder: JSONDecoder = JSONDecoder(),
         logger: Logger) {
        self.httpNetwork = httpNetwork
        self.logger = logger
    }
}

