//
//  SwiftUIView.swift
//  Restaurant_Guide
//
//  Created by Jes Muli on 2021-03-01.
//

import SwiftUI

struct SwiftUIView: View {
    
    @State private var progress = 0
    @State private var currentProgress = 0
    
    
    var body: some View {
        
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color(.secondarySystemBackground)
            }
            HStack {
                
            }
        }
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
