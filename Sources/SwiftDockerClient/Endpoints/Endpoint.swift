//
//  Endpoint.swift
//  
//
//  Created by Luis Abraham on 2022-01-07.
//

import Foundation
import NIOHTTP1
import AsyncHTTPClient

public struct EmptyBody: Codable {}

public protocol Endpoint {
    associatedtype Request: Codable
    associatedtype Response: Codable
    
    var path: String { get }
    var method: HTTPMethod { get }
    var requestBody: Request? { get }
}

public extension Endpoint {
    func requestBody(encoder: JSONEncoder = JSONEncoder()) -> HTTPClient.Body? {
        guard let requestBody = self.requestBody else {
            return nil
        }
        
        guard let encodedData = try? encoder.encode(requestBody) else {
            return nil
        }
        
        return .data(encodedData)
    }
}
