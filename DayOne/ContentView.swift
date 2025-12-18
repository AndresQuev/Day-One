import SwiftUI

struct ContentView: View {
    var body: some View {
        CounterView()
    }
}

struct CounterView: View {
    @State private var startDate: Date = Date()
    @State private var manualOffset: Int = 0
    @State private var animate = false

    let background = Color(red: 0.18, green: 0.18, blue: 0.32)

    var daysWithoutSmoking: Int {
        let days = Calendar.current.dateComponents(
            [.day],
            from: startDate,
            to: Date()
        ).day ?? 0
        return max(days + manualOffset, 0)
    }

    var motivationText: String {
        switch daysWithoutSmoking {
        case 0...2:
            return "One day at a time"
        case 3...6:
            return "You’re building momentum"
        case 7...13:
            return "A full week. Stay strong"
        case 14...29:
            return "This is becoming a habit"
        case 30...89:
            return "Your body is healing"
        default:
            return "This is who you are now"
        }
    }

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()

            VStack(spacing: 26) {

                Spacer()

                Text("Day-One")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                    

                Text("\(daysWithoutSmoking)")
                    .font(.system(size: 120, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .scaleEffect(animate ? 1.05 : 1.0)
                    .animation(
                        .spring(response: 0.35, dampingFraction: 0.6),
                        value: animate
                    )

                Text("days without smoking")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                    .bold()

                
                Text(motivationText)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.top, 6)
                    .transition(.opacity)

                Spacer()

                DatePicker(
                    "Quit date",
                    selection: $startDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .colorScheme(.dark)
                .padding(.bottom, 12)

                Button {
                    withAnimation {
                        manualOffset += 1
                        animate.toggle()
                    }
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                } label: {
                    Text("Add Day")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundStyle(background)

                Button("Reset Manual Adjust") {
                    withAnimation {
                        manualOffset = 0
                    }
                }
                .font(.footnote)
                .foregroundStyle(.red)
                .bold()

                Spacer(minLength: 30)
            }
            .padding()
        }
        .onChange(of: daysWithoutSmoking) {
            animate.toggle()
        }
    }
}

#Preview {
    ContentView()
}
