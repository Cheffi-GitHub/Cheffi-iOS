//
//  ReviewDetailView.swift
//  Cheffi
//
//  Created by 정건호 on 6/18/24.
//

import SwiftUI

struct ReviewDetailView: View {
    private let screenWidth = UIWindow().screen.bounds.width
    
    @State private var selection = 0
    private let imageCount = 5
    
    @State private var scrollOffset: CGFloat = 0
    @State private var scale: CGFloat = 1
    @State private var navigationBarOpacity: CGFloat = 0
    
    private var navigationForegroundColor: Color {
        Color(white: Double(1 - navigationBarOpacity))
    }
    
    private var navigationBackgroundColor: Color {
        Color.black.opacity(0.5 * Double(1 - navigationBarOpacity))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Image(name: Common.leftArrow)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(navigationForegroundColor)
                    .frame(width: 24, height: 24)
                    .padding(8)
                    .background(navigationBackgroundColor)
                    .clipShape(.rect(cornerRadius: 20))
                Spacer()
                Image(name: Review.dots)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(navigationForegroundColor)
                    .frame(width: 24, height: 24)
                    .padding(8)
                    .background(navigationBackgroundColor)
                    .clipShape(.rect(cornerRadius: 20))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
            .background(Color.white.opacity(navigationBarOpacity))
            .zIndex(1)
            
            ScrollViewOffset(onOffsetChange: { offset in
                scrollOffset = offset
                scale = max(0, scrollOffset / screenWidth) + 1
            }) {
                ZStack {
                    TabView(selection: $selection) {
                        ForEach(0..<5) { _ in
                            Image(name: Dummy.sample)
                                .resizable()
                                .scaledToFill()
                                .frame(width: screenWidth * scale, height: screenWidth * scale)
                                .clipped()
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        Text("취향일치 60%")
                            .font(.suit(.bold, 14))
                            .foregroundStyle(Color.white)
                            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                            .background(Color.black.opacity(0.32))
                            .clipShape(.rect(cornerRadius: 20))
                            .padding(.bottom, 5)
                        Text("그시절낭만의근본 경양식 돈가스")
                            .font(.suit(.bold, 24))
                            .foregroundStyle(Color.white)
                            .lineLimit(2)
                            .padding(.vertical, 5)
                            .padding(.bottom, 3)
                            .background(
                                GeometryReader { geometry -> Color in
                                    let maxY = geometry.frame(in: .global).midY
                                    DispatchQueue.main.async {
                                        navigationBarOpacity = max(0, (-maxY + 40) / 100)
                                    }
                                    return Color.clear
                                }
                            )
                        HStack {
                            Text("1시간 전")
                                .font(.suit(.medium, 14))
                                .foregroundStyle(Color.grey3)
                            Spacer()
                            HStack(spacing: 0) {
                                Text("\(selection + 1)")
                                    .font(.suit(.medium, 14))
                                    .foregroundStyle(Color.white)
                                Text("/\(imageCount)")
                                    .font(.suit(.medium, 14))
                                    .foregroundStyle(Color.grey1)
                            }
                            .padding(EdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10))
                            .background(Color.black.opacity(0.32))
                            .clipShape(.rect(cornerRadius: 20))
                        }
                        .padding(.bottom, 16)
                    }
                    .padding(.horizontal, 16)
                }
                .frame(width: screenWidth, height: screenWidth + (scrollOffset > 0 ? scrollOffset : 0))
                .offset(y: (scrollOffset > 0 ? -scrollOffset : 0))
                
                Spacer().frame(height: 32)
                
                VStack(spacing: 0) {
                    // 식당 이름
                    HStack(alignment: .center) {
                        Text("전풍호텔라운지")
                            .font(.suit(.bold, 24))
                            .foregroundStyle(Color.black)
                        Spacer()
                        Image(name: Common.emptyHeart)
                    }
                    .padding(.bottom, 32)
                    // 리뷰 본문
                    Text("문을 열자마자 시간 여행을 한다. 레트로함이 좀 느껴지는 수준을 넘어 진도준 선생님처럼 과거로 회귀한 듯 하다. 두툼한 돈카츠로 포화된 지금 찾기 힌든 근본의 한국 경양식 돈까스는 추억 보정까지 담아 더 맛이 깊어진다. 클래식하다. \n\n영화 촬영장 수준으로 과거를 표현한 매장은 돈까스가 나오기도 전에 어릴 적 엄마아빠 손을 잡고 돈까스를 썰어 먹던 추억을 불러온다. 배부르게 먹고 단순하게 행복해진 기억이 입혀져 음식이 더 기대되고, 먹고 나선 더 만족스러워진다.\n\n 돈까스가 나오자마자 벌써부터 눈이 배부르다. 확실하게 클래식함이 묻어나는 옛날 돈까스다. 얇고 넓게 펴져 큰 접시가 꽉 차도록 푸짐하게 담겨 있다. 돈까스를 다 썰은 후 먹는 것을 좋아한다면 넓은 돈까스 사이즈에 고생 좀 할 수도 있다. 부드럽지만 한참을 썰어야 해서 팔이 너덜너덜해진다.\n\n 옛날 돈까스이기 때문에 더 기본에 충실한 근본의 맛이 느껴진다. 겉은 소스에 절여졌음에도 바삭함이 유지되었고, 속은 순두부에 수렴하는 부드러운 느낌이었다. 한국 경양식 돈까스 탑티어다. 과일을 많이 사용하는지 소스가 새콤하며 느끼함이 전혀 없다. 밥과 샐러드, 돈까스를 비벼는 맛잘알들에게는 딱 맞을 소스다.\n\n 엄마가 ‘아들~ 돈까스 먹으러 가자’라고 하는 데에는 이유가 있다. 어릴 때에도 못 참았던 맛이 레트로한 공간과 어울려 깊어진다. 경양식계 클래식을 확실히 영접하고 나니 오므라이스와 매운 돈까스도 기대가 된다. 기회가 되면 꼭 재방문해야겠다.")
                        .font(.suit(.regular, 16))
                        .foregroundStyle(Color.grey8)
                        .padding(.bottom, 32)
                    // 메뉴
                    VStack(alignment: .leading, spacing: 4) {
                        Text("메뉴")
                            .font(.suit(.bold, 18))
                            .foregroundStyle(Color.black)
                            .padding(.bottom, 8)
                        ForEach(0..<5) { _ in
                            HStack {
                                Text("전풍 수제 돈까스")
                                    .font(.suit(.regular, 16))
                                    .foregroundStyle(Color.grey8)
                                    .frame(width: (screenWidth - 32) * 0.58, alignment: .leading)
                                    .lineLimit(1)
                                Spacer()
                                Text("12,000원")
                                    .font(.suit(.medium, 16))
                                    .foregroundStyle(Color.grey7)
                                    .frame(width: (screenWidth - 32) * 0.36, alignment: .trailing)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(.bottom, 32)
                    // 위치
                    VStack(alignment: .leading, spacing: 12) {
                        Text("위치")
                            .font(.suit(.bold, 18))
                            .foregroundStyle(Color.black)
                            .padding(.bottom, 6)
                        HStack {
                            Text("서울 성동구 무학봉28길 7 1층")
                                .font(.suit(.regular, 16))
                                .foregroundStyle(Color.grey8)
                                .frame(width: (screenWidth - 32) * 0.88, alignment: .leading)
                                .lineLimit(1)
                            Spacer()
                            Text("복사")
                                .underline()
                                .font(.suit(.regular, 14))
                                .foregroundStyle(Color.init(hex: 0x34AFF7))
                        }
                    }
                    .padding(.bottom, 32)
                    // 경계선
                    Color.grey1.frame(height: 1)
                        .padding(.bottom, 32)
                    // 작성자
                    VStack(alignment: .leading, spacing: 16) {
                        Text("작성자")
                            .font(.suit(.bold, 18))
                            .foregroundStyle(Color.black)
                            .padding(.bottom, 6)
                        WriterRow(
                            imageUrl: String(),
                            title: "김맛집",
                            intro: "더 많은 맛집을 찾으러 여정을 따나는 중인 초보 맛집러",
                            isFollowed: true
                        )
                    }
                    .padding(.bottom, 32)
                    // 평가
                    VStack(alignment: .leading, spacing: 16) {
                        Text("이 식당 어떠셨나요?")
                            .font(.suit(.bold, 18))
                            .foregroundStyle(Color.black)
                            .padding(.bottom, 12)
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Image(name: Review.normalGood)
                                Text("맛있어요")
                                    .font(.suit(.regular, 12))
                                    .foregroundStyle(Color.grey5)
                                Text("999+")
                                    .font(.suit(.regular, 15))
                                    .foregroundStyle(Color.grey5)
                            }
                            Spacer()
                            VStack(spacing: 8) {
                                Image(name: Review.normalSoso)
                                Text("평범해요")
                                    .font(.suit(.regular, 12))
                                    .foregroundStyle(Color.grey5)
                                Text("999+")
                                    .font(.suit(.regular, 15))
                                    .foregroundStyle(Color.grey5)
                            }
                            Spacer()
                            VStack(spacing: 8) {
                                Image(name: Review.normalBad)
                                Text("별로에요")
                                    .font(.suit(.regular, 12))
                                    .foregroundStyle(Color.grey5)
                                Text("999+")
                                    .font(.suit(.regular, 15))
                                    .foregroundStyle(Color.grey5)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.grey1, lineWidth: 1)
                        )
                    }
                    .padding(.bottom, 32)
                }
                .offset(y: scrollOffset <= 0 ? 0 : -scrollOffset)
                .padding(.horizontal, 16)
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}


#Preview {
    ReviewDetailView()
}
