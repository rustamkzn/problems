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
                return Problem(text: "\(a) + \(b) − \(c) = ?", answer: first - c)
            }
        }
        return Problem(text: "25 + 17 = ?", answer: 42)
    }
}

struct DayStats: Codable, Identifiable {
    var date: String
    var correct: Int = 0
    var incorrect: Int = 0
    var id: String { date }
    var total: Int { correct + incorrect }
    var accuracy: Int { total == 0 ? 0 : Int((Double(correct) / Double(total) * 100).rounded()) }
}

struct TrainerStats: Codable {
    var correct = 0
    var incorrect = 0
    var diamonds = 0
    var currentStreak = 0
    var bestStreak = 0
    var days: [DayStats] = []
    var celebratedStreaks: [Int] = []
    var celebratedDiamondMilestones: [Int] = []
    var total: Int { correct + incorrect }
    var accuracy: Int { total == 0 ? 0 : Int((Double(correct) / Double(total) * 100).rounded()) }
}

@MainActor
final class StatsStore: ObservableObject {
    @Published var stats: TrainerStats
    private let key = "MathTrainer.Stats.v2"

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode(TrainerStats.self, from: data) {
            stats = saved
        } else {
            stats = TrainerStats()
        }
    }

    func record(correct isCorrect: Bool) -> [String] {
        let date = Self.dateKey(Date())
        if let index = stats.days.firstIndex(where: { $0.date == date }) {
            if isCorrect { stats.days[index].correct += 1 } else { stats.days[index].incorrect += 1 }
        } else {
            stats.days.append(DayStats(date: date, correct: isCorrect ? 1 : 0, incorrect: isCorrect ? 0 : 1))
        }
        var celebrations: [String] = []
        if isCorrect {
            stats.correct += 1
            stats.diamonds += 1
            stats.currentStreak += 1
            stats.bestStreak = max(stats.bestStreak, stats.currentStreak)
            if stats.currentStreak >= 5 && stats.currentStreak.isMultiple(of: 5)
                && !stats.celebratedStreaks.contains(stats.currentStreak) {
                stats.celebratedStreaks.append(stats.currentStreak)
                celebrations.append("streak:\(stats.currentStreak)")
            }
            for milestone in [50, 100] where stats.diamonds >= milestone
                && !stats.celebratedDiamondMilestones.contains(milestone) {
                stats.celebratedDiamondMilestones.append(milestone)
                celebrations.append("diamonds:\(milestone)")
            }
        } else {
            stats.incorrect += 1
            stats.currentStreak = 0
        }
        stats.days.sort { $0.date > $1.date }
        save()
        return celebrations
    }

    private func save() {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func dateKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_CA")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    static func displayDate(_ key: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: key) else { return key }
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: date)
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
        .defaultSize(width: 900, height: 660)
    }
}

struct ContentView: View {
    @StateObject private var store = StatsStore()
    @State private var problem = ProblemGenerator.next()
    @State private var answer = ""
    @State private var state: AnswerState = .neutral
    @State private var celebration: String?
    @State private var showCelebration = false
    @State private var celebrationTokens: [CelebrationToken] = []
    @FocusState private var answerFocused: Bool

    enum AnswerState { case neutral, correct, incorrect }

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
            ).ignoresSafeArea()

            TabView {
                trainingView
                    .tabItem { Label("Тренировка", systemImage: "function") }
                statisticsView
                    .tabItem { Label("Статистика", systemImage: "chart.bar.xaxis") }
            }

            if showCelebration {
                celebrationOverlay
                    .transition(.opacity)
                    .zIndex(10)
            }
        }
        .frame(minWidth: 760, minHeight: 560)
        .onAppear { answerFocused = true }
    }

    private var trainingView: some View {
        VStack(spacing: 0) {
            header
            Spacer(minLength: 18)
            VStack(spacing: 25) {
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
                        .background(RoundedRectangle(cornerRadius: 24).fill(.white.opacity(0.92)))
                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(answerColor.opacity(0.35), lineWidth: 3))
                        .shadow(color: .black.opacity(0.08), radius: 12, y: 5)
                        .focused($answerFocused)
                        .onSubmit(checkAnswer)
                        .onChange(of: answer) { _, newValue in
                            let filtered = String(newValue.filter { $0.isNumber }.prefix(3))
                            if filtered != newValue { answer = filtered }
                        }

                    Button(action: checkAnswer) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 72, height: 72)
                            .background(Circle().fill(LinearGradient(
                                colors: [Color(red: 0.66, green: 0.34, blue: 0.72), Color(red: 0.82, green: 0.30, blue: 0.58)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )))
                    }
                    .buttonStyle(.plain)
                }

                Text(stateMessage)
                    .font(.system(size: 21, weight: .semibold, design: .rounded))
                    .foregroundStyle(answerColor)
                    .frame(height: 28)
            }
            .padding(.horizontal, 40)
            Spacer(minLength: 18)
            footer
        }
        .padding(30)
        .overlay(alignment: .topTrailing) {
            Text("💎 \(store.stats.diamonds)")
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.58, green: 0.25, blue: 0.57))
                .padding(.top, 12)
                .padding(.trailing, 18)
        }
    }

    private var header: some View {
        HStack {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 13)
                        .fill(LinearGradient(
                            colors: [Color(red: 0.66, green: 0.34, blue: 0.72), Color(red: 0.82, green: 0.30, blue: 0.58)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
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
                stat(title: "Решено", value: store.stats.total)
                stat(title: "Верно", value: store.stats.correct)
                stat(title: "Точность", value: store.stats.accuracy, suffix: "%")
            }
        }
        .padding(.top, 12)
    }

    private func stat(title: String, value: Int, suffix: String = "") -> some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(title).font(.system(size: 13, weight: .medium, design: .rounded)).foregroundStyle(.secondary)
            Text("\(value)\(suffix)").font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.45, green: 0.25, blue: 0.52))
        }
    }

    private var footer: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("Введите ответ и нажмите Enter ↵")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                Text("Серия: \(store.stats.currentStreak) подряд 🔥")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(red: 0.67, green: 0.29, blue: 0.55))
            }
            Spacer()
            Button("Новый пример") { nextProblem() }
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .buttonStyle(.bordered)
                .tint(Color(red: 0.62, green: 0.34, blue: 0.66))
        }
    }

    private var stateMessage: String {
        switch state {
        case .neutral: return "У тебя всё получится! 🌸"
        case .correct: return "Правильно! +1 алмаз 💎"
        case .incorrect: return "Попробуй ещё раз"
        }
    }

    private var statisticsView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Text("Твои успехи")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.28, green: 0.20, blue: 0.36))

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                    statCard(title: "Правильные", value: "\(store.stats.correct)", symbol: "checkmark.circle.fill", color: Color(red: 0.16, green: 0.65, blue: 0.40))
                    statCard(title: "Ошибки", value: "\(store.stats.incorrect)", symbol: "xmark.circle.fill", color: Color(red: 0.86, green: 0.25, blue: 0.38))
                    statCard(title: "Точность", value: "\(store.stats.accuracy)%", symbol: "target", color: Color(red: 0.58, green: 0.30, blue: 0.69))
                    statCard(title: "Всего заданий", value: "\(store.stats.total)", symbol: "list.number", color: Color(red: 0.58, green: 0.30, blue: 0.69))
                    statCard(title: "Алмазы", value: "💎 \(store.stats.diamonds)", symbol: "sparkle", color: Color(red: 0.76, green: 0.28, blue: 0.56))
                    statCard(title: "Лучшая серия", value: "\(store.stats.bestStreak)", symbol: "flame.fill", color: Color(red: 0.90, green: 0.48, blue: 0.24))
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Награды")
                        .font(.system(size: 23, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.35, green: 0.22, blue: 0.43))
                    rewardRow(emoji: "🔥", title: "Серия правильных ответов", detail: "Награда каждые 5 подряд", progress: store.stats.currentStreak % 5, goal: 5)
                    rewardRow(emoji: "🎉", title: "50 алмазов", detail: "Цветной салют и мягкие игрушки", progress: min(store.stats.diamonds, 50), goal: 50)
                    rewardRow(emoji: "🦋", title: "100 алмазов", detail: "Летающие птички и бабочки", progress: min(store.stats.diamonds, 100), goal: 100)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("По дням")
                        .font(.system(size: 23, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.35, green: 0.22, blue: 0.43))
                    if store.stats.days.isEmpty {
                        Text("Здесь появятся результаты после первых примеров.")
                            .foregroundStyle(.secondary)
                            .padding(18)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 16))
                    } else {
                        HStack {
                            Text("Дата").frame(maxWidth: .infinity, alignment: .leading)
                            Text("Верно").frame(width: 65, alignment: .trailing)
                            Text("Ошибки").frame(width: 65, alignment: .trailing)
                            Text("Всего").frame(width: 65, alignment: .trailing)
                            Text("%").frame(width: 48, alignment: .trailing)
                        }
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(.secondary)
                        ForEach(store.stats.days) { day in
                            HStack {
                                Text(StatsStore.displayDate(day.date)).frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(day.correct)").foregroundStyle(.green).frame(width: 65, alignment: .trailing)
                                Text("\(day.incorrect)").foregroundStyle(.red).frame(width: 65, alignment: .trailing)
                                Text("\(day.total)").frame(width: 65, alignment: .trailing)
                                Text("\(day.accuracy)%").frame(width: 48, alignment: .trailing)
                            }
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .padding(.vertical, 11)
                            .padding(.horizontal, 12)
                            .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
            .padding(30)
        }
    }

    private func statCard(title: String, value: String, symbol: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: symbol).font(.system(size: 23, weight: .semibold)).foregroundStyle(color)
            Text(value).font(.system(size: 27, weight: .bold, design: .rounded)).foregroundStyle(Color(red: 0.28, green: 0.20, blue: 0.36))
            Text(title).font(.system(size: 14, weight: .medium, design: .rounded)).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 108, alignment: .leading)
        .padding(16)
        .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 18))
    }

    private func rewardRow(emoji: String, title: String, detail: String, progress: Int, goal: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Text(emoji).font(.system(size: 25))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.system(size: 15, weight: .bold, design: .rounded))
                    Text(detail).font(.system(size: 13, design: .rounded)).foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(progress)/\(goal)").font(.system(size: 14, weight: .bold, design: .rounded)).foregroundStyle(Color(red: 0.58, green: 0.30, blue: 0.69))
            }
            ProgressView(value: Double(progress), total: Double(goal)).tint(Color(red: 0.76, green: 0.36, blue: 0.68))
        }
        .padding(14)
        .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 15))
    }

    private func checkAnswer() {
        guard let value = Int(answer), !answer.isEmpty, state != .correct else { return }
        let isCorrect = value == problem.answer
        let rewards = store.record(correct: isCorrect)
        if isCorrect {
            state = .correct
            if let reward = rewards.last { triggerCelebration(reward) }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                if state == .correct { nextProblem() }
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

    private func triggerCelebration(_ reward: String) {
        celebration = reward
        celebrationTokens = (0..<28).map { _ in
            CelebrationToken(
                emoji: reward.hasSuffix("50") ? ["🧸", "🪅", "🎈", "🧸", "🎉"].randomElement()! : ["🐦", "🦋", "🐤", "🦋", "🐦"].randomElement()!,
                x: Double.random(in: 0.05...0.95),
                y: Double.random(in: 0.08...0.85),
                delay: Double.random(in: 0...0.8)
            )
        }
        withAnimation(.easeInOut(duration: 0.25)) { showCelebration = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            withAnimation(.easeOut(duration: 0.5)) { showCelebration = false }
        }
    }

    private var celebrationOverlay: some View {
        ZStack {
            Color(red: 0.32, green: 0.16, blue: 0.42).opacity(0.30).ignoresSafeArea()
            if celebration == "diamonds:50" {
                ForEach(Array(celebrationTokens.enumerated()), id: \.offset) { _, token in
                    Text(token.emoji)
                        .font(.system(size: 25 + CGFloat(token.delay * 16)))
                        .position(x: CGFloat(token.x * 900), y: CGFloat(token.y * 600))
                        .offset(y: showCelebration ? 0 : -100)
                        .animation(.easeOut(duration: 1.7).delay(token.delay), value: showCelebration)
                }
            } else if celebration == "diamonds:100" {
                ForEach(Array(celebrationTokens.enumerated()), id: \.offset) { _, token in
                    Text(token.emoji)
                        .font(.system(size: 25 + CGFloat(token.delay * 14)))
                        .position(x: CGFloat(token.x * 900), y: CGFloat(token.y * 600))
                        .offset(x: showCelebration ? (token.x < 0.5 ? 180 : -180) : 0, y: showCelebration ? -130 : 80)
                        .animation(.easeInOut(duration: 2.8).repeatCount(1, autoreverses: true).delay(token.delay), value: showCelebration)
                }
            }
            VStack(spacing: 12) {
                Text(celebrationTitle).font(.system(size: 34, weight: .heavy, design: .rounded))
                Text(celebrationSubtitle).font(.system(size: 19, weight: .semibold, design: .rounded))
                Button("Ура!") { withAnimation { showCelebration = false } }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.76, green: 0.36, blue: 0.68))
                    .padding(.top, 6)
            }
            .padding(30)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 26))
            .shadow(radius: 20)
        }
        .foregroundStyle(Color(red: 0.35, green: 0.20, blue: 0.45))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var celebrationTitle: String {
        switch celebration {
        case "diamonds:50": return "🎉 50 алмазов!"
        case "diamonds:100": return "🦋 100 алмазов!"
        default:
            if let value = celebration?.split(separator: ":").last { return "🔥 \(value) подряд!" }
            return "Молодец!"
        }
    }

    private var celebrationSubtitle: String {
        switch celebration {
        case "diamonds:50": return "Салют и целая компания мягких игрушек!"
        case "diamonds:100": return "Смотри, птички и бабочки летают!"
        default: return "Невероятная серия правильных ответов!"
        }
    }
}

private struct CelebrationToken {
    let emoji: String
    let x: Double
    let y: Double
    let delay: Double
}
