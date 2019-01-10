//
//  FileUtil.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 19/07/17.
//
//

import UIKit

public class FileUtil {
    
    public static var bundle: BundleUtil.Type {
        return BundleUtil.self
    }
    
    public static var documents: DocumentsUtil {
        return DocumentsUtil()
    }
    
    private init() {}
}
