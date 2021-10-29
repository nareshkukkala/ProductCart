/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Venues : Codable {
	let id : String?
	let name : String?
	let contact : Contact?
	let location : Location?
	let categories : [Categories]?
	let verified : Bool?
	let stats : Stats?
	let beenHere : BeenHere?
	let venuePage : VenuePage?
	let hereNow : HereNow?
	let referralId : String?
	let venueChains : [VenuePageElement]?
	let hasPerk : Bool?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case contact = "contact"
		case location = "location"
		case categories = "categories"
		case verified = "verified"
		case stats = "stats"
		case beenHere = "beenHere"
		case venuePage = "venuePage"
		case hereNow = "hereNow"
		case referralId = "referralId"
		case venueChains = "venueChains"
		case hasPerk = "hasPerk"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		contact = try values.decodeIfPresent(Contact.self, forKey: .contact)
		location = try values.decodeIfPresent(Location.self, forKey: .location)
		categories = try values.decodeIfPresent([Categories].self, forKey: .categories)
		verified = try values.decodeIfPresent(Bool.self, forKey: .verified)
		stats = try values.decodeIfPresent(Stats.self, forKey: .stats)
		beenHere = try values.decodeIfPresent(BeenHere.self, forKey: .beenHere)
		venuePage = try values.decodeIfPresent(VenuePage.self, forKey: .venuePage)
		hereNow = try values.decodeIfPresent(HereNow.self, forKey: .hereNow)
		referralId = try values.decodeIfPresent(String.self, forKey: .referralId)
		venueChains = try values.decodeIfPresent([VenuePageElement].self, forKey: .venueChains)
		hasPerk = try values.decodeIfPresent(Bool.self, forKey: .hasPerk)
	}

}

// MARK: - VenuePageElement
struct VenuePageElement: Codable {
    let id: String
}
