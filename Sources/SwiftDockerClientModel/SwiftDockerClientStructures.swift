//
//  SwiftDockerClientStructures.swift
//  
//
//  Created by Luis Abraham on 2022-02-05.
//

import Foundation

public typealias ContainerId = String
public typealias ContainerName = String
public typealias ContainerNames = [ContainerName]
public typealias ContainerStatus = String
public typealias ContainerState = String
public typealias ImageName = String
public typealias ImageId = String
public typealias Command = String
public typealias CreatedDateMillis = Int64
public typealias IPAddress = String
public typealias IPAddresses = [IPAddress]
public typealias PrivatePort = UInt16
public typealias PublicPort = UInt16
public typealias Ports = [Port]
public typealias Containers = [Container]
public typealias Size = Int64
public typealias Labels = [String: String]
public typealias NetworkMode = String
public typealias ContainerPath = String
public typealias ReadOnly = Bool
public typealias MountSource = String
public typealias PermissionMode = Int
public typealias DriverName = String
public typealias DriverOptions = [String: String]
public typealias NoCopy = Bool
public typealias Mounts = [Mount]
public typealias NetworkId = String
public typealias EndpointId = String
public typealias MACAddress = String
public typealias MaskLength = Int
public typealias NetworkLink = String
public typealias NetworkLinks = [NetworkLink]
public typealias NetworkAlias = String
public typealias NetworkAliases = [NetworkAlias]
public typealias NetworkEndpoint = String
public typealias Networks = [NetworkEndpoint: EndpointSettings]
public typealias EndpointsConfig = [String: EndpointSettings]
public typealias Volumes = [String: Empty]
public typealias PortSet = [PortType: Empty]
public typealias Memory = Int64
public typealias ContainerHostname = String
public typealias DomainName = String
public typealias User = String
public typealias Commands = [Command]
public typealias Environment = [String]
public typealias ContainerWorkingDirectory = String
public typealias Entrypoint = [String]
public typealias Signal = String
public typealias Seconds = Int
public typealias Nanoseconds = Int
public typealias HealthCheckTest = String
public typealias HealthCheckTests = [HealthCheckTest]
public typealias Architecture = String
public typealias OS = String
public typealias OSVersion = String
public typealias OSFeature = String
public typealias OSFeatures = [OSFeature]
public typealias Variant = String
public typealias DetachKeys = String

public struct Empty: Codable {
    
}

public enum MountType: String, Codable {
    case bind
    case volume
    case tmpfs
    case npipe
}

public enum ConsistencyRequirement: String, Codable {
    case `default`
    case consistent
    case cached
    case delegated
}

public enum BindPropogationMode: String, Codable {
    case `private`
    case rprivate
    case shared
    case rshared
    case slave
    case rslave
}

public struct BindOptions: Codable {
    public let propogation:     BindPropogationMode
    public let nonRecursive:    Bool
    
    public init(propogation: BindPropogationMode,
                nonRecursive: Bool) {
        self.propogation = propogation
        self.nonRecursive = nonRecursive
    }
    
    enum CodingKeys: String, CodingKey {
        case propogation = "Propogation"
        case nonRecursive = "NonRecursive"
    }
}

public struct DriverConfig: Codable {
    public let name:    DriverName
    public let options: DriverOptions
    
    public init(name: DriverName,
                options: DriverOptions) {
        self.name = name
        self.options = options
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case options = "Options"
    }
}

public struct VolumeOptions: Codable {
    public let noCopy:          NoCopy
    public let labels:          Labels
    public let driverConfig:    DriverConfig
    
    public init(noCopy: NoCopy,
                labels: Labels,
                driverConfig: DriverConfig) {
        self.noCopy = noCopy
        self.labels = labels
        self.driverConfig = driverConfig
    }
    
    enum CodingKeys: String, CodingKey {
        case noCopy = "NoCopy"
        case labels = "Labels"
        case driverConfig = "DriverConfig"
    }
}

public struct TmpfsOptions: Codable {
    public let sizeBytes:       Size
    public let permissionMode:  PermissionMode
    
    public init(sizeBytes: Size,
                permissionMode: PermissionMode) {
        self.sizeBytes = sizeBytes
        self.permissionMode = permissionMode
    }
    
    enum CodingKeys: String, CodingKey {
        case sizeBytes = "SizeBytes"
        case permissionMode = "Mode"
    }
}

public struct Mount: Codable {
    public let target:          ContainerPath
    public let source:          MountSource
    public let type:            MountType
    public let readOnly:        ReadOnly
    public let consistency:     ConsistencyRequirement
    public let bindOptions:     BindOptions?
    public let volumeOptions:   VolumeOptions?
    public let tmpfsOptions:    TmpfsOptions?
    
    public init(target: ContainerPath,
                source: MountSource,
                type: MountType,
                readOnly: ReadOnly,
                consistency: ConsistencyRequirement,
                bindOptions: BindOptions?,
                volumeOptions: VolumeOptions?,
                tmpfsOptions: TmpfsOptions?) {
        self.target = target
        self.source = source
        self.type = type
        self.readOnly = readOnly
        self.consistency = consistency
        self.bindOptions = bindOptions
        self.volumeOptions = volumeOptions
        self.tmpfsOptions = tmpfsOptions
    }
    
    enum CodingKeys: String, CodingKey {
        case target = "Target"
        case source = "Source"
        case type = "Type"
        case readOnly = "ReadOnly"
        case consistency = "Consistency"
        case bindOptions = "BindOptions"
        case volumeOptions = "VolumeOptions"
        case tmpfsOptions = "TmpfsOptions"
    }
}

public struct Port: Codable {
    public let ipAddress:   IPAddress?
    public let privatePort: PrivatePort
    public let publicPort:  PublicPort?
    public let type:        PortType
    
    public init(ipAddress: IPAddress?,
                privatePort: PrivatePort,
                publicPort: PublicPort?,
                type: PortType) {
        self.ipAddress = ipAddress
        self.privatePort = privatePort
        self.publicPort = publicPort
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case ipAddress = "IPAddress"
        case privatePort = "PrivatePort"
        case publicPort = "PublicPort"
        case type = "Type"
    }
}

public enum PortType: String, Codable {
    case tcp
    case udp
    case sctp
}

public struct EndpointIPAMConfig: Codable {
    public let ipv4Address: IPAddress
    public let ipv6Address: IPAddress
    public let linkLocalIPs: IPAddresses
    
    public init(ipv4Address: IPAddress,
                ipv6Address: IPAddress,
                linkLocalIPs: IPAddresses) {
        self.ipv4Address = ipv4Address
        self.ipv6Address = ipv6Address
        self.linkLocalIPs = linkLocalIPs
    }
    
    enum CodingKeys: String, CodingKey {
        case ipv4Address = "IPv4Address"
        case ipv6Address = "IPv6Address"
        case linkLocalIPs = "LinkLocalIPs"
    }
}

public struct EndpointSettings: Codable {
    public let ipamConfig: EndpointIPAMConfig?
    public let links: NetworkLinks?
    public let aliases: NetworkAliases?
    public let networkId: NetworkId
    public let endpointId: EndpointId
    public let gatewayAddress: IPAddress
    public let ipAddress: IPAddress
    public let ipPrefixLength: MaskLength
    public let ipv6Gateway: IPAddress
    public let globalIPv6Address: IPAddress
    public let globalIPv6PrefixLength: MaskLength
    public let macAddress: MACAddress
    public let driverOptions: DriverOptions?
    
    public init(ipamConfig: EndpointIPAMConfig?,
                links: NetworkLinks?,
                aliases: NetworkAliases?,
                networkId: NetworkId,
                endpointId: EndpointId,
                gatewayAddress: IPAddress,
                ipAddress: IPAddress,
                ipPrefixLength: MaskLength,
                ipv6Gateway: IPAddress,
                globalIPv6Address: IPAddress,
                globalIPv6PrefixLength: MaskLength,
                macAddress: MACAddress,
                driverOptions: DriverOptions?) {
        self.ipamConfig = ipamConfig
        self.links = links
        self.aliases = aliases
        self.networkId = networkId
        self.endpointId = endpointId
        self.gatewayAddress = gatewayAddress
        self.ipAddress = ipAddress
        self.ipPrefixLength = ipPrefixLength
        self.ipv6Gateway = ipv6Gateway
        self.globalIPv6Address = globalIPv6Address
        self.globalIPv6PrefixLength = globalIPv6PrefixLength
        self.macAddress = macAddress
        self.driverOptions = driverOptions
    }
    
    enum CodingKeys: String, CodingKey {
        case ipamConfig = "IPAMConfig"
        case links = "Links"
        case aliases = "Aliases"
        case networkId = "NetworkID"
        case endpointId = "EndpointID"
        case gatewayAddress = "Gateway"
        case ipAddress = "IPAddress"
        case ipPrefixLength = "IPPrefixLen"
        case ipv6Gateway = "IPv6Gateway"
        case globalIPv6Address = "GlobalIPv6Address"
        case globalIPv6PrefixLength = "GlobalIPv6PrefixLen"
        case macAddress = "MacAddress"
        case driverOptions = "DriverOpts"
    }
}
public struct NetworkSettings: Codable {
    public let networks: Networks
    
    public init(networks: Networks) {
        self.networks = networks
    }
    
    enum CodingKeys: String, CodingKey {
        case networks = "Networks"
    }
}

public struct Container: Codable {
    public struct HostConfig: Codable {
        public let networkMode: NetworkMode?
        
        public init(networkMode: NetworkMode?) {
            self.networkMode = networkMode
        }
        
        enum CodingKeys: String, CodingKey {
            case networkMode = "NetworkMode"
        }
    }
    
    public let id:              ContainerId
    public let names:           ContainerNames
    public let image:           ImageName
    public let imageId:         ImageId
    public let command:         Command
    public let createdDate:     CreatedDateMillis
    public let state:           ContainerState
    public let status:          ContainerStatus
    public let ports:           Ports
    public let sizeRW:          Size?
    public let sizeRootFs:      Size?
    public let labels:          Labels
    public let hostConfig:      HostConfig
    public let mounts:          Mounts
    public let networkSettings: NetworkSettings
    
    public init(id: ContainerId,
                names: ContainerNames,
                image: ImageName,
                imageId: ImageId,
                command: Command,
                createdDate: CreatedDateMillis,
                state: ContainerState,
                status: ContainerStatus,
                ports: Ports,
                sizeRW: Size?,
                sizeRootFs: Size?,
                labels: Labels,
                hostConfig: HostConfig,
                mounts: Mounts,
                networkSettings: NetworkSettings) {
        self.id = id
        self.names = names
        self.image = image
        self.imageId = imageId
        self.command = command
        self.createdDate = createdDate
        self.state = state
        self.status = status
        self.ports = ports
        self.sizeRW = sizeRW
        self.sizeRootFs = sizeRootFs
        self.labels = labels
        self.hostConfig = hostConfig
        self.mounts = mounts
        self.networkSettings = networkSettings
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case names = "Names"
        case image = "Image"
        case imageId = "ImageID"
        case command = "Command"
        case createdDate = "Created"
        case ports = "Ports"
        case state = "State"
        case status = "Status"
        case sizeRW = "SizeRw"
        case sizeRootFs = "SizeRootFs"
        case labels = "Labels"
        case hostConfig = "HostConfig"
        case mounts = "Mounts"
        case networkSettings = "NetworkSettings"
    }
}

public struct NetworkingConfig: Codable {

    public let endpointsConfig: EndpointsConfig
    
    public init(endpointsConfig: EndpointsConfig) {
        self.endpointsConfig = endpointsConfig
    }
    
    enum CodingKeys: String, CodingKey {
        case endpointsConfig = "EndpointsConfig"
    }
}

public struct HealthCheck: Codable {
    public let tests: HealthCheckTests?
    public let interval: Nanoseconds?
    public let timeout: Nanoseconds?
    public let retries: Int?
    public let startPeriod: Nanoseconds?
    
    public init(tests: HealthCheckTests?,
                interval: Nanoseconds?,
                timeout: Nanoseconds?,
                retries: Int?, startPeriod: Nanoseconds?) {
        self.tests = tests
        self.interval = interval
        self.timeout = timeout
        self.retries = retries
        self.startPeriod = startPeriod
    }
    
    enum CodingKeys: String, CodingKey {
        case tests = "Test"
        case interval = "Interval"
        case timeout = "Timeout"
        case retries = "Retries"
        case startPeriod = "StartPeriod"
    }
}

public struct Platform: Codable {
    public let architecture: Architecture
    public let os: OS
    public let osVersion: OSVersion?
    public let osFeatures: OSFeatures?
    public let variant: Variant?
}

public struct ContainerConfig: Codable {
    public let hostname: ContainerHostname
    public let domainName: DomainName
    public let user: User
    public let attachStdin: Bool
    public let attachStdout: Bool
    public let attachStderr: Bool
    public let tty: Bool
    public let commands: Commands
    public let environment: Environment
    public let image: ImageName
    public let openStdin: Bool
    public let stdinOnce: Bool
    public let argsEscaped: Bool?
    public let workingDirectory: ContainerWorkingDirectory
    public let entrypoint: Entrypoint
    public let networkDisabled: Bool
    public let macAddress: MACAddress?
    public let labels: Labels
    public let stopSignal: Signal?
    public let stopTimeout: Seconds?
    public let shell: [String]?
    public let onBuild: [String]
    public let volumes: Volumes
    public let healthCheck: HealthCheck?
    public let exposedPorts: PortSet?
    public let networkingConfig: NetworkingConfig?
    public let hostConfig: HostConfig
    
    public init(hostname: ContainerHostname = "",
                domainName: DomainName = "",
                user: User = "",
                attachStdin: Bool = false,
                attachStdout: Bool = true,
                attachStderr: Bool = true,
                tty: Bool = false,
                commands: Commands,
                environment: Environment,
                image: ImageName,
                openStdin: Bool = false,
                stdinOnce: Bool = false,
                argsEscaped: Bool? = nil,
                workingDirectory: ContainerWorkingDirectory = "",
                entrypoint: Entrypoint = [],
                networkDisabled: Bool = false,
                macAddress: MACAddress? = nil,
                labels: Labels = [:],
                stopSignal: Signal? = nil,
                stopTimeout: Seconds? = nil,
                shell: [String]? = nil,
                onBuild: [String] = [],
                networkingConfig: NetworkingConfig? = nil,
                volumes: Volumes = [:],
                healthCheck: HealthCheck? = nil,
                exposedPorts: PortSet? = nil,
                hostConfig: HostConfig) {
        self.hostname = hostname
        self.domainName = domainName
        self.user = user
        self.attachStdin = attachStdin
        self.attachStdout = attachStdout
        self.attachStderr = attachStderr
        self.tty = tty
        self.commands = commands
        self.environment = environment
        self.image = image
        self.openStdin = openStdin
        self.stdinOnce = stdinOnce
        self.argsEscaped = argsEscaped
        self.workingDirectory = workingDirectory
        self.entrypoint = entrypoint
        self.networkDisabled = networkDisabled
        self.macAddress = macAddress
        self.labels = labels
        self.stopSignal = stopSignal
        self.stopTimeout = stopTimeout
        self.shell = shell
        self.onBuild = onBuild
        self.networkingConfig = networkingConfig
        self.volumes = volumes
        self.healthCheck = healthCheck
        self.exposedPorts = exposedPorts
        self.hostConfig = hostConfig
    }
    
    enum CodingKeys: String, CodingKey {
        case hostname = "Hostname"
        case domainName = "Domainname"
        case user = "User"
        case attachStdin = "AttachStdin"
        case attachStdout = "AttachStdout"
        case attachStderr = "AttachStderr"
        case tty = "Tty"
        case commands = "Cmd"
        case environment = "Env"
        case image = "Image"
        case openStdin = "OpenStdin"
        case stdinOnce = "StdinOnce"
        case argsEscaped = "ArgsEscaped"
        case workingDirectory = "WorkingDir"
        case entrypoint = "Entrypoint"
        case networkDisabled = "NetworkDisabled"
        case macAddress = "MacAddress"
        case labels = "Labels"
        case stopSignal = "StopSignal"
        case stopTimeout = "StopTimeout"
        case shell = "Shell"
        case onBuild = "OnBuild"
        case networkingConfig = "NetworkingConfig"
        case volumes = "Volumes"
        case healthCheck = "HealthCheck"
        case exposedPorts = "ExposedPorts"
        case hostConfig = "HostConfig"
    }
}

public enum RestartPolicy: String, Codable {
    case none = ""
    case always = "always"
    case unlessStopped = "unless-stopped"
    case onFailure = "on-failure"
}

public struct RestartPolicyConfig: Codable {
   
    public let name: RestartPolicy
    public let maximumRetryCount: Int
    
    public init(name: RestartPolicy, maximumRetryCount: Int) {
        self.name = name
        self.maximumRetryCount = maximumRetryCount
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case maximumRetryCount = "MaximumRetryCount"
    }
}

public struct HostConfig: Codable {

    public let memory: Memory
    public let restartPolicy: RestartPolicyConfig
    public let mounts: Mounts?
    public let publishAllPorts: Bool
    
    public init(memory: Memory,
                restartPolicy: RestartPolicyConfig,
                mounts: Mounts? = nil,
                publishAllPorts: Bool = true) {
        self.memory = memory
        self.restartPolicy = restartPolicy
        self.mounts = mounts
        self.publishAllPorts = publishAllPorts
    }
    
    enum CodingKeys: String, CodingKey {
        case memory = "Memory"
        case restartPolicy = "RestartPolicy"
        case mounts = "Mounts"
        case publishAllPorts = "PublishAllPorts"
    }
}

public struct DockerResponse: Codable {
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
}

public enum DockerAPIError: Error {
    case serverError(String)
    case resourceNotFound(String)
    case invalidRequest(String)
}
