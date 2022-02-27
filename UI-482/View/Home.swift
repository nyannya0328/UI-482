//
//  Home.swift
//  UI-482
//
//  Created by nyannyan0328 on 2022/02/27.
//

import SwiftUI

struct Home: View {
    
    @State var expaceCard : Bool = false
    @Namespace var animation
    
    @State var currentCard : Card?
    @State var showDetail : Bool = false
    var body: some View {
        VStack(spacing:0){
            
            
            Text("Wallet")
                .font(.largeTitle.weight(.heavy))
                .foregroundColor(.black)
                .frame(maxWidth:.infinity,alignment: expaceCard ? .leading : .center)
                .overlay(alignment: .trailing) {
                    
                    
                    Button {
                        
                        withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.7)){
                            
                            
                            expaceCard = false
                        }
                        
                        
                    } label: {
                        
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(.black,in: Circle())
                            .rotationEffect(.init(degrees: expaceCard ? 45 : 0))
                            .offset(x:expaceCard ? 10 : 15)
                            .opacity(expaceCard ? 1 : 0)
                    }
                    .padding(.horizontal,13)
                    .padding(.bottom,10)

                }
            
            
            ScrollView(.vertical, showsIndicators: false) {
                
                
                VStack(spacing:0){
                    
                    ForEach(cards){card in
                        
                        
                        Group{
                            
                            if currentCard?.id == card.id && showDetail{
                                
                                cardView(card: card)
                                    .opacity(0)
                              
                            }
                            
                            else{
                                
                                cardView(card: card)
                                    .matchedGeometryEffect(id: card.id, in: animation)
                                
                                
                            }
                          
                        }
                        .onTapGesture {
                            
                            withAnimation(.easeInOut(duration: 0.35)){
                                
                                
                                showDetail = true
                                currentCard = card
                            }
                        }
                        
                        
                       
                        
                        
                        
                    }
                }
                
                .overlay{
                    
                    Rectangle()
                        .fill(.black.opacity(expaceCard ? 0 : 0.01))
                        .onTapGesture {
                            
                            
                            withAnimation(.easeInOut(duration: 0.2)){
                                
                                expaceCard = true
                            }
                        }
                    
                    
                }
                .padding(.top,expaceCard ? 30 : 0)
                
            }
            .coordinateSpace(name: "SCROLL")
            .offset(y: expaceCard ? 0 : 30)
            
            
            
            Button {
                
            } label: {
                
                
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(.black,in: Circle())
                 
                    
            }
            .rotationEffect(.init(degrees: expaceCard ? 180 : 0))
            .scaleEffect(expaceCard ? 0.01 : 1)
            .opacity(!expaceCard ? 1 : 0)
            .frame(height: expaceCard ? 0 : nil)
            .padding(.bottom,expaceCard ? 0 : 30)
        

            
            
            
        }
        .padding([.horizontal,.top])
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .overlay{
            
            if let currentCard = currentCard,showDetail {
                
                
                DetailView(currentCard: currentCard, showDetailCard: $showDetail, animation: animation)
            }
            
            
        }
    }
    
    
    
    @ViewBuilder
    func cardView(card : Card)->some View{
        
        
        GeometryReader{proxy in
            
            let rect = proxy.frame(in: .named("SCROLL"))
            
            
            let offset = CGFloat(getIndex(card: card) * (expaceCard ? 10 : 70))
            
            
            ZStack(alignment: .bottomLeading) {
                
                Image(card.cardImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    
                    Text(card.name)
                    
                    Text(CustomCardNumber(number:card.cardNumber))
                }
                .padding()
                .padding(.bottom,10)
                .foregroundColor(.white)
                
                
                
                
            }
            
            .offset(y:expaceCard ? offset : -rect.minY + offset)
            
        }
        .frame(height:200)
        
     
        
        
        
    }
    
    
    func getIndex(card : Card)->Int{
        
        
        return cards.firstIndex { currentCard in
            
            currentCard.id == card.id
        } ?? 0
    }
    
  
  
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


func CustomCardNumber(number : String) -> String{
    
    var newValue : String = ""
    
    let maxCount = number.count - 4
    
    number.enumerated().forEach { value in
        
        
        if value.offset >= maxCount{
            
            let string = String(value.element)
            
            
            newValue.append(contentsOf: string)
            
            
            
        }
        
        else{
            
            let string = String(value.element)
            
            
            if string == " "{
                
                newValue.append(contentsOf: " ")
            }
            
            else{
                
                
                newValue.append(contentsOf: "*")
            }
        }
        
        
      
    }
    return newValue
    
    
}


struct DetailView :View{
    
    
    var currentCard : Card
    
    @Binding var showDetailCard : Bool
    
    @State var showExpeceView : Bool = false
    var animation : Namespace.ID
    
    var body: some View{
        
        VStack{
            
            
            CardView()
                .frame(height: 200)
                .matchedGeometryEffect(id: currentCard.id, in: animation)
                .onTapGesture {
                    
                    
                    withAnimation(.easeInOut){
                        
                        showExpeceView = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        
                        
                        withAnimation(.easeOut(duration: 0.35)){
                            
                            showDetailCard = false
                        }
                        
                    }
                    
                    
                    
                }
                .padding(.top,20)
                .zIndex(10)
            
            
            GeometryReader{proxy in
                
                
                let height = proxy.size.height + 50
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    
                    VStack(spacing:20){
                        
                        
                        ForEach(expenses){exp in
                            
                            
                            ExpecneView(expence: exp)
                            
                            
                        }
                    }
                    .padding()
                }
                .frame(maxWidth:.infinity)
                .background(
                
                
                    Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .ignoresSafeArea()
                
                )
                .offset(y: showExpeceView ? 0 : height)
                
                
            }
            .padding([.horizontal,.top])
            .zIndex(-10)
            
            
            
        }
        .frame(maxWidth:.infinity,maxHeight: .infinity,alignment: .top)
        .background(Color("BG").ignoresSafeArea())
        .onAppear {
            
            
            withAnimation(.easeInOut.delay(0.1)){
                
                showExpeceView = true
            }
            
        }
    }
    @ViewBuilder
    func CardView()->some View{
        
        
        ZStack(alignment: .bottomTrailing) {
            
            Image(currentCard.cardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            
            VStack(alignment: .leading, spacing: 15) {
                
                
                Text(currentCard.name)
                    .fontWeight(.bold)
                
                
                Text(CustomCardNumber(number:currentCard.cardNumber))
                    .font(.caption.weight(.bold))
                
            }
            .padding()
            .padding(.bottom,10)
            .foregroundColor(.white)
            
            
        }
        
        
    }
}


struct ExpecneView : View{
    
    var expence : Expense
    
    @State var showView : Bool = false
    
    var body: some View{
        
        HStack(spacing:15){
            
         
            
            Image(expence.productIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
            
            
            VStack(alignment: .leading, spacing: 15) {
                
                
                Text(expence.product)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                
                Text(expence.spendType)
                    .font(.caption)
                    .foregroundColor(.gray)
                
            }
            .frame(maxWidth:.infinity,alignment: .leading)
            
            
            VStack(spacing:15){
                
                
                
                Text(expence.amountSpent)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                
                Text(Date().formatted(date: .numeric, time: .omitted))
                    .foregroundColor(.gray)
                
                
                
            }
            
            
        }
        .opacity(showView ? 1 : 0)
        .offset(y: showView ? 0 : 20)
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                
                
                withAnimation(.easeInOut(duration: 0.3).delay(Double(getIndex()) * 0.1)){
                    
                    
                    
                    showView = true
                }
            }
        }
    }
    func getIndex() -> Int{
        
        
        return expenses.firstIndex { currenetexp in
            
            currenetexp.id == expence.id
        } ?? 0
    }
}

