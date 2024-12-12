//
//  BiometricAuthManager.swift
//  Eppo
//
//  Created by Letter on 12/12/2024.
//

import Foundation

import LocalAuthentication

class BiometricAuthManager {
    static let shared = BiometricAuthManager()
    
    // UserDefaults key for the switch state
    private let biometricSwitchKey = "biometricSwitchState"
    
    private init() {}
    
    // Function to set the state of the biometric switch
    func setBiometricSwitchState(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: biometricSwitchKey)
    }
    
    // Function to get the state of the biometric switch
    func isBiometricSwitchOn() -> Bool {
        return UserDefaults.standard.bool(forKey: biometricSwitchKey)
    }
    
    func canUseBiometricAuthentication() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    func getBiometricType() -> LABiometryType {
        let context = LAContext()
        return context.biometryType
    }
    func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate using Face ID or Touch ID") { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
    
    func showBiometricsSettingsAlert() {
        
    }
}
