import SwiftUI

struct Problem {
    let text: String
    let answer: Int
}

struct ProblemGenerator {
    static func next() -> Problem {
        switch Int.random(in: 0...2) {
        case 0:
            let a = Int.random(in: 1...89)
            let b = Int.random(in: 1...(100 - a))
            return Problem(text: "\(a) + \(b) = ?", answer: a + b)
        case 1:
            let a = Int.random(in: 20...100)
            let b = Int.random(in: 1...a)
            return Problem(text: "\(a) − \(b) = ?", answer: a - b)
        default:
            for _ in 0..<100 {
                let a = Int.random(in: 10...80)
                let b = Int.random(in: 1...20)
                let sum = a + b
                if sum <= 100 {
                    let c = Int.random(in: 1...min(20, sum))
                    return Problem(text: "\(a) + \(b) − \(c) = ?", answer: sum - c)
                }
            }
            return Problem(text: "25 + 17 = ?", answer: 42)
        }
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
           let decoded = try? JSONDecoder().decode(TrainerStats.self, from: data) {
            stats = decoded
        } else {
            stats = TrainerStats()
        }
    }

    func record(correct isCorrect: Bool) -> [String] {
        let dayKey = Self.dateKey(Date())
        if let index = stats.days.firstIndex(where: { $0.date == dayKey }) {
            if isCorrect {
                stats.days[index].correct += 1
            } else {
                stats.days[index].incorrect += 1
            }
        } else {
            stats.days.append(DayStats(date: dayKey, correct: isCorrect ? 1 : 0, incorrect: isCorrect ? 0 : 1))
        }

        var rewards: [String] = []
        if isCorrect {
            stats.correct += 1
            stats.diamonds += 1
            stats.currentStreak += 1
            stats.bestStreak = max(stats.bestStreak, stats.currentStreak)

            if stats.currentStreak >= 5 && stats.currentStreak.isMultiple(of: 5)
                && !stats.celebratedStreaks.contains(stats.currentStreak) {
                stats.celebratedStreaks.append(stats.currentStreak)
                rewards.append("streak:\(stats.currentStreak)")
            }
            for milestone in [20, 50] where stats.diamonds >= milestone
                && !stats.celebratedDiamondMilestones.contains(milestone) {
                stats.celebratedDiamondMilestones.append(milestone)
                rewards.append("diamonds:\(milestone)")
            }
        } else {
            stats.incorrect += 1
            stats.currentStreak = 0
        }

        stats.days.sort { $0.date > $1.date }
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: key)
        }
        return rewards
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
        formatter.timeZone = .current
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
        .defaultSize(width: 1480, height: 940)
    }
}

private enum AppSection: String, CaseIterable, Identifiable {
    case task = "Задание"
    case statistics = "Статистика"
    case days = "По дням"
    case rewards = "Награды"
    case settings = "Настройки"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .task: return "house.fill"
        case .statistics: return "chart.bar.fill"
        case .days: return "calendar"
        case .rewards: return "trophy.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

private enum Palette {
    static let ink = Color(red: 0.20, green: 0.15, blue: 0.39)
    static let purple = Color(red: 0.56, green: 0.37, blue: 0.83)
    static let lilac = Color(red: 0.76, green: 0.65, blue: 0.96)
    static let pink = Color(red: 0.96, green: 0.70, blue: 0.86)
    static let palePink = Color(red: 1.00, green: 0.92, blue: 0.97)
    static let green = Color(red: 0.20, green: 0.66, blue: 0.43)
    static let red = Color(red: 0.89, green: 0.28, blue: 0.42)
    static let muted = Color(red: 0.51, green: 0.47, blue: 0.63)
    static let line = Color(red: 0.88, green: 0.82, blue: 0.97)
}

struct ContentView: View {
    @StateObject private var store = StatsStore()
    @State private var problem = ProblemGenerator.next()
    @State private var answer = ""
    @State private var selected: AppSection = .task
    @State private var answerState: AnswerState = .neutral
    @State private var showBunny = false
    @State private var celebration: String?
    @State private var showCelebration = false
    @State private var celebrationTokens: [CelebrationToken] = []
    @FocusState private var answerFocused: Bool

    enum AnswerState { case neutral, correct, incorrect }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    private var answerColor: Color {
        switch answerState {
        case .neutral: return Palette.purple
        case .correct: return Palette.green
        case .incorrect: return Palette.red
        }
    }

    private var today: DayStats {
        store.stats.days.first(where: { $0.date == StatsStore.dateKey(Date()) })
            ?? DayStats(date: StatsStore.dateKey(Date()))
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.88, green: 0.82, blue: 0.98),
                    Color(red: 1.00, green: 0.91, blue: 0.96),
                    Color(red: 0.96, green: 0.91, blue: 1.00)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            HStack(spacing: 0) {
                sidebar.frame(width: 238)
                Rectangle().fill(Palette.line.opacity(0.8)).frame(width: 1)
                mainContent.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 25))
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(.white.opacity(0.94), lineWidth: 1.2))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding(13)

            if showCelebration {
                celebrationOverlay
                    .transition(.opacity)
                    .zIndex(20)
            }
        }
        .frame(minWidth: 1180, minHeight: 760)
        .onAppear { answerFocused = true }
    }

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 17)
                        .fill(LinearGradient(colors: [Palette.purple, Color(red: 0.85, green: 0.43, blue: 0.74)],
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                    Image(systemName: "plus.forwardslash.minus")
                        .font(.system(size: 25, weight: .heavy))
                        .foregroundStyle(.white)
                }
                .frame(width: 52, height: 52)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Математика")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundStyle(Palette.ink)
                    Text("Учимся с удовольствием!")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(Palette.muted)
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 28)
            .padding(.bottom, 38)

            VStack(spacing: 8) {
                ForEach(AppSection.allCases) { section in
                    Button {
                        selected = section
                        if section == .task {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { answerFocused = true }
                        }
                    } label: {
                        HStack(spacing: 13) {
                            Image(systemName: section.icon)
                                .font(.system(size: 18, weight: .bold))
                                .frame(width: 24)
                            Text(section.rawValue)
                                .font(.system(size: 15, weight: selected == section ? .bold : .semibold, design: .rounded))
                            Spacer(minLength: 0)
                        }
                        .foregroundStyle(selected == section ? .white : Palette.purple)
                        .padding(.horizontal, 15)
                        .frame(height: 49)
                        .background {
                            if selected == section {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(LinearGradient(colors: [Palette.purple, Color(red: 0.68, green: 0.49, blue: 0.89)],
                                                         startPoint: .leading, endPoint: .trailing))
                                    .shadow(color: Palette.purple.opacity(0.2), radius: 8, x: 0, y: 4)
                            }
                        }
                        .contentShape(RoundedRectangle(cornerRadius: 15))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)

            Spacer(minLength: 20)

            HStack(spacing: 7) {
                Image(systemName: "heart.fill").foregroundStyle(Palette.pink)
                Text("Для маленьких побед")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(Palette.muted)
            }
            .padding(.horizontal, 19)

            Text("ВЕРСИЯ \(appVersion)")
                .font(.system(size: 11, weight: .heavy, design: .rounded))
                .foregroundStyle(Palette.purple)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.white.opacity(0.75), in: Capsule())
                .padding(.leading, 19)
                .padding(.top, 11)
                .padding(.bottom, 24)
        }
        .frame(maxHeight: .infinity)
        .background(LinearGradient(
            colors: [.white.opacity(0.86), Color(red: 0.95, green: 0.90, blue: 1.0).opacity(0.96)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        ))
    }

    @ViewBuilder
    private var mainContent: some View {
        switch selected {
        case .task: taskDashboard
        case .statistics: statisticsPage
        case .days: daysPage
        case .rewards: rewardsPage
        case .settings: settingsPage
        }
    }

    private var taskDashboard: some View {
        HStack(alignment: .top, spacing: 15) {
            VStack(spacing: 14) {
                topBar
                quizCard
                    .frame(maxWidth: .infinity, minHeight: 430)
                dailyPreview
                tipBar
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            rightDashboard.frame(width: 318)
        }
        .padding(17)
    }

    private var topBar: some View {
        HStack(spacing: 10) {
            HStack(spacing: 12) {
                Text("💎").font(.system(size: 32))
                VStack(alignment: .leading, spacing: 1) {
                    Text("Алмазы").font(.system(size: 12, weight: .bold, design: .rounded)).foregroundStyle(Palette.muted)
                    Text("\(store.stats.diamonds)").font(.system(size: 26, weight: .heavy, design: .rounded)).foregroundStyle(Palette.ink)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(.white.opacity(0.76), in: RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Palette.line, lineWidth: 1))

            HStack(spacing: 10) {
                Text("🔥").font(.system(size: 30))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Серия").font(.system(size: 12, weight: .bold, design: .rounded)).foregroundStyle(Palette.muted)
                    Text("\(store.stats.currentStreak) подряд").font(.system(size: 17, weight: .heavy, design: .rounded)).foregroundStyle(Palette.ink)
                }
                Spacer(minLength: 2)
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { index in
                        Circle()
                            .fill(index < store.stats.currentStreak % 5 ? Palette.purple : Palette.line)
                            .frame(width: 8, height: 8)
                    }
                }
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(.white.opacity(0.76), in: RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Palette.line, lineWidth: 1))
        }
    }

    private var quizCard: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 16)
            Text("РЕШИ ПРИМЕР")
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .tracking(1.1)
                .foregroundStyle(Palette.purple)
                .padding(.horizontal, 22)
                .padding(.vertical, 11)
                .background(.white.opacity(0.84), in: Capsule())
                .overlay(Capsule().stroke(.white, lineWidth: 1))
                .shadow(color: Palette.pink.opacity(0.18), radius: 9, y: 3)

            Spacer(minLength: 24)

            Text(problem.text)
                .font(.system(size: 62, weight: .heavy, design: .rounded))
                .foregroundStyle(Palette.ink)
                .contentTransition(.numericText())
                .minimumScaleFactor(0.42)
                .lineLimit(1)
                .padding(.horizontal, 12)

            Spacer(minLength: 34)

            HStack(spacing: 11) {
                TextField("Введи ответ...", text: $answer)
                    .font(.system(size: 23, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(answerColor)
                    .frame(height: 74)
                    .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 21))
                    .overlay(RoundedRectangle(cornerRadius: 21).stroke(answerColor.opacity(0.78), lineWidth: 2))
                    .focused($answerFocused)
                    .onSubmit(checkAnswer)
                    .onChange(of: answer) { _, newValue in
                        let filtered = String(newValue.filter(\.isNumber).prefix(3))
                        if filtered != newValue { answer = filtered }
                    }

                Button(action: checkAnswer) {
                    HStack(spacing: 7) {
                        Text("Проверить")
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 15)
                    .frame(height: 74)
                    .background(LinearGradient(colors: [Palette.lilac, Color(red: 0.82, green: 0.50, blue: 0.84)],
                                               startPoint: .topLeading, endPoint: .bottomTrailing),
                                in: RoundedRectangle(cornerRadius: 21))
                    .shadow(color: Palette.purple.opacity(0.2), radius: 10, y: 5)
                }
                .buttonStyle(.plain)
                .disabled(answerState == .correct)
            }
            .padding(.horizontal, 23)

            Text(stateMessage)
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundStyle(answerColor)
                .frame(height: 31)
                .padding(.top, 13)

            Spacer(minLength: 22)
            HStack(spacing: 8) {
                Text("✨")
                Text("Ты можешь! У тебя всё получится!")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Palette.purple)
                Text("💗")
            }
            .padding(.bottom, 21)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(LinearGradient(
                        colors: [.white.opacity(0.97), Color(red: 1, green: 0.91, blue: 0.96), Color(red: 0.96, green: 0.91, blue: 1)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                Circle().fill(.white.opacity(0.60)).frame(width: 360, height: 360).blur(radius: 10)
                Circle().fill(Palette.pink.opacity(0.18)).frame(width: 230, height: 230).blur(radius: 12).offset(x: -190, y: 170)
                Circle().fill(Palette.lilac.opacity(0.20)).frame(width: 260, height: 260).blur(radius: 12).offset(x: 220, y: 170)
            }
        }
        .overlay(alignment: .topLeading) {
            Text("✦").font(.system(size: 24)).foregroundStyle(Color(red: 1, green: 0.74, blue: 0.44)).padding(23)
        }
        .overlay(alignment: .topTrailing) {
            Text("✧").font(.system(size: 30)).foregroundStyle(Palette.pink).padding(26)
        }
        .overlay(alignment: .bottomTrailing) {
            Text("✦").font(.system(size: 22)).foregroundStyle(Color(red: 1, green: 0.78, blue: 0.52)).padding(23)
        }
        .overlay(alignment: .leading) {
            if showBunny {
                bunnySticker
                    .offset(x: -65, y: 34)
                    .transition(.move(edge: .leading).combined(with: .opacity))
                    .zIndex(5)
            }
        }
        .overlay(RoundedRectangle(cornerRadius: 28).stroke(.white.opacity(0.92), lineWidth: 1.4))
    }

    private var bunnySticker: some View {
        VStack(spacing: 0) {
            Text("😱").font(.system(size: 27)).offset(x: 22, y: 12)
            Text("🐰").font(.system(size: 92))
            Text("Ой!").font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundStyle(Palette.purple).offset(y: -8)
        }
        .frame(width: 128, height: 180)
        .background(LinearGradient(colors: [.white, Palette.palePink], startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 27))
        .overlay(RoundedRectangle(cornerRadius: 27).stroke(.white, lineWidth: 2))
        .shadow(color: Palette.purple.opacity(0.23), radius: 14, x: 3, y: 5)
        .allowsHitTesting(false)
    }

    private var tipBar: some View {
        HStack(spacing: 12) {
            Text("💡").font(.system(size: 29))
            VStack(alignment: .leading, spacing: 3) {
                Text("Маленькая подсказка")
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .foregroundStyle(Palette.ink)
                Text("Сначала реши сложение, потом вычитание.")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Palette.muted)
            }
            Spacer(minLength: 4)
            Rectangle().fill(Palette.line).frame(width: 1, height: 34)
            Button { nextProblem() } label: {
                Label("Новый пример", systemImage: "arrow.clockwise")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(Palette.purple)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(.white.opacity(0.75), in: RoundedRectangle(cornerRadius: 19))
        .overlay(RoundedRectangle(cornerRadius: 19).stroke(Palette.line.opacity(0.75), lineWidth: 1))
    }

    private var rightDashboard: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Общая статистика", icon: "chart.bar.fill")
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                        miniStat("Всего ответов", value: "\(store.stats.total)", icon: "list.number", color: Palette.purple)
                        miniStat("Верных", value: "\(store.stats.correct)", icon: "checkmark.circle.fill", color: Palette.green)
                        miniStat("Неверных", value: "\(store.stats.incorrect)", icon: "xmark.circle.fill", color: Palette.red)
                        miniStat("Точность", value: "\(store.stats.accuracy)%", icon: "percent", color: Color(red: 0.29, green: 0.57, blue: 0.87))
                    }
                }
                .padding(13)
                .cardStyle()

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        sectionTitle("Сегодня", icon: "calendar")
                        Spacer()
                        Text("За день").font(.system(size: 10, weight: .semibold, design: .rounded)).foregroundStyle(Palette.muted)
                    }
                    todayStat("Верных ответов", value: today.correct, icon: "checkmark.circle.fill", color: Palette.green)
                    todayStat("Неверных ответов", value: today.incorrect, icon: "xmark.circle.fill", color: Palette.red)
                    todayStat("Всего ответов", value: today.total, icon: "list.number", color: Palette.purple)
                    HStack {
                        Text("Точность").font(.system(size: 12, weight: .medium, design: .rounded)).foregroundStyle(Palette.muted)
                        Spacer()
                        Text("\(today.accuracy)%").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(Palette.purple)
                    }
                }
                .padding(13)
                .cardStyle()

                VStack(alignment: .leading, spacing: 9) {
                    HStack {
                        sectionTitle("По дням", icon: "calendar")
                        Spacer()
                        Button("Все") { selected = .days }
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(Palette.purple).buttonStyle(.plain)
                    }
                    if store.stats.days.isEmpty {
                        emptyHint("Результаты появятся после первых примеров.")
                    } else {
                        HStack(spacing: 4) {
                            tableHead("Дата", align: .leading)
                            tableHead("✓", align: .trailing).frame(width: 26)
                            tableHead("×", align: .trailing).frame(width: 26)
                            tableHead("Всего", align: .trailing).frame(width: 34)
                            tableHead("%", align: .trailing).frame(width: 30)
                        }
                        ForEach(Array(store.stats.days.prefix(4))) { day in
                            HStack(spacing: 4) {
                                Text(StatsStore.displayDate(day.date)).frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(day.correct)").foregroundStyle(Palette.green).frame(width: 26, alignment: .trailing)
                                Text("\(day.incorrect)").foregroundStyle(Palette.red).frame(width: 26, alignment: .trailing)
                                Text("\(day.total)").foregroundStyle(Palette.ink).frame(width: 34, alignment: .trailing)
                                Text("\(day.accuracy)%").foregroundStyle(Palette.purple).frame(width: 30, alignment: .trailing)
                            }
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .padding(.vertical, 5)
                        }
                    }
                }
                .padding(13)
                .cardStyle()

                VStack(alignment: .leading, spacing: 10) {
                    sectionTitle("Награды", icon: "trophy.fill")
                    rewardPreview(emoji: "🧸", title: "20 алмазов", subtitle: "Салют из игрушек", progress: min(store.stats.diamonds, 20), goal: 20)
                    rewardPreview(emoji: "🦋", title: "50 алмазов", subtitle: "Птички и бабочки", progress: min(store.stats.diamonds, 50), goal: 50)
                    Button("Все награды →") { selected = .rewards }
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(Palette.purple).buttonStyle(.plain)
                }
                .padding(13)
                .cardStyle()
            }
        }
        .scrollIndicators(.hidden)
    }

    private var dailyPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                sectionTitle("Статистика по дням", icon: "calendar")
                Spacer()
                Button("Показать все") { selected = .days }
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(Palette.purple).buttonStyle(.plain)
            }
            if store.stats.days.isEmpty {
                emptyHint("Здесь появится история занятий — сколько ответов удалось решить каждый день.")
            } else {
                HStack(spacing: 8) {
                    tableHead("Дата", align: .leading)
                    tableHead("Верных", align: .trailing).frame(width: 58)
                    tableHead("Неверных", align: .trailing).frame(width: 68)
                    tableHead("Всего", align: .trailing).frame(width: 47)
                    tableHead("Точность", align: .trailing).frame(width: 58)
                }
                .padding(.horizontal, 8)
                ForEach(Array(store.stats.days.prefix(3))) { day in
                    HStack(spacing: 8) {
                        Text(StatsStore.displayDate(day.date)).frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(day.correct)").foregroundStyle(Palette.green).frame(width: 58, alignment: .trailing)
                        Text("\(day.incorrect)").foregroundStyle(Palette.red).frame(width: 68, alignment: .trailing)
                        Text("\(day.total)").foregroundStyle(Palette.ink).frame(width: 47, alignment: .trailing)
                        Text("\(day.accuracy)%").foregroundStyle(Palette.purple).frame(width: 58, alignment: .trailing)
                    }
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 7)
                    .background(.white.opacity(0.48), in: RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(12)
        .cardStyle()
    }

    private var statisticsPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                pageHeading("Твои успехи", subtitle: "Каждый пример помогает стать увереннее 💜")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                    largeStat("Всего ответов", value: "\(store.stats.total)", icon: "list.number", color: Palette.purple)
                    largeStat("Правильных ответов", value: "\(store.stats.correct)", icon: "checkmark.circle.fill", color: Palette.green)
                    largeStat("Неправильных ответов", value: "\(store.stats.incorrect)", icon: "xmark.circle.fill", color: Palette.red)
                    largeStat("Процент верных", value: "\(store.stats.accuracy)%", icon: "target", color: Color(red: 0.29, green: 0.57, blue: 0.87))
                    largeStat("Алмазы", value: "💎 \(store.stats.diamonds)", icon: "sparkles", color: Palette.purple)
                    largeStat("Лучшая серия", value: "\(store.stats.bestStreak)", icon: "flame.fill", color: Color(red: 0.94, green: 0.52, blue: 0.24))
                }
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Твой прогресс", icon: "chart.bar.fill")
                    HStack {
                        Text("Правильные ответы").font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundStyle(Palette.ink)
                        Spacer()
                        Text("\(store.stats.accuracy)%").font(.system(size: 17, weight: .heavy, design: .rounded)).foregroundStyle(Palette.green)
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Palette.line.opacity(0.6))
                            Capsule()
                                .fill(LinearGradient(colors: [Palette.green, Color(red: 0.47, green: 0.84, blue: 0.62)], startPoint: .leading, endPoint: .trailing))
                                .frame(width: geo.size.width * CGFloat(store.stats.accuracy) / 100)
                        }
                    }
                    .frame(height: 16)
                    Text("За каждый верный ответ ты получаешь один алмаз. Ошибки тоже записываются, поэтому видно, как становится лучше точность.")
                        .font(.system(size: 13, weight: .medium, design: .rounded)).foregroundStyle(Palette.muted)
                }
                .padding(22)
                .cardStyle()
                Button("Посмотреть статистику по дням →") { selected = .days }
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(Palette.purple).buttonStyle(.plain)
            }
            .padding(25)
        }
        .scrollIndicators(.hidden)
    }

    private var daysPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                pageHeading("Статистика по дням", subtitle: "Все занятия по датам — результаты сохраняются на этом Mac")
                HStack(spacing: 12) {
                    largeStat("Всего ответов", value: "\(store.stats.total)", icon: "list.number", color: Palette.purple)
                    largeStat("Верных", value: "\(store.stats.correct)", icon: "checkmark.circle.fill", color: Palette.green)
                    largeStat("Неверных", value: "\(store.stats.incorrect)", icon: "xmark.circle.fill", color: Palette.red)
                    largeStat("Точность", value: "\(store.stats.accuracy)%", icon: "percent", color: Palette.purple)
                }
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        tableHead("Дата", align: .leading)
                        tableHead("Правильные", align: .trailing).frame(width: 120)
                        tableHead("Неправильные", align: .trailing).frame(width: 130)
                        tableHead("Всего ответов", align: .trailing).frame(width: 120)
                        tableHead("Верно", align: .trailing).frame(width: 80)
                    }
                    Rectangle().fill(Palette.line).frame(height: 1)
                    if store.stats.days.isEmpty {
                        emptyHint("Пока занятий нет. Реши первый пример — и здесь появятся результаты.")
                    } else {
                        ForEach(store.stats.days) { day in
                            HStack(spacing: 8) {
                                Text(StatsStore.displayDate(day.date)).frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(day.correct)").foregroundStyle(Palette.green).frame(width: 120, alignment: .trailing)
                                Text("\(day.incorrect)").foregroundStyle(Palette.red).frame(width: 130, alignment: .trailing)
                                Text("\(day.total)").foregroundStyle(Palette.ink).frame(width: 120, alignment: .trailing)
                                Text("\(day.accuracy)%").foregroundStyle(Palette.purple).frame(width: 80, alignment: .trailing)
                            }
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .padding(12)
                            .background(.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 11))
                        }
                    }
                }
                .padding(20)
                .cardStyle()
            }
            .padding(25)
        }
        .scrollIndicators(.hidden)
    }

    private var rewardsPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                pageHeading("Награды и достижения", subtitle: "Решай примеры, собирай алмазы и открывай праздничные сюрпризы ✨")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    rewardLarge("🧸", title: "20 алмазов", detail: "Салют из разноцветных мягких игрушек", progress: min(store.stats.diamonds, 20), goal: 20, color: Palette.pink)
                    rewardLarge("🦋", title: "50 алмазов", detail: "Вокруг будут летать маленькие птички и бабочки", progress: min(store.stats.diamonds, 50), goal: 50, color: Palette.lilac)
                    rewardLarge("🔥", title: "5 верных подряд", detail: "Первая серия без ошибок", progress: store.stats.currentStreak % 5, goal: 5, color: Color(red: 1, green: 0.83, blue: 0.60))
                    rewardLarge("🏆", title: "Лучшая серия", detail: "Твой личный рекорд — \(store.stats.bestStreak)", progress: min(store.stats.bestStreak, 20), goal: 20, color: Color(red: 0.76, green: 0.91, blue: 0.79))
                }
                Text("Каждый правильный ответ приносит один алмаз. Серия увеличивается, пока ответы верные, и начинается заново после ошибки.")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Palette.muted)
                    .padding(17)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardStyle()
            }
            .padding(25)
        }
        .scrollIndicators(.hidden)
    }

    private var settingsPage: some View {
        VStack(alignment: .leading, spacing: 20) {
            pageHeading("Настройки", subtitle: "Твоё учебное пространство")
            VStack(alignment: .leading, spacing: 15) {
                Label("Пастельная тема", systemImage: "paintpalette.fill")
                    .font(.system(size: 17, weight: .bold, design: .rounded)).foregroundStyle(Palette.ink)
                Text("Лавандовый, нежно-розовый и белый — как в детской книжке.")
                    .font(.system(size: 14, weight: .medium, design: .rounded)).foregroundStyle(Palette.muted)
                Divider().overlay(Palette.line)
                Label("Версия программы \(appVersion)", systemImage: "app.badge.checkmark")
                    .font(.system(size: 16, weight: .bold, design: .rounded)).foregroundStyle(Palette.purple)
                Text("Статистика и алмазы хранятся на этом Mac.")
                    .font(.system(size: 13, weight: .medium, design: .rounded)).foregroundStyle(Palette.muted)
            }
            .padding(24)
            .cardStyle()
            Spacer()
        }
        .padding(25)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var stateMessage: String {
        switch answerState {
        case .neutral: return "У тебя всё получится! 🌸"
        case .correct: return "Правильно! +1 алмаз 💎"
        case .incorrect: return "Попробуй ещё раз — заяц удивился! 🐰"
        }
    }

    private func sectionTitle(_ text: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .heavy))
                .foregroundStyle(Palette.purple)
            Text(text)
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundStyle(Palette.ink)
        }
    }

    private func miniStat(_ title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 5) {
                Image(systemName: icon).font(.system(size: 13, weight: .heavy)).foregroundStyle(color)
                Text(title).font(.system(size: 10, weight: .semibold, design: .rounded)).foregroundStyle(Palette.muted).lineLimit(1).minimumScaleFactor(0.75)
            }
            Text(value).font(.system(size: 23, weight: .heavy, design: .rounded)).foregroundStyle(Palette.ink)
        }
        .frame(maxWidth: .infinity, minHeight: 67, alignment: .leading)
        .padding(10)
        .background(.white.opacity(0.75), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Palette.line.opacity(0.7), lineWidth: 1))
    }

    private func todayStat(_ title: String, value: Int, icon: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 15, weight: .bold)).foregroundStyle(color)
            Text(title).font(.system(size: 11, weight: .medium, design: .rounded)).foregroundStyle(Palette.muted)
            Spacer(minLength: 2)
            Text("\(value)").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(color)
        }
        .padding(.vertical, 5)
        .overlay(alignment: .bottom) { Rectangle().fill(Palette.line.opacity(0.55)).frame(height: 1) }
    }

    private func tableHead(_ text: String, align: Alignment) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold, design: .rounded))
            .foregroundStyle(Palette.muted)
            .frame(maxWidth: align == .leading ? .infinity : nil, alignment: align)
    }

    private func emptyHint(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .medium, design: .rounded))
            .foregroundStyle(Palette.muted)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(.white.opacity(0.56), in: RoundedRectangle(cornerRadius: 11))
    }

    private func rewardPreview(emoji: String, title: String, subtitle: String, progress: Int, goal: Int) -> some View {
        HStack(spacing: 9) {
            Text(emoji).font(.system(size: 27))
                .frame(width: 42, height: 45)
                .background(Palette.palePink, in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.system(size: 12, weight: .heavy, design: .rounded)).foregroundStyle(Palette.ink)
                Text(subtitle).font(.system(size: 10, weight: .medium, design: .rounded)).foregroundStyle(Palette.muted)
                ProgressView(value: Double(progress), total: Double(goal)).tint(Palette.purple).scaleEffect(x: 1, y: 0.72, anchor: .center)
            }
            Spacer(minLength: 0)
        }
        .padding(7)
        .background(.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 13))
    }

    private func largeStat(_ title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon).font(.system(size: 23, weight: .semibold)).foregroundStyle(color)
            Text(value).font(.system(size: 29, weight: .heavy, design: .rounded)).foregroundStyle(Palette.ink)
                .minimumScaleFactor(0.7).lineLimit(1)
            Text(title).font(.system(size: 13, weight: .semibold, design: .rounded)).foregroundStyle(Palette.muted)
        }
        .frame(maxWidth: .infinity, minHeight: 113, alignment: .leading)
        .padding(17)
        .cardStyle()
    }

    private func rewardLarge(_ emoji: String, title: String, detail: String, progress: Int, goal: Int, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(emoji).font(.system(size: 42))
                .frame(width: 68, height: 68)
                .background(color.opacity(0.6), in: RoundedRectangle(cornerRadius: 20))
            Text(title).font(.system(size: 20, weight: .heavy, design: .rounded)).foregroundStyle(Palette.ink)
            Text(detail).font(.system(size: 13, weight: .medium, design: .rounded)).foregroundStyle(Palette.muted)
                .fixedSize(horizontal: false, vertical: true)
            ProgressView(value: Double(progress), total: Double(goal)).tint(Palette.purple)
            Text("\(progress) из \(goal)")
                .font(.system(size: 12, weight: .bold, design: .rounded)).foregroundStyle(Palette.purple)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .cardStyle()
    }

    private func pageHeading(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.system(size: 29, weight: .heavy, design: .rounded)).foregroundStyle(Palette.ink)
            Text(subtitle).font(.system(size: 14, weight: .medium, design: .rounded)).foregroundStyle(Palette.muted)
        }
    }

    private func checkAnswer() {
        guard let value = Int(answer), !answer.isEmpty, answerState != .correct else { return }
        let isCorrect = value == problem.answer
        let rewards = store.record(correct: isCorrect)

        if isCorrect {
            answerState = .correct
            if let reward = rewards.last { triggerCelebration(reward) }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.72) {
                if answerState == .correct { nextProblem() }
            }
        } else {
            answerState = .incorrect
            answer = ""
            withAnimation(.spring(response: 0.4, dampingFraction: 0.66)) { showBunny = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation(.easeOut(duration: 0.25)) { showBunny = false }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
                if answerState == .incorrect {
                    answerState = .neutral
                    answerFocused = true
                }
            }
        }
    }

    private func nextProblem() {
        problem = ProblemGenerator.next()
        answer = ""
        answerState = .neutral
        answerFocused = true
    }

    private func triggerCelebration(_ reward: String) {
        celebration = reward
        let emojis: [String]
        if reward == "diamonds:20" {
            emojis = ["🧸", "🎈", "🎉", "🪅", "🪁", "🧸", "🎊", "🧸", "🎈"]
        } else if reward == "diamonds:50" {
            emojis = ["🐦", "🦋", "🐤", "🦋", "🐦", "🦋", "🐦", "🦋", "🐤"]
        } else {
            emojis = ["⭐️", "✨", "💜", "🌸", "⭐️"]
        }

        celebrationTokens = (0..<42).map { index in
            CelebrationToken(
                emoji: emojis[index % emojis.count],
                x: Double.random(in: 0.03...0.97),
                y: Double.random(in: 0.07...0.93),
                delay: Double.random(in: 0...1.1),
                drift: Double.random(in: -140...140)
            )
        }
        withAnimation(.easeInOut(duration: 0.25)) { showCelebration = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.2) {
            withAnimation(.easeOut(duration: 0.45)) { showCelebration = false }
        }
    }

    private var celebrationOverlay: some View {
        GeometryReader { geo in
            ZStack {
                Color(red: 0.28, green: 0.17, blue: 0.40).opacity(0.20).ignoresSafeArea()
                ForEach(celebrationTokens.indices, id: \.self) { index in
                    let token = celebrationTokens[index]
                    Text(token.emoji)
                        .font(.system(size: CGFloat(24 + token.delay * 12)))
                        .position(x: CGFloat(token.x) * geo.size.width, y: CGFloat(token.y) * geo.size.height)
                        .offset(
                            x: showCelebration ? CGFloat(token.drift) : 0,
                            y: showCelebration ? -110 : 90
                        )
                        .animation(
                            .easeInOut(duration: celebration == "diamonds:50" ? 3.4 : 1.8)
                                .repeatCount(1, autoreverses: true)
                                .delay(token.delay),
                            value: showCelebration
                        )
                }
                VStack(spacing: 12) {
                    Text(celebrationTitle)
                        .font(.system(size: 34, weight: .heavy, design: .rounded))
                        .multilineTextAlignment(.center)
                    Text(celebrationSubtitle)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)
                    Button("Ура!") { withAnimation { showCelebration = false } }
                        .font(.system(size: 14, weight: .heavy, design: .rounded))
                        .buttonStyle(.borderedProminent)
                        .tint(Palette.purple)
                        .padding(.top, 6)
                }
                .foregroundStyle(Palette.ink)
                .padding(31)
                .frame(maxWidth: 460)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 27))
                .overlay(RoundedRectangle(cornerRadius: 27).stroke(.white.opacity(0.9), lineWidth: 1.5))
                .shadow(color: Palette.ink.opacity(0.18), radius: 30, y: 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var celebrationTitle: String {
        switch celebration {
        case "diamonds:20": return "🎉 20 алмазов!"
        case "diamonds:50": return "🦋 50 алмазов!"
        default:
            if let value = celebration?.split(separator: ":").last {
                return "🔥 \(value) правильных подряд!"
            }
            return "Молодец!"
        }
    }

    private var celebrationSubtitle: String {
        switch celebration {
        case "diamonds:20": return "Салют из разноцветных мягких игрушек!"
        case "diamonds:50": return "Птички и бабочки летают вокруг!"
        default: return "Ты отлично справляешься. Продолжай!"
        }
    }
}

private struct CelebrationToken {
    let emoji: String
    let x: Double
    let y: Double
    let delay: Double
    let drift: Double
}

private extension View {
    func cardStyle() -> some View {
        self
            .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 19))
            .overlay(RoundedRectangle(cornerRadius: 19).stroke(Palette.line.opacity(0.7), lineWidth: 1))
            .shadow(color: Palette.purple.opacity(0.035), radius: 8, y: 3)
    }
}
