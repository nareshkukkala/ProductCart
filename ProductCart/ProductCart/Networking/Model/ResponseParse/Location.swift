/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Location : Codable {
	let address : String?
	let crossStreet : String?
	let lat : Double?
	let lng : Double?
	let labeledLatLngs : [LabeledLatLngs]?
	let distance : Int?
	let postalCode : String?
	let cc : String?
	let city : String?
	let state : String?
	let country : String?
	let formattedAddress : [String]?

	enum CodingKeys: String, CodingKey {

		case address = "address"
		case crossStreet = "crossStreet"
		case lat = "lat"
		case lng = "lng"
		case labeledLatLngs = "labeledLatLngs"
		case distance = "distance"
		case postalCode = "postalCode"
		case cc = "cc"
		case city = "city"
		case state = "state"
		case country = "country"
		case formattedAddress = "formattedAddress"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		crossStreet = try values.decodeIfPresent(String.self, forKey: .crossStreet)
		lat = try values.decodeIfPresent(Double.self, forKey: .lat)
		lng = try values.decodeIfPresent(Double.self, forKey: .lng)
		labeledLatLngs = try values.decodeIfPresent([LabeledLatLngs].self, forKey: .labeledLatLngs)
		distance = try values.decodeIfPresent(Int.self, forKey: .distance)
		postalCode = try values.decodeIfPresent(String.self, forKey: .postalCode)
		cc = try values.decodeIfPresent(String.self, forKey: .cc)
		city = try values.decodeIfPresent(String.self, forKey: .city)
		state = try values.decodeIfPresent(String.self, forKey: .state)
		country = try values.decodeIfPresent(String.self, forKey: .country)
		formattedAddress = try values.decodeIfPresent([String].self, forKey: .formattedAddress)
	}

}