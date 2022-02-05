//
//  SwiftDockerClientStructures.swift
//  
//
//  Created by Luis Abraham on 2022-02-05.
//

import Foundation

public typealias ContainerId        = String
public typealias ContainerName      = String
public typealias ContainerNames     = [ContainerName]
public typealias ContainerStatus    = String
public typealias ContainerState     = String
public typealias ImageName          = String
public typealias ImageId            = String
public typealias Command            = String
public typealias CreatedDateMillis  = Int64
public typealias IPAddress          = String
public typealias IPAddresses        = [IPAddress]
public typealias PrivatePort        = UInt16
public typealias PublicPort         = UInt16
public typealias Ports              = [Port]
public typealias Containers         = [Container]
public typealias Size               = Int64
public typealias Labels             = [String: String]
public typealias NetworkMode        = String
public typealias ContainerPath      = String
public typealias ReadOnly           = Bool
public typealias MountSource        = String
public typealias PermissionMode     = Int
public typealias DriverName         = String
public typealias DriverOptions      = [String: String]
public typealias NoCopy             = Bool
public typealias Mounts             = [Mount]
public typealias NetworkId          = String
public typealias EndpointId         = String
public typealias MACAddress         = String
public typealias MaskLength         = Int
public typealias NetworkLink        = String
public typealias NetworkLinks       = [NetworkLink]
public typealias NetworkAlias       = String
public typealias NetworkAliases     = [NetworkAlias]
public typealias NetworkEndpoint    = String
public typealias Networks           = [NetworkEndpoint: EndpointSettings]

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

public struct HostConfig: Codable {
    public let networkMode: NetworkMode
    
    public init(networkMode: NetworkMode) {
        self.networkMode = networkMode
    }
    
    enum CodingKeys: String, CodingKey {
        case networkMode = "NetworkMode"
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
