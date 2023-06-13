//
//  Food.swift
//  weaning
//
//  Created by Yuri Cavallin on 11/2/23.
//

import Foundation

public struct Food: Codable {

    let id: String?
    let name: String?
    let image: String?
    let video: String?
    let description: String?
    let category: String?
    let startingFrom: String?
    let ageDictionary: AgeDictionary?
    let infosDictionary: FoodInfosDictionary?
    let recipes: [ShortRecipe]?
    let properties: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case video
        case description
        case category
        case startingFrom = "starting_from"
        case ageDictionary = "age_dictionary"
        case infosDictionary = "infos_dictionary"
        case recipes
        case properties
    }

    init(data: [String: Any]) {
        self.id = data["id"] as? String
        self.name = data["name"] as? String
        self.image = data["image"] as? String
        self.video = data["video"] as? String
        self.description = data["description"] as? String
        self.category = data["category"] as? String
        self.startingFrom = data["starting_from"] as? String
        self.ageDictionary = Food.buildAgeDictionary(data)
        self.infosDictionary = Food.buildFoodInfosDictionary(data)
        self.recipes = data["recipes"] as? [ShortRecipe]
        self.properties = data["properties"] as? [String]
    }

    init(id: String?,
         name: String?,
         image: String?,
         video: String?,
         description: String?,
         category: String?,
         startingFrom: String?,
         ageDictionary: AgeDictionary?,
         infosDictionary: FoodInfosDictionary?,
         recipes: [ShortRecipe],
         properties: [String]?) {
        self.id = id
        self.name = name
        self.image = image
        self.video = video
        self.description = description
        self.category = category
        self.startingFrom = startingFrom
        self.ageDictionary = ageDictionary
        self.infosDictionary = infosDictionary
        self.recipes = recipes
        self.properties = properties
    }

    static func buildAgeDictionary(_ data: [String: Any]) -> AgeDictionary? {
        let dictionary = data["age_dictionary"] as? [String: Any]
        var first: AgeSegment?
        var second: AgeSegment?
        var third: AgeSegment?
        if let firstDictionary = dictionary?["first"] as? [String: Any] {
            first = AgeSegment(months: firstDictionary["months"] as? String, description: firstDictionary["description"] as? String, pictures: firstDictionary["pictures"] as? [String])
        }
        if let secondDictionary = dictionary?["first"] as? [String: Any] {
            second = AgeSegment(months: secondDictionary["months"] as? String, description: secondDictionary["description"] as? String, pictures: secondDictionary["pictures"] as? [String])
        }
        if let thirdDictionary = dictionary?["first"] as? [String: Any] {
            third = AgeSegment(months: thirdDictionary["months"] as? String, description: thirdDictionary["description"] as? String, pictures: thirdDictionary["pictures"] as? [String])
        }
        return .init(first: first, second: second, third: third)
    }

    static func buildFoodInfosDictionary(_ data: [String: Any]) -> FoodInfosDictionary? {
        let dictionary = data["infos_dictionary"] as? [String: Any]
        var first: InfoSection?
        var second: InfoSection?
        var third: InfoSection?
        var fourth: InfoSection?
        var fifth: InfoSection?
        var sixth: InfoSection?
        var seventh: InfoSection?
        if let firstDictionary = dictionary?["first"] as? [String: Any] {
            first = InfoSection(title: firstDictionary["title"] as? String, description: firstDictionary["description"] as? String)
        }
        if let secondDictionary = dictionary?["second"] as? [String: Any] {
            second = InfoSection(title: secondDictionary["title"] as? String, description: secondDictionary["description"] as? String)
        }
        if let thirdDictionary = dictionary?["third"] as? [String: Any] {
            third = InfoSection(title: thirdDictionary["title"] as? String, description: thirdDictionary["description"] as? String)
        }
        if let fourthDictionary = dictionary?["fourth"] as? [String: Any] {
            fourth = InfoSection(title: fourthDictionary["title"] as? String, description: fourthDictionary["description"] as? String)
        }
        if let fifthDictionary = dictionary?["fifth"] as? [String: Any] {
            fifth = InfoSection(title: fifthDictionary["title"] as? String, description: fifthDictionary["description"] as? String)
        }
        if let sixthDictionary = dictionary?["sixth"] as? [String: Any] {
            sixth = InfoSection(title: sixthDictionary["title"] as? String, description: sixthDictionary["description"] as? String)
        }
        if let seventhDictionary = dictionary?["seventh"] as? [String: Any] {
            seventh = InfoSection(title: seventhDictionary["title"] as? String, description: seventhDictionary["description"] as? String)
        }
        return .init(first: first, second: second, third: third, fourth: fourth, fifth: fifth, sixth: sixth, seventh: seventh)
    }

}

extension Food {

    var asShortFood: ShortFood {
        .init(id: id, name: name, image: image, category: category, startingFrom: startingFrom, properties: properties)
    }

    var hasAgeDictionary: Bool {
        ageDictionary != nil
    }

    var hasInfosDictionary: Bool {
        infosDictionary != nil
    }

    var hasRecipes: Bool {
        false // !(recipes?.isEmpty ?? true)
    }

    var hasDescription: Bool {
        !(description?.isEmpty ?? true)
    }

    var categoryImage: String {
        FoodCategory.allValues.first(where: { $0.id == category ?? "" })?.imageName ?? ""
    }

    var isFree: Bool {
        properties?.contains(where: { $0 == "free" }) ?? false
    }

    var isNew: Bool {
        properties?.contains(where: { $0 == "new" }) ?? false
    }

    var isSeasonal: Bool {
        properties?.contains(where: { $0 == "seasonal" }) ?? false
    }

    var isFavorite: Bool {
        UserDefaultsService.favoriteFoods.contains(where: { $0 == id })
    }

    var ageSegments: [AgeSegment] {
        var segments: [AgeSegment] = []
        if let first = ageDictionary?.first {
            segments.append(first)
        }
        if let second = ageDictionary?.second {
            segments.append(second)
        }
        if let third = ageDictionary?.third {
            segments.append(third)
        }
        return segments
    }

    var infoSections: [InfoSection] {
        var infos: [InfoSection] = []
        if let first = infosDictionary?.first {
            infos.append(first)
        }
        if let second = infosDictionary?.second {
            infos.append(second)
        }
        if let third = infosDictionary?.third {
            infos.append(third)
        }
        if let fourth = infosDictionary?.fourth {
            infos.append(fourth)
        }
        if let fifth = infosDictionary?.fifth {
            infos.append(fifth)
        }
        if let sixth = infosDictionary?.sixth {
            infos.append(sixth)
        }
        if let seventh = infosDictionary?.seventh {
            infos.append(seventh)
        }
        return infos
    }

}
