//
//  HTTPNetwork.swift
//  
//
//  Created by Luis Abraham on 2022-01-16.
//

import AsyncHTTPClient
import Foundation
import Logging
import NIO

public protocol HTTPNetworking {
    func execute<E: Endpoint>(_ endpoint: E) async throws -> E.Response
    func execute<E: Endpoint>(_ endpoint: E, onSocketPath socketPath: String) async throws -> E.Response
}

public enum HTTPNetworkError: Error {
    case invalidResponseBody(String)
}

public class HTTPNetwork: HTTPNetworking {
    private let httpClient: HTTPClient
    private let decoder: JSONDecoder
    private let logger: Logger
    
    public init(eventLoopGroup: EventLoopGroup? = nil,
                decoder: JSONDecoder = JSONDecoder(),
                logger: Logger) {
        let eventLoopGroupProvider: HTTPClient.EventLoopGroupProvider
        if let eventLoopGroup = eventLoopGroup {
            eventLoopGroupProvider = .shared(eventLoopGroup)
        } else {
            eventLoopGroupProvider = .createNew
        }
        
        self.httpClient = HTTPClient(eventLoopGroupProvider: eventLoopGroupProvider)
        self.decoder = decoder
        self.logger = logger
    }
    
    public init(httpClient: HTTPClient,
         decoder: JSONDecoder = JSONDecoder(),
         logger: Logger) {
        self.httpClient = httpClient
        self.decoder = decoder
        self.logger = logger
    }
    
    deinit {
        do {
            try httpClient.syncShutdown()
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    public func execute<E: Endpoint>(_ endpoint: E) async throws -> E.Response {
        let httpResponse = try await httpClient.execute(endpoint.method,
                                                        url: endpoint.path,
                                                        body: endpoint.requestBody(),
                                                        logger: logger).get()
        return try decodeResponse(httpResponse, forEndpoint: endpoint)
    }
    
    public func execute<E: Endpoint>(_ endpoint: E, onSocketPath socketPath: String) async throws -> E.Response {
        let httpResponse = try await httpClient.execute(endpoint.method,
                                                        socketPath: socketPath,
                                                        urlPath: endpoint.path,
                                                        body: endpoint.requestBody(),
                                                        logger: logger).get()
        return try decodeResponse(httpResponse, forEndpoint: endpoint)
    }
    
    private func decodeResponse<E: Endpoint>(_ response: HTTPClient.Response, forEndpoint endpoint: E) throws -> E.Response {
        if E.Response.self == EmptyBody.self {
            return EmptyBody() as! E.Response
        }
        
        guard let buffer = response.body,
              let data = buffer.getData(at: buffer.readerIndex, length: buffer.readableBytes) else {
            let errorMessage = "HTTP Response has an invalid body for endpoint: \(endpoint)"
            logger.error("\(errorMessage)")
            throw HTTPNetworkError.invalidResponseBody(errorMessage)
        }

        return try decoder.decode(E.Response.self, from: data)
    }
}
