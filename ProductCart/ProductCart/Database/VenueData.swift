//
//  ContentView.swift
//  VenueData
//
//  Created by naresh kukkala on 21/08/21.
//


import Foundation

class VenueData
{
    var id: String = ""
    var venue: Venues?
    
    init(id:String, venue:Venues)
    {
        self.id = id
        self.venue = venue
    }
    
}
