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
            
            try await dockerClient.pullImage(imageName: "alpine:latest")
            let hostConfig = HostConfig(memory: 0, restartPolicy: .init(name: .none, maximumRetryCount: 0))
            let containerConfig = ContainerConfig(commands: ["echo", "hello!"],
                                                  environment: [],
                                                  image: "alpine:latest",
                                                  hostConfig: hostConfig)
            
            let createContainerResponse = try await dockerClient.createContainer(containerName: "FUN",
                                                                                 containerConfig: containerConfig)
            
            logger.info("\(createContainerResponse)")
            let response = try await dockerClient.listContainers(all: true)
            logger.info("\(response)")
        } catch {
            logger.error("\(error)")
        }
    }
}
