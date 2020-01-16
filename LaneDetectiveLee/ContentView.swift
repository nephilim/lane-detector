//
//  ContentView.swift
//  LaneDetectiveLee
//
//  Created by Dongwook Lee on 2019/12/25.
//  Copyright © 2019 Dable. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var capturedImage: UIImage?
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Spacer()
                CameraCaptureImageView(capturedImage: self.$capturedImage).padding(10.0)
                Spacer()
            }
            Spacer()
            HStack(alignment: .center){
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text(/*@START_MENU_TOKEN@*/"BUTTON"/*@END_MENU_TOKEN@*/)
                }
                Spacer()
            }
            Spacer()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return EmptyView()
    }
}
