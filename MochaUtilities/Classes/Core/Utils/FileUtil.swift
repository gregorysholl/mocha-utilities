//
//  FileUtil.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 19/07/17.
//
//

import UIKit

public class FileUtil {
    
    public var bundle: BundleUtil {
        return BundleUtil()
    }
    
    public var documents: DocumentsUtil {
        return DocumentsUtil()
    }
    
    private init() {}
}
