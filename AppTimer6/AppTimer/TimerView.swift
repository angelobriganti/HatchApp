import SwiftUI

struct TimerView: View {

    @Binding var goToHome: Bool
    @Binding var unlockedCreature: Creature?
    var cycles: Int

    @State private var currentCycle = 1
    @State private var timeRemaining: Int = 0
    @State private var isFocus = true
    @State private var timerRunning = true
    @State private var timer: Timer? = nil

    var myData = sharedData

    var body: some View {
        ZStack {
            LinearGradient(colors: [.white, .indigo], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                /*
                Image(myData.creatures[0].eggImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 150)
                    .padding(.bottom, 20)
                 */

                Text(isFocus ? "Focus Time" : "Break Time")
                    .font(.largeTitle)
                    .bold()
                    .opacity(0.85)
                    .padding(.top, 40)

                Text(formatTime(timeRemaining))
                    .font(.system(size: 90))
                    .bold()

                Text("Cycle \(currentCycle) of \(cycles)")
                    .font(.title2)
                    .bold()
                    .opacity(0.7)
                    .padding(.bottom, 40)
                
                Spacer()

                Button {
                    timerRunning.toggle()
                } label: {
                    HStack {
                        Text(timerRunning ? "Pause" : "Play")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.indigo)
                            .frame(width: 100)
                        Image(systemName: timerRunning ? "pause.fill" : "play.fill")
                            .font(.system(size: 30))
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 100)
                .background(.white.opacity(0.8))
                .cornerRadius(62)

                Button {
                    stopTimer()
                    goToHome = false
                } label: {
                    HStack {
                        Text("Stop")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Image(systemName: "stop.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 110)
                .background(.indigo)
                .cornerRadius(62)
                .padding(.bottom, 40)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            startFocus()
            startTimerLoop()
        }
        .onDisappear {
            stopTimer()
        }
    }

    // MARK: Timer logic
    func startTimerLoop() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            guard timerRunning else { return }

            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                t.invalidate()
                timer = nil
                handlePhaseEnd()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func startFocus() {
        isFocus = true
        //timeRemaining = 2 // test
        timeRemaining = 25 * 60
        startTimerLoop()
    }

    func startBreak() {
        isFocus = false
        //timeRemaining = 1 // test
        timeRemaining = 5 * 60
        startTimerLoop()
    }

    func handlePhaseEnd() {
        if isFocus {
            startBreak()
        } else {
            if currentCycle < cycles {
                currentCycle += 1
                startFocus()
            } else {
                // completati tutti i cicli
                myData.totalCyclesCompleted += cycles
                unlockedCreature = myData.updateCreatures()
                stopTimer()
                goToHome = false
            }
        }
    }
}

func formatTime(_ seconds: Int) -> String {
    let m = seconds / 60
    let s = seconds % 60
    return String(format: "%02d:%02d", m, s)
}

#Preview {
    TimerView(goToHome: .constant(true), unlockedCreature: .constant(nil), cycles: 3)
}
