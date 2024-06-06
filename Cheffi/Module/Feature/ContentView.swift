//
//  ContentView.swift
//  Cheffi
//
//  Created by 정건호 on 5/28/24.
//

import SwiftUI
import Combine
import Alamofire

struct ContentView: View {
    
    let networkClient = NetworkClient()
    
    @State var cancellable: Set<AnyCancellable> = []
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            networkClient.request(CheffiAPI.testAuth, type: TestResponse.self)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("finished")
                    case .failure(let failure):
                        print(failure)
                    }
                }, receiveValue: { response in
                    print(response)
                })
                .store(in: &cancellable)
        }
    }
}

#Preview {
    ContentView()
}

struct TestResponse: Codable {
    let data: String
    let code: Int
    let message: String
}
