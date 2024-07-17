//
//  MainTabView.swift
//  Cheffi
//
//  Created by 정건호 on 6/10/24.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
    
    @Perception.Bindable var store: StoreOf<MainTabFeature> = .init(
        initialState: MainTabFeature.State()) {
            MainTabFeature()
        }

    
    @State private var selectedIndex: Int = 0
    @State private var oldIndex = 0
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                TabView(selection: $selectedIndex) {
                    ForEach(TabType.allCases, id: \.self) { type in
                        getTabView(type: type)
                            .tag(type.rawValue)
                            .tabItem {
                                VStack(spacing: 4) {
                                    selectedIndex == type.rawValue
                                    ? type.tabItem.selectedImage
                                    : type.tabItem.normalImage
                                    
                                    Text(type.tabItem.title)
                                        .foregroundStyle(Color.grey4)
                                        .font(.suit(.regular, 12))
                                }
                            }
                    }
                }
                .accentColor(Color.primary)
            }
            .fullScreenCover(isPresented: $store.presentRegisterView.sending(\.toggleRegisterView)) {
                Text("맛집등록 뷰")
                    .onTapGesture {
                        store.send(.toggleRegisterView(false))
                    }
            }
            .onChange(of: selectedIndex) { newIndex in
                if newIndex == TabType.write.rawValue {
                    store.send(.toggleRegisterView(true))
                    selectedIndex = oldIndex
                } else {
                    oldIndex = newIndex
                }
            }
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundImage = UIImage.borderForTabBar(color: Color.white)
                appearance.shadowImage = UIImage.borderForTabBar(color: Color.grey1)
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
    
    @ViewBuilder
    func getTabView(type: TabType) -> some View {
        switch type {
        case .home:
            HomeView()
        case .trend:
            Text("전국트렌트 탭")
        case .write:
            Text(String())
        case .myPage:
            Text("마이페이지 탭")
        }
    }
}

struct TabItemData {
    let normalImage: Image
    let selectedImage: Image
    let title: String
}

enum TabType: Int, CaseIterable {
    case home = 0
    case trend = 1
    case write = 2
    case myPage = 3
    
    var tabItem: TabItemData {
        switch self {
        case .home:
            return TabItemData(
                normalImage: Image(name: Tab.normalHome),
                selectedImage: Image(name: Tab.selectedHome),
                title: "홈"
            )
        case .trend:
            return TabItemData(
                normalImage: Image(name: Tab.normalTrend),
                selectedImage: Image(name: Tab.selectedTrend),
                title: "전국트렌드"
            )
        case .write:
            return TabItemData(
                normalImage: Image(name: Tab.write),
                selectedImage: Image(name: Tab.write),
                title: "맛집등록"
            )
        case .myPage:
            return TabItemData(
                normalImage: Image(name: Tab.normalMyPage),
                selectedImage: Image(name: Tab.selectedMyPage),
                title: "마이페이지"
            )
        }
    }
}

#Preview {
    MainTabView()
}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
