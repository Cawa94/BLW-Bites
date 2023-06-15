//
//  FirebaseAnalytics.swift
//  weaning
//
//  Created by Yuri Cavallin on 15/6/23.
//

import FirebaseAnalytics

class FirebaseAnalytics {

    static let shared = FirebaseAnalytics()

    private init() { }

    func trackScreenView(screenName: String? = nil, className: String) {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                            AnalyticsParameterScreenName: screenName != nil
                            ? "\(screenName ?? "")" : className.replacingOccurrences(of: "ViewController", with: ""),
                            AnalyticsParameterScreenClass: screenName != nil
                            ? "\(screenName ?? "")" : className.replacingOccurrences(of: "ViewController", with: "")])
    }

}
