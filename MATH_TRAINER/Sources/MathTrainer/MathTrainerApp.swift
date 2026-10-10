import SwiftUI

struct Problem {
    let text: String
    let answer: String
    let isComparison: Bool

    init(text: String, answer: String, isComparison: Bool = false) {
        self.text = text
        self.answer = answer
        self.isComparison = isComparison
    }
}

struct ProblemGenerator {
    static func next() -> Problem {
        switch Int.random(in: 0...8) {
        case 0:
            let a = Int.random(in: 1...89)
            let b = Int.random(in: 1...(100 - a))
            return Problem(text: "\(a) + \(b) = ?", answer: String(a + b))
        case 1:
            let a = Int.random(in: 20...100)
            let b = Int.random(in: 1...a)
            return Problem(text: "\(a) − \(b) = ?", answer: String(a - b))
        case 2:
            let a = Int.random(in: 10...80)
            let b = Int.random(in: 1...20)
            let c = Int.random(in: 1...min(20, a + b))
            return Problem(text: "\(a) + \(b) − \(c) = ?", answer: String(a + b - c))
        case 3:
            let a = Int.random(in: 2...9)
            let b = Int.random(in: 2...9)
            return Problem(text: "\(a) × \(b) = ?", answer: String(a * b))
        case 4:
            let divisor = Int.random(in: 2...9)
            let quotient = Int.random(in: 2...10)
            return Problem(text: "\(divisor * quotient) : \(divisor) = ?", answer: String(quotient))
        case 5:
            let a = Int.random(in: 2...9)
            let b = Int.random(in: 2...9)
            let c = Int.random(in: 1...15)
            return Problem(text: "\(a) × \(b) + \(c) = ?", answer: String(a * b + c))
        case 6:
            let a = Int.random(in: 2...9)
            let b = Int.random(in: 2...9)
            let product = a * b
            let c = Int.random(in: 1...max(1, product - 1))
            return Problem(text: "\(a) × \(b) − \(c) = ?", answer: String(product - c))
        case 7:
            let divisor = Int.random(in: 2...9)
            let quotient = Int.random(in: 3...10)
            let subtract = Int.random(in: 1...(quotient - 1))
            return Problem(text: "\(divisor * quotient) : \(divisor) − \(subtract) = ?", answer: String(quotient - subtract))
        default:
            let a = Int.random(in: 10...100)
            let b = Int.random(in: 10...100)
            let sign = a > b ? ">" : (a < b ? "<" : "=")
            return Problem(text: "Сравни числа:\n\(a)  ?  \(b)", answer: sign, isComparison: true)
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

    func spendDiamonds(_ amount: Int) -> Bool {
        guard amount > 0, stats.diamonds >= amount else { return false }
        stats.diamonds -= amount
        if let data = try? JSONEncoder().encode(stats) { UserDefaults.standard.set(data, forKey: key) }
        return true
    }

    static func dateKey(_ date: Date) -> String {
        let p = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", p.year ?? 0, p.month ?? 0, p.day ?? 0)
    }

    static func displayDate(_ key: String) -> String {
        let p = key.split(separator: "-")
        guard p.count == 3, let year = Int(p[0]), let month = Int(p[1]), let day = Int(p[2]),
              (1...12).contains(month), (1...31).contains(day) else { return key }
        return String(format: "%02d.%02d.%04d", day, month, year)
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
    case shop = "Магазин"
    case settings = "Настройки"
    case versionHistory = "Версии и изменения"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .task: return "house.fill"
        case .statistics: return "chart.bar.fill"
        case .days: return "calendar"
        case .rewards: return "trophy.fill"
        case .shop: return "storefront.fill"
        case .settings: return "gearshape.fill"
        case .versionHistory: return "doc.text.magnifyingglass"
        }
    }
}

private enum AppTheme: String, CaseIterable, Identifiable {
    case lilac = "Лаванда"
    case ocean = "Океан"
    case mint = "Мята"
    case peach = "Персик"
    case night = "Ночное небо"
    case rose = "Розовый сад"
    case forest = "Лес"
    case sky = "Небесная"
    case sunshine = "Солнечная"
    case galaxy = "Галактика"
    var id: String { rawValue }
}
private struct AppPalette {
    let theme: AppTheme
    private func c(_ r: Double, _ g: Double, _ b: Double) -> Color { Color(red:r, green:g, blue:b) }
    var ink: Color { switch theme { case .lilac:c(0.20,0.15,0.39); case .ocean:c(0.10,0.22,0.38); case .mint:c(0.12,0.32,0.29); case .peach:c(0.42,0.23,0.24); case .night:c(0.2,0.15,0.39); case .rose:c(0.45,0.19,0.27); case .forest:c(0.08,0.35,0.265); case .sky:c(0.075,0.245,0.415); case .sunshine:c(0.465,0.25,0.2); case .galaxy:c(0.16,0.13,0.3) } }
    var purple: Color { switch theme { case .lilac:c(0.56,0.37,0.83); case .ocean:c(0.23,0.46,0.76); case .mint:c(0.19,0.56,0.48); case .peach:c(0.80,0.42,0.42); case .night:c(0.62,0.48,0.94); case .rose:c(0.83,0.38,0.45); case .forest:c(0.15,0.59,0.455); case .sky:c(0.205,0.485,0.795); case .sunshine:c(0.845,0.44,0.38); case .galaxy:c(0.585,0.495,0.985) } }
    var lilac: Color { switch theme { case .lilac:c(0.76,0.65,0.96); case .ocean:c(0.62,0.82,0.98); case .mint:c(0.58,0.84,0.75); case .peach:c(1,0.70,0.54); case .night:c(0.42,0.30,0.75); case .rose:c(1,0.66,0.57); case .forest:c(0.54,0.87,0.725); case .sky:c(0.595,0.845,1); case .sunshine:c(1,0.72,0.5); case .galaxy:c(0.385,0.315,0.795) } }
    var pink: Color { switch theme { case .lilac:c(0.96,0.70,0.86); case .ocean:c(0.63,0.88,0.94); case .mint:c(0.74,0.92,0.83); case .peach:c(1,0.75,0.66); case .night:c(0.83,0.45,0.75); case .rose:c(1,0.71,0.69); case .forest:c(0.7,0.95,0.805); case .sky:c(0.605,0.905,0.975); case .sunshine:c(1,0.77,0.62); case .galaxy:c(0.795,0.465,0.795) } }
    var palePink: Color { switch theme { case .lilac:c(1,0.92,0.97); case .ocean:c(0.91,0.97,1); case .mint:c(0.91,0.98,0.94); case .peach:c(1,0.94,0.88); case .night:c(0.96,0.93,0.99); case .rose:c(1,0.9,0.91); case .forest:c(0.87,1,0.915); case .sky:c(0.885,0.995,1); case .sunshine:c(1,0.96,0.84); case .galaxy:c(0.96,0.94,1) } }
    var green: Color { switch theme { case .lilac:c(0.20,0.66,0.43); case .ocean:c(0.15,0.62,0.52); case .mint:c(0.15,0.62,0.42); case .peach:c(0.28,0.61,0.40); case .night:c(0.44,0.82,0.60); case .rose:c(0.31,0.57,0.43); case .forest:c(0.11,0.65,0.395); case .sky:c(0.125,0.645,0.555); case .sunshine:c(0.325,0.63,0.36); case .galaxy:c(0.405,0.835,0.645) } }
    var red: Color { switch theme { case .lilac:c(0.89,0.28,0.42); case .ocean:c(0.84,0.34,0.40); case .mint:c(0.83,0.31,0.44); case .peach:c(0.84,0.28,0.31); case .night:c(0.98,0.46,0.58); case .rose:c(0.87,0.24,0.34); case .forest:c(0.79,0.34,0.415); case .sky:c(0.815,0.365,0.435); case .sunshine:c(0.885,0.3,0.27); case .galaxy:c(0.945,0.475,0.625) } }
    var muted: Color { switch theme { case .lilac:c(0.51,0.47,0.63); case .ocean:c(0.32,0.47,0.62); case .mint:c(0.30,0.50,0.46); case .peach:c(0.56,0.39,0.39); case .night:c(0.36,0.31,0.48); case .rose:c(0.59,0.35,0.42); case .forest:c(0.26,0.53,0.435); case .sky:c(0.295,0.495,0.655); case .sunshine:c(0.605,0.41,0.35); case .galaxy:c(0.34,0.29,0.48) } }
    var line: Color { switch theme { case .lilac:c(0.88,0.82,0.97); case .ocean:c(0.75,0.87,0.98); case .mint:c(0.76,0.91,0.84); case .peach:c(0.97,0.82,0.72); case .night:c(0.39,0.34,0.53); case .rose:c(1,0.78,0.75); case .forest:c(0.72,0.94,0.815); case .sky:c(0.725,0.895,1); case .sunshine:c(1,0.84,0.68); case .galaxy:c(0.355,0.355,0.575) } }
    var canvasTop: Color { switch theme { case .lilac:c(0.88,0.82,0.98); case .ocean:c(0.83,0.92,1); case .mint:c(0.82,0.96,0.89); case .peach:c(1,0.86,0.75); case .night:c(0.15,0.13,0.27); case .rose:c(1,0.82,0.78); case .forest:c(0.78,0.99,0.865); case .sky:c(0.805,0.945,1); case .sunshine:c(1,0.88,0.71); case .galaxy:c(0.115,0.145,0.315) } }
    var canvasMiddle: Color { switch theme { case .lilac:c(1,0.91,0.96); case .ocean:c(0.90,0.97,1); case .mint:c(0.94,1,0.96); case .peach:c(1,0.94,0.87); case .night:c(0.22,0.17,0.34); case .rose:c(1,0.9,0.9); case .forest:c(0.9,1,0.935); case .sky:c(0.875,0.995,1); case .sunshine:c(1,0.96,0.83); case .galaxy:c(0.185,0.185,0.385) } }
    var canvasBottom: Color { switch theme { case .lilac:c(0.96,0.91,1); case .ocean:c(0.88,0.95,1); case .mint:c(0.83,0.95,0.90); case .peach:c(1,0.89,0.81); case .night:c(0.14,0.18,0.31); case .rose:c(1,0.85,0.84); case .forest:c(0.79,0.98,0.875); case .sky:c(0.855,0.975,1); case .sunshine:c(1,0.91,0.77); case .galaxy:c(0.105,0.195,0.355) } }
    var sidebarTop: Color { switch theme { case .lilac:.white; case .ocean:c(0.96,0.99,1); case .mint:c(0.98,1,0.98); case .peach:c(1,0.99,0.96); case .night:c(0.98,0.97,1); case .rose:c(1,0.95,0.99); case .forest:c(0.94,1,0.955); case .sky:c(0.935,1,1); case .sunshine:c(1,1,0.92); case .galaxy:c(0.97,0.96,1) } }
    var sidebarBottom: Color { switch theme { case .lilac:c(0.95,0.90,1); case .ocean:c(0.87,0.94,1); case .mint:c(0.86,0.97,0.91); case .peach:c(1,0.90,0.81); case .night:c(0.91,0.88,0.99); case .rose:c(1,0.86,0.84); case .forest:c(0.82,1,0.885); case .sky:c(0.845,0.965,1); case .sunshine:c(1,0.92,0.77); case .galaxy:c(0.9,0.88,0.99) } }
    var quizTop: Color { switch theme { case .lilac:c(1,0.99,1); case .ocean:c(0.97,1,1); case .mint:c(0.99,1,0.99); case .peach:c(1,0.99,0.96); case .night:c(1,0.98,1); case .rose:c(1,0.95,0.99); case .forest:c(0.95,1,0.965); case .sky:c(0.945,1,1); case .sunshine:c(1,1,0.92); case .galaxy:c(0.99,0.98,1) } }
    var quizBottom: Color { switch theme { case .lilac:c(1,0.91,0.96); case .ocean:c(0.87,0.96,1); case .mint:c(0.88,0.98,0.92); case .peach:c(1,0.88,0.78); case .night:c(0.88,0.83,0.98); case .rose:c(1,0.84,0.81); case .forest:c(0.84,1,0.895); case .sky:c(0.845,0.985,1); case .sunshine:c(1,0.9,0.74); case .galaxy:c(0.88,0.84,1) } }
    var quizGlow: Color { switch theme { case .lilac:c(0.94,0.88,0.98); case .ocean:c(0.66,0.87,0.98); case .mint:c(0.70,0.91,0.82); case .peach:c(1,0.76,0.63); case .night:c(0.42,0.32,0.62); case .rose:c(1,0.72,0.66); case .forest:c(0.66,0.94,0.795); case .sky:c(0.635,0.895,1); case .sunshine:c(1,0.78,0.59); case .galaxy:c(0.385,0.335,0.665) } }
    static func make(_ theme: AppTheme) -> AppPalette { AppPalette(theme: theme) }
}
private enum StudySubject: String, CaseIterable, Identifiable {
    case math = "Математика"
    case world = "Окружающий мир"
    case russian = "Русский язык"
    case english = "Английский язык"
    case tatar = "Татарский язык"
    case art = "Рисование"
    case keyboard = "Клавиатура"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .math: "function"
        case .world: "leaf.fill"
        case .russian: "book.closed.fill"
        case .english: "globe"
        case .tatar: "textformat"
        case .art: "paintpalette.fill"
        case .keyboard: "keyboard"
        }
    }
}
private struct Achievement: Identifiable {
    let id: String
    let title: String
    let detail: String
    let emoji: String
}
private enum AchievementCatalog {
    static let all = [
        Achievement(id: "first-answer", title: "Первый шаг", detail: "Реши свой первый пример", emoji: "🌱"),
        Achievement(id: "ten-correct", title: "Десятка", detail: "10 правильных ответов", emoji: "🔟"),
        Achievement(id: "twenty-correct", title: "Двадцатка", detail: "20 правильных ответов", emoji: "🌟"),
        Achievement(id: "fifty-correct", title: "Полсотни", detail: "50 правильных ответов", emoji: "🎖️"),
        Achievement(id: "five-streak", title: "Не остановить", detail: "5 верных подряд", emoji: "🔥"),
        Achievement(id: "fifteen-streak", title: "Суперсерия", detail: "15 верных подряд", emoji: "⚡️"),
        Achievement(id: "twenty-streak", title: "Серия мастера", detail: "20 верных подряд", emoji: "🚀"),
        Achievement(id: "daily-solver", title: "Марафонец", detail: "20 ответов за один день", emoji: "🏃"),
        Achievement(id: "three-days", title: "Стабильность", detail: "Занимайся в 3 разных дня", emoji: "📅"),
        Achievement(id: "five-days", title: "Пять учебных дней", detail: "Занимайся в 5 разных днях", emoji: "🗓️"),
        Achievement(id: "perfect-ten", title: "Без ошибок", detail: "10 ответов без ошибок", emoji: "💎"),
        Achievement(id: "accuracy-90", title: "Меткий ответ", detail: "Точность 90% после 50 ответов", emoji: "🎯"),
        Achievement(id: "hundred-answers", title: "Сотня", detail: "100 решённых примеров", emoji: "🏆"),
        Achievement(id: "five-hundred-answers", title: "Большой ум", detail: "500 решённых примеров", emoji: "🧠"),
        Achievement(id: "diamond-100", title: "Алмазный запас", detail: "Накопи 100 алмазов", emoji: "💠")
    ]
}
private struct Collectible: Identifiable {
    let id: String
    let title: String
    let detail: String
    let emoji: String

    static let all: [Collectible] = {
        let legacy: [Collectible] = [
            Collectible(id: "rainbow", title: "Радуга", detail: "Редкая цветная находка", emoji: "🌈"),
            Collectible(id: "magic-star", title: "Волшебная звезда", detail: "Маленькое чудо за старание", emoji: "🌟"),
            Collectible(id: "bunny-friend", title: "Друг-зайчонок", detail: "Пушистый помощник", emoji: "🐰"),
            Collectible(id: "heart-gem", title: "Сердце-драгоценность", detail: "Особая находка", emoji: "💖"),
            Collectible(id: "fox", title: "Лисёнок", detail: "Хитрый хранитель знаний", emoji: "🦊"),
            Collectible(id: "turtle", title: "Черепашка", detail: "Напоминает не торопиться", emoji: "🐢"),
            Collectible(id: "unicorn", title: "Единорог", detail: "Волшебный друг", emoji: "🦄"),
            Collectible(id: "koala", title: "Коала", detail: "Мягкий коллекционный друг", emoji: "🐨"),
            Collectible(id: "planet", title: "Планета", detail: "Маленький мир открытий", emoji: "🪐"),
            Collectible(id: "robot", title: "Робот", detail: "Помощник юного инженера", emoji: "🤖"),
            Collectible(id: "dragon", title: "Дракончик", detail: "Редкий огненный друг", emoji: "🐉"),
            Collectible(id: "cat", title: "Котёнок", detail: "Самый любопытный в коллекции", emoji: "🐱")
        ]
        let mascots: [(id: String, title: String, emoji: String)] = [
            ("bunny", "Зайчонок", "🐰"), ("fox", "Лисёнок", "🦊"),
            ("turtle", "Черепашка", "🐢"), ("unicorn", "Единорог", "🦄"),
            ("koala", "Коала", "🐨"), ("planet", "Планета", "🪐"),
            ("robot", "Робот", "🤖"), ("dragon", "Дракончик", "🐉"),
            ("cat", "Котёнок", "🐱"), ("dog", "Щенок", "🐶"),
            ("bear", "Медвежонок", "🐻"), ("panda", "Панда", "🐼"),
            ("penguin", "Пингвин", "🐧"), ("owl", "Совёнок", "🦉"),
            ("bee", "Пчёлка", "🐝"), ("butterfly", "Бабочка", "🦋"),
            ("frog", "Лягушонок", "🐸"), ("whale", "Китёнок", "🐳"),
            ("dolphin", "Дельфин", "🐬"), ("octopus", "Осьминожек", "🐙"),
            ("hedgehog", "Ёжик", "🦔"), ("hamster", "Хомячок", "🐹"),
            ("tiger", "Тигрёнок", "🐯"), ("lion", "Львёнок", "🦁"),
            ("monkey", "Обезьянка", "🐵"), ("giraffe", "Жираф", "🦒"),
            ("elephant", "Слонёнок", "🐘"), ("parrot", "Попугай", "🦜"),
            ("duck", "Утёнок", "🦆"), ("snail", "Улитка", "🐌")
        ]
        let collections: [(id: String, name: String, detail: String)] = [
            ("bronze", "Бронзовый", "Тёплая бронзовая коллекция"),
            ("silver", "Серебряный", "Блестящая серебряная коллекция"),
            ("gold", "Золотой", "Редкая золотая коллекция"),
            ("cosmic", "Космический", "Игрушка из далёкой галактики"),
            ("rainbow", "Радужный", "Яркая радужная коллекция")
        ]
        let themed = collections.flatMap { collection in
            mascots.map { mascot in
                Collectible(id: "\(collection.id)-\(mascot.id)",
                            title: "\(collection.name) \(mascot.title)",
                            detail: collection.detail,
                            emoji: mascot.emoji)
            }
        }
        return legacy + themed
    }()
}

private struct ReleaseNote: Identifiable {
    let version: String
    let date: String
    let title: String
    let changes: [String]
    var id: String { version }
}

struct ContentView: View {
    @AppStorage("MathTrainer.Theme") private var themeName = AppTheme.lilac.rawValue
    @AppStorage("MathTrainer.SelectedSubject") private var selectedSubjectName = StudySubject.math.rawValue
    @AppStorage("MathTrainer.UnlockedAchievements") private var unlockedAchievementStorage = ""
    @AppStorage("MathTrainer.RandomCollectibles") private var randomCollectiblesStorage = ""
    @AppStorage("MathTrainer.ShopPurchases") private var shopPurchasesStorage = ""
    @AppStorage("MathTrainer.ShopPrices.v2") private var shopPricesStorage = ""
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
    private var appReleaseDate: String {
        Bundle.main.infoDictionary?["AppReleaseDate"] as? String ?? "Дата неизвестна"
    }
    private var selectedSubject: StudySubject { StudySubject(rawValue: selectedSubjectName) ?? .math }
    private var palette: AppPalette { AppPalette.make(AppTheme(rawValue: themeName) ?? .lilac) }
    private var unlockedAchievementIDs: Set<String> { Set(unlockedAchievementStorage.split(separator: ",").map(String.init)) }
    private var unlockedCollectibleIDs: Set<String> { Set(randomCollectiblesStorage.split(separator: ",").map(String.init)) }
    private var shopOwnedIDs: Set<String> { Set(shopPurchasesStorage.split(separator: ",").map(String.init)) }
    private var allOwnedCollectibleIDs: Set<String> { unlockedCollectibleIDs.union(shopOwnedIDs) }
    private var shopPrices: [String: Int] {
        var result: [String: Int] = [:]
        for entry in shopPricesStorage.split(separator: ",") {
            let pair = entry.split(separator: "=", maxSplits: 1)
            if pair.count == 2, let price = Int(pair[1]) { result[String(pair[0])] = price }
        }
        return result
    }
    private var levelNumber: Int { store.stats.total / 25 + 1 }
    private var levelProgress: Int { store.stats.total % 25 }
    private var releaseNotes: [ReleaseNote] {
        [
            ReleaseNote(version: appVersion, date: appReleaseDate, title: "Текущий выпуск", changes: [
                "Исправлено: заяц появляется внутри карточки задания, а не между колонками.",
                "Устранено: голубые линии и стандартное оформление поля ответа.",
                "Добавлено: 10 цветовых тем и раздел «Клавиатура» (пока без уроков).",
                "Магазин расширен до 162 игрушек: 12 прежних предметов и 150 новых вариантов.",
                "Первая игрушка стоит 25 алмазов; цена следующей случайно растёт на 20 или 25 алмазов и сохраняется.",
                "Добавлены уровни, бронзовая, серебряная и золотая медали и новые достижения.",
                "Исправлено отображение даты занятия: DD.MM.YYYY с явным контрастным цветом текста.",
                "Для тем «Ночное небо» и «Галактика» исправлен контраст текста и фон карточек.",
                "Добавлены таблица умножения и деления, смешанные действия и сравнение чисел знаками >, < и =."
                "Приложение переименовано в «Тренировка мозга», добавлена нативная иконка macOS."
            ]),
            ReleaseNote(version: "1.0.10", date: "09.10.2026", title: "Новый интерфейс", changes: [
                "Переработан основной экран: боковое меню, карточка примера и правая панель статистики.",
                "Добавлены статистика по дням, алмазы и праздничные анимации.",
                "Добавлен номер версии в интерфейс."
            ]),
            ReleaseNote(version: "1.0.9", date: "09.10.2026", title: "Версия и награды", changes: [
                "Сделан заметным номер версии приложения.",
                "Обновлены награды за 20 и 50 алмазов."
            ]),
            ReleaseNote(version: "1.0.8", date: "09.10.2026", title: "Статистика", changes: [
                "Добавлена статистика правильных и неправильных ответов.",
                "Добавлена история результатов по дням и начисление алмазов."
            ])
        ]
    }

    private var answerColor: Color {
        switch answerState {
        case .neutral: return palette.purple
        case .correct: return palette.green
        case .incorrect: return palette.red
        }
    }

    private var today: DayStats {
        store.stats.days.first(where: { $0.date == StatsStore.dateKey(Date()) })
            ?? DayStats(date: StatsStore.dateKey(Date()))
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [palette.canvasTop, palette.canvasMiddle, palette.canvasBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            HStack(spacing: 0) {
                sidebar.frame(width: 238)
                Rectangle().fill(palette.line.opacity(0.8)).frame(width: 1)
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
        .onAppear { prepareShopPrices(); answerFocused = true }
    }

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 17).fill(LinearGradient(colors: [palette.purple, Color(red: 0.85, green: 0.43, blue: 0.74)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    Image(systemName: "brain.head.profile").font(.system(size: 27, weight: .heavy)).foregroundStyle(.white)
                }.frame(width: 52, height: 52)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Тренировка мозга").font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink).lineLimit(2).minimumScaleFactor(0.78)
                    Menu {
                        ForEach(StudySubject.allCases) { subject in
                            Button {
                                selectedSubjectName = subject.rawValue
                                selected = .task
                                answerState = .neutral
                                answer = ""
                                if subject == .math {
                                    problem = ProblemGenerator.next()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { answerFocused = true }
                                }
                            } label: { Label(subject.rawValue, systemImage: subject.icon) }
                        }
                    } label: {
                        HStack(spacing: 5) {
                            Text(selectedSubject.rawValue).font(.system(size: 12, weight: .heavy, design: .rounded)).lineLimit(1).minimumScaleFactor(0.7)
                            Image(systemName: "chevron.down").font(.system(size: 9, weight: .heavy))
                        }.foregroundStyle(palette.purple).contentShape(Rectangle())
                    }.menuStyle(.borderlessButton)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 14).padding(.top, 25).padding(.bottom, 27)

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
                        .foregroundStyle(selected == section ? .white : palette.purple)
                        .padding(.horizontal, 15)
                        .frame(height: 49)
                        .background {
                            if selected == section {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(LinearGradient(colors: [palette.purple, Color(red: 0.68, green: 0.49, blue: 0.89)],
                                                         startPoint: .leading, endPoint: .trailing))
                                    .shadow(color: palette.purple.opacity(0.2), radius: 8, x: 0, y: 4)
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
                Image(systemName: "heart.fill").foregroundStyle(palette.pink)
                Text("Для маленьких побед")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(palette.muted)
            }
            .padding(.horizontal, 19)

            Text("ВЕРСИЯ \(appVersion)")
                .font(.system(size: 11, weight: .heavy, design: .rounded))
                .foregroundStyle(palette.purple)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.white.opacity(0.75), in: Capsule())
                .padding(.leading, 19)
                .padding(.top, 11)
                .padding(.bottom, 24)
        }
        .frame(maxHeight: .infinity)
        .background(LinearGradient(
            colors: [palette.sidebarTop, palette.sidebarBottom],
            startPoint: .topLeading, endPoint: .bottomTrailing
        ))
    }

    @ViewBuilder
    private var mainContent: some View {
        switch selected {
        case .task:
            if selectedSubject == .math { taskDashboard } else { subjectComingSoon }
        case .statistics: statisticsPage
        case .days: daysPage
        case .rewards: rewardsPage
        case .shop: shopPage
        case .settings: settingsPage
        case .versionHistory: versionHistoryPage
        }
    }

    private var subjectComingSoon: some View {
        VStack(alignment: .leading, spacing: 25) {
            pageHeading(selectedSubject.rawValue, subtitle: "Новый предмет в твоём учебном пространстве")
            Spacer()
            VStack(spacing: 18) {
                Text(subjectEmoji).font(.system(size: 86))
                Text("Готовим задания!").font(.system(size: 30, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                Text("Раздел уже создан. Задания для этого предмета появятся в следующем обновлении. Математика продолжает работать как обычно.")
                    .font(.system(size: 16, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    .multilineTextAlignment(.center).frame(maxWidth: 510)
                Button {
                    selectedSubjectName = StudySubject.math.rawValue
                    selected = .task
                    problem = ProblemGenerator.next()
                    answer = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { answerFocused = true }
                } label: {
                    Label("Вернуться к математике", systemImage: "function")
                        .font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                        .padding(.horizontal, 20).padding(.vertical, 13).background(palette.purple, in: Capsule())
                }.buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity).padding(40).cardStyle(palette)
            Spacer()
        }
        .padding(28).frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var subjectEmoji: String {
        switch selectedSubject {
        case .math: "🔢"
        case .world: "🌍"
        case .russian: "📚"
        case .english: "🔤"
        case .tatar: "🌿"
        case .art: "🎨"
        case .keyboard: "⌨️"
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
            Button { openShop() } label: {
                HStack(spacing: 12) {
                    Text("💎").font(.system(size: 32))
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Алмазы · магазин").font(.system(size: 12, weight: .bold, design: .rounded)).foregroundStyle(palette.muted)
                        Text("\(store.stats.diamonds)").font(.system(size: 26, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right").font(.system(size: 11, weight: .heavy)).foregroundStyle(palette.purple)
                }.padding(.horizontal, 14).frame(maxWidth: .infinity).frame(height: 70)
                 .background(.white.opacity(0.76), in: RoundedRectangle(cornerRadius: 20))
                 .overlay(RoundedRectangle(cornerRadius: 20).stroke(palette.line, lineWidth: 1))
            }.buttonStyle(.plain).help("Открыть магазин коллекционных игрушек")
            HStack(spacing: 10) {
                Text("🔥").font(.system(size: 30))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Серия").font(.system(size: 12, weight: .bold, design: .rounded)).foregroundStyle(palette.muted)
                    Text("\(store.stats.currentStreak) подряд").font(.system(size: 17, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                }
                Spacer(minLength: 2)
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { index in
                        Circle().fill(index < store.stats.currentStreak % 5 ? palette.purple : palette.line).frame(width: 8, height: 8)
                    }
                }
            }.padding(.horizontal, 12).frame(maxWidth: .infinity).frame(height: 70)
             .background(.white.opacity(0.76), in: RoundedRectangle(cornerRadius: 20))
             .overlay(RoundedRectangle(cornerRadius: 20).stroke(palette.line, lineWidth: 1))
        }
    }

    private var quizCard: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 16)
            Text("РЕШИ ПРИМЕР")
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .tracking(1.1)
                .foregroundStyle(palette.purple)
                .padding(.horizontal, 22)
                .padding(.vertical, 11)
                .background(.white.opacity(0.84), in: Capsule())
                .overlay(Capsule().stroke(.white, lineWidth: 1))
                .shadow(color: palette.pink.opacity(0.18), radius: 9, y: 3)

            Spacer(minLength: 24)

            Text(problem.text)
                .font(.system(size: 62, weight: .heavy, design: .rounded))
                .foregroundStyle(palette.ink)
                .contentTransition(.numericText())
                .minimumScaleFactor(0.42)
                .lineLimit(1)
                .padding(.horizontal, 12)

            Spacer(minLength: 34)

            HStack(spacing: 11) {
                TextField(problem.isComparison ? "Выбери знак ниже" : "Введи ответ...", text: $answer)
                    .font(.system(size: 23, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(answerColor)
                    .textFieldStyle(.plain)
                    .focusEffectDisabled()
                    .frame(height: 74)
                    .background(.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 21))
                    .overlay(RoundedRectangle(cornerRadius: 21).stroke(answerColor.opacity(0.78), lineWidth: 2))
                    .focused($answerFocused)
                    .onSubmit(checkAnswer)
                    .onChange(of: answer) { _, newValue in
                        if problem.isComparison {
                            let filtered = String(newValue.filter { ["<", ">", "="].contains(String($0)) }.prefix(1))
                            if filtered != newValue { answer = filtered }
                        } else {
                            let filtered = String(newValue.filter(\.isNumber).prefix(3))
                            if filtered != newValue { answer = filtered }
                        }
                    }

                if problem.isComparison {
                    HStack(spacing: 12) {
                        ForEach([">", "<", "="], id: \.self) { symbol in
                            Button {
                                answer = symbol
                                answerFocused = false
                            } label: {
                                Text(symbol)
                                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                                    .foregroundStyle(answer == symbol ? .white : palette.ink)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 49)
                                    .background(answer == symbol ? palette.purple : .white.opacity(0.90), in: RoundedRectangle(cornerRadius: 14))
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(palette.line, lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                            .disabled(answerState == .correct)
                        }
                    }
                    .padding(.horizontal, 23)
                    .padding(.top, -8)
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
                    .background(LinearGradient(colors: [palette.lilac, Color(red: 0.82, green: 0.50, blue: 0.84)],
                                               startPoint: .topLeading, endPoint: .bottomTrailing),
                                in: RoundedRectangle(cornerRadius: 21))
                    .shadow(color: palette.purple.opacity(0.2), radius: 10, y: 5)
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
                    .foregroundStyle(palette.purple)
                Text("💗")
            }
            .padding(.bottom, 21)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(LinearGradient(
                        colors: [palette.quizTop, palette.quizBottom, palette.palePink],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ))
                Circle().fill(.white.opacity(0.60)).frame(width: 360, height: 360).blur(radius: 10)
                Circle().fill(palette.quizGlow.opacity(0.34)).frame(width: 230, height: 230).blur(radius: 12).offset(x: -190, y: 170)
                Circle().fill(palette.lilac.opacity(0.20)).frame(width: 260, height: 260).blur(radius: 12).offset(x: 220, y: 170)
            }
        }
        .overlay(alignment: .topLeading) {
            Text("✦").font(.system(size: 24)).foregroundStyle(Color(red: 1, green: 0.74, blue: 0.44)).padding(23)
        }
        .overlay(alignment: .topTrailing) {
            Text("✧").font(.system(size: 30)).foregroundStyle(palette.pink).padding(26)
        }
        .overlay(alignment: .bottomTrailing) {
            Text("✦").font(.system(size: 22)).foregroundStyle(Color(red: 1, green: 0.78, blue: 0.52)).padding(23)
        }
        .overlay(alignment: .leading) {
            if showBunny {
                bunnySticker.scaleEffect(0.78)
                    .offset(x: 8, y: 28)
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
                .foregroundStyle(palette.purple).offset(y: -8)
        }
        .frame(width: 112, height: 150)
        .background(LinearGradient(colors: [.white, palette.palePink], startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 27))
        .overlay(RoundedRectangle(cornerRadius: 27).stroke(.white, lineWidth: 2))
        .shadow(color: palette.purple.opacity(0.23), radius: 14, x: 3, y: 5)
        .allowsHitTesting(false)
    }

    private var tipBar: some View {
        HStack(spacing: 12) {
            Text("💡").font(.system(size: 29))
            VStack(alignment: .leading, spacing: 3) {
                Text("Маленькая подсказка")
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .foregroundStyle(palette.ink)
                Text("Сначала реши сложение, потом вычитание.")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.muted)
            }
            Spacer(minLength: 4)
            Rectangle().fill(palette.line).frame(width: 1, height: 34)
            Button { nextProblem() } label: {
                Label("Новый пример", systemImage: "arrow.clockwise")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.purple)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(.white.opacity(0.75), in: RoundedRectangle(cornerRadius: 19))
        .overlay(RoundedRectangle(cornerRadius: 19).stroke(palette.line.opacity(0.75), lineWidth: 1))
    }

    private var rightDashboard: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Общая статистика", icon: "chart.bar.fill")
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                        miniStat("Всего ответов", value: "\(store.stats.total)", icon: "list.number", color: palette.purple)
                        miniStat("Верных", value: "\(store.stats.correct)", icon: "checkmark.circle.fill", color: palette.green)
                        miniStat("Неверных", value: "\(store.stats.incorrect)", icon: "xmark.circle.fill", color: palette.red)
                        miniStat("Точность", value: "\(store.stats.accuracy)%", icon: "percent", color: Color(red: 0.29, green: 0.57, blue: 0.87))
                    }
                }
                .padding(13)
                .cardStyle(palette)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        sectionTitle("Сегодня", icon: "calendar")
                        Spacer()
                        Text("За день").font(.system(size: 10, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
                    }
                    todayStat("Верных ответов", value: today.correct, icon: "checkmark.circle.fill", color: palette.green)
                    todayStat("Неверных ответов", value: today.incorrect, icon: "xmark.circle.fill", color: palette.red)
                    todayStat("Всего ответов", value: today.total, icon: "list.number", color: palette.purple)
                    HStack {
                        Text("Точность").font(.system(size: 12, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                        Spacer()
                        Text("\(today.accuracy)%").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple)
                    }
                }
                .padding(13)
                .cardStyle(palette)

                VStack(alignment: .leading, spacing: 9) {
                    HStack {
                        sectionTitle("По дням", icon: "calendar")
                        Spacer()
                        Button("Все") { selected = .days }
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(palette.purple).buttonStyle(.plain)
                    }
                    if store.stats.days.isEmpty {
                        emptyHint("Результаты появятся после первых примеров.")
                    } else {
                        HStack(spacing: 4) {
                            tableHead("Дата занятия", align: .leading)
                            tableHead("✓", align: .trailing).frame(width: 26)
                            tableHead("×", align: .trailing).frame(width: 26)
                            tableHead("Всего", align: .trailing).frame(width: 34)
                            tableHead("%", align: .trailing).frame(width: 30)
                        }
                        ForEach(Array(store.stats.days.prefix(4))) { day in
                            HStack(spacing: 4) {
                                Text(StatsStore.displayDate(day.date)).foregroundStyle(palette.ink).lineLimit(1).minimumScaleFactor(0.65).frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(day.correct)").foregroundStyle(palette.green).frame(width: 26, alignment: .trailing)
                                Text("\(day.incorrect)").foregroundStyle(palette.red).frame(width: 26, alignment: .trailing)
                                Text("\(day.total)").foregroundStyle(palette.ink).frame(width: 34, alignment: .trailing)
                                Text("\(day.accuracy)%").foregroundStyle(palette.purple).frame(width: 30, alignment: .trailing)
                            }
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .padding(.vertical, 5)
                        }
                    }
                }
                .padding(13)
                .cardStyle(palette)

                VStack(alignment: .leading, spacing: 10) {
                    sectionTitle("Награды", icon: "trophy.fill")
                    rewardPreview(emoji: "🧸", title: "20 алмазов", subtitle: "Салют из игрушек", progress: min(store.stats.diamonds, 20), goal: 20)
                    rewardPreview(emoji: "🦋", title: "50 алмазов", subtitle: "Птички и бабочки", progress: min(store.stats.diamonds, 50), goal: 50)
                    Button("Все награды →") { selected = .rewards }
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(palette.purple).buttonStyle(.plain)
                }
                .padding(13)
                .cardStyle(palette)
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
                    .foregroundStyle(palette.purple).buttonStyle(.plain)
            }
            if store.stats.days.isEmpty {
                emptyHint("Здесь появится история занятий — сколько ответов удалось решить каждый день.")
            } else {
                HStack(spacing: 8) {
                    tableHead("Дата занятия", align: .leading)
                    tableHead("Верных", align: .trailing).frame(width: 58)
                    tableHead("Неверных", align: .trailing).frame(width: 68)
                    tableHead("Всего", align: .trailing).frame(width: 47)
                    tableHead("Точность", align: .trailing).frame(width: 58)
                }
                .padding(.horizontal, 8)
                ForEach(Array(store.stats.days.prefix(3))) { day in
                    HStack(spacing: 8) {
                        Text(StatsStore.displayDate(day.date)).foregroundStyle(palette.ink).lineLimit(1).minimumScaleFactor(0.65).frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(day.correct)").foregroundStyle(palette.green).frame(width: 58, alignment: .trailing)
                        Text("\(day.incorrect)").foregroundStyle(palette.red).frame(width: 68, alignment: .trailing)
                        Text("\(day.total)").foregroundStyle(palette.ink).frame(width: 47, alignment: .trailing)
                        Text("\(day.accuracy)%").foregroundStyle(palette.purple).frame(width: 58, alignment: .trailing)
                    }
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 7)
                    .background(.white.opacity(0.48), in: RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(12)
        .cardStyle(palette)
    }

    private var statisticsPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                pageHeading("Твои успехи", subtitle: "Каждый пример помогает стать увереннее 💜")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                    largeStat("Всего ответов", value: "\(store.stats.total)", icon: "list.number", color: palette.purple)
                    largeStat("Правильных ответов", value: "\(store.stats.correct)", icon: "checkmark.circle.fill", color: palette.green)
                    largeStat("Неправильных ответов", value: "\(store.stats.incorrect)", icon: "xmark.circle.fill", color: palette.red)
                    largeStat("Процент верных", value: "\(store.stats.accuracy)%", icon: "target", color: Color(red: 0.29, green: 0.57, blue: 0.87))
                    largeStat("Алмазы", value: "💎 \(store.stats.diamonds)", icon: "sparkles", color: palette.purple)
                    largeStat("Лучшая серия", value: "\(store.stats.bestStreak)", icon: "flame.fill", color: Color(red: 0.94, green: 0.52, blue: 0.24))
                }
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Твой прогресс", icon: "chart.bar.fill")
                    HStack {
                        Text("Правильные ответы").font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundStyle(palette.ink)
                        Spacer()
                        Text("\(store.stats.accuracy)%").font(.system(size: 17, weight: .heavy, design: .rounded)).foregroundStyle(palette.green)
                    }
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(palette.line.opacity(0.6))
                            Capsule()
                                .fill(LinearGradient(colors: [palette.green, Color(red: 0.47, green: 0.84, blue: 0.62)], startPoint: .leading, endPoint: .trailing))
                                .frame(width: geo.size.width * CGFloat(store.stats.accuracy) / 100)
                        }
                    }
                    .frame(height: 16)
                    Text("За каждый верный ответ ты получаешь один алмаз. Ошибки тоже записываются, поэтому видно, как становится лучше точность.")
                        .font(.system(size: 13, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                }
                .padding(22)
                .cardStyle(palette)
                Button("Посмотреть статистику по дням →") { selected = .days }
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundStyle(palette.purple).buttonStyle(.plain)
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
                    largeStat("Всего ответов", value: "\(store.stats.total)", icon: "list.number", color: palette.purple)
                    largeStat("Верных", value: "\(store.stats.correct)", icon: "checkmark.circle.fill", color: palette.green)
                    largeStat("Неверных", value: "\(store.stats.incorrect)", icon: "xmark.circle.fill", color: palette.red)
                    largeStat("Точность", value: "\(store.stats.accuracy)%", icon: "percent", color: palette.purple)
                }
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        tableHead("Дата занятия", align: .leading)
                        tableHead("Правильные", align: .trailing).frame(width: 120)
                        tableHead("Неправильные", align: .trailing).frame(width: 130)
                        tableHead("Всего ответов", align: .trailing).frame(width: 120)
                        tableHead("Верно", align: .trailing).frame(width: 80)
                    }
                    Rectangle().fill(palette.line).frame(height: 1)
                    if store.stats.days.isEmpty {
                        emptyHint("Пока занятий нет. Реши первый пример — и здесь появятся результаты.")
                    } else {
                        ForEach(store.stats.days) { day in
                            HStack(spacing: 8) {
                                Text(StatsStore.displayDate(day.date)).foregroundStyle(palette.ink).lineLimit(1).minimumScaleFactor(0.65).frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(day.correct)").foregroundStyle(palette.green).frame(width: 120, alignment: .trailing)
                                Text("\(day.incorrect)").foregroundStyle(palette.red).frame(width: 130, alignment: .trailing)
                                Text("\(day.total)").foregroundStyle(palette.ink).frame(width: 120, alignment: .trailing)
                                Text("\(day.accuracy)%").foregroundStyle(palette.purple).frame(width: 80, alignment: .trailing)
                            }
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .padding(12)
                            .background(.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 11))
                        }
                    }
                }
                .padding(20)
                .cardStyle(palette)
            }
            .padding(25)
        }
        .scrollIndicators(.hidden)
    }

    private var rewardsPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                pageHeading("Награды и достижения", subtitle: "Собирай алмазы, повышай уровень и открывай коллекцию ✨")
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 13) {
                        Text("⭐️").font(.system(size: 38))
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Уровень \(levelNumber)").font(.system(size: 21, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                            Text("Всего решено примеров: \(store.stats.total)").font(.system(size: 12, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                        }
                        Spacer()
                        Text("💎 \(store.stats.diamonds)").font(.system(size: 17, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple)
                    }
                    ProgressView(value: Double(levelProgress), total: 25).tint(palette.purple)
                    Text("До уровня \(levelNumber + 1): ещё \(25 - levelProgress) ответов").font(.system(size: 12, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
                }.padding(18).cardStyle(palette)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    medalCard("🥉", title: "Бронзовая медаль", detail: "10 правильных ответов", progress: min(store.stats.correct, 10), goal: 10, color: Color(red: 0.78, green: 0.49, blue: 0.30))
                    medalCard("🥈", title: "Серебряная медаль", detail: "50 правильных ответов", progress: min(store.stats.correct, 50), goal: 50, color: Color(red: 0.68, green: 0.73, blue: 0.80))
                    medalCard("🥇", title: "Золотая медаль", detail: "100 правильных ответов", progress: min(store.stats.correct, 100), goal: 100, color: Color(red: 0.95, green: 0.72, blue: 0.22))
                    medalCard("💠", title: "Алмазный кубок", detail: "250 правильных ответов", progress: min(store.stats.correct, 250), goal: 250, color: palette.lilac)
                }
                Button { openShop() } label: {
                    Label("Открыть магазин коллекционных игрушек", systemImage: "storefront.fill")
                        .font(.system(size: 14, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                        .padding(.horizontal, 19).padding(.vertical, 13)
                        .background(LinearGradient(colors: [palette.purple, palette.pink], startPoint: .leading, endPoint: .trailing), in: Capsule())
                }.buttonStyle(.plain)
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Коллекция достижений", icon: "rosette")
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(AchievementCatalog.all) { item in achievementCard(item) }
                    }
                }.padding(18).cardStyle(palette)
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Коллекционные игрушки", icon: "sparkles")
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(Collectible.all) { item in collectibleCard(item) }
                    }
                    Text("Игрушки можно находить случайно или покупать за алмазы.").font(.system(size: 12, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                }.padding(18).cardStyle(palette)
            }.padding(25)
        }.scrollIndicators(.hidden)
    }
    private func medalCard(_ emoji: String, title: String, detail: String, progress: Int, goal: Int, color: Color) -> some View {
        let earned = progress >= goal
        return VStack(alignment: .leading, spacing: 9) {
            Text(earned ? emoji : "🔒").font(.system(size: 37)).frame(width: 65, height: 65)
                .background((earned ? color : palette.line).opacity(0.35), in: RoundedRectangle(cornerRadius: 19))
            Text(title).font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
            Text(detail).font(.system(size: 12, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
            ProgressView(value: Double(progress), total: Double(goal)).tint(earned ? color : palette.purple)
            Text(earned ? "Медаль получена!" : "\(progress) из \(goal)").font(.system(size: 11, weight: .bold, design: .rounded)).foregroundStyle(earned ? palette.green : palette.purple)
        }.frame(maxWidth: .infinity, alignment: .leading).padding(17).cardStyle(palette)
    }
    private var shopPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                pageHeading("Магазин игрушек", subtitle: "Покупай за алмазы. После покупки игрушка становится яркой и открытой!")
                HStack(spacing: 12) {
                    Text("💎").font(.system(size: 33))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Твой баланс").font(.system(size: 12, weight: .bold, design: .rounded)).foregroundStyle(palette.muted)
                        Text("\(store.stats.diamonds) алмазов").font(.system(size: 23, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                    }
                    Spacer()
                    Text("\(Collectible.all.count) игрушек").font(.system(size: 12, weight: .bold, design: .rounded)).foregroundStyle(palette.purple)
                }.padding(17).cardStyle(palette)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 13) {
                    ForEach(Collectible.all) { item in shopItemCard(item) }
                }
                Text("Цены случайные при первом запуске и сохраняются на этом Mac.").font(.system(size: 12, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
            }.padding(25)
        }.scrollIndicators(.hidden)
    }
    private func shopItemCard(_ item: Collectible) -> some View {
        let owned = allOwnedCollectibleIDs.contains(item.id)
        let price = shopPrices[item.id] ?? 20
        return VStack(alignment: .leading, spacing: 9) {
            ZStack {
                RoundedRectangle(cornerRadius: 17).fill(LinearGradient(colors: owned ? [palette.pink, palette.lilac] : [palette.line.opacity(0.5), palette.palePink], startPoint: .topLeading, endPoint: .bottomTrailing))
                Text(owned ? item.emoji : "🔒").font(.system(size: 43)).saturation(owned ? 1 : 0).opacity(owned ? 1 : 0.55)
            }.frame(height: 83)
            Text(owned ? item.title : "Секретная игрушка").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink).lineLimit(1)
            Text(owned ? item.detail : "Открой за алмазы").font(.system(size: 10, weight: .medium, design: .rounded)).foregroundStyle(palette.muted).lineLimit(2)
            if owned {
                Label("Открыта!", systemImage: "checkmark.seal.fill").font(.system(size: 11, weight: .heavy, design: .rounded)).foregroundStyle(palette.green).frame(maxWidth: .infinity).padding(.vertical, 8)
            } else {
                Button { buyCollectible(item) } label: {
                    HStack(spacing: 5) { Text("💎").font(.system(size: 12)); Text("\(price)").font(.system(size: 13, weight: .heavy, design: .rounded)); Text("Купить").font(.system(size: 10, weight: .bold, design: .rounded)) }
                        .frame(maxWidth: .infinity).padding(.vertical, 8)
                        .foregroundStyle(store.stats.diamonds >= price ? .white : palette.muted)
                        .background(store.stats.diamonds >= price ? palette.purple : palette.line, in: Capsule())
                }.buttonStyle(.plain).disabled(store.stats.diamonds < price)
            }
        }.padding(11).cardStyle(palette)
    }
    private func prepareShopPrices() {
        var prices = shopPrices
        var lastPrice = 0
        for (index, item) in Collectible.all.enumerated() {
            if let existing = prices[item.id], existing >= lastPrice {
                lastPrice = existing
                continue
            }
            if index == 0 || lastPrice == 0 {
                lastPrice = 25
            } else {
                lastPrice += Bool.random() ? 20 : 25
            }
            prices[item.id] = lastPrice
        }
        shopPricesStorage = prices.keys.sorted().map { "\($0)=\(prices[$0]!)" }.joined(separator: ",")
    }

    private func openShop() {
        prepareShopPrices()
        selected = .shop
    }

    private func buyCollectible(_ item: Collectible) {
        guard !allOwnedCollectibleIDs.contains(item.id) else { return }
        let price = shopPrices[item.id] ?? 25
        guard store.spendDiamonds(price) else { return }
        shopPurchasesStorage = shopOwnedIDs.union([item.id]).sorted().joined(separator: ",")
        triggerCelebration("bonus:\(item.id)")
    }

    private var settingsPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                pageHeading("Настройки", subtitle: "Настрой своё учебное пространство")
                VStack(alignment: .leading, spacing: 15) {
                    Label("Тема оформления", systemImage: "paintpalette.fill").font(.system(size: 18, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                    Text("Выбери одну из десяти тем. Цвета интерфейса изменятся сразу.").font(.system(size: 13, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    Picker("Цветовая тема", selection: $themeName) {
                        ForEach(AppTheme.allCases) { theme in Text(theme.rawValue).tag(theme.rawValue) }
                    }.pickerStyle(.menu).frame(maxWidth: 320, alignment: .leading)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 10) {
                        ForEach(AppTheme.allCases) { theme in themeSwatch(theme) }
                    }
                    Divider().overlay(palette.line)
                    Label("Учебные предметы", systemImage: "books.vertical.fill").font(.system(size: 17, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                    Text("Нажми на название предмета вверху слева, чтобы переключиться. Математика работает; задания для остальных предметов появятся в следующем обновлении.")
                        .font(.system(size: 13, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    ForEach(StudySubject.allCases) { subject in
                        HStack(spacing: 9) {
                            Image(systemName: subject.icon).foregroundStyle(palette.purple).frame(width: 22)
                            Text(subject.rawValue).font(.system(size: 13, weight: .semibold, design: .rounded)).foregroundStyle(palette.ink)
                            Spacer()
                            if subject == selectedSubject { Image(systemName: "checkmark.circle.fill").foregroundStyle(palette.green) }
                        }
                    }
                }.padding(22).cardStyle(palette)
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 9) {
                        Image(systemName: "app.badge.checkmark").foregroundStyle(palette.purple)
                        Text("Версия \(appVersion)").font(.system(size: 18, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                    }
                    Text("Дата выпуска: \(appReleaseDate)").font(.system(size: 13, weight: .bold, design: .rounded)).foregroundStyle(palette.muted)
                    Button("Открыть историю версий →") { selected = .versionHistory }.font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple).buttonStyle(.plain)
                    Text("Журнал выпусков и описания изменений сохраняются в программе. Статистика и коллекции тоже остаются на этом Mac.")
                        .font(.system(size: 13, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                }.padding(22).cardStyle(palette)
            }.padding(25)
        }.scrollIndicators(.hidden)
    }
    private func themeSwatch(_ theme: AppTheme) -> some View {
        let p = AppPalette.make(theme)
        return Button { themeName = theme.rawValue } label: {
            VStack(spacing: 5) {
                RoundedRectangle(cornerRadius: 9)
                    .fill(LinearGradient(colors: [p.purple, p.pink, p.palePink], startPoint: .leading, endPoint: .trailing))
                    .frame(maxWidth: .infinity).frame(height: 31)
                    .overlay {
                        if themeName == theme.rawValue {
                            Image(systemName: "checkmark").font(.system(size: 12, weight: .heavy)).foregroundStyle(theme == .night ? .white : p.ink)
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 9).stroke(p.line, lineWidth: 1))
                Text(theme.rawValue).font(.system(size: 9, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted).lineLimit(1)
            }.frame(maxWidth: .infinity)
        }.buttonStyle(.plain)
    }
    private var versionHistoryPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                pageHeading("Версии и изменения", subtitle: "Что сделано, исправлено и добавлено в каждом выпуске")
                ForEach(releaseNotes) { note in
                    VStack(alignment: .leading, spacing: 11) {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "app.badge.checkmark").font(.system(size: 23, weight: .bold)).foregroundStyle(palette.purple)
                                .frame(width: 42, height: 42).background(palette.palePink, in: RoundedRectangle(cornerRadius: 13))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Версия \(note.version)").font(.system(size: 17, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                                Text(note.title).font(.system(size: 13, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
                            }
                            Spacer()
                            Text(note.date).font(.system(size: 11, weight: .bold, design: .rounded)).foregroundStyle(palette.purple)
                                .padding(.horizontal, 9).padding(.vertical, 6).background(palette.lilac.opacity(0.28), in: Capsule())
                        }
                        Divider().overlay(palette.line)
                        ForEach(note.changes, id: \.self) { change in
                            HStack(alignment: .top, spacing: 9) {
                                Image(systemName: "checkmark.circle.fill").font(.system(size: 13, weight: .semibold)).foregroundStyle(palette.green).padding(.top, 2)
                                Text(change).font(.system(size: 13, weight: .medium, design: .rounded)).foregroundStyle(palette.ink).fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }.padding(20).cardStyle(palette)
                }
            }.padding(25)
        }.scrollIndicators(.hidden)
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
                .foregroundStyle(palette.purple)
            Text(text)
                .font(.system(size: 15, weight: .heavy, design: .rounded))
                .foregroundStyle(palette.ink)
        }
    }

    private func miniStat(_ title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 5) {
                Image(systemName: icon).font(.system(size: 13, weight: .heavy)).foregroundStyle(color)
                Text(title).font(.system(size: 10, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted).lineLimit(1).minimumScaleFactor(0.75)
            }
            Text(value).font(.system(size: 23, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
        }
        .frame(maxWidth: .infinity, minHeight: 67, alignment: .leading)
        .padding(10)
        .background(.white.opacity(0.75), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(palette.line.opacity(0.7), lineWidth: 1))
    }

    private func todayStat(_ title: String, value: Int, icon: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 15, weight: .bold)).foregroundStyle(color)
            Text(title).font(.system(size: 11, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
            Spacer(minLength: 2)
            Text("\(value)").font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(color)
        }
        .padding(.vertical, 5)
        .overlay(alignment: .bottom) { Rectangle().fill(palette.line.opacity(0.55)).frame(height: 1) }
    }

    private func tableHead(_ text: String, align: Alignment) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold, design: .rounded))
            .foregroundStyle(palette.muted)
            .frame(maxWidth: align == .leading ? .infinity : nil, alignment: align)
    }

    private func emptyHint(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .medium, design: .rounded))
            .foregroundStyle(palette.muted)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(.white.opacity(0.56), in: RoundedRectangle(cornerRadius: 11))
    }

    private func rewardPreview(emoji: String, title: String, subtitle: String, progress: Int, goal: Int) -> some View {
        HStack(spacing: 9) {
            Text(emoji).font(.system(size: 27))
                .frame(width: 42, height: 45)
                .background(palette.palePink, in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.system(size: 12, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                Text(subtitle).font(.system(size: 10, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                ProgressView(value: Double(progress), total: Double(goal)).tint(palette.purple).scaleEffect(x: 1, y: 0.72, anchor: .center)
            }
            Spacer(minLength: 0)
        }
        .padding(7)
        .background(.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 13))
    }

    private func largeStat(_ title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon).font(.system(size: 23, weight: .semibold)).foregroundStyle(color)
            Text(value).font(.system(size: 29, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                .minimumScaleFactor(0.7).lineLimit(1)
            Text(title).font(.system(size: 13, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
        }
        .frame(maxWidth: .infinity, minHeight: 113, alignment: .leading)
        .padding(17)
        .cardStyle(palette)
    }

    private func achievementCard(_ item: Achievement) -> some View {
        let unlocked = unlockedAchievementIDs.contains(item.id)
        return HStack(alignment: .top, spacing: 10) {
            Text(unlocked ? item.emoji : "🔒").font(.system(size: 28))
                .frame(width: 48, height: 48).background((unlocked ? palette.lilac : palette.line).opacity(0.45), in: RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title).font(.system(size: 13, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                Text(item.detail).font(.system(size: 11, weight: .medium, design: .rounded)).foregroundStyle(palette.muted).fixedSize(horizontal: false, vertical: true)
                Text(unlocked ? "Получено!" : "Ещё впереди").font(.system(size: 10, weight: .bold, design: .rounded)).foregroundStyle(unlocked ? palette.green : palette.muted)
            }
            Spacer(minLength: 0)
        }.frame(maxWidth: .infinity, minHeight: 78, alignment: .leading).padding(11)
            .background(.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 15))
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(palette.line.opacity(0.7), lineWidth: 1))
    }
    private func collectibleCard(_ item: Collectible) -> some View {
        let unlocked = allOwnedCollectibleIDs.contains(item.id)
        return HStack(spacing: 9) {
            Text(unlocked ? item.emoji : "❔").font(.system(size: 29))
                .frame(width: 48, height: 48).background(palette.palePink, in: RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 3) {
                Text(unlocked ? item.title : "Секретная находка").font(.system(size: 12, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                Text(unlocked ? item.detail : "Шанс найти за верный ответ").font(.system(size: 10, weight: .medium, design: .rounded)).foregroundStyle(palette.muted).fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }.frame(maxWidth: .infinity, minHeight: 62, alignment: .leading).padding(9)
            .background(.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 14))
    }
    private func unlockEligibleAchievements() -> [Achievement] {
        let already = unlockedAchievementIDs
        let newly = AchievementCatalog.all.filter { item in
            guard !already.contains(item.id) else { return false }
            switch item.id {
            case "first-answer": return store.stats.total >= 1
            case "ten-correct": return store.stats.correct >= 10
            case "twenty-correct": return store.stats.correct >= 20
            case "fifty-correct": return store.stats.correct >= 50
            case "five-streak": return store.stats.bestStreak >= 5
            case "fifteen-streak": return store.stats.bestStreak >= 15
            case "twenty-streak": return store.stats.bestStreak >= 20
            case "daily-solver": return today.total >= 20
            case "three-days": return store.stats.days.filter { $0.total > 0 }.count >= 3
            case "five-days": return store.stats.days.filter { $0.total > 0 }.count >= 5
            case "perfect-ten": return store.stats.total >= 10 && store.stats.accuracy == 100
            case "accuracy-90": return store.stats.total >= 50 && store.stats.accuracy >= 90
            case "hundred-answers": return store.stats.total >= 100
            case "five-hundred-answers": return store.stats.total >= 500
            case "diamond-100": return store.stats.diamonds >= 100
            default: return false
            }
        }
        if !newly.isEmpty { unlockedAchievementStorage = already.union(newly.map(\.id)).sorted().joined(separator: ",") }
        return newly
    }
    private func maybeUnlockRandomCollectible() -> Collectible? {
        guard Double.random(in: 0..<1) < 0.08 else { return nil }
        let owned = allOwnedCollectibleIDs
        guard let item = Collectible.all.filter({ !owned.contains($0.id) }).randomElement() else { return nil }
        randomCollectiblesStorage = unlockedCollectibleIDs.union([item.id]).sorted().joined(separator: ",")
        return item
    }
    private func rewardLarge(_ emoji: String, title: String, detail: String, progress: Int, goal: Int, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(emoji).font(.system(size: 42))
                .frame(width: 68, height: 68)
                .background(color.opacity(0.6), in: RoundedRectangle(cornerRadius: 20))
            Text(title).font(.system(size: 20, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
            Text(detail).font(.system(size: 13, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                .fixedSize(horizontal: false, vertical: true)
            ProgressView(value: Double(progress), total: Double(goal)).tint(palette.purple)
            Text("\(progress) из \(goal)")
                .font(.system(size: 12, weight: .bold, design: .rounded)).foregroundStyle(palette.purple)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .cardStyle(palette)
    }

    private func pageHeading(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.system(size: 29, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
            Text(subtitle).font(.system(size: 14, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
        }
    }

    private func checkAnswer() {
        guard !answer.isEmpty, answerState != .correct else { return }
        let isCorrect = answer.trimmingCharacters(in: .whitespacesAndNewlines) == problem.answer
        let rewards = store.record(correct: isCorrect)
        let newAchievements = unlockEligibleAchievements()

        if isCorrect {
            answerState = .correct
            if let reward = rewards.last {
                triggerCelebration(reward)
            } else if let item = newAchievements.randomElement() {
                triggerCelebration("achievement:\(item.id)")
            } else if let item = maybeUnlockRandomCollectible() {
                triggerCelebration("bonus:\(item.id)")
            }
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
        } else if reward.hasPrefix("achievement:") {
            let id = String(reward.dropFirst("achievement:".count))
            let emoji = AchievementCatalog.all.first(where: { $0.id == id })?.emoji ?? "🏆"
            emojis = [emoji, "✨", "🌟", emoji, "💜"]
        } else if reward.hasPrefix("bonus:") {
            let id = String(reward.dropFirst("bonus:".count))
            let emoji = Collectible.all.first(where: { $0.id == id })?.emoji ?? "🎁"
            emojis = [emoji, "✨", emoji, "🌟", "🎉"]
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
                        .tint(palette.purple)
                        .padding(.top, 6)
                }
                .foregroundStyle(palette.ink)
                .padding(31)
                .frame(maxWidth: 460)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 27))
                .overlay(RoundedRectangle(cornerRadius: 27).stroke(.white.opacity(0.9), lineWidth: 1.5))
                .shadow(color: palette.ink.opacity(0.18), radius: 30, y: 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var celebrationTitle: String {
        switch celebration {
        case "diamonds:20": return "🎉 20 алмазов!"
        case "diamonds:50": return "🦋 50 алмазов!"
        default:
            if let reward = celebration, reward.hasPrefix("achievement:") {
                let id = String(reward.dropFirst("achievement:".count))
                return AchievementCatalog.all.first(where: { $0.id == id }).map { "\($0.emoji) Достижение!" } ?? "🏆 Новая награда!"
            }
            if let reward = celebration, reward.hasPrefix("bonus:") {
                let id = String(reward.dropFirst("bonus:".count))
                return Collectible.all.first(where: { $0.id == id }).map { "\($0.emoji) Находка!" } ?? "🎁 Сюрприз!"
            }
            if let value = celebration?.split(separator: ":").last { return "🔥 \(value) правильных подряд!" }
            return "Молодец!"
        }
    }
    private var celebrationSubtitle: String {
        switch celebration {
        case "diamonds:20": return "Салют из разноцветных мягких игрушек!"
        case "diamonds:50": return "Птички и бабочки летают вокруг!"
        default:
            if let reward = celebration, reward.hasPrefix("achievement:") {
                let id = String(reward.dropFirst("achievement:".count))
                return AchievementCatalog.all.first(where: { $0.id == id })?.detail ?? "Новое достижение сохранено в коллекции."
            }
            if let reward = celebration, reward.hasPrefix("bonus:") {
                let id = String(reward.dropFirst("bonus:".count))
                return Collectible.all.first(where: { $0.id == id })?.detail ?? "Коллекционная находка сохранена."
            }
            return "Ты отлично справляешься. Продолжай!"
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
    func cardStyle(_ palette: AppPalette) -> some View {
        self
            .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 19))
            .overlay(RoundedRectangle(cornerRadius: 19).stroke(palette.line.opacity(0.7), lineWidth: 1))
            .shadow(color: palette.purple.opacity(0.035), radius: 8, y: 3)
    }
}
