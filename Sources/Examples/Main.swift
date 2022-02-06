//
//  Main.swift
//  
//
//  Created by Luis Abraham on 2022-01-07.
//

import Foundation
import SwiftDockerClient
import SwiftDockerClientModel
import Logging

@main
struct Main {
    static func main() async {
        let logger = Logger(label: "com.dockerClient.example")
        let dockerClient = DockerClient(logger: logger)
        
        do {
            
            // Pull image
            try await dockerClient.pullImage(imageName: "alpine:latest")
            // Setup container
            let hostConfig = HostConfig(memory: 0, restartPolicy: .init(name: .none, maximumRetryCount: 0))
            let containerConfig = ContainerConfig(commands: ["echo", "hello!"],
                                                  environment: [],
                                                  image: "alpine:latest",
                                                  hostConfig: hostConfig)
            
            let createContainerResponse = try await dockerClient.createContainer(containerName: "FUN",
                                                                                 containerConfig: containerConfig)
            
            // Start container
            try await dockerClient.startContainer(containerId: createContainerResponse.id)
            
            // Stop container
            try await dockerClient.stopContainer(containerId: createContainerResponse.id)
            
            logger.info("\(createContainerResponse)")
            let response = try await dockerClient.listContainers(all: true)
            logger.info("\(response)")
        } catch {
            logger.error("\(error)")
        }
    }
}
