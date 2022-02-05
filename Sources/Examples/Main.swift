//
//  Main.swift
//  
//
//  Created by Luis Abraham on 2022-01-07.
//

import Foundation
import SwiftDockerClient
import Logging

@main
struct Main {
    static func main() async {
        let logger = Logger(label: "com.dockerClient.example")
        let dockerClient = DockerClient(logger: logger)
        
        do {
            let response = try await dockerClient.listContainers(all: true)
            logger.info("\(response)")
        } catch {
            logger.error("\(error)")
        }
    }
}
