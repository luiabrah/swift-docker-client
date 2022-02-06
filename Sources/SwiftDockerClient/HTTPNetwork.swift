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
import NIOHTTP1
import SwiftDockerClientModel

public protocol HTTPNetworking {
    func execute<E: Endpoint>(_ endpoint: E) async throws -> E.Response
    func execute<E: Endpoint>(_ endpoint: E, onSocketPath socketPath: String) async throws -> E.Response
}

public enum HTTPNetworkError: Error {
    case invalidResponseBody(String)
    case invalidURL(String)
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
        logger.info("Executing request on socket path \(socketPath) for endpoint \(endpoint)")
        
        let request = try createRequest(for: endpoint, onSocketPath: socketPath)
        let httpResponse = try await httpClient.execute(request: request, logger: logger).get()
        
        logger.info("Received HTTP Response: \(httpResponse) with status: \(httpResponse.status.code) \(httpResponse.status.reasonPhrase)")
        
        return try decodeResponse(httpResponse, forEndpoint: endpoint)
    }
    
    private func decodeResponse<E: Endpoint>(_ response: HTTPClient.Response, forEndpoint endpoint: E) throws -> E.Response {
        // Check response status code
        try response.checkStatusCode()
        
        if E.Response.self == EmptyBody.self {
            return EmptyBody() as! E.Response
        }
        
        guard let data = response.bodyData() else {
            let errorMessage = "HTTP Response has an invalid body for endpoint: \(endpoint)"
            logger.error("\(errorMessage)")
            throw HTTPNetworkError.invalidResponseBody(errorMessage)
        }

        if let responseString = data.prettyPrintedJSONString {
            logger.info("Received \(responseString)")
        }
        
        return try decoder.decode(E.Response.self, from: data)
    }
    
    private func createRequest<E: Endpoint>(for endpoint: E, onSocketPath socketPath: String) throws -> HTTPClient.Request {
        let headers = HTTPHeaders([("Content-Type", "application/json")])
        
        guard let url = URL(httpURLWithSocketPath: socketPath, uri: endpoint.path) else {
            let errorMessage = "Invalid URL for \(socketPath)\(endpoint.path)"
            logger.error("\(errorMessage)")
            throw HTTPNetworkError.invalidURL(errorMessage)
        }
        
        return try HTTPClient.Request(url: url,
                                      method: endpoint.method,
                                      headers: headers,
                                      body: endpoint.requestBody())
    }
    

}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

extension HTTPClient.Response {
    func checkStatusCode() throws {
        if (200...299).contains(self.status.code) {
            return
        }
        
        // Not modified isn't an error state
        if self.status.code == 304 {
            return
        }
        
        // Response is an error
        var errorMessage = ""
        if let reponseBody = self.bodyData(),
           let dockerResponse = try? JSONDecoder().decode(DockerResponse.self, from: reponseBody) {
            errorMessage = dockerResponse.message
        }
        
        switch self.status.code {
            case 400:
                throw DockerAPIError.invalidRequest(errorMessage)
            case 404:
                throw DockerAPIError.resourceNotFound(errorMessage)
            default:
                throw DockerAPIError.serverError(errorMessage)
        }
    }
    
    func bodyData() -> Data? {
        guard let buffer = self.body,
              let data = buffer.getData(at: buffer.readerIndex, length: buffer.readableBytes) else {
                  return nil
              }
        
        return data
    }
}
