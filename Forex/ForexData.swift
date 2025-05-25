//import Foundation
//import SwiftUI
//
//struct ForexData: Codable {
//    let price: String
//    
//    // TwelveData API returns different structure than expected
//    enum CodingKeys: String, CodingKey {
//        case price
//    }
//}
//
//class ForexService: ObservableObject {
//    @Published var forexData: ForexData?
//    @Published var isLoading = false
//    @Published var error: String?
//    
//    private let apiKey = "6d1193aa24894534852a550ddd165911" // Replace with your actual API key
//    
//    func fetchForexData(symbol: String) {
//        isLoading = true
//        error = nil
//        
//        // Format symbol correctly (API expects EUR/USD format)
//        let formattedSymbol = symbol.replacingOccurrences(of: "USD", with: "/USD")
//        let urlString = "https://api.twelvedata.com/price?symbol=\(formattedSymbol)&apikey=\(apiKey)"
//        
//        guard let url = URL(string: urlString) else {
//            error = "Invalid URL for symbol: \(symbol)"
//            isLoading = false
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                
//                if let error = error {
//                    self?.error = "Network error: \(error.localizedDescription)"
//                    return
//                }
//                
//                guard let data = data else {
//                    self?.error = "No data returned from server"
//                    return
//                }
//                
//                // Print raw response for debugging
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("API Response: \(jsonString)")
//                }
//                
//                do {
//                    let decodedData = try JSONDecoder().decode(ForexData.self, from: data)
//                    self?.forexData = decodedData
//                } catch let decodingError {
//                    self?.error = "Decoding error: \(decodingError.localizedDescription)\nResponse: \(String(data: data, encoding: .utf8) ?? "No response")"
//                }
//            }
//        }.resume()
//    }
//}
//
//struct ForexView: View {
//    let symbol: String
//    @StateObject private var forexService = ForexService()
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Forex for \(symbol)")
//                .font(.title)
//                .bold()
//            
//            if forexService.isLoading {
//                ProgressView()
//            } else if let error = forexService.error {
//                VStack {
//                    Text("Error: \(error)")
//                        .foregroundStyle(.red)
//                        .multilineTextAlignment(.center)
//                    Text("Please try again")
//                        .font(.caption)
//                }
//            } else if let forexData = forexService.forexData {
//                VStack(spacing: 8) {
//                    Text(forexData.price)
//                        .font(.system(size: 48, weight: .bold))
//                        .foregroundStyle(.green)
//                    Text("Updated: \(formattedDate())")
//                        .font(.caption)
//                        .foregroundStyle(.gray)
//                }
//            }
//            
//            Button("Refresh") {
//                forexService.fetchForexData(symbol: symbol)
//            }
//            .padding()
//            .background(Color.blue)
//            .foregroundStyle(.white)
//            .cornerRadius(10)
//        }
//        .padding(20)
//        .onAppear {
//            forexService.fetchForexData(symbol: symbol)
//        }
//    }
//    
//    private func formattedDate() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss"
//        return dateFormatter.string(from: Date())
//    }
//}
//
//// Preview with mock data
//struct ForexView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ForexView(symbol: "EURUSD")
//                .previewDisplayName("Success")
//                .onAppear {
//                    let mockService = ForexService()
//                    mockService.forexData = ForexData(price: "1.0853")
//                }
//            
//            ForexView(symbol: "EURUSD")
//                .previewDisplayName("Loading")
//                .onAppear {
//                    let mockService = ForexService()
//                    mockService.isLoading = true
//                }
//            
//            ForexView(symbol: "EURUSD")
//                .previewDisplayName("Error")
//                .onAppear {
//                    let mockService = ForexService()
//                    mockService.error = "Sample error message"
//                }
//        }
//    }
//}
