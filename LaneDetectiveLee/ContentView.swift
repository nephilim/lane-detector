//
//  ContentView.swift
//  LaneDetectiveLee
//
//  Created by Dongwook Lee on 2019/12/25.
//  Copyright © 2019 Dable. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Image("camera_icon").padding(10.0)
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                 Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
