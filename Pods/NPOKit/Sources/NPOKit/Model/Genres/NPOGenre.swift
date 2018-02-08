//
//  NPOGenre.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 30/06/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public enum NPOGenre: Int {
    enum NPOSubGenre {
        case movie(Int)         // Film
        case series(Int)        // Series
        case sport(Int)         // Sport
        case music(Int)         // Muziek
        case amusement(Int)     // Amusement
        case informative(Int)   // Informatief / Sport informatie
        case documentary(Int)   // Documentaire
        
        case thriller(Int)      // Spanning
        case animation(Int)     // Animatie
        case drama(Int)         // Drama
        case humor(Int)         // Komisch
        
        case soap(Int)          // Soap serie
        case detective(Int)     // Detectives
        
        case game(Int)          // Spel / Quiz / (Sport) wedstrijd
        
        case classical(Int)     // Muziek - Klassiek
        case popular(Int)       // Muziek - Populair
        
        case standUp(Int)       // Cabaret
        
        case news(Int)          // Nieuws / actualiteiten
        case health(Int)        // Gezondheid / opvoeding
        case food(Int)          // Koken / eten
        case art(Int)           // Kunst / cultuur
        case nature(Int)        // Natuur
        case religious(Int)     // Religieus
        case science(Int)       // Wetenschap
        case consumerInfo(Int)  // Consumenten informatie
        case travel(Int)        // Reizen
        case history(Int)       // Geschiedenis
        case home(Int)          // Wonen / tuin
    }
    
    case youth = 1              // Jeugd
    case film = 12              // Film
    case series = 17            // Serie
    case sport = 23             // Sport
    case music = 26             // Muziek
    case amusement = 29         // Amusement
    case informative = 33       // Informatief
    case documentary = 46       // Documentaire
    
    func all() -> [NPOGenre] {
        return [.youth, .film, .series, .sport, .music, .amusement, .informative, .documentary]
    }
    
    func subgenres() -> [NPOSubGenre] {
        switch self {
        case .youth:
            return [.movie(12), .series(17), .sport(23), .music(26), .amusement(29), .informative(33), .documentary(46)]
        case .film:
            return [.thriller(14), .animation(15), .drama(16), .humor(13)]
        case .series:
            return [.thriller(19), .animation(20), .drama(21), .soap(22), .humor(18), .detective(55)]
        case .sport:
            return [.informative(24), .game(25)]
        case .music:
            return [.classical(27), .popular(28)]
        case .amusement:
            return [.game(30), .standUp(31), .humor(32)]
        case .informative:
            return [.game(34), .news(35), .health(36), .food(37), .art(38), .nature(39), .religious(40), .science(41),
                    .consumerInfo(42), .travel(43), .history(44), .home(45)]
        case .documentary:
            return [.health(47), .food(48), .art(49), .nature(50), .religious(51), .science(52), .travel(53), .history(54)]
        }
    }
}

//enum NPOSubgenre: Int {
//    case humor
//    case thriller
//    case animation
//    case drama
//    case soap
//    case detective = 38
//}
//
//enum NPOGenre: Int {
//    // Jeugd
//    case youth = 1
//    case animation = 4
//    case gameQuiz = 10
//    case movie = 2
//    case nature = 11
//    case series = 3
//    case sport = 5
//    case music = 6
//    case amusement = 7
//    case informative = 8
//    case documentary = 9
//
//    // Film
//    case film = 12
//    case humor = 13
//    case thriller = 14
//    case animation = 15
//    case drama = 16
//
//    // Serie
//    case series = 17
//    case humor = 18
//    case thriller = 19
//    case animation = 20
//    case drama = 21
//    case soap = 22
//    case detective = 55
//
//    // Sport
//    case sport = 23
//    case information = 24
//    case match = 25
//
//    // Music
//    case music = 26
//    case classic = 27
//    case popular = 28
//
//    // Amusement
//    case amusement = 29
//    case game = 30          // Spel/Quiz
//    case standup = 31       // Cabaret
//    case humor = 32         // Komisch
//
//    // Informatief
//    case informative = 33
//    case game = 34          // Spel/Quiz
//    case news = 35          // Nieuws/Actualiteiten
//    case health = 36        // Gezondheid/opvoeding
//    case food = 37          // Koken/eten
//    case art = 38           // Kunst/cultuur
//    case nature = 39        // Natuur
//    case religious = 40     // Religieus
//    case science = 41       // Wetenschap
//    case consumerInformation = 42   // Consumenten informatie
//    case travel = 43        // Reizen
//    case history = 44       // Geschiedenis
//    case home = 45          // Wonen/Tuin
//
//    // Documentaire
//    case documentary = 46
//    case health = 47        // Gezondheid/opvoeding
//    case food = 48          // Koken/eten
//    case art = 49           // Kunst/cultuur
//    case nature = 50        // Natuur
//    case religious = 51     // Religieus
//    case science = 52       // Wetenschap
//    case travel = 53        // Reizen
//    case history = 54       // Geschiedenis
//}
