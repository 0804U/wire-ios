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

extension ZMUserSession {
    
    @objc var isCallOngoing: Bool {
        guard let callCenter = callCenter else { return false }
        
        return !callCenter.activeCallConversations(in: self).isEmpty
    }
    
    @objc var ongoingCallConversation: ZMConversation? {
        guard let callCenter = self.callCenter else { return nil }
        
        return callCenter.nonIdleCallConversations(in: self).first { (conversation) -> Bool in
            guard let callState = conversation.voiceChannel?.state else { return false }
            
            switch callState {
            case .answered, .established, .establishedDataChannel, .outgoing:
                return true
            default:
                return false
            }
        }
    }
    
    @objc var ringingCallConversation: ZMConversation? {
        guard let callCenter = self.callCenter else { return nil }
        
        return callCenter.nonIdleCallConversations(in: self).first { (conversation) -> Bool in
            guard let callState = conversation.voiceChannel?.state else { return false }
            
            switch callState {
            case .incoming, .outgoing:
                return true
            default:
                return false
            }
        }
    }
}
