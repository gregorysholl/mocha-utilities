//
//  MochaTaskManager.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 18/07/17.
//
//

import UIKit

// MARK: - Main

public class MochaTaskManager: NSObject {
    
    fileprivate let defaultProgressMessage = "Please wait..."
    
    fileprivate var baseTask    : MochaTask!
    
    fileprivate var activityIndicator   : UIActivityIndicatorView?
    
    fileprivate var customProgress  : UIView?
    
    fileprivate var progressDialog  : UIView?
    fileprivate var progressMessage : String?
    fileprivate var progressFont    : UIFont?
    
    fileprivate var cancellable : Bool = false
    fileprivate var offline     : Bool = false
    fileprivate var showDialog  : Bool = false
    
    fileprivate var operation   : BlockOperation!
    
    fileprivate override init() {
        super.init()
    }
    
    public func start() -> BlockOperation? {
        
        if baseTask == nil {
            MochaLogger.log("Please assign a MochaTask through the method setTask(_:) from MochaTaskManager.Builder class.")
            return nil
        }
        
        operation = BlockOperation(block: {
            return self.manage()
        })
        
        baseTask.operation = operation
        return operation
    }
    
    public func manage() {
        if operation.isCancelled {
            stopProgress(onMainThread: true)
            return
        }
        
        startProgress()
        
        if let preExecute = baseTask.preExecute {
            preExecute()
        }
        
        //TODO: Check why performSelector(onMainThread: #selector(preExecuteTask), with: nil, waitUntilDone: true) does not work
        
        if operation.isCancelled {
            stopProgress(onMainThread: true)
            return
        }
        
        do {
            try baseTask.execute()
            
            if operation.isCancelled {
                stopProgress(onMainThread: true)
                return
            }
            
            performSelector(onMainThread: #selector(updateViewTask), with: nil, waitUntilDone: true)
            
        } catch {
            if operation.isCancelled {
                stopProgress(onMainThread: true)
                return
            }
            
            DispatchQueue.main.async {
                if let onError = self.baseTask.error {
                    onError(error)
                }
                self.stopProgress(onMainThread: false)
            }
        }
    }
    
    @objc public func onCancel() {
        operation.cancel()
    }
    
    public func preExecuteTask() {
        if operation.isCancelled {
            return
        }
        
        startProgress()
        
        if let preExecute = baseTask.preExecute {
            preExecute()
        }
    }
    
    @objc public func updateViewTask() {
        if operation.isCancelled {
            return
        }
        
        baseTask.updateView()
        
        stopProgress(onMainThread: false)
    }
}

// MARK: - Builder

public extension MochaTaskManager {
    
    public class Builder {
        
        private var manager : MochaTaskManager!
        
        public init() {
            self.manager = MochaTaskManager()
        }
        
        public func setTask(_ task: MochaTask) -> Builder {
            manager.baseTask = task
            return self
        }
        
        public func setActivityIndicator(_ indicator: UIActivityIndicatorView?) -> Builder {
            manager.activityIndicator = indicator
            return self
        }
        
        public func setCustomProgress(_ view: UIView) -> Builder {
            manager.customProgress = view
            return self
        }
        
        public func setMessage(_ progressMessage: String) -> Builder {
            manager.progressMessage = progressMessage
            return self
        }
        
        public func setFont(_ progressFont: UIFont) -> Builder {
            manager.progressFont = progressFont
            return self
        }
        
        public func setCancellable(_ cancel: Bool) -> Builder {
            manager.cancellable = cancel
            return self
        }
        
        public func setShowDialog(_ dialog: Bool) -> Builder {
            manager.showDialog = dialog
            return self
        }
        
        public func build() -> MochaTaskManager {
            return manager
        }
    }
}

// MARK: - Layout

extension MochaTaskManager {
    
    fileprivate func startProgress() {
        if showDialog {
            showProgressView()
        } else {
            startActivityIndicator()
        }
    }
    
    fileprivate func stopProgress(onMainThread onMain: Bool) {
        if showDialog {
            hideProgressView(onMainThread: onMain)
        } else {
            cancelActivityIndicator(onMainThread: onMain)
        }
    }
    
    fileprivate func startActivityIndicator() {
        guard let activityIndicator = activityIndicator else {
            return
        }
        
        activityIndicator.startAnimating()
    }
    
    fileprivate func cancelActivityIndicator(onMainThread onMain: Bool) {
        if let activityIndicator = activityIndicator {
            if onMain {
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                }
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    fileprivate func showProgressView() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        if let customProgress = customProgress {
            
            customProgress.translatesAutoresizingMaskIntoConstraints = false
            
            window.addSubview(customProgress)
            
            let viewUpperConstraint = NSLayoutConstraint(item: customProgress, attribute: .top, relatedBy: .equal, toItem: window, attribute: .top, multiplier: 1.0, constant: 0.0)
            
            let viewLeadingConstraint = NSLayoutConstraint(item: customProgress, attribute: .leading, relatedBy: .equal, toItem: window, attribute: .leading, multiplier: 1.0, constant: 0.0)
            
            let viewTrailingConstraint = NSLayoutConstraint(item: customProgress, attribute: .trailing, relatedBy: .equal, toItem: window, attribute: .trailing, multiplier: 1.0, constant: 0.0)
            
            let viewLowerConstraint = NSLayoutConstraint(item: customProgress, attribute: .bottom, relatedBy: .equal, toItem: window, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            
            NSLayoutConstraint.activate([viewUpperConstraint, viewLeadingConstraint, viewTrailingConstraint, viewLowerConstraint])
            
            customProgress.layoutIfNeeded()
            
            return
        }
        
        guard progressDialog == nil else {
            return
        }
        
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor(rgbWithRed: 0, green: 0, blue: 0, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if cancellable {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCancel))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            
            view.addGestureRecognizer(tapGesture)
        }
        
        let dialog = UIView(frame: CGRect.zero)
        dialog.backgroundColor = UIColor.white
        dialog.layer.cornerRadius = 4.0
        dialog.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel(frame: CGRect.zero)
        label.text = progressMessage ?? defaultProgressMessage
        label.font = progressFont ?? UIFont.systemFont(ofSize: 17.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        dialog.addSubview(label)
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        dialog.addSubview(spinner)
        
        view.addSubview(dialog)
        
        window.addSubview(view)
        
        let viewUpperConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: window, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let viewLeadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: window, attribute: .leading, multiplier: 1.0, constant: 0.0)
        
        let viewTrailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: window, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        
        let viewLowerConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: window, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([viewUpperConstraint, viewLeadingConstraint, viewTrailingConstraint, viewLowerConstraint])
        
        let dialogLeadingConstraint = NSLayoutConstraint(item: dialog, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 25.0)
        
        let dialogTrailingConstraint = NSLayoutConstraint(item: dialog, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -25.0)
        
        let dialogCenterYConstraint = NSLayoutConstraint(item: dialog, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([dialogLeadingConstraint, dialogTrailingConstraint, dialogCenterYConstraint])
        
        let labelUpperConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: dialog, attribute: .top, multiplier: 1.0, constant: 16.0)
        
        let labelLeadingConstraint = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: dialog, attribute: .leading, multiplier: 1.0, constant: 16.0)
        
        let labelTrailingConstraint = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: dialog, attribute: .trailing, multiplier: 1.0, constant: -16.0)
        
        let labelBottomConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: spinner, attribute: .top, multiplier: 1.0, constant: -16.0)
        
        NSLayoutConstraint.activate([labelUpperConstraint, labelLeadingConstraint, labelTrailingConstraint, labelBottomConstraint])
        
        let spinnerBottomContraint = NSLayoutConstraint(item: spinner, attribute: .bottom, relatedBy: .equal, toItem: dialog, attribute: .bottom, multiplier: 1.0, constant: -16.0)
        
        let spinnerCenterXContraint = NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: dialog, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([spinnerBottomContraint, spinnerCenterXContraint])
        
        progressDialog = view
        progressDialog?.isHidden = false
        
        self.activityIndicator = spinner
        self.activityIndicator?.startAnimating()
        
        view.layoutIfNeeded()
    }
    
    fileprivate func hideProgressView(onMainThread onMain: Bool) {
        if let customProgress = customProgress {
            DispatchQueue.main.async {
                customProgress.isHidden = true
                customProgress.removeFromSuperview()
                
                self.customProgress = nil
            }
        }
        
        guard let progressDialog = progressDialog else {
            return
        }
        
        DispatchQueue.main.async {
            progressDialog.isHidden = true
            progressDialog.removeFromSuperview()
            
            self.activityIndicator?.stopAnimating()
            self.activityIndicator = nil
            self.progressDialog = nil
        }
    }
}
