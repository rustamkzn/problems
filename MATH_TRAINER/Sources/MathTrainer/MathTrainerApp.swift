import SwiftUI

struct Problem {
    let text: String
    let answer: Int
}

struct ProblemGenerator {
    static func next() -> Problem {
        let kind = Int.random(in: 0...2)

        for _ in 0..<100 {
            if kind == 0 {
                let a = Int.random(in: 1...89)
                let b = Int.random(in: 1...(100 - a))
                return Problem(text: "\(a) + \(b) = ?", answer: a + b)
            }

            if kind == 1 {
                let a = Int.random(in: 20...100)
                let b = Int.random(in: 1...a)
                return Problem(text: "\(a) − \(b) = ?", answer: a - b)
            }

            let a = Int.random(in: 10...80)
            let b = Int.random(in: 1...20)
            let first = a + b
            if first <= 100 {
                let c = Int.random(in: 1...min(20, first))
                let answer = first - c
                return Problem(text: "\(a) + \(b) − \(c) = ?", answer: answer)
            }
        }

        return Problem(text: "25 + 17 = ?", answer: 42)
    }
}

@main
struct MathTrainerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 900, height: 620)
    }
}

struct ContentView: View {
    @State private var problem = ProblemGenerator.next()
    @State private var answer = ""
    @State private var state: AnswerState = .neutral
    @State private var total = 0
    @State private var correct = 0
    @FocusState private var answerFocused: Bool

    enum AnswerState {
        case neutral, correct, incorrect
    }

    private var answerColor: Color {
        switch state {
        case .neutral: return Color(red: 0.36, green: 0.24, blue: 0.48)
        case .correct: return Color(red: 0.16, green: 0.68, blue: 0.40)
        case .incorrect: return Color(red: 0.86, green: 0.25, blue: 0.38)
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.91, blue: 0.98),
                    Color(red: 0.99, green: 0.95, blue: 0.97),
                    Color(red: 0.94, green: 0.88, blue: 0.97)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                Spacer()

                VStack(spacing: 28) {
                    Text("Реши пример")
                        .font(.system(size: 26, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(red: 0.43, green: 0.32, blue: 0.52))

                    Text(problem.text)
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.25, green: 0.18, blue: 0.34))
                        .contentTransition(.numericText())
                        .minimumScaleFactor(0.6)

                    HStack(spacing: 14) {
                        TextField("", text: $answer)
                            .font(.system(size: 52, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(answerColor)
                            .frame(width: 250, height: 88)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(.white.opacity(0.92))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(answerColor.opacity(0.35), lineWidth: 3)
                            )
                            .shadow(color: .black.opacity(0.08), radius: 12, y: 5)
                            .focused($answerFocused)
                            .onSubmit(checkAnswer)
                            .onChange(of: answer) { _, newValue in
                                let filtered = newValue.filter { $0.isNumber }.prefix(3)
                                if String(filtered) != newValue {
                                    answer = String(filtered)
                                }
                            }

                        Button(action: checkAnswer) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 72, height: 72)
                                .background(
                                    Circle().fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.66, green: 0.34, blue: 0.72),
                                                Color(red: 0.82, green: 0.30, blue: 0.58)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                )
                        }
                        .buttonStyle(.plain)
                    }

                    Text(stateMessage)
                        .font(.system(size: 21, weight: .semibold, design: .rounded))
                        .foregroundStyle(answerColor)
                        .frame(height: 28)
                }
                .padding(.horizontal, 40)

                Spacer()
                footer
            }
            .padding(34)
        }
        .frame(minWidth: 760, minHeight: 560)
        .onAppear {
            answerFocused = true
        }
    }

    private var header: some View {
        HStack {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 13)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.66, green: 0.34, blue: 0.72),
                                    Color(red: 0.82, green: 0.30, blue: 0.58)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 46, height: 46)

                    Image(systemName: "plus.forwardslash.minus")
                        .font(.system(size: 21, weight: .bold))
                        .foregroundStyle(.white)
                }

                Text("Математика")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.28, green: 0.20, blue: 0.36))
            }

            Spacer()

            HStack(spacing: 18) {
                stat(title: "Решено", value: total)
                stat(title: "Верно", value: correct)
            }
        }
    }

    private func stat(title: String, value: Int) -> some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(title)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
            Text("\(value)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.45, green: 0.25, blue: 0.52))
        }
    }

    private var footer: some View {
        HStack {
            Text("Введите ответ и нажмите Enter ↵")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)

            Spacer()

            Button("Новый пример") {
                nextProblem()
            }
            .font(.system(size: 15, weight: .semibold, design: .rounded))
            .buttonStyle(.bordered)
            .tint(Color(red: 0.62, green: 0.34, blue: 0.66))
        }
    }

    private var stateMessage: String {
        switch state {
        case .neutral:
            return "У тебя всё получится! 🌸"
        case .correct:
            return "Правильно! Молодец! ✨"
        case .incorrect:
            return "Попробуй ещё раз"
        }
    }

    private func checkAnswer() {
        guard let value = Int(answer), !answer.isEmpty else { return }

        total += 1

        if value == problem.answer {
            correct += 1
            state = .correct

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                if state == .correct {
                    nextProblem()
                }
            }
        } else {
            state = .incorrect
            answer = ""

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                if state == .incorrect {
                    state = .neutral
                    answerFocused = true
                }
            }
        }
    }

    private func nextProblem() {
        problem = ProblemGenerator.next()
        answer = ""
        state = .neutral
        answerFocused = true
    }
}
