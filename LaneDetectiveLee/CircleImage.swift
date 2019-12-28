//
//  CircleImage.swift
//  LaneDetectiveLee
//
//  Created by Dongwook Lee on 2019/12/27.
//  Copyright © 2019 Dable. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("dongwook_profile")
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10.0)
        
        
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
