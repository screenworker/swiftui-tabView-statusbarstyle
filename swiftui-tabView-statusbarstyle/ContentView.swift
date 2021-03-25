//
//  ContentView.swift
//  swiftui-tabView-statusbarstyle
//
//  Created by Peter Kreinz on 25.03.21.
//
// based on: https://github.com/xavierdonnellon/swiftui-statusbarstyle

import SwiftUI

struct ContentView: View {
    
    @State var tabRoute = TabRoute.green
    
    enum TabRoute: String, Identifiable {
        
        var id: String {
            self.rawValue
        }
        
        case green, black, blue, purple
        
        static var all: [TabRoute] {
            [.green, .black, .blue, .purple]
        }
        
        var bgColor: Color {
            switch self {
            case .green:
                return .green
                
            case .black:
                return .black
                
            case .blue:
                return .blue
                
            case .purple:
                return .purple
                
            }
        }
        
        var statusBarStyle: UIStatusBarStyle {
            switch self {
            case .black:
                return .lightContent
                
            default:
                return .darkContent
                
            }
        }
    }
    
    
    var body: some View {
        
        TabView(selection: $tabRoute) {
            
            ForEach(TabRoute.all) { route in
                NavigationView {
                    ViewExample(isPresented: false, title: route.rawValue, bgColor: route.bgColor, statusBarStyle: route.statusBarStyle)
                        .navigationTitle(route.rawValue)
                        .navigationBarTitleDisplayMode(.inline)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .tabItem {
                    Text(route.rawValue)
                }
                .tag(TabRoute(rawValue: route.rawValue))
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
    
}

struct ViewExample: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State private var sheetIsPresented = false
    
    @State  var isPresented: Bool
    
    var title: String
    
    var bgColor: Color
    
    var statusBarStyle: UIStatusBarStyle
    
    var body: some View {
        ZStack {
            bgColor
            
            VStack(spacing: 32) {
                NavigationLink(
                    destination: ViewExample(isPresented: false, title: "Detail", bgColor: .black, statusBarStyle: .lightContent),
                    label: {
                        Text("Navigation Link")
                    })
                
                Button(action: {
                    sheetIsPresented.toggle()
                }, label: {
                    Text("Sheet")
                })
            }
            
        }
        .toolbar(content: {
            if isPresented {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Close")
                })
            }
        })

        .sheet(isPresented: $sheetIsPresented, onDismiss: {
            UIApplication.statusBarStyleHierarchy.removeLast()
            UIApplication.setStatusBarStyle(statusBarStyle)
        }, content: {
            NavigationView {
                ViewExample(isPresented: true, title: "Detail", bgColor: .black, statusBarStyle: .lightContent)
                    .navigationTitle("Detail")
                   
            }
        })
        .onAppear {
            UIApplication.statusBarStyleHierarchy.append(statusBarStyle)
            UIApplication.setStatusBarStyle(statusBarStyle)
        }
        .onDisappear {
            guard UIApplication.statusBarStyleHierarchy.count > 1 else { return }
            let style = UIApplication.statusBarStyleHierarchy[UIApplication.statusBarStyleHierarchy.count - 1]
            UIApplication.statusBarStyleHierarchy.removeLast()
            UIApplication.setStatusBarStyle(style)
        }
        .edgesIgnoringSafeArea(.all)
    }
}
