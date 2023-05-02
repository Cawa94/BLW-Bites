//
//  AppCheckProvider.swift
//  weaning
//
//  Created by Yuri Cavallin on 2/5/23.
//

import FirebaseAppCheck
import FirebaseCore

class AppCheckProviderService: NSObject, AppCheckProviderFactory {

    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        return AppAttestProvider(app: app)
    }

}
