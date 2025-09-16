# SecureVault
An intuitive iOS password manager app built with SwiftUI that securely stores and manages your login credentials locally on your device.

## Features
* **Secure Local Storage**: All passwords stored using iOS Keychain - nothing leaves your device
* **Master Password Protection**: Additional layer of security with master password
* **Smart Search**: Quickly find passwords by website name or username
* **Easy Password Management**: Add, view, edit, and delete passwords with intuitive UI
* **Auto-lock**: Automatically locks app after inactivity for enhanced security
* **Clean SwiftUI Interface**: Modern, user-friendly design built entirely with SwiftUI
* **Privacy Overlay**: Hides sensitive content when app is backgrounded
  
## Screenshots
**Privacy Overlay**  

<img width="322" height="615" alt="Privacy Overlay" src="https://github.com/user-attachments/assets/3bf030a3-f3cc-4574-95bf-0b09b7ae71a2" />  

**Master Password Login**  

<img width="322" height="615" alt="Master Password Login" src="https://github.com/user-attachments/assets/0134fc25-f444-400e-94af-18c25e58d3dc" />  

**Add Password**  

<img width="322" height="615" alt="Add Password" src="https://github.com/user-attachments/assets/68027057-9497-45e1-92a7-0d096ea432c6" />  

**Detailed View**  

<img width="322" height="615" alt="Detailed View" src="https://github.com/user-attachments/assets/f60fec05-ca04-43e8-8652-a5d429a4459a" />  

**Delete Password**  

<img width="322" height="615" alt="Delete Password" src="https://github.com/user-attachments/assets/b3dd25f3-9ff5-4e44-9e1d-4cb760380b83" />  

**Delete Selected Passwords**  

<img width="322" height="615" alt="Delete Selected Passwords" src="https://github.com/user-attachments/assets/10d71cc6-69e9-415e-9dd5-478329a13d10" />  

## Technologies Used
* **SwiftUI** - Modern declarative UI framework
* **iOS Keychain Services** - Secure local storage
* **Foundation** - Core iOS frameworks
* **Security Framework** - Keychain management

## Architecture
* **MVVM Pattern** - With SwiftUI
* **Keychain Manager** - Centralized secure storage
* **Auto-lock Manager** - Session management
* **Privacy Controls** - Background app security

## Project Structure

<img width="244" height="491" alt="Project Structure" src="https://github.com/user-attachments/assets/bc04df63-a9c4-4410-80bd-11f26a06b56b" />  

## Getting Started
**Prerequisites**
* Xcode 15.0+
* iOS 15.0+
* macOS for development
  
## Installation
1. **Clone the repository**: (bash \ git clone https://github.com/yourusername/SecureVault.git)
2. **Open the project**: (bash \ cd SecureVault \ open SecureVault.xcodeproj)
3. **Build and run**: Select your target device or simulator, and then press 'Cmd + R' or click the Run button

## Security Features
* **Local-Only Storage**: All data remains on your device using iOS Keychain
* **Encryption**: Passwords encrypted using iOS security standards
* **Auto-Lock**: Configurable timeout for automatic locking
* **Privacy Overlay**: Prevents screenshots and app preview in multitasking
* **Master Password**: Additional authentication layer

## How to Use
1. **First Launch**: Set up your master password
2. **Add Passwords**: Tap the "+" button to add new login credentials
3. **View Details**: Tap any password entry to view and copy credentials
4. **Search**: Use the search bar to quickly find specific passwords
5. **Bulk Management**: Use Edit mode to select and delete multiple passwords

## Contributing
This is a personal learning project, but feedback and suggestions are welcome!
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Disclaimer
This app is designed for educational purposes. While it implements iOS security best practices. Always use additional backup methods for critical passwords.

## Acknowledgements
* Built as part of iOS development learning journey
* Inspired by modern password manager design principles
* Uses Apple's recommended security practices
