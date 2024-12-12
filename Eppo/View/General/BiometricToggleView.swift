//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI
import LocalAuthentication

struct BiometricToggleView: View {
    // MARK: - ENUM
    
    enum BiometricToggleViewActiveAlert {
        case remind
        case error
        case cancelError
        case success
    }
    
    // MARK: - PROPERTY
    @State private var biometricImageName: String = "touchid"
    @State var biometricToggleEnabled: Bool
    @State private var isConfirmBiometric = false
    @State private var isAlertShowing = false
    @State private var activeAlert: BiometricToggleViewActiveAlert = .remind
    
    init() {
        let credentials = KeychainManager.shared.getCredentials()
        if let currentUsername = UserSession.shared.username,
           credentials.username == currentUsername {
            self.biometricToggleEnabled = true
        } else {
            self.biometricToggleEnabled = false
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Image(systemName: biometricImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 30)
            
            Toggle(isOn: $biometricToggleEnabled) {
                Text("Xác thực sinh trắc học")
            }
            .onChange(of: biometricToggleEnabled) { _, isEnabled in
                if isEnabled {
                    enableBiometrics()
                } else {
                    // Action when the toggle is turned off
                    showAlert(activeAlert: .cancelError)
                }
            }
        }
        .fontWeight(.semibold)
        .foregroundStyle(.black)
        .padding()
        .background(.settingBoxBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.vertical)
        .alert(isPresented: $isAlertShowing) {
            switch activeAlert {
            case .remind:
                return Alert(title: Text("Các dữ liệu sinh trắc cũ của thiết bị này (nếu có) sẽ bị ghi đè. Bạn có chắc muốn bật xác thực sinh trắc không?"), primaryButton: .destructive(Text("Huỷ"), action: {
                    biometricToggleEnabled = false
                }), secondaryButton: .default(Text("Bật"), action: {
                    enableBiometricAuthentication()
                }))
            case .cancelError:
                return Alert(title: Text("Các dữ liệu sinh trắc cũ của thiết bị này (nếu có) sẽ xoá. Bạn có chắc muốn tắt xác thực sinh trắc không?"), primaryButton: .default(Text("Huỷ"), action: {
                    biometricToggleEnabled = false
                }), secondaryButton: .destructive(Text("Tắt"), action: {
                    disableBiometricAuthentication()
                }))
            case .error:
                return Alert(
                    title: Text("Enable Face ID/Touch ID"),
                    message: Text("To use biometric authentication, you need to enable Face ID/Touch ID for this app in your device settings."),
                    primaryButton: .default(Text("Go to Settings"), action: {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        }
                    }),
                    secondaryButton: .cancel()
                )
            case .success:
                return Alert(title: Text("Đã kích hoạt xác thực sinh trắc"))
            }
        }
    }
    
    func enableBiometricAuthentication() {
        BiometricAuthManager.shared.authenticateWithBiometrics { success, error in
            if success {
                // Lưu username và password vào Keychain
                if let username = UserSession.shared.myInformation?.userName,
                   let password = UserSession.shared.password {
                    KeychainManager.shared.saveCredentials(username: username, password: password)
                    showAlert(activeAlert: .success)
                }
            } else {
                if let error = error as? LAError {
                    print("Biometric error: \(error.localizedDescription)")
                    showAlert(activeAlert: .error)
                }
            }
        }
    }
    
    func disableBiometricAuthentication() {
        // Xoá thông tin tài khoản (username và password) khỏi Keychain
        KeychainManager.shared.clearCredentials()
    }
    
    
    func enableBiometrics() {
        if BiometricAuthManager.shared.canUseBiometricAuthentication() {
            showAlert(activeAlert: .remind)
        } else {
            // Biometric authentication is not available; guide the user to the device settings.
            showAlert(activeAlert: .error)
        }
    }
    
    func showAlert(activeAlert: BiometricToggleViewActiveAlert) {
        DispatchQueue.main.async {
            self.activeAlert = activeAlert
            self.isAlertShowing = true
        }
    }
    
    func setUpBiometricImage() {
        if BiometricAuthManager.shared.canUseBiometricAuthentication() {
            // Biometric authentication is available, you can enable a switch or a button to let the user turn it on.
            switch BiometricAuthManager.shared.getBiometricType() {
            case .faceID:
                biometricImageName = "faceid"
            case .touchID:
                biometricImageName = "touchid"
            case .opticID:
                biometricImageName = "opticid"
            default:
                biometricImageName = "gear.badge.xmark"
            }
        } else {
            biometricImageName = "gear.badge.xmark"
        }
    }
}

// MARK: - PREVIEW
#Preview {
    BiometricToggleView()
}
