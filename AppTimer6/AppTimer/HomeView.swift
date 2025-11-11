import SwiftUI

struct HomeView: View {

    @State private var modalIsPresented = false
    @State private var goToTimer = false
    @State private var cycles: Int = 3
    @State private var unlockedCreature: Creature? = nil

    var myData = sharedData

    var totalMinutes: Int {
        cycles * 30
    }

    var totalTimeFormatted: String {
        if totalMinutes >= 60 {
            let hours = totalMinutes / 60
            let minutes = totalMinutes % 60
            return String(format: "%d:%02d hours", hours, minutes)
        } else {
            return "\(totalMinutes) min"
        }
    }

    var body: some View {
        ZStack {
            if goToTimer {
                TimerView(goToHome: $goToTimer, unlockedCreature: $unlockedCreature, cycles: cycles)
            } else {
                NavigationStack {
                    HomeContent
                }
                .overlay {
                    if let creature = unlockedCreature {
                        UnlockPopup(creature: creature) {
                            // 👇 Nessuna animazione sul dismiss
                            withTransaction(Transaction(animation: nil)) {
                                unlockedCreature = nil
                            }
                        }
                    }
                }
            }
        }
    }

    var HomeContent: some View {
        ZStack {
            LinearGradient(colors: [.white, .indigo], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                Image(myData.creatures[0].eggImage)
                    .resizable()
                    .frame(width: 300, height: 380)

                Spacer().frame(height: 90)

                Button {
                    modalIsPresented = true
                } label: {
                    Text("Set Timer")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                        .padding(.vertical, 12)
                        .padding(.horizontal, 70)
                        .background(.indigo)
                        .cornerRadius(62)
                }

                Spacer().frame(height: 16)
            }
        }
        .sheet(isPresented: $modalIsPresented) {
            TimerSetupSheet
        }
    }

    var TimerSetupSheet: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Focus Time").padding(.leading, 35)
                    Spacer()
                    Text("25 min").foregroundStyle(.indigo).padding(.trailing, 35)
                }
                .font(.title).padding(.top, 40).bold()

                HStack {
                    Text("Break Time").padding(.leading, 35)
                    Spacer()
                    Text("5 min").foregroundStyle(.indigo).padding(.trailing, 35)
                }
                .font(.title).padding(.top, 20).bold()

                Spacer()

                HStack {
                    Text("Cycles").padding(.leading, 35)
                    Spacer()
                    HStack {
                        Button { if cycles > 1 { cycles -= 1 } } label: { Image(systemName: "minus.circle") }
                        Text(" \(cycles) ").font(.largeTitle)
                        Button { cycles += 1 } label: { Image(systemName: "plus.circle") }
                    }
                    .padding(.trailing, 35)
                }
                .font(.title).bold()

                Spacer()

                Text("Total Focus Time").font(.largeTitle).bold()
                Text(totalTimeFormatted)
                    .font(.system(size: 60))
                    .padding(.top, 20)
                    .foregroundStyle(.indigo)
                    .bold()

                Spacer()

                Button {
                    goToTimer = true
                    modalIsPresented = false
                } label: {
                    Text("Start")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                        .padding(.vertical, 12)
                        .padding(.horizontal, 70)
                        .background(.indigo)
                        .cornerRadius(62)
                }
                .padding(.bottom)

            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { modalIsPresented = false }
                        .foregroundStyle(.indigo)
                        .bold()
                }
            }
        }
    }
}

/// Popup per nuova creatura sbloccata
struct UnlockPopup: View {
    let creature: Creature
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            // Layer opaco scuro
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("New Creature Unlocked!")
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .padding(.bottom)

                Button {
                    onDismiss()
                } label: {
                    Text("Continue")
                        .bold()
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 50)
                        .background(Color.indigo)
                        .cornerRadius(40)
                }
            }
            .padding()
            .frame(width: 320)
            .background(.white)
            .cornerRadius(40)
            .shadow(radius: 15)
        }
    }
}

#Preview {
    HomeView()
}
