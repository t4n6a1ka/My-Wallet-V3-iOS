//
//  CrashlyticsRecorder.swift
//  Blockchain
//
//  Created by Daniel Huri on 24/06/2019.
//  Copyright © 2019 Blockchain Luxembourg S.A. All rights reserved.
//

import Foundation
import FirebaseCrashlytics
import ToolKit
import PlatformKit

/// Crashlytics implementation of `Recording`. Should be injected as a service.
final class CrashlyticsRecorder: Recording {

    // MARK: - Properties
    
    private let crashlytics: Crashlytics
    
    // MARK: - Setup
    
    init(crashlytics: Crashlytics = Crashlytics.crashlytics()) {
        self.crashlytics = crashlytics
    }
    
    // MARK: - ErrorRecording
    
    /// Records error using Crashlytics.
    /// If the only necessary recording data is the context, just call `error()` with no `error` parameter.
    /// - Parameter error: The error to be recorded by the crash service. defaults to `BreadcrumbError` instance.
    func error(_ error: Error) {
        crashlytics.record(error: error as NSError)
    }
    
    /// Breadcrumbs an error
    func error() {
        error(RecordingError.breadcrumb)
    }
    
    /// Record a custom error message
    func error(_ errorMessage: String) {
        error(RecordingError.message(errorMessage))
    }

    // MARK: - MessageRecording
    
    /// Records any type of message.
    /// If the only necessary recording data is the context, just call `record()` with no `message` parameter.
    /// - Parameter message: The message to be recorded by the crash service. defaults to an empty string.
    func record(_ message: String) {
        crashlytics.log(message)
    }
    
    /// Breadcrumbs a message
    func record() {
        record("")
    }
    
    // MARK: - UIOperationRecording
    
    /// Should be called if there is a suspicion that a UI action is performed on a background thread.
    /// In such case, a non-fatal error will be recorded.
    func recordIllegalUIOperationIfNeeded() {
        guard !Thread.isMainThread else {
            return
        }
        error(RecordingError.changingUIOnBackgroundThread)
    }
}
