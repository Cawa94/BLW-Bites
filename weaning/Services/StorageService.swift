//
//  StorageService.swift
//  weaning
//
//  Created by Yuri Cavallin on 12/2/23.
//

import FirebaseCore
import FirebaseStorage

struct StorageService {

    static let shared = StorageService()
    let storage: Storage

    init() {
        storage = Storage.storage()
    }

    func getReferenceFor(path: String) -> StorageReference {
        return storage.reference(forURL: path)
    }

}
