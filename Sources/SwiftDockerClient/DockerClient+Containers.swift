//
//  DockerClient+Containers.swift
//  
//
//  Created by Luis Abraham on 2022-01-07.
//

import AsyncHTTPClient
import Foundation
import SwiftDockerClientModel

public extension DockerClient {
    
    func listContainers(all: Bool = false) async throws -> Containers {
        try await self.httpNetwork.execute(ListContainersEndpoint(all: all), onSocketPath: socketPath)
    }
    
    func createContainer(containerName: ContainerName, containerConfig: ContainerConfig) async throws -> CreateContainerResponse {
        try await self.httpNetwork.execute(CreateContainerEndpoint(containerName: containerName,
                                                                   containerConfig: containerConfig),
                                           onSocketPath: socketPath)
    }
    
    func startContainer(containerId: ContainerId) async throws {
        try await self.startContainer(containerId: containerId, detachKeys: nil)
    }
    
    func startContainer(containerId: ContainerId, detachKeys: DetachKeys?) async throws {
        logger.info("Starting container \(containerId)")
        let _ = try await self.httpNetwork.execute(StartContainerEndpoint(containerId: containerId,
                                                                          detachKeys: detachKeys),
                                                   onSocketPath: socketPath)
        logger.info("Started container \(containerId)")
    }
    
    func stopContainer(containerId: ContainerId) async throws {
        try await self.stopContainer(containerId: containerId, killWaitTime: nil)
    }
    
    func stopContainer(containerId: ContainerId, killWaitTime: Seconds?) async throws {
        logger.info("Stopping container \(containerId)")
        let _ = try await self.httpNetwork.execute(StopContainerEndpoint(containerId: containerId,
                                                                         killWaitTime: killWaitTime),
                                                   onSocketPath: socketPath)
        logger.info("Stopped container \(containerId)")
    }
}
