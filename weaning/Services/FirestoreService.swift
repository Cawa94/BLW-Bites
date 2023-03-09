//
//  FirestoreService.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import FirebaseCore
import FirebaseFirestore

struct FirestoreService {

    static let shared = FirestoreService()
    let database: Firestore

    init() {
        database = Firestore.firestore()
    }

}
