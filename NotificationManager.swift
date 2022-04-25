//
//  NotificationManager.swift
//  WWDC-Brainstorming
//
//  Created by Sam Burkhard on 4/13/22.
//

import UserNotifications

import Foundation

class NotificationManager {
    
    static let shared = NotificationManager()
    
    func requestAuth() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func scheduleIndicatorNotification(notificationString: String) {
        let date = Date().addingTimeInterval(1.0)
        scheduleNotification(dateInterval: date, notificationString: notificationString)
    }
    
    func scheduleNotification(dateInterval: Date, notificationString: String) {
        let content = UNMutableNotificationContent()
        content.title = "Concentrate"
        content.body = notificationString
        let categoryIdentifier = UUID().uuidString
        content.categoryIdentifier = categoryIdentifier
        content.sound = .none
        content.interruptionLevel = .active
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: dateInterval)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
