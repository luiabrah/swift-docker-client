//
//  File.swift
//  
//
//  Created by Luis Abraham on 2022-02-05.
//

import AsyncHTTPClient
import Foundation
import SwiftDockerClientModel

public extension DockerClient {
    func pullImage(imageName: ImageName) async throws {
        logger.info("Creating image \(imageName)")
        let _ = try await self.httpNetwork.execute(CreateImageEndpoint(imageName: imageName), onSocketPath: socketPath)
        logger.info("Successfully created image \(imageName)")
    }
}
