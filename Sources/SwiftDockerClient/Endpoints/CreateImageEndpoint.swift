//
//  CreateImageEndpoint.swift
//  
//
//  Created by Luis Abraham on 2022-02-05.
//

import Foundation
import NIOHTTP1
import SwiftDockerClientModel

public struct CreateImageEndpoint: Endpoint {
    public typealias Request = EmptyBody
    public typealias Response = EmptyBody
    
    private let imageName: ImageName
    
    public init(imageName: ImageName) {
        self.imageName = imageName
    }
    
    public var path: String {
        "/images/create?fromImage=\(imageName)"
    }
    
    public var method: HTTPMethod {
        .POST
    }
    
    public var requestBody: EmptyBody? {
        nil
    }
}
