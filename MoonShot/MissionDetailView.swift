//
//  MissionDetailView.swift
//  MoonShot
//
//  Created by Chad Smith on 5/25/21.
//

import SwiftUI

struct MissionDetailView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
        
        var isCommander: Bool {
            if role == "Commander" || role == "Command Pilot" {
                return true
            }
            
            return false
        }
    }

    let mission: Mission
    let astronauts: [CrewMember]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.7 )
                        .padding(.top)
                    Text(self.mission.formattedLaunchDate)
                    Text(self.mission.description)
                        .padding()
                    
                    Text("Crew Members")
                        .font(.title)
                    VStack {
                        ForEach(self.astronauts, id: \.role) { crewMember in
                            NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                                HStack {
                                    Image(crewMember.astronaut.id)
                                        .resizable()
                                        .frame(width: 83, height: 60)
                                        .clipShape(Capsule())
                                        .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(crewMember.astronaut.name)
                                                .font(.headline)
                                            if crewMember.isCommander {
                                                Image(systemName: "star.circle.fill")
                                                    .renderingMode(.original)
                                                    .font(.largeTitle)
                                                    .padding(.leading)
                                            }
                                        }
                                        Text(crewMember.role)
                                            .foregroundColor(.secondary)
                                        
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                        }
                    }
                    .frame(width: 375, height: 275)
                    .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.black)
                        )
                    
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        for member in mission.crew {
            if let match = astronauts.first(where: {$0.id == member.name}) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing member: \(member)")
            }
        }
        
        self.astronauts = matches
    }
}

struct MissionDetailView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionDetailView(mission: missions[0], astronauts: astronauts)
    }
}
