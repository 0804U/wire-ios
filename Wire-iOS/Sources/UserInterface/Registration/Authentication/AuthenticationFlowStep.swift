//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import Foundation

/**
 * Steps of the authentication flow.
 */

enum AuthenticationFlowStep: Equatable {

    // Initial Steps
    case start
    case landingScreen
    case reauthenticate(error: NSError, numberOfAccounts: Int)

    // Sign-In
    case provideCredentials
    case sendLoginCode(phoneNumber: String, isResend: Bool)
    case enterLoginCode(phoneNumber: String)
    case authenticateEmailCredentials(ZMEmailCredentials)
    case authenticatePhoneCredentials(ZMPhoneCredentials)
    case companyLogin

    // Post Sign-In
    case noHistory(credentials: ZMCredentials?, type: Wire.ContextType)
    case clientManagement(clients: [UserClient], credentials: ZMCredentials?)
    case removeClient
    case addEmailAndPassword(user: ZMUser, profile: UserProfileUpdateStatus, canSkip: Bool)
    case registerEmailCredentials(ZMEmailCredentials, isResend: Bool)
    case pendingEmailLinkVerification(ZMEmailCredentials)
    case verifyEmailChangeCode(ZMEmailCredentials)
    case pendingInitialSync

    // Registration
    case teamCreation(TeamCreationState)
    case createCredentials(UnregisteredUser)
    case sendActivationCode(UnverifiedCredential, user: UnregisteredUser, isResend: Bool)
    case enterActivationCode(UnverifiedCredential, user: UnregisteredUser)
    case activateCredentials(UnverifiedCredential, user: UnregisteredUser, code: String)
    case incrementalUserCreation(UnregisteredUser, IntermediateRegistrationStep)
    case createUser(UnregisteredUser)

    // MARK: - Properties

    /// Whether the step can be unwinded.
    var allowsUnwind: Bool {
        switch self {
        case .landingScreen, .clientManagement, .noHistory, .addEmailAndPassword, .incrementalUserCreation: return false
        case .enterLoginCode: return true
        case .createCredentials: return true
        case .enterActivationCode: return true
        case .provideCredentials: return true
        case .companyLogin: return true
        case .teamCreation(let teamState): return teamState.allowsUnwind
        default: return true
        }
    }

    /// Whether the authentication steps generates a user interface.
    var needsInterface: Bool {
        switch self {
        // Initial Steps
        case .start: return false
        case .landingScreen: return true
        case .reauthenticate: return true

        // Sign-In
        case .provideCredentials: return true
        case .sendLoginCode: return false
        case .enterLoginCode: return true
        case .authenticateEmailCredentials: return false
        case .authenticatePhoneCredentials: return false
        case .registerEmailCredentials: return false
        case .companyLogin: return false

        // Post Sign-In
        case .noHistory: return true
        case .clientManagement: return true
        case .removeClient: return false
        case .addEmailAndPassword: return true
        case .pendingInitialSync: return false
        case .pendingEmailLinkVerification: return true
        case .verifyEmailChangeCode: return false

        // Registration
        case .teamCreation(let teamState): return teamState.needsInterface
        case .createCredentials: return true
        case .sendActivationCode: return false
        case .enterActivationCode: return true
        case .activateCredentials: return false
        case .incrementalUserCreation(_, let intermediateStep): return intermediateStep.needsInterface
        case .createUser: return false
        }
    }

}

// MARK: - Intermediate Steps

/**
 * Intermediate steps required for user registration.
 */

enum IntermediateRegistrationStep: Equatable {
    case start, reviewTermsOfService, provideMarketingConsent, setName, setProfilePicture

    var needsInterface: Bool {
        switch self {
        case .start: return false
        case .provideMarketingConsent: return false
        default : return true
        }
    }
}
