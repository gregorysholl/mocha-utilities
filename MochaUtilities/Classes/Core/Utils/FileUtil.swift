//
//  FileUtil.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 19/07/17.
//
//

import UIKit

public class FileUtil {
    
    static public var bundle: BundleUtil.Type {
        return BundleUtil.self
    }
    
    static public var documents: DocumentsUtil {
        return DocumentsUtil()
    }
    
    private init() {}
}
