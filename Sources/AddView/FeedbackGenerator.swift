//
//  FeedbackGenerator.swift
//  
//
//  Created by Senior Developer on 20.06.2023.
//

import UIKit

final class FeedbackGenerator {
    static func impactFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: style)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }

    static func notificationFeedback(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(notificationType)
    }
}
