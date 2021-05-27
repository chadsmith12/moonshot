//
//  ContentView.swift
//  MoonShot
//
//  Created by Chad Smith on 5/23/21.
//

import SwiftUI

struct ContentView: View {
    let astronauts:[Astronaut] = Bundle.main.decode("astronauts.json")
    let missions:[Mission] = Bundle.main.decode("missions.json")
    @State private var showLaunchDates = false
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionDetailView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        getSubHeaderText(mission: mission)

                    }
                }
            }
            .navigationBarTitle("Moonshot")
            .toolbar {
                Button(buttonText) {
                    self.showLaunchDates.toggle()
                }
            }
        }
    }
    
    var buttonText: String {
        if showLaunchDates {
            return "Show Launch Dates"
        }
        
        return "Show Crew Members"
    }
    
    func getSubHeaderText(mission: Mission) -> some View {
        if showLaunchDates {
            var matches = [Astronaut]()
            for member in mission.crew {
                if let match = astronauts.first(where: {$0.id == member.name}) {
                    matches.append(match)
                }
            }
            
            let crewMembers = matches.map { member in
                String(member.name)
            }.joined(separator: ",")
            
            return Text(crewMembers)
                .font(.caption2)
        }
        
        return Text(mission.formattedLaunchDate)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
