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
    
    func createContainer(containerName: ContainerName, containerConfig: ContainerConfig) async throws -> CreateContainerResponse
    
    func startContainer(containerId: ContainerId) async throws
    
    func startContainer(containerId: ContainerId, detachKeys: DetachKeys?) async throws
    
    func stopContainer(containerId: ContainerId) async throws
    
    func stopContainer(containerId: ContainerId, killWaitTime: Seconds?) async throws
    
    func pullImage(imageName: ImageName) async throws
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

