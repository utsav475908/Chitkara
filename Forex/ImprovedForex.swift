import SwiftUI

struct ForexData: Decodable {
    let price: String
    
    enum CodingKeys: String, CodingKey {
        case price
    }
}

class ForexService: ObservableObject {
    @Published var forexData: ForexData?
    @Published var isLoading = false
    @Published var error: String?
    
    private let apiKEY = "YOUR_API_KEY"
    
    func fetchForexdata(symbol: String) {
        isLoading = true
        error = nil
        
        let formattedSymbol = symbol.replacingOccurrences(of: "USD", with: "/USD")
        let urlString = "https://api.twelvedata.com/price?symbol=\(formattedSymbol)&apikey=\(apiKEY)"
        
        guard let url = URL(string: urlString) else {
            error = "Invalid URL for symbol: \(symbol)"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.error = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.error = "No data returned from API"
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(ForexData.self, from: data)
                    self?.forexData = decodedData
                } catch {
                    self?.error = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

struct ImprovedForex: View {
    @State private var selectedPair = "EURUSD"
    let currencyPairs: [String] = ["EURUSD", "USDJPY", "GBPUSD", "AUDUSD"]
    @StateObject private var service = ForexService()
    
    var body: some View {
        VStack(spacing: 20) {
            Picker("Select Currency Pair", selection: $selectedPair) {
                ForEach(currencyPairs, id: \.self) { pair in Text(pair)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selectedPair) { _ in
                service.fetchForexdata(symbol: selectedPair)
            }
            
            Text("\(selectedPair) Live Rate")
                .font(.title.bold())
            
            if service.isLoading {
                ProgressView()
            } else if let error = service.error {
                Text("Error: \(error)")
                    .foregroundStyle(.red)
            } else if let forexData = service.forexData {
                Text(forexData.price)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(priceColor(for: forexData.price))
                Text("Updated: \(formattedDate())")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Button("Refresh") {
                service.fetchForexdata(symbol: selectedPair)
            }
            .buttonStyle(.borderedProminent)
        
    }
        .padding()
        .onAppear {
            service.fetchForexdata(symbol: selectedPair)
        }
}
    
    private func priceColor(for price: String) -> Color {
        (Double(price) ?? 0) > 1.0 ? .green : .red
    }

   private func formattedDate() -> String {
    let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd"
       return dateFormatter.string(from: Date())
  }
}

#Preview {
    ImprovedForex()
}
