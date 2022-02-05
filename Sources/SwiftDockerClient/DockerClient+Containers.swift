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
}
