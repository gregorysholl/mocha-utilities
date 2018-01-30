//
//  SynchronousHttpClient.swift
//  MochaUtilities
//
//  Created by Gregory Sholl e Santos on 30/01/18.
//

import UIKit

internal protocol SyncDataTask {
    func executeDataTask(with request: URLRequest,
                         and session: URLSession) -> Result<Data>
}

internal class SynchronousHttpClient: NSObject {
    
    fileprivate var semaphore: DispatchSemaphore!
    
    fileprivate var responseResult: Result<Data>!
    
    override internal init() {
        super.init()

        semaphore = DispatchSemaphore(value: 0)
    }
}

extension SynchronousHttpClient: SyncDataTask {
    
    internal func executeDataTask(with request: URLRequest,
                                  and session: URLSession) -> Result<Data> {
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    self.responseResult = .failure(.httpResponse(
                        statusCode: httpResponse.statusCode,
                        data: data))
                }
            }
            
            if let error = error {
                MochaLogger.log("Http error: \(error.localizedDescription)")
                self.responseResult = .failure(.error(error: error))
            }
            
            if let data = data {
                self.responseResult = .success(data)
            }
            
            self.semaphore.signal()
        })
        
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        session.finishTasksAndInvalidate()
        
        return responseResult
    }
}

extension SynchronousHttpClient: URLSessionDelegate {

    internal func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        guard let error = error else {
            return
        }
        
        responseResult = .failure(.error(error: error))
        semaphore.signal()
    }
}
