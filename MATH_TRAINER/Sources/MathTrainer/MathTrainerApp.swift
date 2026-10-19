import SwiftUI
import AppKit
import Combine
import AVFoundation

private struct PeriodicElementTile: View {
    let prompt: String
    let answer: String
    private let elements: [(String, String, Int)] = [
        ("H", "Водород", 1), ("He", "Гелий", 2), ("Li", "Литий", 3), ("Be", "Бериллий", 4), ("B", "Бор", 5), ("C", "Углерод", 6), ("N", "Азот", 7), ("O", "Кислород", 8), ("F", "Фтор", 9), ("Ne", "Неон", 10),
        ("Na", "Натрий", 11), ("Mg", "Магний", 12), ("Al", "Алюминий", 13), ("Si", "Кремний", 14), ("P", "Фосфор", 15), ("S", "Сера", 16), ("Cl", "Хлор", 17), ("Ar", "Аргон", 18), ("K", "Калий", 19), ("Ca", "Кальций", 20),
        ("Fe", "Железо", 26), ("Cu", "Медь", 29), ("Zn", "Цинк", 30), ("Ag", "Серебро", 47), ("Sn", "Олово", 50), ("I", "Йод", 53), ("Au", "Золото", 79), ("Hg", "Ртуть", 80), ("Pb", "Свинец", 82), ("U", "Уран", 92),
        ("Cr", "Хром", 24), ("Mn", "Марганец", 25), ("Co", "Кобальт", 27), ("Ni", "Никель", 28), ("Br", "Бром", 35), ("Ba", "Барий", 56), ("Pt", "Платина", 78), ("W", "Вольфрам", 74), ("Se", "Селен", 34)
    ]
    private var element: (String, String, Int) {
        if let match = elements.first(where: { prompt.localizedCaseInsensitiveContains($0.1) || answer == $0.0 || answer == $0.1 }) { return match }
        return ("?", "Химический элемент", 0)
    }
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(element.2)").font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded))
                Spacer(minLength: 0)
                Text(prompt.localizedCaseInsensitiveContains("символ у элемента") ? "?" : element.0).font(.system(size: 42 * AppFontScale.factor, weight: .black, design: .rounded))
                Text(prompt.localizedCaseInsensitiveContains("символ у элемента") ? "Символ скрыт" : (prompt.localizedCaseInsensitiveContains("элемент с символом") ? "Название скрыто" : element.1)).font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded)).lineLimit(1).minimumScaleFactor(0.7)
            }
            .foregroundStyle(Color(red: 0.08, green: 0.25, blue: 0.48))
            .padding(12).frame(width: 112, height: 106, alignment: .leading)
            .background(LinearGradient(colors: [Color(red: 0.75, green: 0.92, blue: 1), Color(red: 0.48, green: 0.79, blue: 0.97)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 6) {
                Text("ТАБЛИЦА МЕНДЕЛЕЕВА").font(.system(size: 11 * AppFontScale.factor, weight: .black, design: .rounded)).tracking(0.6)
                Text("Карточка химического элемента").font(.system(size: 14 * AppFontScale.factor, weight: .bold, design: .rounded))
                Text("Атомный номер · символ · название").font(.system(size: 11 * AppFontScale.factor, weight: .medium, design: .rounded))
            }.foregroundStyle(Color(red: 0.08, green: 0.25, blue: 0.48))
            Spacer(minLength: 0)
        }
        .padding(10).frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.86, green: 0.95, blue: 1), in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.blue.opacity(0.28), lineWidth: 1))
    }
}

private struct StudyIllustration: View {
    let subject: StudySubject
    let prompt: String
    private var lower: String { prompt.lowercased() }

    private var symbol: String {
        switch subject {
        case .logic:
            if lower.contains("круг") { return "circle.fill" }
            if lower.contains("квадрат") { return "square.fill" }
            if lower.contains("треуголь") || lower.contains("угл") || lower.contains("фигур") { return "shapes.fill" }
            if lower.contains("кубик") || lower.contains("куб") { return "cube.fill" }
            return "puzzlepiece.extension.fill"
        case .biology:
            // First match the named organism, not words from the question such as "питается рыбой".
            if lower.contains("дельфин") { return "water.waves" }
            if lower.contains("карась") || lower.contains("рыба") || lower.contains("рыб ") { return "fish.fill" }
            if lower.contains("орёл") || lower.contains("птиц") { return "bird.fill" }
            if lower.contains("бабоч") || lower.contains("пчел") { return "ladybug.fill" }
            if lower.contains("ёж") || lower.contains("крот") || lower.contains("верблюд") || lower.contains("медвед") { return "pawprint.fill" }
            if lower.contains("лягуш") { return "figure.frog" }
            if lower.contains("улит") { return "shell.fill" }
            if lower.contains("паук") { return "ant.fill" }
            if lower.contains("дождевой черв") { return "scribble.variable" }
            if lower.contains("сосна") || lower.contains("берёз") || lower.contains("папорот") { return "tree.fill" }
            if lower.contains("кактус") || lower.contains("растени") || lower.contains("лист") || lower.contains("цвет") { return "leaf.fill" }
            if lower.contains("шампиньон") || lower.contains("гриб") { return "circle.hexagongrid.fill" }
            if lower.contains("бактери") || lower.contains("микроорганизм") { return "microbe.fill" }
            if lower.contains("дыш") || lower.contains("лёгк") { return "lungs.fill" }
            if lower.contains("серд") || lower.contains("кров") { return "heart.fill" }
            if lower.contains("мозг") || lower.contains("думать") { return "brain.head.profile" }
            return "leaf.fill"
        default:
            if subject == .geometry {
                if lower.contains("цилиндр") { return "cylinder" }
                if lower.contains("октаэдр") { return "diamond.fill" }
                if lower.contains("тетраэдр") { return "pyramid.fill" }
                if lower.contains("куб") { return "cube.fill" }
                if lower.contains("конус") { return "cone.fill" }
                if lower.contains("шар") { return "sphere.fill" }
                if lower.contains("луч") || lower.contains("прямая") { return "arrow.left.and.right" }
                if lower.contains("отрез") { return "line.3.horizontal" }
                if lower.contains("точк") { return "circle.fill" }
                if lower.contains("угол") { return "angle" }
            }
            if lower.contains("петри") { return "circle.hexagongrid.fill" }
            if lower.contains("мензур") || lower.contains("делени") || lower.contains("объём") { return "testtube.2" }
            if lower.contains("пипет") || lower.contains("капля") || lower.contains("переноса небольш") { return "eyedropper.full" }
            if lower.contains("ступк") || lower.contains("измельч") { return "circle.bottomhalf.filled" }
            return "flask.fill"
        }
    }

    private var tint: Color {
        switch subject {
        case .logic: return Color(red: 0.48, green: 0.31, blue: 0.94)
        case .biology: return Color(red: 0.10, green: 0.68, blue: 0.42)
        case .geometry: return Color(red: 0.15, green: 0.47, blue: 0.91)
        default: return Color(red: 0.12, green: 0.55, blue: 0.92)
        }
    }
    private var biologyName: String? {
        guard subject == .biology else { return nil }
        let names = ["дождевой червь", "белый медведь", "дельфин", "карась", "орёл", "лягушка", "бабочка", "пчела", "ёж", "крот", "верблюд", "пингвин", "улитка", "паук", "сосна", "берёза", "кактус", "папоротник", "шампиньон", "бактерия"]
        return names.first(where: { lower.contains($0) })?.uppercased()
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous).fill(tint.opacity(0.13))
            Circle().fill(tint.opacity(0.10)).frame(width: 112, height: 112).offset(x: 74, y: -24)
            if subject == .geometry {
                GeometryFigureView(name: prompt)
                    .frame(width: 220, height: 126)
                    .accessibilityLabel("Цветная геометрическая иллюстрация: \(prompt)")
            } else if subject == .biology {
                HStack(spacing: 18) {
                    if lower.contains("пингвин") {
                        Text("🐧").font(.system(size: 58 * AppFontScale.factor)).frame(width: 82)
                    } else if lower.contains("дельфин") {
                        Text("🐬").font(.system(size: 58 * AppFontScale.factor)).frame(width: 82)
                    } else if lower.contains("карась") || lower.contains("рыба") {
                        Text("🐟").font(.system(size: 58 * AppFontScale.factor)).frame(width: 82)
                    } else if lower.contains("бабоч") {
                        Text("🦋").font(.system(size: 58 * AppFontScale.factor)).frame(width: 82)
                    } else if lower.contains("пчел") {
                        Text("🐝").font(.system(size: 58 * AppFontScale.factor)).frame(width: 82)
                    } else if lower.contains("лягуш") {
                        Text("🐸").font(.system(size: 58 * AppFontScale.factor)).frame(width: 82)
                    } else if lower.contains("белый медвед") {
                        Text("🐻‍❄️").font(.system(size: 58 * AppFontScale.factor)).frame(width: 82)
                    } else if lower.contains("верблюд") {
                        Text("🐪").font(.system(size: 58 * AppFontScale.factor)).frame(width: 82)
                    } else if lower.contains("ёж") {
                        Text("🦔").font(.system(size: 58 * AppFontScale.factor)).frame(width: 82)
                    } else if lower.contains("сосна") || lower.contains("берёз") {
                        Text("🌳").font(.system(size: 58 * AppFontScale.factor)).frame(width: 82)
                    } else if lower.contains("кактус") {
                        Text("🌵").font(.system(size: 58 * AppFontScale.factor)).frame(width: 82)
                    } else if lower.contains("шампиньон") || lower.contains("гриб") {
                        Text("🍄").font(.system(size: 58 * AppFontScale.factor)).frame(width: 82)
                    } else {
                        Image(systemName: symbol).font(.system(size: 58 * AppFontScale.factor, weight: .bold)).symbolRenderingMode(.hierarchical).foregroundStyle(tint).frame(width: 82)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text(biologyName ?? "ОБЪЕКТ ИЗУЧЕНИЯ").font(.system(size: 15 * AppFontScale.factor, weight: .black, design: .rounded)).foregroundStyle(tint).lineLimit(2)
                        Text("Иллюстрация к этому организму").font(.system(size: 11 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(tint.opacity(0.78))
                    }
                    Spacer(minLength: 4)
                }.padding(.horizontal, 14)
            } else {
                Image(systemName: symbol).font(.system(size: 68 * AppFontScale.factor, weight: .bold)).symbolRenderingMode(.hierarchical).foregroundStyle(tint).frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 118)
        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(tint.opacity(0.24), lineWidth: 1))
        .accessibilityLabel(subject.rawValue + ": иллюстрация к заданию")
    }
}

private struct GeometryFigureView: View {
    let name: String
    private var title: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var lower: String { title.lowercased() }

    var body: some View {
        Canvas { context, size in
            let w = size.width, h = size.height
            let ink = Color(red: 0.20, green: 0.27, blue: 0.42)
            let blue = Color(red: 0.18, green: 0.53, blue: 0.96)
            let violet = Color(red: 0.47, green: 0.36, blue: 0.92)
            let pink = Color(red: 0.97, green: 0.36, blue: 0.64)
            let mint = Color(red: 0.16, green: 0.72, blue: 0.62)
            let fillStyle = GraphicsContext.Shading.linearGradient(
                Gradient(colors: [Color(red: 0.47, green: 0.76, blue: 1), Color(red: 0.53, green: 0.43, blue: 0.96)]),
                startPoint: CGPoint(x: w * 0.2, y: h * 0.15),
                endPoint: CGPoint(x: w * 0.8, y: h * 0.9))
            func polygon(_ points: [CGPoint], color: GraphicsContext.Shading? = nil) {
                guard let first = points.first else { return }
                var path = Path()
                path.move(to: first)
                for point in points.dropFirst() { path.addLine(to: point) }
                path.closeSubpath()
                context.fill(path, with: color ?? fillStyle)
                context.stroke(path, with: .color(ink), lineWidth: 2.8)
            }
            func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: x * w, y: y * h) }
            func line(_ points: [CGPoint], color: Color? = nil, width: CGFloat = 4, dash: [CGFloat] = []) {
                guard let first = points.first else { return }
                var path = Path()
                path.move(to: first)
                for p in points.dropFirst() { path.addLine(to: p) }
                context.stroke(path, with: .color(color ?? ink), style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round, dash: dash))
            }
            func ellipse(_ rect: CGRect, color: Color, stroke: Color? = nil, width: CGFloat = 2.8) {
                let path = Path(ellipseIn: rect)
                context.fill(path, with: .color(color))
                context.stroke(path, with: .color(stroke ?? ink), lineWidth: width)
            }
            if lower.contains("прямой угол") || lower.contains("острый угол") || lower.contains("тупой угол") || lower == "угол" {
                let v = point(0.30, 0.78)
                let left = point(0.07, 0.78)
                let end: CGPoint = lower.contains("прямой угол") ? point(0.30, 0.17) : (lower.contains("острый угол") ? point(0.82, 0.36) : (lower.contains("тупой угол") ? point(0.83, 0.18) : point(0.72, 0.20)))
                line([left, v, end], color: blue, width: 6)
                if lower.contains("прямой угол") {
                    polygon([point(0.30,0.68),point(0.40,0.68),point(0.40,0.78),point(0.30,0.78)], color: .color(mint.opacity(0.85)))
                } else {
                    var arc = Path()
                    let radius: CGFloat = 0.13 * min(w,h)
                    let angle: CGFloat = lower.contains("острый угол") ? -.pi/4 : (lower.contains("тупой угол") ? -2.2 : -0.9)
                    arc.addArc(center: v, radius: radius, startAngle: .degrees(180), endAngle: .radians(angle), clockwise: true)
                    context.stroke(arc, with: .color(pink), lineWidth: 4)
                }
                ellipse(CGRect(x: v.x-4, y: v.y-4, width: 8, height: 8), color: pink, stroke: pink, width: 1)
            } else if lower.contains("параллельные прямые") {
                line([point(0.12,0.32),point(0.88,0.32)],color:blue,width:6)
                line([point(0.12,0.68),point(0.88,0.68)],color:violet,width:6)
                for x in [0.42,0.58] { line([point(x,0.25),point(x+0.06,0.39)],color:pink,width:3) }
            } else if lower.contains("перпендикулярные прямые") {
                line([point(0.12,0.50),point(0.88,0.50)],color:blue,width:6)
                line([point(0.50,0.14),point(0.50,0.86)],color:violet,width:6)
                polygon([point(0.50,0.50),point(0.60,0.50),point(0.60,0.40),point(0.50,0.40)],color:.color(mint))
            } else if lower.contains("пунктир") {
                line([point(0.12,0.52),point(0.88,0.52)],color:blue,width:5,dash:[7,7])
            } else if lower.contains("ломан") {
                line([point(0.12,0.78),point(0.35,0.25),point(0.57,0.65),point(0.84,0.18)],color:violet,width:6)
            } else if lower.contains("крив") {
                var path = Path()
                path.move(to: point(0.10,0.72))
                path.addCurve(to: point(0.90,0.32), control1: point(0.18,0.08), control2: point(0.74,0.94))
                context.stroke(path, with: .color(pink), lineWidth: 6)
            } else if lower == "точка" {
                ellipse(CGRect(x:w*0.43,y:h*0.34,width:w*0.14,height:w*0.14),color:pink,stroke:violet,width:2)
            } else if lower == "прямая" || lower == "луч" || lower == "отрезок" {
                line([point(0.12,0.52),point(lower == "луч" ? 0.88 : 0.78,0.52)],color:blue,width:6)
                if lower == "прямая" {
                    line([point(0.12,0.52),point(0.22,0.43)],color:blue,width:3)
                    line([point(0.12,0.52),point(0.22,0.61)],color:blue,width:3)
                    line([point(0.88,0.52),point(0.78,0.43)],color:blue,width:3)
                    line([point(0.88,0.52),point(0.78,0.61)],color:blue,width:3)
                } else if lower == "луч" {
                    line([point(0.88,0.52),point(0.76,0.43)],color:blue,width:3)
                    line([point(0.88,0.52),point(0.76,0.61)],color:blue,width:3)
                    ellipse(CGRect(x:w*0.09,y:h*0.52-4,width:8,height:8),color:pink,stroke:pink,width:1)
                } else {
                    ellipse(CGRect(x:w*0.10,y:h*0.52-4,width:8,height:8),color:pink,stroke:pink,width:1)
                    ellipse(CGRect(x:w*0.77,y:h*0.52-4,width:8,height:8),color:pink,stroke:pink,width:1)
                }
            } else if lower.contains("цилиндр") {
                var bodyPath = Path()
                bodyPath.addRoundedRect(in: CGRect(x:w*0.28,y:h*0.28,width:w*0.44,height:h*0.48), cornerSize: CGSize(width:w*0.22,height:h*0.09))
                context.fill(bodyPath, with: fillStyle)
                context.stroke(bodyPath, with: .color(ink), lineWidth: 2.8)
                ellipse(CGRect(x:w*0.28,y:h*0.20,width:w*0.44,height:h*0.18),color:Color(red:0.65,green:0.85,blue:1))
                line([point(0.28,0.29),point(0.28,0.70)],color:ink,width:2)
                line([point(0.72,0.29),point(0.72,0.70)],color:ink,width:2)
            } else if lower.contains("конус") {
                polygon([point(0.50,0.13),point(0.22,0.76),point(0.78,0.76)],color:fillStyle)
                ellipse(CGRect(x:w*0.22,y:h*0.68,width:w*0.56,height:h*0.20),color:Color(red:0.64,green:0.80,blue:1))
            } else if lower.contains("шар") {
                ellipse(CGRect(x:w*0.28,y:h*0.15,width:w*0.44,height:h*0.70),color:Color(red:0.37,green:0.72,blue:1),stroke:violet,width:3)
                var shine = Path(); shine.addEllipse(in:CGRect(x:w*0.38,y:h*0.25,width:w*0.13,height:h*0.18))
                context.fill(shine,with:.color(.white.opacity(0.7)))
            } else if lower.contains("куб") {
                polygon([point(0.26,0.34),point(0.56,0.18),point(0.83,0.34),point(0.53,0.50)],color:.color(Color(red:0.65,green:0.82,blue:1)))
                polygon([point(0.26,0.34),point(0.53,0.50),point(0.53,0.84),point(0.26,0.67)],color:.color(blue.opacity(0.9)))
                polygon([point(0.53,0.50),point(0.83,0.34),point(0.83,0.67),point(0.53,0.84)],color:.color(violet.opacity(0.8)))
            } else if lower.contains("призма") || lower.contains("пирамида") || lower.contains("тетраэдр") || lower.contains("октаэдр") {
                if lower.contains("пирамида") || lower.contains("тетраэдр") {
                    polygon([point(0.50,0.12),point(0.20,0.80),point(0.82,0.80)],color:.color(Color(red:0.61,green:0.78,blue:1)))
                    line([point(0.50,0.12),point(0.51,0.79),point(0.20,0.80)],color:ink,width:2)
                } else {
                    polygon([point(0.25,0.33),point(0.47,0.20),point(0.76,0.34),point(0.54,0.49)],color:.color(Color(red:0.62,green:0.82,blue:1)))
                    polygon([point(0.25,0.33),point(0.54,0.49),point(0.54,0.80),point(0.25,0.64)],color:.color(blue))
                    polygon([point(0.54,0.49),point(0.76,0.34),point(0.76,0.65),point(0.54,0.80)],color:.color(violet))
                }
            } else {
                var vertices: [CGPoint] = []
                if lower.contains("треуголь") { vertices = [point(0.50,0.12),point(0.84,0.80),point(0.16,0.80)] }
                else if lower.contains("прямоуголь") { vertices = [point(0.20,0.24),point(0.80,0.24),point(0.80,0.76),point(0.20,0.76)] }
                else if lower.contains("квадрат") { vertices = [point(0.28,0.18),point(0.72,0.18),point(0.72,0.82),point(0.28,0.82)] }
                else if lower.contains("ромб") { vertices = [point(0.50,0.12),point(0.82,0.50),point(0.50,0.88),point(0.18,0.50)] }
                else if lower.contains("параллелограмм") { vertices = [point(0.32,0.22),point(0.84,0.22),point(0.68,0.78),point(0.16,0.78)] }
                else if lower.contains("трапец") { vertices = [point(0.32,0.20),point(0.68,0.20),point(0.86,0.80),point(0.14,0.80)] }
                else if lower.contains("пятиуголь") || lower.contains("шестиуголь") {
                    let n = lower.contains("пятиуголь") ? 5 : 6
                    vertices = (0..<n).map { i in
                        let angle = -CGFloat.pi/2 + CGFloat(i) * 2 * CGFloat.pi / CGFloat(n)
                        return point(0.5 + 0.34 * cos(angle), 0.5 + 0.38 * sin(angle))
                    }
                }
                if !vertices.isEmpty { polygon(vertices) }
                else if lower.contains("овал") { ellipse(CGRect(x:w*0.17,y:h*0.28,width:w*0.66,height:h*0.44),color:Color(red:0.53,green:0.77,blue:1)) }
                else { ellipse(CGRect(x:w*0.26,y:h*0.18,width:w*0.48,height:h*0.64),color:Color(red:0.53,green:0.77,blue:1)) }
            }
        }
        .padding(8)
        .background(
            LinearGradient(colors: [Color(red: 0.94, green: 0.97, blue: 1), Color(red: 0.97, green: 0.93, blue: 1)],
                           startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).stroke(Color(red: 0.72, green: 0.79, blue: 0.96), lineWidth: 1.2))
    }
}

struct Problem: Codable {
    let text: String
    let answer: String
    let isComparison: Bool
    let isTatarChoice: Bool
    let tatarChoices: [String]
    let showIllustration: Bool

    init(text: String, answer: String, isComparison: Bool = false, isTatarChoice: Bool = false, tatarChoices: [String] = [], showIllustration: Bool = false) {
        self.text = text
        self.answer = answer
        self.isComparison = isComparison
        self.isTatarChoice = isTatarChoice
        self.tatarChoices = tatarChoices
        self.showIllustration = showIllustration
    }
}

struct ProblemGenerator {
    static func next(difficulty: Int = 1) -> Problem {
        if Int.random(in: 0..<5) == 0 { return realLifeMathQuestion(level: difficulty) }
        if difficulty > 1 && Int.random(in: 0...99) < 75 { return advancedMathQuestion(level: difficulty) }
        // Регулярная практика таблицы умножения для начальной школы.
        if Int.random(in: 0...2) == 0 {
            let a = Int.random(in: 2...9)
            let b = Int.random(in: 2...9)
            return Problem(text: "Таблица умножения: \(a) × \(b) = ?", answer: String(a * b))
        }
        switch Int.random(in: 0...16) {
        case 0:
            let a = Int.random(in: 1...89)
            let b = Int.random(in: 1...(100 - a))
            return Problem(text: "\(a) + \(b) = ?", answer: String(a + b))
        case 1:
            let tens = Int.random(in: 4...9) * 10
            let ones = Int.random(in: 1...9)
            let subtract = Int.random(in: 11...min(39, tens + ones))
            let result = tens + ones - subtract
            return Problem(text: "Вычитание по частям: \(tens + ones) − \(subtract) = ? (сначала десятки, затем единицы)", answer: String(result))
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
        case 8:
            let tens = Int.random(in: 2...9)
            let ones = Int.random(in: 1...9)
            return Problem(text: "В числе \(tens * 10 + ones) сколько десятков?", answer: String(tens))
        case 9:
            let tens = Int.random(in: 1...9)
            return Problem(text: "Сколько единиц в \(tens) десятках?", answer: String(tens * 10))
        case 10:
            let dm = Int.random(in: 2...9)
            return Problem(text: "Сколько сантиметров в \(dm) дм?", answer: String(dm * 10))
        case 11:
            let kg = Int.random(in: 2...9)
            return Problem(text: "Сколько граммов в \(kg) кг?", answer: String(kg * 1000))
        case 12:
            let centners = Int.random(in: 1...9)
            return Problem(text: "Сколько килограммов в \(centners) ц?", answer: String(centners * 100))
        case 13:
            let days = Int.random(in: 2...9)
            return Problem(text: "Сколько часов в \(days) сутках?", answer: String(days * 24))
        case 14:
            let weeks = Int.random(in: 2...4)
            return Problem(text: "Сколько дней в \(weeks) неделях?", answer: String(weeks * 7))
        case 15:
            let years = Int.random(in: 2...4)
            return Problem(text: "Сколько месяцев в \(years) годах?", answer: String(years * 12))
        default:
            let a = Int.random(in: 10...100)
            let b = Int.random(in: 10...100)
            let sign = a > b ? ">" : (a < b ? "<" : "=")
            return Problem(text: "Сравни: \(a)  ?  \(b)", answer: sign, isComparison: true)
        }
    }

    private static func realLifeMathQuestion(level: Int) -> Problem {
        let bank: [(String, String)] = [
            ("В магазине яблоки стоят 35 ₽, а сок — 48 ₽. Сколько нужно заплатить за оба товара?", "83"),
            ("Ты купил булочку за 27 ₽ и дал кассиру 100 ₽. Сколько рублей сдачи нужно получить?", "73"),
            ("У тебя было 150 ₽. Ты купил тетрадь за 42 ₽ и ручку за 28 ₽. Сколько денег осталось?", "80"),
            ("Билет на автобус стоит 32 ₽. Сколько стоят 2 билета?", "64"),
            ("Поезд отправился в 10:20 и ехал 2 часа. Во сколько он прибыл?", "12:20"),
            ("Мультфильм начался в 17:15 и длился 45 минут. Во сколько он закончился?", "18:00"),
            ("Пиццу разделили на 8 одинаковых кусочков. Съели 3 кусочка. Сколько кусочков осталось?", "5"),
            ("Одна пицца стоит 420 ₽. Сколько стоят две такие пиццы?", "840"),
            ("Игрушка стоит 200 ₽. На неё скидка 50 ₽. Сколько она стоит со скидкой?", "150"),
            ("Рюкзак стоил 600 ₽, а после скидки стал дешевле на 100 ₽. Сколько он стоит теперь?", "500"),
            ("Тебе дают 40 ₽ карманных денег каждый день. Сколько ты накопишь за 5 дней?", "200"),
            ("У тебя 250 ₽. Ты потратил 90 ₽ на книгу. Сколько денег осталось?", "160"),
            ("Машина проехала 30 км утром и 25 км днём. Сколько километров она проехала всего?", "55"),
            ("До парка 2 км. Ты прошёл 700 м. Сколько метров осталось пройти?", "1300"),
            ("В коробке 6 рядов по 4 конфеты. Сколько всего конфет в коробке?", "24"),
            ("Семья купила 3 пакета молока по 75 ₽ каждый. Сколько заплатили?", "225"),
            ("У тебя 500 ₽. Ты купил игру за 180 ₽ и мороженое за 70 ₽. Сколько осталось?", "250"),
            ("Урок начался в 9:00 и закончился в 9:40. Сколько минут длился урок?", "40"),
            ("На столе 12 долек шоколада. Ты съел четверть шоколада. Сколько долек съел?", "3"),
            ("В кино билет стоит 180 ₽. Сколько стоят 3 билета?", "540")
        ]
        let item = bank.randomElement()!
        return Problem(text: item.0, answer: item.1)
    }

    fileprivate static func tip(for subject: StudySubject, problem: Problem) -> String {
        let hints: [String]
        switch subject {
        case .math:
            if problem.text.contains("сантиметр") || problem.text.contains("дм") { hints = ["1 дм = 10 см.", "При переводе дм в см умножай на 10."] }
            else if problem.text.contains("грамм") { hints = ["1 кг = 1000 г.", "Чтобы получить граммы, умножь килограммы на 1000."] }
            else if problem.text.contains("центнер") || problem.text.contains(" ц?") { hints = ["1 центнер = 100 кг.", "Центнеры переводи в килограммы умножением на 100."] }
            else if problem.text.contains("сутках") || problem.text.contains("часов") { hints = ["В сутках 24 часа.", "Чтобы получить часы, умножь сутки на 24."] }
            else if problem.text.contains("недел") { hints = ["В неделе 7 дней.", "Недели переводи в дни умножением на 7."] }
            else if problem.text.contains("месяц") { hints = ["В году 12 месяцев.", "Годы переводи в месяцы умножением на 12."] }
            else if problem.text.contains("десят") || problem.text.contains("единиц") { hints = ["Один десяток — это 10 единиц.", "Десятки стоят левее единиц."] }
            else if problem.isComparison { hints = ["Сначала сравни десятки.", "Знак > раскрывается к большему числу."] }
            else { hints = ["Проверь ответ обратным действием.", "Сначала умножение и деление, затем сложение и вычитание.", "Не торопись — проверь каждый шаг.", "Внимательно посмотри на знак действия."] }
        case .world: hints = ["Свяжи вопрос с тем, что наблюдаешь в природе.", "Вспомни факты об окружающем мире.", "Прочитай условие ещё раз.", "Попробуй исключить неверные варианты."]
        case .russian: hints = ["Подумай о значении слова.", "Вспомни правило и проверь написание.", "Попробуй произнести слово по слогам.", "Подбери похожее по смыслу слово."]
        case .english: hints = ["Вспомни перевод слова в контексте.", "Произнеси слово вслух.", "Подумай, где встречал это слово.", "Проверь написание букв."]
        case .tatar: hints = ["Вспомни перевод татарского слова.", "Произнеси слово вслух.", "Вспомни, как это говорят дома.", "Повтори слово и его значение."]
        case .art: hints = ["Вспомни свойства цвета и основные цвета.", "Подумай, какой инструмент или материал подходит для этой задачи.", "Вспомни отличия портрета, пейзажа и натюрморта.", "Обрати внимание на слова о композиции и художественных техниках."]
        case .chemistry: hints = ["Вспомни символы химических элементов.", "Первая буква символа обычно заглавная, вторая — строчная.", "Найди элемент по его месту в таблице Менделеева.", "Попробуй исключить элементы из других групп."]
        case .informatics: hints = ["Вспомни, для чего нужны разные устройства и программы.", "Выбирай самый безопасный вариант действий.", "Прочитай все четыре ответа и найди тот, который подходит точнее.", "Алгоритм — это порядок шагов для выполнения задачи."]
        case .pdd: hints = ["Вспомни цвет светофора и его значение.", "Обращай внимание на форму и цвет дорожного знака.", "Переходи дорогу только в безопасном, разрешённом месте.", "Выбирай самый безопасный вариант для пешехода."]
        case .orthography: hints = ["Прочитай слово медленно и вспомни правило.", "Проверь безударную гласную проверочным словом.", "Вспомни жи–ши, ча–ща и чу–щу.", "Прочитай предложение целиком и проверь каждое слово."]
        case .geography: hints = ["Найди ключевое слово: страна, столица, материк, море или река.", "Посмотри на порядок цветов флага.", "Остров со всех сторон окружён водой, а река течёт по руслу.", "Океан больше моря."]
        case .logic: hints = ["Найди закономерность между числами или фигурами.", "Проверь, что меняется от шага к шагу.", "Исключи варианты, которые нарушают условие."]
        case .biology: hints = ["Вспомни, чем живые организмы отличаются от неживых объектов.", "Сопоставь строение организма с его функцией.", "Подумай о среде обитания и питании."]
        case .geometry: hints = ["Посмотри на число граней, рёбер и вершин.", "У цилиндра два круглых основания.", "У луча есть начало, а у отрезка — два конца."]
        }
        return hints.randomElement() ?? "Внимательно прочитай условие и проверь ответ."
    }

    private static let informaticsQuestionBank: [Problem] = makeInformaticsQuestionBank()

    /// The question bank is built from many independent primary-school concepts and
    /// several different question forms for each concept. Prompts remain unique until
    /// the child has completed the whole bank.
    private static func makeInformaticsQuestionBank() -> [Problem] {
        var bank: [Problem] = []

        func add(_ prompt: String, _ answer: String, _ pool: [String]) {
            let otherAnswers = Array(Set(pool.filter { $0 != answer })).shuffled().prefix(3)
            guard otherAnswers.count == 3 else { return }
            let options = ([answer] + Array(otherAnswers)).shuffled()
            bank.append(Problem(text: prompt, answer: answer, isTatarChoice: true, tatarChoices: options))
        }

        let devices: [(name: String, purpose: String, action: String, clue: String)] = [
            ("клавиатура", "вводить текст", "напечатать имя или рассказ", "у неё много кнопок с буквами и цифрами"),
            ("мышь", "управлять указателем на экране", "выбрать значок на экране", "её двигают по столу, чтобы переместить указатель"),
            ("монитор", "показывать текст и изображения", "посмотреть открытое задание", "на нём видны окна, картинки и слова"),
            ("системный блок", "обрабатывать данные компьютера", "запустить работу настольного компьютера", "внутри находятся основные детали компьютера"),
            ("принтер", "печатать документы и картинки на бумаге", "получить бумажную копию рисунка", "он переносит изображение на лист"),
            ("сканер", "переносить бумажные документы в компьютер", "сделать цифровую копию листа", "он считывает изображение с бумаги"),
            ("микрофон", "записывать голос и звуки", "записать голосовое сообщение", "он улавливает голос и другие звуки"),
            ("колонки", "воспроизводить звук", "послушать музыку из компьютера", "из них слышна музыка или речь"),
            ("наушники", "слушать звук, не мешая другим", "послушать урок тихо", "их надевают на уши"),
            ("веб-камера", "снимать или передавать видео", "поговорить по видеосвязи", "она показывает изображение человека"),
            ("фотоаппарат", "делать фотографии", "сфотографировать поделку", "он сохраняет снимки"),
            ("видеокамера", "записывать движущееся изображение", "снять короткий ролик", "она записывает видео"),
            ("сенсорный экран", "управлять устройством касанием", "нажать на значок пальцем", "на нём можно касаться значков пальцем"),
            ("тачпад", "управлять курсором на ноутбуке", "передвинуть курсор на ноутбуке", "это чувствительная площадка для пальца"),
            ("джойстик", "управлять движением в игре", "повернуть игровой объект в сторону", "им управляют наклоном рычага"),
            ("геймпад", "управлять игрой кнопками", "нажать игровые кнопки", "у него есть кнопки для управления игрой"),
            ("флеш-накопитель", "хранить и переносить файлы", "перенести документ на другой компьютер", "это небольшой носитель для файлов"),
            ("карта памяти", "хранить фотографии и другие файлы", "добавить место для фотографий", "её вставляют в фотоаппарат или другое устройство"),
            ("жёсткий диск", "хранить программы и файлы", "сохранить документы надолго", "на нём могут храниться файлы и программы"),
            ("роутер", "соединять устройства с сетью", "подключить несколько устройств к домашнему интернету", "он помогает устройствам подключиться к сети"),
            ("планшет", "работать с приложениями на сенсорном экране", "читать электронную книгу на большом экране", "это переносное устройство с большим экраном"),
            ("ноутбук", "работать с компьютерными программами в дороге", "взять компьютер в поездку", "это переносной компьютер с экраном и клавиатурой"),
            ("смартфон", "звонить и запускать приложения", "связаться с родителями на расстоянии", "это телефон с приложениями и сенсорным экраном"),
            ("проектор", "показывать изображение на большом экране", "показать презентацию всему классу", "он выводит картинку на стену или экран"),
            ("3D-принтер", "создавать объёмные предметы по цифровой модели", "создать пластиковую фигурку", "он строит предмет слой за слоем"),
            ("зарядное устройство", "пополнять заряд батареи", "зарядить планшет", "к нему подключают устройство, которому нужна энергия"),
            ("источник бесперебойного питания", "некоторое время питать компьютер при отключении электричества", "дать компьютеру время на сохранение работы при пропаже света", "он помогает пережить короткое отключение питания"),
            ("графический планшет", "рисовать на компьютере специальным пером", "нарисовать цифровую картинку рукой", "на нём рисуют пером, а рисунок появляется на компьютере"),
            ("электронная книга", "читать книги в электронном виде", "читать рассказ в дороге", "её экран предназначен для чтения"),
            ("умные часы", "показывать время и уведомления", "проверить время на запястье", "их носят на руке"),
            ("сканер штрихкодов", "считывать штрихкоды", "считать код на упаковке товара", "он считывает полоски специального кода"),
            ("интерактивная доска", "показывать и изменять учебный материал касанием", "делать пометки на большом экране в классе", "на ней можно писать и касаться изображения"),
            ("сервер", "предоставлять данные другим компьютерам", "получить общий файл из школьной сети", "он хранит данные и отвечает на запросы других устройств"),
            ("GPS-приёмник", "помогать определять местоположение", "узнать своё местоположение на карте", "он помогает определить, где находится устройство"),
            ("робот", "выполнять заданные команды", "запрограммировать движение робота", "он выполняет команды по заданному порядку"),
            ("датчик температуры", "измерять температуру", "узнать, насколько тепло в комнате", "он измеряет нагрев или холод"),
            ("диктофон", "записывать звук", "сохранить голосовую заметку", "он сохраняет речь или другой звук"),
            ("пульт управления", "отправлять команды технике на расстоянии", "переключить слайды издалека", "он позволяет управлять устройством, не подходя к нему"),
            ("сетевой кабель", "соединять устройства проводом", "подключить компьютер к сети проводом", "по нему устройства соединяются друг с другом"),
            ("внешний аккумулятор", "заряжать телефон вдали от розетки", "подзарядить телефон в дороге", "это переносной запас энергии")
        ]
        let deviceNames = devices.map(\.name)
        let devicePurposes = devices.map(\.purpose)
        let deviceActions = devices.map(\.action)
        for item in devices {
            add("Какое устройство помогает \(item.action)?", item.name, deviceNames)
            add("Что поможет выполнить задачу: \(item.action)?", item.name, deviceNames)
            add("Какое устройство выбрать, если нужно \(item.action)?", item.name, deviceNames)
            add("Какая техника нужна, чтобы \(item.action)?", item.name, deviceNames)
            add("Что обычно делает устройство «\(item.name)»?", item.purpose, devicePurposes)
            add("Какая задача подходит устройству «\(item.name)»?", item.action, deviceActions)
        }

        let programs: [(name: String, task: String, purpose: String)] = [
            ("текстовый редактор", "написать и исправить рассказ", "создавать и редактировать текст"),
            ("графический редактор", "нарисовать картинку на компьютере", "рисовать и изменять изображения"),
            ("калькулятор", "быстро посчитать пример", "выполнять вычисления"),
            ("браузер", "открыть веб-страницу", "просматривать сайты в интернете"),
            ("поисковая система", "найти сведения по теме", "искать информацию в интернете"),
            ("программа для презентаций", "подготовить слайды для доклада", "создавать презентации из слайдов"),
            ("проигрыватель музыки", "послушать аудиозапись", "воспроизводить музыку и другие звуковые файлы"),
            ("видеопроигрыватель", "посмотреть сохранённый ролик", "воспроизводить видео"),
            ("фоторедактор", "обрезать фотографию и улучшить её", "изменять фотографии"),
            ("электронный дневник", "посмотреть домашнее задание", "показывать школьные задания и оценки"),
            ("почтовая программа", "отправить электронное письмо", "работать с электронной почтой"),
            ("переводчик", "узнать перевод иностранного слова", "переводить слова и короткие тексты"),
            ("программа для рисования", "раскрасить рисунок на экране", "создавать цифровые рисунки"),
            ("обучающая игра", "тренировать память в игровой форме", "учить новому через задания и игру"),
            ("программа для чтения PDF", "прочитать электронную книгу в формате PDF", "открывать документы PDF"),
            ("архиватор", "упаковать несколько файлов в один архив", "сжимать файлы и создавать архивы"),
            ("антивирус", "проверить файл на вредоносные программы", "помогать находить и блокировать вредоносные программы"),
            ("файловый менеджер", "найти и разложить документы по папкам", "управлять файлами и папками"),
            ("блокнот", "сохранить короткую заметку без сложного оформления", "записывать простой текст"),
            ("табличный редактор", "составить таблицу с числами", "работать с таблицами и простыми расчётами"),
            ("программа для видеосвязи", "поговорить с человеком по видео", "организовывать видеозвонки"),
            ("диктофонная программа", "записать своё чтение вслух", "записывать и сохранять звук"),
            ("программа для создания мультфильмов", "сделать простую анимацию", "создавать движущиеся сцены"),
            ("тренажёр клавиатуры", "потренироваться быстро печатать", "учиться печатать на клавиатуре"),
            ("программа для заметок", "записать список дел", "сохранять заметки и напоминания"),
            ("карты", "посмотреть маршрут до нужного места", "показывать карты и маршруты"),
            ("секундомер", "измерить время короткого задания", "измерять промежутки времени"),
            ("календарь", "посмотреть дату и записать событие", "показывать даты и напоминать о событиях"),
            ("сканер документов", "сохранить изображение бумажного документа", "превращать бумажные документы в цифровые копии"),
            ("программа для изучения языков", "повторить новые английские слова", "помогать учить иностранные слова"),
            ("редактор аудио", "обрезать начало аудиозаписи", "изменять звуковые записи"),
            ("конструктор блоковых программ", "собрать команды для движения героя", "собирать программу из визуальных блоков")
        ]
        let programNames = programs.map(\.name)
        let programPurposes = programs.map(\.purpose)
        for item in programs {
            add("Какая программа подойдёт, чтобы \(item.task)?", item.name, programNames)
            add("Для чего используют программу «\(item.name)»?", item.purpose, programPurposes)
            add("Что помогает сделать программа «\(item.name)»?", item.purpose, programPurposes)
            add("Выбери программу для задачи: \(item.task).", item.name, programNames)
        }

        let fileActions: [(action: String, task: String, meaning: String)] = [
            ("Сохранить", "записать результат работы, чтобы открыть его позже", "записать изменения в файл"),
            ("Открыть", "посмотреть уже сохранённый файл", "запустить выбранный файл для просмотра"),
            ("Создать папку", "собрать несколько файлов в одном месте", "подготовить новое место для документов"),
            ("Переименовать", "изменить название файла или папки", "дать объекту другое имя"),
            ("Копировать", "сделать ещё один экземпляр файла", "создать копию, не убирая оригинал"),
            ("Вырезать", "подготовить файл к перемещению", "убрать объект с прежнего места после вставки"),
            ("Вставить", "поместить скопированный объект в новое место", "добавить копию в выбранную папку"),
            ("Удалить", "убрать ненужный файл в корзину", "переместить лишний объект в корзину"),
            ("Восстановить", "вернуть файл из корзины", "достать ошибочно удалённый файл"),
            ("Найти", "отыскать файл по названию", "искать нужный документ среди многих"),
            ("Закрыть программу", "закончить работу приложения", "завершить работу открытого приложения"),
            ("Свернуть окно", "временно убрать окно с экрана", "спрятать окно, не закрывая программу"),
            ("Развернуть окно", "увеличить окно до размера экрана", "показать окно на весь экран"),
            ("Печать", "получить бумажную копию документа", "отправить документ на принтер"),
            ("Отменить действие", "вернуться к состоянию до последнего шага", "исправить ошибочный шаг обратным действием"),
            ("Повторить действие", "снова выполнить отменённый шаг", "вернуть результат отменённого действия"),
            ("Выделить", "выбрать файл или часть текста", "отметить объект для следующей команды"),
            ("Сортировать", "расположить файлы по имени или дате", "упорядочить список объектов"),
            ("Сменить пароль", "установить новый секретный код", "обновить пароль доступа"),
            ("Выйти из аккаунта", "завершить личный сеанс на общем устройстве", "закрыть свой сеанс пользователя"),
            ("Включить звук", "сделать звук слышимым", "включить воспроизведение звуков"),
            ("Уменьшить громкость", "сделать звук тише", "понизить уровень звука"),
            ("Увеличить громкость", "сделать звук громче", "повысить уровень звука"),
            ("Сделать снимок экрана", "сохранить изображение текущего экрана", "создать картинку того, что видно на экране"),
            ("Включить полный экран", "показать программу на всём экране", "убрать лишние рамки окна"),
            ("Изменить размер текста", "сделать буквы крупнее или мельче", "настроить удобную величину букв"),
            ("Подключиться к Wi-Fi", "подключить устройство к беспроводной сети", "выбрать беспроводную сеть и при необходимости ввести пароль"),
            ("Отключиться от сети", "прекратить соединение с интернетом", "разорвать подключение к сети"),
            ("Обновить страницу", "загрузить страницу заново", "повторно показать содержимое веб-страницы"),
            ("Добавить закладку", "сохранить ссылку на нужную страницу", "быстро вернуться к сайту позже"),
            ("Изменить масштаб", "сделать содержимое на экране крупнее или мельче", "приблизить или отдалить отображение"),
            ("Очистить поле поиска", "убрать старый текст из строки поиска", "освободить строку, чтобы ввести новый запрос")
        ]
        let actionNames = fileActions.map(\.action)
        for item in fileActions {
            add("Какое действие нужно, чтобы \(item.task)?", item.action, actionNames)
            add("Как называется действие: \(item.meaning)?", item.action, actionNames)
            add("Что выбрать в меню, если нужно \(item.task)?", item.action, actionNames)
            add("Какой командой можно \(item.task)?", item.action, actionNames)
        }

        let safetyCases: [(situation: String, correct: String, wrong1: String, wrong2: String, wrong3: String)] = [
            ("незнакомец в игре просит твой пароль", "не сообщать пароль и рассказать взрослому", "отправить пароль в чат", "написать пароль в профиле", "попросить незнакомца придумать пароль за тебя"),
            ("пришло сообщение с неизвестной ссылкой и обещанием приза", "не открывать ссылку и спросить взрослого", "нажать на ссылку сразу", "ввести данные карты ради приза", "переслать ссылку всем друзьям"),
            ("человек в интернете просит домашний адрес", "не сообщать адрес и обратиться к взрослому", "написать полный адрес", "указать расписание семьи", "опубликовать адрес в игре"),
            ("появилось незнакомое окно с просьбой скачать файл", "не скачивать файл без разрешения взрослого", "скачать и открыть его сразу", "отключить защиту компьютера", "разослать файл одноклассникам"),
            ("кто-то прислал обидное сообщение", "не отвечать обидой и рассказать взрослому", "написать ещё более обидные слова", "опубликовать чужие секреты", "передать сообщение всему классу"),
            ("друг забыл выйти из своего аккаунта на общем компьютере", "сообщить другу и выйти из его аккаунта", "читать его личные сообщения", "менять настройки его страницы", "покупать что-то от его имени"),
            ("сайт просит твоё имя, адрес и телефон без понятной причины", "не вводить личные данные и спросить взрослого", "заполнить всё сразу", "публиковать данные в комментариях", "выслать данные незнакомому человеку"),
            ("компьютер сообщает о подозрительном файле", "не открывать файл и попросить взрослого проверить", "отключить предупреждение", "повторно скачивать файл из того же сообщения", "запустить файл несколько раз"),
            ("в интернете предлагают тайно встретиться", "не соглашаться и немедленно рассказать взрослому", "пойти на встречу одному", "скрыть встречу от родителей", "отправить своё местоположение"),
            ("ты случайно открыл странную страницу", "закрыть страницу и сообщить взрослому, если тревожно", "нажимать все кнопки на странице", "заполнять появившиеся формы", "скачивать всё, что предлагают"),
            ("кто-то просит прислать код из SMS", "никому не сообщать код и обратиться к взрослому", "отправить код в чат", "опубликовать код в профиле", "переслать код незнакомому человеку"),
            ("ты нашёл чужую фотографию и хочешь её выложить", "спросить разрешение человека и взрослого", "публиковать без спроса", "добавить обидную подпись", "разослать фотографию незнакомцам"),
            ("появилась всплывающая реклама с кнопкой «Ты выиграл»", "не нажимать и закрыть рекламу", "нажать и ввести данные", "скачать неизвестное приложение", "разрешить все уведомления"),
            ("кто-то в чате представляется одноклассником, но пишет странно", "проверить у знакомого другим способом и спросить взрослого", "сразу отправить ему секреты", "перевести деньги", "выслать пароль"),
            ("ты хочешь установить новую игру", "сначала получить разрешение родителей", "установить её с любого сайта", "отключить антивирус", "согласиться со всеми окнами"),
            ("ты используешь общий школьный компьютер", "выйти из своих аккаунтов после работы", "оставить аккаунт открытым", "сохранить пароль в общем файле", "сообщить пароль следующему ученику"),
            ("в чате просят назвать школу и расписание", "не сообщать такие сведения незнакомцам", "написать расписание уроков", "отправить фото школьного пропуска", "указать время, когда ты один дома"),
            ("программа неожиданно просит разрешение на всё подряд", "остановиться и спросить взрослого", "нажимать «Разрешить» не читая", "ввести пароль в каждое окно", "отключить защитные настройки"),
            ("ты увидел в сети непонятную или пугающую картинку", "закрыть её и рассказать взрослому", "искать ещё похожие картинки", "пересылать картинку детям", "оставаться на странице"),
            ("друг просит твой пароль, чтобы поиграть за тебя", "не делиться паролем даже с другом", "дать пароль на один вечер", "написать пароль на бумаге для друга", "поставить общий пароль для всех"),
            ("тебе пишут, что нужно срочно оплатить подарок", "не платить и показать сообщение взрослому", "ввести данные карты", "отправить фотографию карты", "перевести деньги по ссылке"),
            ("ты заметил, что сайт выглядит не так, как обычно", "проверить адрес и спросить взрослого", "сразу вводить пароль", "скачать предложенное обновление", "игнорировать все предупреждения"),
            ("тебя просят отправить личные фотографии незнакомцу", "отказаться и сразу рассказать взрослому", "отправить фотографии тайно", "попросить незнакомца хранить их в секрете", "опубликовать фотографии в открытом доступе"),
            ("ты хочешь использовать чужой текст в школьной работе", "указать автора и спросить учителя, как правильно использовать текст", "выдать чужой текст за свой", "стереть имя автора", "скопировать работу одноклассника полностью"),
            ("в игре предлагают обойти правила и получить бесплатные монеты через неизвестный файл", "не скачивать файл и посоветоваться со взрослым", "скачать программу", "сообщить пароль от аккаунта", "отключить защиту"),
            ("кто-то написал, что твой аккаунт заблокируют, если ты не сообщишь пароль", "не отвечать и показать сообщение взрослому", "сразу отправить пароль", "написать пароль в общий чат", "перейти по любой ссылке из сообщения"),
            ("ты получил файл от неизвестного отправителя", "не открывать его без проверки взрослым", "открыть файл из любопытства", "переслать файл всем", "выключить защиту"),
            ("видеоигра просит разрешить доступ к микрофону, хотя он не нужен", "не давать лишнее разрешение и спросить взрослого", "разрешить всё", "включить микрофон постоянно", "записать разговоры семьи"),
            ("во время онлайн-урока нужно отойти от компьютера", "выключить микрофон, если это нужно, и соблюдать правила урока", "оставить микрофон включённым во время личного разговора", "показывать камере чужие вещи", "перебивать всех участников"),
            ("ты отправил сообщение не тому человеку", "сразу сообщить взрослому, если там были личные данные", "делать вид, что ничего не произошло", "попросить получателя разослать сообщение", "отправить ещё больше личных данных"),
            ("на экране появилось предупреждение о вирусе с неизвестным номером телефона", "не звонить по нему и позвать взрослого", "позвонить неизвестному номеру", "сказать оператору пароль", "установить программу по его просьбе"),
            ("кто-то смеётся над ошибкой другого ребёнка в сети", "не поддерживать насмешки и сообщить взрослому", "добавить обидный комментарий", "разослать скриншот для смеха", "создать группу для насмешек"),
            ("ты хочешь опубликовать своё местоположение в реальном времени", "сначала обсудить это с родителями и не делиться публично", "публиковать адрес всем", "отправить координаты незнакомцам", "указать, когда дома никого нет"),
            ("сайт обещает бесплатный телефон за ввод пароля от почты", "не вводить пароль и закрыть страницу", "ввести пароль от почты", "отправить код подтверждения", "передать данные другу для заполнения"),
            ("ты заметил, что кто-то пользуется твоим аккаунтом", "сразу рассказать родителям и вместе сменить пароль", "ничего не менять и молчать", "публиковать пароль в чате", "отправить незнакомцу код входа"),
            ("незнакомый игрок просит сохранить разговор в тайне от родителей", "прекратить разговор и рассказать родителям", "пообещать хранить всё в секрете", "отправить свой адрес", "согласиться на личную встречу"),
            ("ты хочешь оставить комментарий под чужой работой", "написать вежливо и по делу", "оскорбить автора", "публиковать чужие секреты", "насмехаться над внешностью"),
            ("в письме есть вложение, которого ты не ожидал", "проверить письмо со взрослым, прежде чем открывать вложение", "открыть вложение немедленно", "скачать все файлы из письма", "переслать вложение всем"),
            ("ты случайно сообщил пароль в открытом чате", "сразу рассказать взрослому и сменить пароль", "оставить пароль прежним", "написать пароль ещё раз", "отправить пароль другим друзьям"),
            ("перед скачиванием приложения ты не уверен, можно ли ему доверять", "попросить взрослого проверить источник и разрешения", "скачать с первой попавшейся страницы", "отключить все предупреждения", "нажать на любую рекламную кнопку")
        ]
        for item in safetyCases {
            let options = [item.correct, item.wrong1, item.wrong2, item.wrong3]
            add("Что безопаснее сделать, если \(item.situation)?", item.correct, options)
            add("Как правильно поступить в ситуации: \(item.situation)?", item.correct, options)
            add("Что лучше выбрать, когда \(item.situation)?", item.correct, options)
            add("Какой ответ будет безопасным, если \(item.situation)?", item.correct, options)
        }

        let keys: [(key: String, purpose: String, action: String, clue: String)] = [
            ("Enter", "подтверждать ввод или переходить на новую строку", "подтвердить ответ", "на неё часто нажимают в конце ввода"),
            ("Пробел", "оставлять промежуток между словами", "разделить слова пробелом", "это длинная клавиша в нижнем ряду"),
            ("Backspace", "удалять символ слева от курсора", "убрать ошибочную букву слева", "она стирает символ перед курсором"),
            ("Delete", "удалять выбранный объект или символ справа", "удалить выбранный элемент", "её название обычно написано на самой клавише"),
            ("Shift", "временно вводить заглавную букву вместе с буквой", "напечатать одну заглавную букву", "её держат нажатой вместе с другой клавишей"),
            ("Caps Lock", "включать или выключать режим заглавных букв", "написать несколько заглавных букв подряд", "она переключает режим букв"),
            ("Esc", "отменять или закрывать некоторые окна и меню", "закрыть небольшое меню", "её название сокращает слово Escape"),
            ("Tab", "переходить к следующему полю", "перейти к следующему полю формы", "ею можно переходить между полями"),
            ("Стрелки", "перемещать курсор или выбор", "переместить выбор вверх", "они показывают направления"),
            ("Ctrl", "использовать сочетания клавиш", "выполнить сочетание клавиш", "часто используется вместе с другими кнопками"),
            ("Command (⌘)", "использовать сочетания клавиш на Mac", "сохранить файл сочетанием клавиш", "на клавиатуре Mac эта клавиша помечена символом ⌘"),
            ("Option (⌥)", "вводить дополнительные символы или использовать сочетания", "выбрать дополнительную команду", "на Mac её часто обозначают символом ⌥"),
            ("Fn", "включать дополнительные функции некоторых клавиш", "использовать дополнительную функцию клавиши", "часто встречается на ноутбуках"),
            ("F1", "открывать справку в некоторых программах", "вызвать справку программы", "это функциональная клавиша с номером один"),
            ("F2", "переименовывать выбранный объект в некоторых системах", "переименовать файл", "в некоторых системах помогает сменить имя файла"),
            ("F5", "обновлять страницу или содержимое в некоторых программах", "обновить страницу", "часто используется для обновления"),
            ("Home", "переходить к началу строки или документа", "перейти к началу строки", "её английское название связано с началом"),
            ("End", "переходить к концу строки или документа", "перейти к концу строки", "она помогает перейти в конец"),
            ("Page Up", "перемещаться вверх на страницу", "пролистать страницу вверх", "на клавише написано Up"),
            ("Page Down", "перемещаться вниз на страницу", "пролистать страницу вниз", "на клавише написано Down"),
            ("Буквенные клавиши", "вводить буквы", "напечатать слово", "на них изображены буквы"),
            ("Цифровые клавиши", "вводить цифры", "напечатать число", "на них изображены цифры"),
            ("Command + C", "копировать выделенное", "скопировать текст", "сочетание C связано с английским словом Copy"),
            ("Command + V", "вставлять скопированное", "вставить текст из буфера", "обычно нажимают после копирования"),
            ("Command + S", "сохранять изменения", "сохранить документ", "сочетание S связано со словом Save"),
            ("Command + Z", "отменять последнее действие", "вернуть предыдущий шаг", "помогает исправить случайное действие"),
            ("Command + P", "открывать печать", "открыть окно печати", "сочетание P связано со словом Print"),
            ("Command + A", "выделять всё", "выбрать весь текст", "сочетание A означает All"),
            ("Command + X", "вырезать выделенное", "вырезать фрагмент текста", "сочетание X используют для вырезания"),
            ("Command + F", "искать текст", "найти слово в документе", "сочетание F связано со словом Find"),
            ("Command + N", "создавать новый документ или окно", "создать новый документ", "сочетание N связано со словом New"),
            ("Command + O", "открывать файл", "открыть документ", "сочетание O связано со словом Open"),
            ("Command + plus", "увеличивать масштаб", "приблизить содержимое", "знак плюс помогает увеличить масштаб"),
            ("Command + minus", "уменьшать масштаб", "уменьшить содержимое на экране", "знак минус помогает уменьшить масштаб")
        ]
        let keyNames = keys.map(\.key)
        let keyPurposes = keys.map(\.purpose)
        for item in keys {
            add("Что делает клавиша или сочетание «\(item.key)»?", item.purpose, keyPurposes)
            add("Какая клавиша или команда нужна, чтобы \(item.action)?", item.key, keyNames)
            add("Для чего пригодится «\(item.key)»?", item.purpose, keyPurposes)
            add("Угадай клавишу или сочетание по подсказке: \(item.clue).", item.key, keyNames)
        }

        let informationExamples: [(example: String, kind: String, action: String)] = [
            ("короткое сообщение на экране", "текст", "прочитать сообщение на экране"),
            ("голосовое сообщение", "звук", "послушать голосовое сообщение"),
            ("фотография котёнка", "изображение", "рассмотреть фотографию котёнка"),
            ("ролик о движении планет", "видео", "посмотреть ролик о планетах"),
            ("число учеников в классе", "числовые данные", "посмотреть количество учеников"),
            ("план комнаты с условными значками", "схема", "изучить план комнаты"),
            ("движущийся герой мультфильма", "анимация", "наблюдать, как герой двигается по кадрам"),
            ("столбики, показывающие результаты опроса", "график", "сравнить результаты опроса по столбикам"),
            ("письмо в тетради", "текст", "прочитать письмо в тетради"),
            ("звонок школьного колокольчика", "звук", "услышать звонок колокольчика"),
            ("карта города", "изображение", "рассмотреть карту города"),
            ("запись футбольного матча", "видео", "посмотреть запись матча"),
            ("температура воздуха в градусах", "числовые данные", "сравнить значения температуры"),
            ("схема маршрута автобуса", "схема", "разобраться в схеме маршрута"),
            ("гифка с прыгающим мячом", "анимация", "увидеть мяч, который движется в повторяющихся кадрах"),
            ("диаграмма любимых фруктов класса", "график", "сравнить данные на диаграмме"),
            ("страница книги с рассказом", "текст", "прочитать рассказ"),
            ("мелодия в наушниках", "звук", "послушать мелодию"),
            ("рисунок космического корабля", "изображение", "посмотреть рисунок корабля"),
            ("обучающий видеоролик", "видео", "посмотреть обучающий ролик"),
            ("номер страницы в книге", "числовые данные", "прочитать номер страницы"),
            ("схема частей цветка", "схема", "изучить обозначения частей цветка"),
            ("анимированный смайлик", "анимация", "посмотреть на движущийся смайлик"),
            ("график изменения погоды", "график", "сравнить изменения погоды на графике"),
            ("список покупок", "текст", "прочитать список покупок"),
            ("звук дождя в аудиозаписи", "звук", "послушать запись дождя"),
            ("картина с изображением моря", "изображение", "рассмотреть картину с морем"),
            ("видеозапись школьного концерта", "видео", "посмотреть концерт в записи"),
            ("результат вычисления 25", "числовые данные", "прочитать результат вычисления"),
            ("план эвакуации в школе", "схема", "найти путь на плане эвакуации"),
            ("анимация вращающейся Земли", "анимация", "увидеть вращение модели Земли"),
            ("диаграмма погоды за неделю", "график", "сравнить температуру за неделю по диаграмме"),
            ("электронная открытка с поздравлением", "изображение", "рассмотреть рисунок на открытке"),
            ("записанное объявление по громкой связи", "звук", "прослушать объявление"),
            ("субтитры в фильме", "текст", "прочитать слова внизу фильма"),
            ("фрагмент мультфильма", "видео", "посмотреть фрагмент мультфильма"),
            ("таблица результатов соревнования", "числовые данные", "сравнить результаты в таблице"),
            ("план расположения парт в классе", "схема", "найти своё место на плане класса"),
            ("движущиеся картинки в обучающей игре", "анимация", "наблюдать за движущимися картинками"),
            ("линейный график температуры", "график", "посмотреть, как менялась температура")
        ]
        let informationKinds = ["текст", "звук", "изображение", "видео", "числовые данные", "схема", "анимация", "график"]
        for item in informationExamples {
            add("К какому виду информации относится «\(item.example)»?", item.kind, informationKinds)
            add("Какой вид информации можно получить, если \(item.action)?", item.kind, informationKinds)
            add("Если ты собираешься \(item.action), с каким видом информации работаешь?", item.kind, informationKinds)
            add("Выбери вид информации для примера: \(item.example).", item.kind, informationKinds)
        }

        let algorithms: [(task: String, first: String, last: String, order: String)] = [
            ("собрать портфель в школу", "проверить расписание", "проверить, всё ли положено", "расписание → учебники → пенал"),
            ("сохранить рассказ на компьютере", "открыть текстовый редактор", "проверить название файла", "открыть редактор → написать → сохранить"),
            ("нарисовать цифровую открытку", "придумать идею рисунка", "сохранить открытку", "идея → рисунок → сохранить"),
            ("найти ответ в учебном сайте", "прочитать вопрос", "проверить найденный ответ", "вопрос → поиск → проверка"),
            ("распечатать школьную работу", "проверить документ", "забрать бумажную копию", "проверить файл → печать → забрать лист"),
            ("запустить простую игру", "открыть меню игры", "проверить, что игра загрузилась", "открыть игру → нажать старт → играть"),
            ("отправить письмо учителю", "проверить адрес получателя", "проверить отправленное письмо", "адрес → текст письма → отправить"),
            ("создать папку для фотографий", "открыть место для новой папки", "проверить, где появилась папка", "открыть папку → создать новую → назвать"),
            ("переименовать документ", "найти нужный файл", "проверить новое название", "найти файл → выбрать имя → подтвердить"),
            ("подключить планшет к Wi-Fi", "открыть настройки сети", "проверить подключение", "настройки → выбрать сеть → подключиться"),
            ("сфотографировать поделку и сохранить снимок", "подготовить камеру", "проверить снимок", "открыть камеру → сделать фото → проверить"),
            ("написать и проверить короткий текст", "прочитать задание", "перечитать готовый текст", "прочитать задание → написать → проверить"),
            ("найти сохранённую картинку", "открыть список файлов", "открыть найденную картинку", "открыть файлы → найти картинку → открыть"),
            ("собрать команды для движения героя", "выбрать героя", "запустить и проверить программу", "выбрать героя → собрать команды → запустить"),
            ("измерить время бега секундомером", "подготовить секундомер", "записать результат", "подготовить секундомер → старт → стоп"),
            ("послушать учебную аудиозапись", "проверить громкость", "остановить запись после прослушивания", "проверить звук → включить запись → остановить"),
            ("создать презентацию о животных", "выбрать тему", "проверить слайды", "тема → слайды → проверка"),
            ("удалить ненужную копию файла", "проверить, какой файл лишний", "убедиться, что нужная версия осталась", "проверить файл → удалить копию → проверить папку"),
            ("обновить страницу сайта", "проверить подключение к сети", "прочитать обновлённую страницу", "проверить сеть → обновить страницу → прочитать"),
            ("изучить новое английское слово", "прочитать слово", "повторить перевод", "прочитать слово → узнать перевод → повторить"),
            ("раскрасить рисунок в редакторе", "открыть рисунок", "сохранить раскрашенную работу", "открыть рисунок → выбрать цвет → сохранить"),
            ("сделать резервную копию файла на флешку", "проверить флешку", "безопасно извлечь флешку", "проверить флешку → скопировать файл → извлечь"),
            ("подготовить школьный доклад", "выбрать тему доклада", "проверить готовый доклад", "тема → собрать сведения → проверить"),
            ("изменить размер изображения", "открыть изображение в редакторе", "сохранить изменённый файл", "открыть изображение → изменить размер → сохранить"),
            ("найти нужную страницу электронной книги", "открыть книгу", "начать читать найденную страницу", "открыть книгу → найти страницу → читать"),
            ("составить список дел на день", "вспомнить нужные дела", "проверить список", "вспомнить дела → записать список → проверить"),
            ("проверить работу робота", "прочитать команды", "исправить найденную ошибку", "прочитать команды → запустить робота → проверить"),
            ("сделать снимок экрана", "найти нужное изображение на экране", "проверить сохранённый снимок", "найти изображение → сделать снимок → проверить"),
            ("создать новый документ", "открыть меню программы", "сохранить новый документ", "открыть меню → создать документ → сохранить"),
            ("найти ошибку в последовательности команд", "прочитать команды по порядку", "проверить исправленный результат", "прочитать команды → найти ошибку → исправить"),
            ("подготовиться к видеозвонку с классом", "проверить время урока", "завершить звонок после занятия", "проверить время → подключиться → завершить звонок"),
            ("записать голосовое сообщение", "подумать, что нужно сказать", "прослушать запись перед отправкой", "подготовить слова → записать → прослушать"),
            ("посмотреть безопасный сайт с родителем", "согласовать сайт со взрослым", "закрыть страницу после работы", "спросить взрослого → открыть сайт → закрыть страницу"),
            ("отсортировать файлы по названию", "открыть папку с файлами", "проверить новый порядок", "открыть папку → выбрать сортировку → проверить"),
            ("создать простой мультфильм", "придумать сюжет", "проверить движение персонажа", "сюжет → добавить кадры → проверить"),
            ("посчитать результаты небольшого опроса", "собрать ответы", "проверить итоговые числа", "собрать ответы → посчитать → проверить")
        ]
        let firstSteps = algorithms.map(\.first)
        let lastSteps = algorithms.map(\.last)
        let orders = algorithms.map(\.order)
        for item in algorithms {
            add("Что нужно сделать сначала, чтобы \(item.task)?", item.first, firstSteps)
            add("Что логично сделать в конце, когда \(item.task)?", item.last, lastSteps)
            add("Какой порядок действий подходит для задачи: \(item.task)?", item.order, orders)
            add("Почему полезно выполнять шаги по порядку, когда нужно \(item.task)?", "Чтобы не пропустить важный шаг", ["Чтобы не пропустить важный шаг", "Чтобы компьютер угадал результат", "Чтобы не читать задание", "Чтобы действия выполнялись случайно"])
        }

        let concepts: [(term: String, meaning: String, task: String)] = [
            ("алгоритм", "точный порядок шагов для выполнения задачи", "составить шаги для решения задачи"),
            ("команда", "указание выполнить определённое действие", "попросить персонажа идти вперёд"),
            ("программа", "набор команд для компьютера", "дать компьютеру несколько инструкций"),
            ("исполнитель", "тот, кто выполняет команды", "управлять роботом по инструкции"),
            ("цикл", "повторение действий несколько раз", "повторить движение несколько раз"),
            ("событие", "то, что запускает действие программы", "начать действия после нажатия кнопки"),
            ("персонаж", "герой, который действует на сцене", "добавить героя в простую игру"),
            ("сцена", "место, где находится персонаж", "изменить фон истории"),
            ("блок", "готовая команда в блочном редакторе", "собрать программу из цветных команд"),
            ("условие", "проверка, от которой зависит следующее действие", "выполнить шаг, если нажата кнопка"),
            ("последовательность", "шаги, расположенные один за другим", "выполнить команды в нужном порядке"),
            ("ошибка", "неверная команда или неправильный результат", "понять, почему программа работает не так"),
            ("отладка", "поиск и исправление ошибок в программе", "проверить, почему герой не движется"),
            ("координаты", "числа, которые показывают положение объекта", "определить место персонажа на поле"),
            ("направление", "сторона, в которую движется объект", "выбрать движение вверх или вниз"),
            ("скорость", "то, насколько быстро движется объект", "сделать движение персонажа быстрее"),
            ("спрайт", "персонаж или объект в визуальной программе", "выбрать героя для игры"),
            ("фон", "изображение позади персонажей", "выбрать лес для сцены мультфильма"),
            ("анимация", "движение, созданное сменой изображений или кадров", "показать, как герой шагает"),
            ("переменная", "именованное место для хранения значения", "сохранить число очков в игре"),
            ("ввод", "передача данных или команд компьютеру", "напечатать ответ на клавиатуре"),
            ("вывод", "показ результата работы компьютера", "увидеть ответ на экране"),
            ("файл", "сохранённый документ, рисунок или другой набор данных", "сохранить готовый рисунок"),
            ("папка", "место для хранения и упорядочивания файлов", "собрать похожие документы вместе"),
            ("значок", "маленькое изображение, обозначающее программу или файл", "найти нужное приложение на экране"),
            ("курсор", "указатель, показывающий место или выбранный объект", "переместить указатель к кнопке"),
            ("браузер", "программа для открытия веб-страниц", "посмотреть страницу школьного сайта"),
            ("сайт", "набор связанных веб-страниц", "прочитать материал в интернете"),
            ("поиск", "способ находить нужные сведения", "отыскать сведения о планетах"),
            ("пароль", "секретный набор символов для защиты доступа", "защитить личную учётную запись"),
            ("логин", "имя пользователя для входа в аккаунт", "указать, какой пользователь входит"),
            ("электронная почта", "способ отправлять и получать письма через интернет", "отправить письмо учителю"),
            ("презентация", "рассказ, состоящий из слайдов", "показать классу доклад с картинками"),
            ("слайд", "одна отдельная страница презентации", "добавить новую страницу в доклад"),
            ("текстовый документ", "файл с написанным текстом", "сохранить сочинение"),
            ("графический редактор", "программа для создания и изменения изображений", "нарисовать картинку на компьютере"),
            ("интерфейс", "элементы окна, с которыми взаимодействует пользователь", "найти кнопку и меню программы"),
            ("робототехника", "создание и управление роботами", "собрать робота и задать ему команды"),
            ("датчик", "устройство, которое измеряет или замечает изменение", "узнать температуру в комнате"),
            ("интернет", "глобальная сеть для обмена информацией", "найти учебный материал на сайте"),
            ("цифровой след", "информация, которая остаётся после действий в сети", "подумать перед публикацией комментария"),
            ("авторское право", "правила, которые защищают созданные другими людьми работы", "указать автора использованной картинки"),
            ("значение пикселя", "цвет одной маленькой точки цифрового изображения", "изменить цвет маленькой точки на картинке"),
            ("ссылка", "адрес, по которому можно открыть страницу или файл", "перейти на нужный сайт"),
            ("обновление", "новая версия программы с исправлениями или улучшениями", "получить исправленную версию приложения")
        ]
        let conceptTerms = concepts.map(\.term)
        let conceptMeanings = concepts.map(\.meaning)
        for item in concepts {
            add("Что означает понятие «\(item.term)» в информатике?", item.meaning, conceptMeanings)
            add("Как называется понятие: \(item.meaning)?", item.term, conceptTerms)
            add("Какое понятие пригодится, если нужно \(item.task)?", item.term, conceptTerms)
            add("Выбери правильное объяснение слова «\(item.term)».", item.meaning, conceptMeanings)
        }

        // Keep prompts unique, even if future lists reuse a wording.
        var seen = Set<String>()
        let unique = bank.filter { seen.insert($0.text).inserted }
        assert(unique.count >= 1000, "Informatics question bank must contain at least 1000 unique prompts")
        return unique
    }

        private static func advancedMathQuestion(level: Int) -> Problem {
        switch min(5, max(2, level)) {
        case 2:
            let a = Int.random(in: 100...499), b = Int.random(in: 20...min(300, 999 - a))
            return Bool.random() ? Problem(text: "\(a) + \(b) = ?", answer: String(a + b)) : Problem(text: "\(a + b) − \(b) = ?", answer: String(a))
        case 3:
            if Bool.random() { let a = Int.random(in: 12...49), b = Int.random(in: 2...9); return Problem(text: "\(a) × \(b) = ?", answer: String(a * b)) }
            let d = Int.random(in: 3...9), q = Int.random(in: 12...45)
            return Problem(text: "\(d * q) : \(d) = ?", answer: String(q))
        case 4:
            let a = Int.random(in: 2...9), b = Int.random(in: 2...9), c = Int.random(in: 10...60)
            return Bool.random() ? Problem(text: "\(a) × \(b) + \(c) = ?", answer: String(a * b + c)) : Problem(text: "(\(c) + \(a * b)) − \(c) = ?", answer: String(a * b))
        default:
            let a = Int.random(in: 12...35), b = Int.random(in: 2...8), d = Int.random(in: 2...8), q = Int.random(in: 12...36)
            return Bool.random() ? Problem(text: "\(a) × \(b) − \(d) = ?", answer: String(a * b - d)) : Problem(text: "(\(q * d) : \(d)) + \(a) = ?", answer: String(q + a))
        }
    }

    private static func logicQuestion(level: Int) -> Problem {
        let banks: [(String, String, [String])] = [
            ("Продолжи числовой ряд: 2, 4, 6, 8, …", "10", ["10", "9", "11", "12"]),
            ("Продолжи числовой ряд: 5, 10, 15, 20, …", "25", ["25", "24", "30", "22"]),
            ("Какое число лишнее: 3, 6, 9, 11, 12?", "11", ["11", "6", "9", "12"]),
            ("Что лишнее: яблоко, груша, морковь, слива?", "Морковь", ["Морковь", "Яблоко", "Груша", "Слива"]),
            ("У Ани 4 карандаша, у Вани на 3 больше. Сколько у Вани?", "7", ["7", "1", "8", "12"]),
            ("У стола 4 угла. Один угол отпилили. Сколько углов стало у столешницы?", "5", ["5", "3", "4", "6"]),
            ("Если сегодня вторник, какой день будет через 3 дня?", "Пятница", ["Пятница", "Четверг", "Суббота", "Воскресенье"]),
            ("Что тяжелее: 1 кг песка или 1 кг сахара?", "Одинаково", ["Одинаково", "Песок", "Сахар", "Нельзя сравнить"]),
            ("В коробке 3 пары носков. Сколько носков?", "6", ["6", "3", "5", "9"]),
            ("Продолжи ряд фигур: круг, квадрат, круг, квадрат, …", "Круг", ["Круг", "Квадрат", "Треугольник", "Звезда"]),
            ("Какое число пропущено: 4, 8, 12, __, 20?", "16", ["16", "14", "15", "18"]),
            ("У пяти птиц по две лапы. Сколько всего лап?", "10", ["10", "7", "5", "12"]),
            ("У Маши 2 брата, и у каждого брата есть одна сестра Маша. Сколько детей в семье?", "3", ["3", "4", "2", "5"]),
            ("Какое слово не подходит к остальным: понедельник, среда, июнь, пятница?", "Июнь", ["Июнь", "Понедельник", "Среда", "Пятница"]),
            ("Продолжи ряд: 1, 2, 4, 8, …", "16", ["16", "10", "12", "14"])
        ]
        let item = banks.randomElement()!
        return choiceProblem(item)
    }

    private static func biologyQuestion(level: Int, illustrated: Bool) -> Problem {
        // Расширенный банк организмов даёт 320 дополнительных сочетаний вопроса и ответа.
        let organisms: [(String, String, String, String, String)] = [
            ("дельфин", "млекопитающее", "море", "рыбой и кальмарами", "лёгкими"),
            ("карась", "рыба", "пресная вода", "водными организмами", "жабрами"),
            ("орёл", "птица", "горы и леса", "мелкими животными", "лёгкими"),
            ("лягушка", "земноводное", "влажные места у воды", "насекомыми", "лёгкими и кожей"),
            ("бабочка", "насекомое", "сады и луга", "нектаром", "трахейной системой"),
            ("пчела", "насекомое", "луга и сады", "нектаром и пыльцой", "трахейной системой"),
            ("ёж", "млекопитающее", "лес и сад", "насекомыми и червями", "лёгкими"),
            ("крот", "млекопитающее", "подземные ходы в почве", "червями", "лёгкими"),
            ("верблюд", "млекопитающее", "пустыня", "растениями", "лёгкими"),
            ("белый медведь", "млекопитающее", "арктические льды", "рыбой и тюленями", "лёгкими"),
            ("пингвин", "птица", "побережье Южного полушария", "рыбой и крилем", "лёгкими"),
            ("улитка", "моллюск", "влажные места", "растениями", "лёгким или жабрами в зависимости от вида"),
            ("паук", "паукообразное", "почва и растения", "насекомыми", "книжными лёгкими или трахеями"),
            ("дождевой червь", "кольчатый червь", "влажная почва", "разлагающимися остатками растений", "через влажную кожу"),
            ("сосна", "хвойное растение", "лес", "сама образует питательные вещества на свету", "через устьица и другие поверхности"),
            ("берёза", "лиственное дерево", "лес и парк", "сама образует питательные вещества на свету", "через устьица листьев"),
            ("кактус", "растение", "засушливые места", "сама образует питательные вещества на свету", "через поверхность стебля и устьица"),
            ("папоротник", "споровое растение", "влажный тенистый лес", "сама образует питательные вещества на свету", "через поверхность растения"),
            ("шампиньон", "гриб", "почва и богатые органикой места", "готовыми органическими веществами", "обменом газов через поверхность"),
            ("бактерия", "микроорганизм", "почва, вода и живые организмы", "разными веществами в зависимости от вида", "через клеточную мембрану"),
            ("росомаха", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("рысь", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("манул", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("сурикат", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("дикобраз", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("енот", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("скунс", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("опоссум", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("ленивец", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("муравьед", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("броненосец", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("тапир", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("лама", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("альпака", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("як", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("буйвол", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("антилопа", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("газель", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("гиена", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("шакал", "млекопитающее", "леса, поля и природные укрытия", "растениями или другими животными в зависимости от вида", "лёгкими"),
            ("журавль", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("перепел", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("фазан", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("павлин", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("индюк", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("ласточка", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("стриж", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("синица", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("поползень", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("зяблик", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("дрозд", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("скворец", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("иволга", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("пустельга", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("альбатрос", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("баклан", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("тупик", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("кондор", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("птица-секретарь", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("казуар", "птица", "леса, поля, берега водоёмов или города", "семенами, растениями или мелкими животными в зависимости от вида", "лёгкими"),
            ("треска", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("сельдь", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("сардина", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("камбала", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("сом", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("карп", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("форель", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("осётр", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("белуга", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("минтай", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("тунец", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("меч-рыба", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("рыба-клоун", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("рыба-попугай", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("мурена", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("пиранья", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("парусник", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("электрический скат", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("рыба-ёж", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("угорь", "рыба", "моря, реки или озёра", "водными организмами; рацион зависит от вида", "жабрами"),
            ("липа", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("ива", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("осина", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("тополь", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("каштан", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("рябина", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("шиповник", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("малина", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("клубника", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("черника", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("брусника", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("клюква", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("одуванчик", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("подорожник", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("крапива", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("лаванда", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("мята", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("базилик", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("тыква", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности"),
            ("огурец", "растение", "почва, луга, леса, сады или водоёмы", "самостоятельно образует питательные вещества при фотосинтезе", "через устьица и другие поверхности")
        ]
        let kinds = organisms.map { $0.1 }
        let habitats = organisms.map { $0.2 }
        let foods = organisms.map { $0.3 }
        let breathing = organisms.map { $0.4 }
        let item = organisms.randomElement()!
        let type = Int.random(in: 0...3)
        let forms = [
            "К какой группе относится организм «%@»?",
            "Где обычно можно встретить организм «%@»?",
            "Чем питается организм «%@»?",
            "Как организм «%@» получает кислород или обменивается газами?"
        ]
        let answer: String
        let choices: [String]
        switch type {
        case 0: answer = item.1; choices = ([answer] + Array(Array(Set(kinds.filter { $0 != answer })).shuffled().prefix(3).prefix(3))).shuffled()
        case 1: answer = item.2; choices = ([answer] + Array(Array(Set(habitats.filter { $0 != answer })).shuffled().prefix(3).prefix(3))).shuffled()
        case 2: answer = item.3; choices = ([answer] + Array(Array(Set(foods.filter { $0 != answer })).shuffled().prefix(3).prefix(3))).shuffled()
        default: answer = item.4; choices = ([answer] + Array(Array(Set(breathing.filter { $0 != answer })).shuffled().prefix(3).prefix(3))).shuffled()
        }
        let prompt = String(format: forms[type], item.0)
        let variant = illustrated ? "Рассмотри иллюстрацию. " : ""
        // Variants vary wording while retaining the same scientific fact and a single correct answer.
        let phrasing = illustrated
            ? ["Рассмотри иллюстрацию. %@", "По изображённому организму ответь: %@", "Изучите рисунок и выбери верный ответ: %@", "Что верно для организма на картинке? %@", "Посмотри на рисунок и ответь: %@", "Какой факт соответствует изображённому организму? %@", "Определи по иллюстрации: %@", "Изучи картинку и выбери ответ: %@", "Что можно сказать об организме на рисунке? %@", "Выбери правильное описание по изображению: %@", "Рассмотри изображение и ответь на вопрос: %@", "Как правильно ответить по картинке? %@", "Что показывает эта иллюстрация? %@", "Используй изображение и знания биологии: %@", "Выбери научно верный ответ по рисунку: %@", "Какой ответ подходит к иллюстрации? %@", "Внимательно посмотри на картинку: %@", "Определи верное утверждение по изображению: %@", "Какой факт подходит к картинке? %@", "Рассмотри организм и выбери ответ: %@", "Что важно знать об изображённом организме? %@", "Сопоставь рисунок и биологический факт: %@", "Как верно описать организм на картинке? %@", "Изображение поможет ответить: %@", "Найди ответ по иллюстрации: %@", "Какой вариант верен для этого организма? %@", "Прочитай вопрос и рассмотри рисунок: %@", "Ответь, изучив иллюстрацию: %@", "Выбери правильный биологический факт: %@", "Проверь знания по картинке: %@"][Int.random(in: 0...29)]
            : ["Ответь на вопрос: %@", "Выбери научно верное утверждение: %@", "Проверь свои знания. %@", "Как правильно ответить? %@", "Биологический вопрос: %@", "Какой ответ верен? %@", "Выбери точный ответ: %@", "Вспомни биологию: %@", "Подумай и ответь: %@", "Что известно об этом организме? %@", "Выбери правильный вариант. %@", "Проверь биологические знания: %@", "Какое утверждение подходит? %@", "Ответь, опираясь на факты: %@", "Найди верный биологический ответ: %@", "Определи верное утверждение: %@", "Что нужно знать об организме? %@", "Какой вариант научно точен? %@", "Выбери ответ без ошибки: %@", "Проверь себя по биологии: %@", "Как верно описать организм? %@", "Какое объяснение правильное? %@", "Выбери подходящий ответ: %@", "Небольшая проверка знаний: %@", "Как ответить на этот вопрос? %@", "Найди правильное описание: %@", "Какой факт соответствует вопросу? %@", "Внимательно прочитай и ответь: %@", "Выбери правильный факт: %@", "Биология вокруг нас: %@"][Int.random(in: 0...29)]
        let finalPrompt = prompt // Стабильный текст позволяет не повторять уже освоенный факт из-за случайной переформулировки.
        _ = variant
        return Problem(text: finalPrompt, answer: answer, isTatarChoice: true, tatarChoices: Array(choices), showIllustration: illustrated)
    }

    private static func chemistryQuestionBank() -> [Problem] {
        // 50 simple facts × 6 different prompts = 300 questions. All distractors are age-appropriate.
        let facts: [(String, String, [String])] = [
            ("Как называется формула воды?", "H₂O", ["CO₂", "O₂", "NaCl"]),
            ("Какой газ нужен человеку для дыхания?", "Кислород", ["Гелий", "Водород", "Азот"]),
            ("Какой газ выделяют растения при фотосинтезе?", "Кислород", ["Гелий", "Неон", "Водород"]),
            ("Как называется поваренная соль?", "Хлорид натрия", ["Сахароза", "Кислород", "Железо"]),
            ("Какой символ у кислорода?", "O", ["H", "C", "N"]),
            ("Какой символ у водорода?", "H", ["O", "He", "Na"]),
            ("Какой символ у углерода?", "C", ["Ca", "Cl", "Cu"]),
            ("Какой символ у железа?", "Fe", ["F", "Fr", "I"]),
            ("В каких обычных предметах чаще всего встречается железо?", "В гвоздях, инструментах и стальных деталях", ["В сахаре и соли", "В бумажных салфетках", "В чистой воде"]),
            ("Из какого элемента в основном сделаны стальные гвозди?", "Из железа", ["Из гелия", "Из кислорода", "Из неона"]),
            ("Где в быту можно встретить алюминий?", "В фольге и некоторых банках", ["В деревянной ложке", "В хлопковой ткани", "В стеклянном стакане"]),
            ("Какой металл часто используют в электрических проводах?", "Медь", ["Сера", "Гелий", "Углерод в виде мела"]),
            ("Какой элемент содержится в обычной воде вместе с водородом?", "Кислород", ["Золото", "Железо", "Серебро"]),
            ("Какой газ составляет большую часть воздуха вокруг нас?", "Азот", ["Золото", "Железо", "Натрий"]),
            ("Какой элемент нужен для дыхания и содержится в воздухе?", "Кислород", ["Медь", "Серебро", "Свинец"]),
            ("Какой элемент есть в графите карандаша?", "Углерод", ["Гелий", "Натрий", "Кальций"]),
            ("Какой элемент есть в пищевой поваренной соли вместе с хлором?", "Натрий", ["Золото", "Гелий", "Серебро"]),
            ("Какой элемент содержится в меле и известняке?", "Кальций", ["Неон", "Золото", "Гелий"]),
            ("Какой элемент используют в некоторых батарейках и аккумуляторах?", "Литий", ["Гелий", "Золото", "Бром"]),
            ("Какой элемент есть в стекле и песке в виде соединений?", "Кремний", ["Гелий", "Золото", "Серебро"]),
            ("Какой символ у золота?", "Au", ["Ag", "O", "G"]),
            ("Какой символ у натрия?", "Na", ["N", "Ne", "Ni"]),
            ("Что обозначает CO₂?", "Углекислый газ", ["Вода", "Кислород", "Поваренная соль"]),
            ("Что обозначает O₂?", "Кислород", ["Вода", "Водород", "Углекислый газ"]),
            ("Из чего состоит лёд?", "Из воды", ["Из соли", "Из железа", "Из кислорода"]),
            ("Что происходит с водой при замерзании?", "Она превращается в лёд", ["Она становится солью", "Она превращается в металл", "Она исчезает"]),
            ("Как называется переход льда в жидкую воду?", "Плавление", ["Замерзание", "Горение", "Ржавление"]),
            ("Как называется превращение воды в пар?", "Испарение", ["Замерзание", "Ржавление", "Дробление"]),
            ("Как называется превращение пара в капли воды?", "Конденсация", ["Горение", "Плавление металла", "Растворение"]),
            ("Что обычно растворяется в воде?", "Сахар", ["Песок полностью", "Мелкие камни", "Масло полностью"]),
            ("Что хорошо растворяется в воде?", "Поваренная соль", ["Галька", "Пластик", "Железный гвоздь"]),
            ("Какое вещество придаёт сладкий вкус чаю?", "Сахар", ["Песок", "Мел", "Ржавчина"]),
            ("Как называется смесь соли и воды?", "Раствор", ["Металл", "Газ", "Кристалл льда"]),
            ("Можно ли увидеть чистый кислород без приборов?", "Нет, это бесцветный газ", ["Да, он ярко-синий", "Да, он всегда красный", "Да, он похож на песок"]),
            ("Какой материал притягивается обычным магнитом?", "Железо", ["Дерево", "Стекло", "Бумага"]),
            ("Что появляется на железе при ржавлении?", "Ржавчина", ["Сахар", "Лёд", "Соль"]),
            ("Какой материал обычно проводят электричество лучше?", "Медь", ["Резина", "Сухое дерево", "Пластик"]),
            ("Почему провода часто покрывают пластиком?", "Пластик плохо проводит электричество", ["Пластик превращается в медь", "Пластик притягивает молнии", "Пластик делает ток видимым"]),
            ("Какое состояние вещества имеет лёд?", "Твёрдое", ["Жидкое", "Газообразное", "Плазменное"]),
            ("Какое состояние вещества имеет пар?", "Газообразное", ["Твёрдое", "Жидкое", "Кристаллическое"]),
            ("Какое состояние вещества имеет вода в стакане?", "Жидкое", ["Твёрдое", "Газообразное", "Металлическое"]),
            ("Из чего состоят все вещества?", "Из частиц", ["Из звука", "Из света", "Из пустоты без частиц"]),
            ("Как называется мельчайшая частица химического элемента?", "Атом", ["Капля", "Кристалл соли", "Пузырёк"]),
            ("Как называется группа связанных атомов?", "Молекула", ["Термометр", "Колба", "Мензурка"]),
            ("Какая частица атома имеет отрицательный заряд?", "Электрон", ["Протон", "Нейтрон", "Молекула"]),
            ("Какая частица атома имеет положительный заряд?", "Протон", ["Электрон", "Нейтрон", "Фотон"]),
            ("Какая частица атома не имеет электрического заряда?", "Нейтрон", ["Электрон", "Протон", "Ион"]),
            ("Как называется таблица химических элементов?", "Периодическая таблица", ["Карта погоды", "Таблица умножения", "Карта мира"]),
            ("Что показывает химический символ O?", "Кислород", ["Золото", "Воду", "Соль"]),
            ("Как называется вещество, из которого сделан стеклянный стакан?", "Стекло", ["Бумага", "Хлопок", "Дерево"]),
            ("Из какого материала часто делают оконное стекло?", "Из стекла на основе песка", ["Из сахара", "Из соли", "Из воска"]),
            ("Какой природный материал используют для изготовления бумаги?", "Древесину", ["Железо", "Стекло", "Медь"]),
            ("Какой материал обычно водонепроницаем?", "Пластик", ["Промокательная бумага", "Вата", "Салфетка"]),
            ("Что происходит с сахаром при растворении в чае?", "Он распределяется в воде", ["Он превращается в железо", "Он становится песком", "Он замерзает сразу"]),
            ("Что быстрее растворяет сахар: холодная или тёплая вода?", "Обычно тёплая вода", ["Лёд без воды", "Сухой песок", "Воздух"]),
            ("Как называется вещество, ускоряющее растворение при перемешивании?", "Перемешивание не вещество, а действие", ["Кислород", "Железо", "Гелий"]),
            ("Какой прибор измеряет температуру?", "Термометр", ["Мензурка", "Пипетка", "Весы"]),
            ("Какой прибор помогает измерить массу?", "Весы", ["Термометр", "Пипетка", "Лупа"]),
            ("Для чего нужна мензурка?", "Для измерения объёма жидкости", ["Для измерения времени", "Для взвешивания", "Для резки бумаги"]),
            ("Для чего используют пипетку?", "Чтобы переносить жидкость по каплям", ["Чтобы измерять массу", "Чтобы нагревать металл", "Чтобы резать стекло"]),
            ("Для чего нужна пробирка?", "Для работы с небольшим количеством вещества", ["Для измерения роста", "Для хранения одежды", "Для измерения скорости"]),
            ("Что нужно надеть при работе с химическими опытами в школе?", "Защитные очки по указанию учителя", ["Солнечные очки вместо защиты", "Наушники вместо очков", "Ничего не нужно никогда"]),
            ("Какой химический элемент обозначен символом H?", "Водород", ["Гелий","Азот","Кислород"]),
            ("Какой химический элемент обозначен символом He?", "Гелий", ["Водород","Неон","Аргон"]),
            ("Какой химический элемент обозначен символом Li?", "Литий", ["Натрий","Калий","Магний"]),
            ("Какой химический элемент обозначен символом Be?", "Бериллий", ["Бор","Барий","Бром"]),
            ("Какой химический элемент обозначен символом B?", "Бор", ["Бериллий","Углерод","Фтор"]),
            ("Какой химический элемент обозначен символом C?", "Углерод", ["Кальций","Медь","Хлор"]),
            ("Какой химический элемент обозначен символом N?", "Азот", ["Неон","Натрий","Никель"]),
            ("Какой химический элемент обозначен символом O?", "Кислород", ["Водород","Золото","Углерод"]),
            ("Какой химический элемент обозначен символом F?", "Фтор", ["Железо","Франций","Фосфор"]),
            ("Какой химический элемент обозначен символом Ne?", "Неон", ["Натрий","Никель","Азот"]),
            ("Какой химический элемент обозначен символом Na?", "Натрий", ["Неон","Никель","Магний"]),
            ("Какой химический элемент обозначен символом Mg?", "Магний", ["Марганец","Медь","Натрий"]),
            ("Какой химический элемент обозначен символом Al?", "Алюминий", ["Аргон","Серебро","Золото"]),
            ("Какой химический элемент обозначен символом Si?", "Кремний", ["Сера","Серебро","Кальций"]),
            ("Какой химический элемент обозначен символом P?", "Фосфор", ["Калий","Фтор","Сера"]),
            ("Какой химический элемент обозначен символом S?", "Сера", ["Кремний","Серебро","Стронций"]),
            ("Какой химический элемент обозначен символом Cl?", "Хлор", ["Кальций","Углерод","Кобальт"]),
            ("Какой химический элемент обозначен символом K?", "Калий", ["Кальций","Кобальт","Кремний"]),
            ("Какой химический элемент обозначен символом Ca?", "Кальций", ["Калий","Углерод","Хлор"]),
            ("Какой химический элемент обозначен символом Fe?", "Железо", ["Фтор","Франций","Йод"]),
            ("Какой химический элемент обозначен символом Cu?", "Медь", ["Кальций","Кобальт","Хром"]),
            ("Какой химический элемент обозначен символом Zn?", "Цинк", ["Золото","Цирконий","Олово"]),
            ("Какой химический элемент обозначен символом Ag?", "Серебро", ["Золото","Алюминий","Аргон"]),
            ("Какой химический элемент обозначен символом Au?", "Золото", ["Серебро","Алюминий","Кислород"]),
            ("Какой химический элемент обозначен символом Hg?", "Ртуть", ["Водород","Магний","Гелий"]),
            ("Какой химический элемент обозначен символом Pb?", "Свинец", ["Фосфор","Бор","Калий"]),
            ("Какой химический элемент обозначен символом Sn?", "Олово", ["Сера","Натрий","Неон"]),
            ("Какой химический элемент обозначен символом I?", "Йод", ["Железо","Индий","Иридий"]),
            ("Какой химический элемент обозначен символом Br?", "Бром", ["Бор","Бериллий","Барий"]),
            ("Какой химический элемент обозначен символом Mn?", "Марганец", ["Магний","Медь","Молибден"]),
        ]
        let periodicElements: [(String, String)] = [
            ("H", "Водород"),
            ("He", "Гелий"),
            ("Li", "Литий"),
            ("Be", "Бериллий"),
            ("B", "Бор"),
            ("C", "Углерод"),
            ("N", "Азот"),
            ("O", "Кислород"),
            ("F", "Фтор"),
            ("Ne", "Неон"),
            ("Na", "Натрий"),
            ("Mg", "Магний"),
            ("Al", "Алюминий"),
            ("Si", "Кремний"),
            ("P", "Фосфор"),
            ("S", "Сера"),
            ("Cl", "Хлор"),
            ("Ar", "Аргон"),
            ("K", "Калий"),
            ("Ca", "Кальций"),
            ("Sc", "Скандий"),
            ("Ti", "Титан"),
            ("V", "Ванадий"),
            ("Cr", "Хром"),
            ("Mn", "Марганец"),
            ("Fe", "Железо"),
            ("Co", "Кобальт"),
            ("Ni", "Никель"),
            ("Cu", "Медь"),
            ("Zn", "Цинк"),
            ("Ga", "Галлий"),
            ("Ge", "Германий"),
            ("As", "Мышьяк"),
            ("Se", "Селен"),
            ("Br", "Бром"),
            ("Kr", "Криптон"),
            ("Rb", "Рубидий"),
            ("Sr", "Стронций"),
            ("Y", "Иттрий"),
            ("Zr", "Цирконий"),
            ("Nb", "Ниобий"),
            ("Mo", "Молибден"),
            ("Tc", "Технеций"),
            ("Ru", "Рутений"),
            ("Rh", "Родий"),
            ("Pd", "Палладий"),
            ("Ag", "Серебро"),
            ("Cd", "Кадмий"),
            ("In", "Индий"),
            ("Sn", "Олово"),
            ("Sb", "Сурьма"),
            ("Te", "Теллур"),
            ("I", "Йод"),
            ("Xe", "Ксенон"),
            ("Cs", "Цезий"),
            ("Ba", "Барий"),
            ("La", "Лантан"),
            ("Ce", "Церий"),
            ("Pr", "Празеодим"),
            ("Nd", "Неодим"),
            ("Pm", "Прометий"),
            ("Sm", "Самарий"),
            ("Eu", "Европий"),
            ("Gd", "Гадолиний"),
            ("Tb", "Тербий"),
            ("Dy", "Диспрозий"),
            ("Ho", "Гольмий"),
            ("Er", "Эрбий"),
            ("Tm", "Тулий"),
            ("Yb", "Иттербий"),
            ("Lu", "Лютеций"),
            ("Hf", "Гафний"),
            ("Ta", "Тантал"),
            ("W", "Вольфрам"),
            ("Re", "Рений"),
            ("Os", "Осмий"),
            ("Ir", "Иридий"),
            ("Pt", "Платина"),
            ("Au", "Золото"),
            ("Hg", "Ртуть"),
            ("Tl", "Таллий"),
            ("Pb", "Свинец"),
            ("Bi", "Висмут"),
            ("Po", "Полоний"),
            ("At", "Астат"),
            ("Rn", "Радон"),
            ("Fr", "Франций"),
            ("Ra", "Радий"),
            ("Ac", "Актиний"),
            ("Th", "Торий"),
            ("Pa", "Протактиний"),
            ("U", "Уран"),
            ("Np", "Нептуний"),
            ("Pu", "Плутоний"),
            ("Am", "Америций"),
            ("Cm", "Кюрий"),
            ("Bk", "Берклий"),
            ("Cf", "Калифорний"),
            ("Es", "Эйнштейний"),
            ("Fm", "Фермий"),
            ("Md", "Менделевий"),
            ("No", "Нобелий"),
            ("Lr", "Лоуренсий"),
            ("Rf", "Резерфордий"),
            ("Db", "Дубний"),
            ("Sg", "Сиборгий"),
            ("Bh", "Борий"),
            ("Hs", "Хассий"),
            ("Mt", "Мейтнерий"),
            ("Ds", "Дармштадтий"),
            ("Rg", "Рентгений"),
            ("Cn", "Коперниций"),
            ("Nh", "Нихоний"),
            ("Fl", "Флеровий"),
            ("Mc", "Московий"),
            ("Lv", "Ливерморий"),
            ("Ts", "Теннессин"),
            ("Og", "Оганесон")
        ]
        let framings = [
            "Вопрос по химии: %@",
            "Выбери правильный ответ: %@",
            "Проверь себя. %@",
            "Как правильно ответить? %@",
            "Подумай и ответь: %@",
            "Мини-викторина: %@"
        ]
        var bank: [Problem] = []
        for (question, answer, distractors) in facts {
            let choices = ([answer] + distractors).shuffled()
            for framing in framings {
                bank.append(Problem(text: String(format: framing, question), answer: answer, isTatarChoice: true, tatarChoices: choices))
            }
        }
        // Все 118 элементов доступны в заданиях: символ в вопросе, четыре русских названия в ответах.
        if let element = periodicElements.randomElement(), let index = periodicElements.firstIndex(where: { $0.0 == element.0 }) {
            let distractorIndexes = [(index + 7) % periodicElements.count, (index + 19) % periodicElements.count, (index + 37) % periodicElements.count]
            let choices = ([element.1] + distractorIndexes.map { periodicElements[$0].1 }).shuffled()
            bank.append(Problem(text: "Какой химический элемент обозначен символом \(element.0)?", answer: element.1, isTatarChoice: true, tatarChoices: choices))
        }
        return bank
    }

    private static func choiceProblem(_ item: (String, String, [String])) -> Problem {
        Problem(text: item.0, answer: item.1, isTatarChoice: true, tatarChoices: item.2.shuffled())
    }

    private static func geographyQuestion(level: Int) -> Problem {
        let capitalPairs: [(String, String)] = [("Россия","Москва"),("Германия","Берлин"),("Франция","Париж"),("Италия","Рим"),("Испания","Мадрид"),("Япония","Токио"),("Бразилия","Бразилиа"),("Китай","Пекин"),("Индия","Нью-Дели"),("Польша","Варшава"),("США","Вашингтон"),("Великобритания","Лондон"),("Украина","Киев"),("Нидерланды","Амстердам"),("Австрия","Вена"),("Бельгия","Брюссель"),("Швейцария","Берн"),("Швеция","Стокгольм"),("Норвегия","Осло"),("Дания","Копенгаген"),("Финляндия","Хельсинки"),("Греция","Афины"),("Ирландия","Дублин"),("Мексика","Мехико"),("Аргентина","Буэнос-Айрес"),("Южная Корея","Сеул"),("Турция","Анкара"),("Саудовская Аравия","Эр-Рияд"),("Пакистан","Исламабад"),("Индонезия","Джакарта"),("Вьетнам","Ханой"),("Таиланд","Бангкок"),("Португалия","Лиссабон"),("Чехия","Прага"),("Египет","Каир"),("Канада","Оттава"),("Австралия","Канберра"),("Новая Зеландия","Веллингтон"),("Казахстан","Астана"),("Узбекистан","Ташкент"),("Грузия","Тбилиси"),("Армения","Ереван"),("Азербайджан","Баку"),("Монголия","Улан-Батор"),("Непал","Катманду"),("Шри-Ланка","Шри-Джаяварденепура-Котте"),("Марокко","Рабат"),("Алжир","Алжир"),("Нигерия","Абуджа"),("Кения","Найроби"),("Эфиопия","Аддис-Абеба"),("Чили","Сантьяго"),("Перу","Лима"),("Колумбия","Богота"),("Куба","Гавана"),("Исландия","Рейкьявик"),("Сербия","Белград"),("Хорватия","Загреб"),("Румыния","Бухарест"),("Болгария","София")]
        if Int.random(in: 0..<100) < 50 {
            let pair = capitalPairs.randomElement()!
            let forms = ["Какова столица страны \(pair.0)?", "Какой город является столицей \(pair.0)?", "Назови столицу государства \(pair.0).", "Выбери столицу страны \(pair.0).", "Столица какой страны — город \(pair.1)?", "Как называется главный город страны \(pair.0)?", "Укажи верную столицу государства \(pair.0).", "Какой город — столица \(pair.0)?", "Определи столицу страны \(pair.0).", "В каком городе находится столица \(pair.0)?"]
            let wrong = capitalPairs.map(\.1).filter { $0 != pair.1 }.shuffled().prefix(3)
            let choices = ([pair.1] + Array(wrong)).shuffled()
            let prompt = forms.randomElement()!
            return Problem(text: prompt, answer: pair.1, isTatarChoice: true, tatarChoices: choices)
        }
        let flagCountries = [
            "Россия", "Германия", "Франция", "Италия", "Испания", "Япония", "Бразилия", "Китай", "Индия", "Польша", "США", "Великобритания", "Украина",
            "Нидерланды", "Австрия", "Бельгия", "Швейцария", "Швеция", "Норвегия", "Дания", "Финляндия", "Греция", "Ирландия", "Мексика", "Аргентина", "Южная Корея", "Турция", "Саудовская Аравия", "Пакистан", "Индонезия", "Вьетнам", "Таиланд"
        ]
        if Bool.random() {
            let country = flagCountries.randomElement()!
            let forms = [
                "Какой флаг изображён на карточке?",
                "Укажи страну по изображённому флагу.",
                "Какой стране принадлежит этот флаг?",
                "Определи страну по её государственному флагу.",
                "Флаг какой страны показан?",
                "Выбери название страны, чей флаг ты видишь.",
                "Как называется государство, представленное этим флагом?",
                "Найди правильное название страны по флагу.",
                "Посмотри на изображение флага и назови страну.",
                "Какой стране соответствует этот флаг?",
                "Выбери страну с таким государственным флагом.",
                "Какой флаг ты видишь на рисунке?",
                "Определи государство по цветам и символам флага.",
                "Какое название подходит к изображённому флагу?",
                "К какой стране относится этот флаг?",
                "Какую страну представляет изображённый флаг?",
                "Узнай государство по флагу.",
                "Выбери страну, флаг которой показан.",
                "Какой государственный флаг изображён?",
                "Какая страна обозначена этим флагом?",
                "Определи, чей флаг показан на карточке.",
                "Сопоставь изображение флага с названием страны.",
                "Какое государство использует этот флаг?",
                "Как правильно назвать страну по её флагу?",
                "Какой стране принадлежит флаг на картинке?"
            ]
            let distractors = flagCountries.filter { $0 != country }.shuffled().prefix(3)
            return Problem(text: forms.randomElement()!, answer: country, isTatarChoice: true, tatarChoices: ([country] + Array(distractors)).shuffled())
        }

        let basic: [(String, String, [String])] = [
            ("Как называется страна, в которой находится город Казань?", "Россия", ["Россия", "Италия", "Япония", "Бразилия"]),
            ("Какой город является столицей России?", "Москва", ["Москва", "Казань", "Сочи", "Владивосток"]),
            ("Какой океан самый большой на Земле?", "Тихий океан", ["Тихий океан", "Атлантический океан", "Индийский океан", "Северный Ледовитый океан"]),
            ("Как называется большой участок суши, окружённый водой со всех сторон?", "Остров", ["Остров", "Полуостров", "Река", "Гора"]),
            ("Что такое река?", "Поток воды, который течёт по руслу", ["Поток воды, который течёт по руслу", "Высокая гора", "Участок пустыни", "Часть флага"]),
            ("Как называется очень большая часть суши, например Африка или Австралия?", "Материк", ["Материк", "Островок", "Залив", "Море"]),
            ("Какой город является столицей Франции?", "Париж", ["Париж", "Рим", "Лондон", "Берлин"]),
            ("Как называется большое солёное водное пространство, меньшее океана?", "Море", ["Море", "Озеро всегда", "Река", "Ледник"]),
            ("Какие три цвета расположены на флаге России сверху вниз?", "Белый, синий, красный", ["Белый, синий, красный", "Красный, жёлтый, зелёный", "Синий, жёлтый, чёрный", "Зелёный, белый, оранжевый"]),
            ("На каком материке находится Египет?", "Африка", ["Африка", "Европа", "Австралия", "Антарктида"]),
            ("Какой материк покрыт льдом и находится вокруг Южного полюса?", "Антарктида", ["Антарктида", "Африка", "Евразия", "Южная Америка"]),
            ("Как называется столица Татарстана?", "Казань", ["Казань", "Уфа", "Самара", "Омск"]),
            ("Какая из этих стран находится в Азии?", "Япония", ["Япония", "Португалия", "Норвегия", "Исландия"]),
            ("Какой океан омывает восточное побережье Африки и юг Азии?", "Индийский океан", ["Индийский океан", "Северный Ледовитый океан", "Южный океан", "Тихий океан"]),
            ("Какая река протекает через город Казань?", "Казанка", ["Казанка", "Нева", "Темза", "Сена"]),
            ("Как называется столица Великобритании?", "Лондон", ["Лондон", "Мадрид", "Прага", "Рим"]),
            ("Как называется столица Италии?", "Рим", ["Рим", "Париж", "Афины", "Вена"]),
            ("На каком материке находится Бразилия?", "Южная Америка", ["Южная Америка", "Европа", "Антарктида", "Австралия"]),
            ("Что из этого — океан?", "Атлантический", ["Атлантический", "Каспийское море", "Волга", "Байкал"]),
            ("Какой стране принадлежит показанный флаг?", "Германия", ["Германия", "Франция", "Италия", "Испания"]),
            ("Какой стране принадлежит показанный флаг?", "Франция", ["Франция", "Германия", "Япония", "Бразилия"]),
            ("Какой стране принадлежит показанный флаг?", "Италия", ["Италия", "Испания", "Германия", "Китай"]),
            ("Какой стране принадлежит показанный флаг?", "Испания", ["Испания", "Италия", "Франция", "Россия"]),
            ("Какой стране принадлежит показанный флаг?", "Япония", ["Япония", "Китай", "Индия", "США"]),
            ("Какой стране принадлежит показанный флаг?", "Бразилия", ["Бразилия", "Россия", "Китай", "Германия"]),
            ("Какой стране принадлежит показанный флаг?", "Китай", ["Китай", "Япония", "Италия", "Франция"]),
            ("Какой стране принадлежит показанный флаг?", "Индия", ["Индия", "Ирландия", "Италия", "Испания"]),
            ("Какой стране принадлежит показанный флаг?", "Польша", ["Польша", "Индонезия", "Монако", "Австрия"]),
            ("Какой стране принадлежит показанный флаг?", "США", ["США", "Великобритания", "Канада", "Бразилия"]),
            ("Какой стране принадлежит показанный флаг?", "Великобритания", ["Великобритания", "США", "Франция", "Ирландия"]),
            ("Какой стране принадлежит показанный флаг?", "Украина", ["Украина", "Швеция", "Казахстан", "Россия"])
        ]
        let level2: [(String, String, [String])] = [
            ("Какой материк самый большой?", "Евразия", ["Евразия", "Австралия", "Антарктида", "Южная Америка"]),
            ("Какое море омывает побережье Сочи?", "Чёрное море", ["Чёрное море", "Балтийское море", "Красное море", "Карибское море"]),
            ("В какой стране находится город Токио?", "Япония", ["Япония", "Канада", "Египет", "Испания"]),
            ("Как называется столица Египта?", "Каир", ["Каир", "Афины", "Берн", "Рига"]),
            ("Какой материк расположен к югу от Европы через Средиземное море?", "Африка", ["Африка", "Австралия", "Антарктида", "Северная Америка"])
        ]
        let level3: [(String, String, [String])] = [
            ("Какой океан находится между Европой и Северной Америкой?", "Атлантический океан", ["Атлантический океан", "Индийский океан", "Тихий океан", "Южный океан"]),
            ("Какая река является одной из самых длинных в Европе?", "Волга", ["Волга", "Сена", "Темза", "По"]),
            ("Как называется столица Казахстана?", "Астана", ["Астана", "Ташкент", "Минск", "Баку"]),
            ("Какой остров — самый большой в мире?", "Гренландия", ["Гренландия", "Мадагаскар", "Кипр", "Куба"])
        ]
        let level4: [(String, String, [String])] = [
            ("Какие два материка соединены Панамским перешейком?", "Северная и Южная Америка", ["Северная и Южная Америка", "Европа и Африка", "Азия и Австралия", "Африка и Антарктида"]),
            ("В каком океане находятся Гавайские острова?", "Тихий океан", ["Тихий океан", "Атлантический океан", "Индийский океан", "Северный Ледовитый океан"]),
            ("Какая река протекает через Париж?", "Сена", ["Сена", "Волга", "Нил", "Амазонка"]),
            ("Как называется линия, которая условно делит Землю на Северное и Южное полушария?", "Экватор", ["Экватор", "Меридиан", "Горизонт", "Береговая линия"])
        ]
        let level5: [(String, String, [String])] = [
            ("Какой океан омывает западное побережье Южной Америки?", "Тихий океан", ["Тихий океан", "Индийский океан", "Северный Ледовитый океан", "Южный океан"]),
            ("Какой пролив отделяет Аляску от России?", "Берингов пролив", ["Берингов пролив", "Гибралтарский пролив", "Ла-Манш", "Магелланов пролив"]),
            ("Как называется столица Австралии?", "Канберра", ["Канберра", "Сидней", "Мельбурн", "Перт"]),
            ("Какая река протекает через Лондон?", "Темза", ["Темза", "Сена", "Дунай", "Нил"])
        ]
        let questions: [(String, String, [String])]
        switch min(5, max(1, level)) {
        case 1: questions = basic
        case 2: questions = level2 + basic
        case 3: questions = level3 + level2
        case 4: questions = level4 + level3
        default: questions = level5 + level4
        }
        let item = questions.randomElement()!
        return Problem(text: item.0, answer: item.1, isTatarChoice: true, tatarChoices: item.2.shuffled())
    }

    private static func trafficQuestion(level: Int) -> Problem {
        let basic: [(String, String, [String])] = [
            ("Что означает красный сигнал светофора?", "Стой", ["Стой", "Иди быстрее", "Можно играть", "Переходи дорогу"]),
            ("Что означает зелёный сигнал для пешехода?", "Переход разрешён, если безопасно", ["Переход разрешён, если безопасно", "Нужно бежать не глядя", "Нужно стоять всегда", "Можно играть на дороге"]),
            ("Где безопаснее переходить улицу?", "По пешеходному переходу", ["По пешеходному переходу", "Между припаркованными машинами", "Из-за автобуса", "В любом месте"]),
            ("Как называют полосатую разметку для пешеходов?", "Зебра", ["Зебра", "Остановка", "Разделительная линия", "Тротуар"]),
            ("Где должен идти пешеход, если есть тротуар?", "По тротуару", ["По тротуару", "По середине проезжей части", "По парковке между машинами", "По дороге"]),
            ("Что сделать перед переходом дороги?", "Остановиться и посмотреть по сторонам", ["Остановиться и посмотреть по сторонам", "Закрыть глаза", "Смотреть только в телефон", "Выбежать из-за машины"]),
            ("Как обычно выглядит предупреждающий дорожный знак?", "Треугольник с красной каймой", ["Треугольник с красной каймой", "Зелёный круг", "Фиолетовый квадрат", "Жёлтый овал"]),
            ("Что показывает знак пешеходного перехода?", "Место перехода для пешеходов", ["Место перехода для пешеходов", "Место для купания", "Въезд на парковку", "Игровую площадку"]),
            ("Для чего нужен тротуар?", "Для движения пешеходов", ["Для движения пешеходов", "Для остановки поездов", "Для игры в мяч на дороге", "Для ремонта машин"]),
            ("Как вести себя рядом с дорогой?", "Не играть у проезжей части", ["Не играть у проезжей части", "Кататься между машинами", "Выбегать за мячом", "Толкаться у края дороги"]),
            ("Что помогает быть заметнее в темноте?", "Светоотражатель", ["Светоотражатель", "Тёмная одежда", "Наушники", "Закрытый зонт"]),
            ("Где нужно ждать автобус?", "На остановке", ["На остановке", "На проезжей части", "На разделительной полосе", "Между машинами"]),
            ("Что означает жёлтый сигнал светофора?", "Нужно приготовиться остановиться", ["Нужно приготовиться остановиться", "Можно начинать игру", "Пешеходам можно бежать", "Светофор выключен"]),
            ("Что означает знак «Стоянка запрещена» — синий круг с одной красной диагональю?", "Стоянка запрещена", ["Стоянка запрещена", "Остановка запрещена", "Парковка разрешена", "Лежачий полицейский"]),
            ("Что означает знак «Остановка запрещена» — синий круг с красным крестом?", "Остановка запрещена", ["Остановка запрещена", "Стоянка запрещена", "Парковка разрешена", "Пешеходный переход"]),
            ("Что означает красный круглый знак с белой горизонтальной полосой?", "Въезд запрещён", ["Въезд запрещён", "Движение разрешено", "Парковка разрешена", "Главная дорога"]),
            ("Что обозначает знак с числом 40 в красном круге?", "Ограничение максимальной скорости 40 км/ч", ["Ограничение максимальной скорости 40 км/ч", "Минимальная скорость 40 км/ч", "Расстояние до города 40 км", "Номер автобуса 40"]),
            ("Что предупреждает треугольный знак с изображением неровности?", "Впереди искусственная дорожная неровность", ["Впереди искусственная дорожная неровность", "Стоянка запрещена", "Подземный переход", "Конец автомагистрали"]),
            ("Что означает знак «Главная дорога» — жёлтый ромб в белой кайме?", "У этой дороги преимущество проезда", ["У этой дороги преимущество проезда", "Остановка запрещена", "Въезд запрещён", "Пешеходная зона"]),
            ("Что обозначает знак «Движение пешеходов запрещено»?", "Пешеходам нельзя идти в этом месте", ["Пешеходам нельзя идти в этом месте", "Здесь обязательно перейти дорогу", "Стоянка запрещена", "Здесь находится школа"]),
            ("Что означает знак «Велосипедная дорожка»?", "Дорожка предназначена для велосипедистов", ["Дорожка предназначена для велосипедистов", "Велосипеды запрещены", "Стоянка велосипедов запрещена", "Место для автобусов"]),
            ("Что означает знак «Дети» — треугольник с двумя силуэтами?", "Возможен выход детей на дорогу", ["Возможен выход детей на дорогу", "Движение детей запрещено", "Рядом остановка метро", "Стоянка запрещена"]),
            ("Что означает знак «Железнодорожный переезд»?", "Впереди пересечение дороги с железнодорожными путями", ["Впереди пересечение дороги с железнодорожными путями", "Переход через реку", "Стоянка запрещена", "Начало велосипедной дорожки"]),
            ("Что означает синий знак с белой буквой P?", "Место парковки", ["Место парковки", "Остановка запрещена", "Въезд запрещён", "Лежачий полицейский"]),
            ("Что показывает знак «Обгон запрещён»?", "Обгонять другие транспортные средства нельзя", ["Обгонять другие транспортные средства нельзя", "Обгон разрешён всегда", "Стоянка запрещена", "Только пешеходная зона"]),
            ("Что означает знак «Уступите дорогу» — перевёрнутый треугольник?", "Нужно уступить дорогу другим участникам движения", ["Нужно уступить дорогу другим участникам движения", "Главная дорога начинается здесь", "Въезд запрещён", "Парковка разрешена"]),
            ("Как выглядит знак «Движение запрещено»?", "Белый круг с красной каймой", ["Белый круг с красной каймой", "Синий квадрат с буквой P", "Жёлтый ромб", "Зелёный треугольник"]),
            ("Что означает знак «Поворот направо запрещён»?", "Поворачивать направо нельзя", ["Поворачивать направо нельзя", "Поворот направо обязателен", "Стоянка разрешена", "Пешеходный переход"]),
            ("Что обозначает знак «Скользкая дорога»?", "На дороге возможно скольжение", ["На дороге возможно скольжение", "Дорога всегда сухая", "Стоянка запрещена", "Начало автомагистрали"]),
            ("Что означает знак с изображением детей у школы?", "На дороге могут появиться дети", ["На дороге могут появиться дети", "Стоянка разрешена", "Пешеходам запрещено двигаться везде", "Въезд запрещён"]),
            ("Что обозначает знак «Конец ограничения скорости»?", "Ограничение скорости, указанное ранее, заканчивается", ["Ограничение скорости, указанное ранее, заканчивается", "Начинается стоянка запрещена", "Дорога закрывается", "Скорость всегда равна нулю"]),
            ("На изображении — синий круг с белой стрелкой вверх. Какое действие предписывает знак?", "Двигаться только прямо", ["Двигаться только прямо", "Повернуть направо", "Развернуться в обратную сторону", "Остановиться перед знаком"]),
            ("Что означает знак «Поворот налево запрещён»?", "Поворачивать налево нельзя", ["Поворачивать налево нельзя", "Поворот налево обязателен", "Разрешён только поворот налево", "Главная дорога"]),
            ("Что означает знак «Разворот запрещён»?", "Разворачиваться нельзя", ["Разворачиваться нельзя", "Разворот обязателен", "Разрешена стоянка", "Впереди тоннель"]),
            ("Что предупреждает знак «Крутой спуск»?", "Впереди крутой спуск", ["Впереди крутой спуск", "Впереди подъём на мост", "Дорога заканчивается", "Парковка"]),
            ("Что предупреждает знак «Крутой подъём»?", "Впереди крутой подъём", ["Впереди крутой подъём", "Впереди крутой спуск", "Остановка запрещена", "Пешеходная зона"]),
            ("Что означает знак «Сужение дороги»?", "Проезжая часть впереди становится уже", ["Проезжая часть впереди становится уже", "Дорога расширяется всегда", "Начинается автосервис", "Стоянка разрешена"]),
            ("Что означает знак «Двустороннее движение»?", "Впереди участок с встречным движением", ["Впереди участок с встречным движением", "Движение только в одну сторону", "Велосипедная дорожка", "Тупик"]),
            ("Что означает знак «Дикие животные»?", "На дорогу могут выходить дикие животные", ["На дорогу могут выходить дикие животные", "Въезд в зоопарк", "Кормление животных обязательно", "Движение животных запрещено"]),
            ("Что означает знак «Падение камней»?", "Возможны камнепады", ["Возможны камнепады", "Дорога проходит по пляжу", "Гравий запрещён", "Впереди железнодорожная станция"]),
            ("Что означает знак «Дорожные работы»?", "Впереди ведутся дорожные работы", ["Впереди ведутся дорожные работы", "Впереди автосервис", "Дорога только для строителей", "Стоянка разрешена"]),
            ("Что означает знак «Тоннель»?", "Впереди тоннель", ["Впереди тоннель", "Подземная парковка всегда", "Железнодорожный переезд", "Конец дороги"]),
            ("Что означает знак «Автомагистраль»?", "Начинается дорога, обозначенная как автомагистраль", ["Начинается дорога, обозначенная как автомагистраль", "Дорога только для пешеходов", "Остановка обязательна", "Движение запрещено всем"]),
            ("Что означает знак «Конец автомагистрали»?", "Заканчивается автомагистраль", ["Заканчивается автомагистраль", "Начинается автомагистраль", "Начало жилой зоны", "Пункт первой помощи"]),
            ("Что означает знак «Круговое движение»?", "На перекрёстке организовано круговое движение", ["На перекрёстке организовано круговое движение", "Разворот запрещён", "Впереди тупик", "Стоянка разрешена"]),
            ("Что означает знак «Тупик»?", "Дорога не имеет сквозного проезда", ["Дорога не имеет сквозного проезда", "Впереди тоннель", "Начинается автомагистраль", "Проезд только прямо"]),
            ("Что означает знак «Объезд препятствия справа»?", "Препятствие следует объехать справа", ["Препятствие следует объехать справа", "Объехать препятствие слева", "Остановиться на препятствии", "Разворот запрещён"]),
            ("Что означает знак «Ограничение высоты»?", "Запрещён проезд транспортных средств выше указанной высоты", ["Запрещён проезд транспортных средств выше указанной высоты", "Ограничение ширины", "Минимальная высота водителя", "Конец дороги"]),
            ("Что означает знак «Ограничение ширины»?", "Запрещён проезд транспортных средств шире указанной ширины", ["Запрещён проезд транспортных средств шире указанной ширины", "Ограничение высоты", "Ограничение массы", "Ширина тротуара"])
        ]
        let level2: [(String, String, [String])] = [
            ("Как узнать предупреждающий знак?", "Обычно это треугольник с красной каймой", ["Обычно это треугольник с красной каймой", "Это всегда синий квадрат", "Это всегда зелёный круг", "У всех знаков одинаковая форма"]),
            ("Что означает знак «Пешеходный переход»?", "В этом месте предусмотрен переход дороги", ["В этом месте предусмотрен переход дороги", "Здесь можно играть в мяч", "Здесь начинается велодром", "Здесь останавливаются поезда"]),
            ("Зачем на одежде ребёнка нужен светоотражатель?", "Чтобы водитель раньше заметил пешехода в темноте", ["Чтобы водитель раньше заметил пешехода в темноте", "Чтобы заменить светофор", "Чтобы перейти дорогу не глядя", "Чтобы остановить автомобиль"]),
            ("Что нужно делать на жёлтый сигнал светофора?", "Остановиться и ждать разрешающего сигнала", ["Остановиться и ждать разрешающего сигнала", "Начать бежать", "Играть на переходе", "Поворачивать машины рукой"])
        ]
        let level3: [(String, String, [String])] = [
            ("Что обычно означает круглый знак с красной каймой?", "Запрет или ограничение", ["Запрет или ограничение", "Место отдыха", "Название улицы", "Пешеходная площадка"]),
            ("Что обозначает стоп-линия?", "Место, перед которым транспорт должен остановиться", ["Место, перед которым транспорт должен остановиться", "Начало тротуара", "Место для игры", "Автобусную остановку"]),
            ("Что означает сплошная линия разметки между полосами?", "Её пересечение обычно запрещено", ["Её пересечение обычно запрещено", "Это пешеходная зебра", "Её можно пересекать всегда", "Это место для парковки"]),
            ("Что делать, если припаркованная машина закрывает обзор перед переходом?", "Не выходить из-за неё и найти безопасный обзор", ["Не выходить из-за неё и найти безопасный обзор", "Выбежать не глядя", "Перелезть через капот", "Закрыть глаза"])
        ]
        let level4: [(String, String, [String])] = [
            ("Что означает синий круглый знак со стрелкой?", "Предписывает направление движения", ["Предписывает направление движения", "Запрещает любое движение", "Обозначает аптеку", "Показывает время"]),
            ("Почему нельзя перебегать дорогу перед близко едущей машиной?", "Водителю может не хватить времени остановиться", ["Водителю может не хватить времени остановиться", "Машины останавливаются мгновенно", "Так всегда безопаснее", "Это переключает светофор"]),
            ("Как безопаснее поступить у автобуса, который закрывает дорогу из виду?", "Дождаться безопасного места с хорошим обзором", ["Дождаться безопасного места с хорошим обзором", "Выбежать прямо перед ним", "Перебежать между автобусом и машиной", "Идти, не смотря по сторонам"]),
            ("Что помогает пассажиру защититься в автомобиле?", "Пристёгнутый ремень безопасности", ["Пристёгнутый ремень безопасности", "Стоять между сиденьями", "Высовываться в окно", "Отвлекать водителя"])
        ]
        let level5: [(String, String, [String])] = [
            ("Пешеходный светофор мигает зелёным. Как поступить, если ты ещё не начал переход?", "Остаться на тротуаре и дождаться следующего разрешающего сигнала", ["Остаться на тротуаре и дождаться следующего разрешающего сигнала", "Выбежать на дорогу", "Перейти между машинами", "Смотреть только на телефон"]),
            ("На перекрёстке работает регулировщик. Чьим сигналам нужно следовать?", "Регулировщика", ["Регулировщика", "Только знакомым машинам", "Только пешеходам рядом", "Никому, если нет зебры"]),
            ("Почему опасно идти по дороге в наушниках и смотреть в телефон?", "Можно не заметить сигнал или приближающийся транспорт", ["Можно не заметить сигнал или приближающийся транспорт", "Наушники останавливают машины", "Телефон делает переход безопасным", "Так водители лучше видят пешехода"]),
            ("Что важно проверить перед переходом даже на разрешающий сигнал?", "Что транспорт остановился и переход безопасен", ["Что транспорт остановился и переход безопасен", "Что телефон заряжен", "Что можно идти не глядя", "Что рядом нет тротуара"])
        ]
        let questions: [(String, String, [String])]
        switch min(5, max(1, level)) {
        case 1: questions = basic
        case 2: questions = level2
        case 3: questions = level3
        case 4: questions = level4
        default: questions = level5
        }
        return choiceProblem(questions.randomElement()!)
    }

    private static func orthographyQuestion(level: Int) -> Problem {
        let basic: [(String, String, [String])] = [
            ("Какое слово написано правильно?", "собака", ["сабака", "собака", "сабока", "сабакаа"]),
            ("В каком слове допущена ошибка?", "жыраф", ["жираф", "жыраф", "жераф", "жирап"]),
            ("Какое слово написано правильно?", "машина", ["машына", "машена", "машина", "машынаа"]),
            ("В каком слове допущена ошибка?", "чяйка", ["чайка", "чейка", "чяйка", "чайко"]),
            ("Выбери правильно написанное слово.", "щука", ["щюка", "щука", "шчука", "щюко"]),
            ("В каком слове ошибка?", "жыли", ["жили", "жыли", "жэли", "жылы"]),
            ("Выбери правильно написанное слово.", "класс", ["клас", "класс", "класcа", "классс"]),
            ("Как правильно написать слово?", "деревья", ["деревя", "диревья", "деревья", "деревьяа"]),
            ("Какое слово написано верно?", "медведь", ["медвед", "мидведь", "медведь", "медвядь"]),
            ("В каком слове допущена ошибка?", "малако", ["молоко", "молако", "малоко", "малако"]),
            ("Выбери правильное написание.", "лисица", ["лисица", "лисицца", "лесится", "лысица"]),
            ("Как правильно написать слово?", "солнце", ["сонце", "солнце", "солнцеа", "сольнце"]),
            ("Найди слово с ошибкой.", "карова", ["корова", "карова", "короваа", "кароваа"]),
            ("Выбери правильное написание.", "щенок", ["щенок", "щинок", "щенак", "щинокк"]),
            ("Выбери слово без ошибки.", "чувство", ["чуство", "чувство", "чювство", "чувсство"]),
            ("В каком слове ошибка?", "пажалуйста", ["пожалуйста", "пажалуйста", "пожалуста", "пожалуйсто"]),
            ("Как правильно пишется слово?", "морковь", ["марковь", "морков", "морковь", "моркофь"]),
            ("В каком слове ошибка?", "каньки", ["коньки", "каньки", "конки", "канькы"]),
            ("Вставь пропущенную букву: «Вчера мы гуляли в пар_е».", "к", ["к", "г", "х", "т"]),
            ("Вставь пропущенную букву: «На ветке сидела пт_ца».", "и", ["и", "е", "я", "о"]),
            ("Вставь пропущенную букву: «Утром пошёл сильный до_дь».", "ж", ["ж", "ш", "з", "щ"]),
            ("Какой слог пропущен в слове «ма__на»?", "ши", ["ши", "си", "чы", "жи"]),
            ("Какой слог пропущен в слове «ка__даш»?", "ран", ["ран", "рон", "рань", "рен"]),
            ("Вставь пропущенную букву: «Дети построили сне_ную крепость».", "ж", ["ж", "ш", "з", "с"]),
            ("Вставь пропущенную букву: «Мы увидели краси_ый закат».", "в", ["в", "ф", "т", "п"]),
            ("Какой слог пропущен в слове «бе__за»?", "рё", ["рё", "ря", "ри", "ре"]),
            ("Вставь пропущенную букву: «В саду созрела спелая гру_а».", "ш", ["ш", "ж", "щ", "с"]),
            ("Какой слог пропущен в слове «уче__к»?", "ни", ["ни", "не", "ны", "но"]),
            ("Вставь пропущенную букву в предложении: «По небу плывут обла_а».", "к", ["к", "г", "х", "ч"]),
            ("Какой слог пропущен в слове «коро__»?", "ва", ["ва", "во", "вы", "ве"]),
            ("Вставь пропущенную букву: «На поляне росли ромаш_и».", "к", ["к", "г", "х", "щ"])
        ]
        let level2: [(String, String, [String])] = [
            ("Как правильно написать сочетание?", "жи–ши пиши с И", ["жи–ши пиши с И", "жи–ши пиши с Ы", "жи–ши пиши с Я", "жи–ши пиши с Ю"]),
            ("Выбери проверочное слово: трава — …", "травы", ["травы", "трова", "траво", "трево"]),
            ("В каком слове пишется разделительный мягкий знак?", "воробьи", ["вороби", "воробьи", "воробъй", "варобьи"]),
            ("Какое слово содержит удвоенную согласную?", "группа", ["група", "группа", "групппа", "групаа"]),
            ("В каком предложении есть ошибка?", "Мышы живут в норе.", ["Мыши живут в норе.", "Мышы живут в норе.", "Кошки спят на ковре.", "На лугу растёт трава."])
        ]
        let level3: [(String, String, [String])] = [
            ("Выбери правильное написание приставки.", "подбежать", ["патбежать", "подбежать", "падбежать", "подбежеть"]),
            ("Какое проверочное слово подходит к слову «леса́»?", "лес", ["лес", "лис", "леса", "лёса"]),
            ("В каком предложении есть ошибка?", "На ветке сидит воробъй.", ["На ветке сидит воробей.", "На ветке сидит воробъй.", "На ветке сидит снегирь.", "На ветке сидит синица."]),
            ("Как правильно пишется слово?", "искусство", ["искуство", "искусство", "исскуство", "искусствo"])
        ]
        let level4: [(String, String, [String])] = [
            ("В каком предложении правильно оформлена прямая речь?", "Мама сказала: «Пора домой».", ["Мама сказала: «Пора домой».", "Мама сказала «:Пора домой».", "Мама сказала, «Пора домой».", "Мама: сказала «Пора домой»"]),
            ("В каком предложении правильно поставлена запятая перед «но»?", "Солнце село, но было ещё светло.", ["Солнце село, но было ещё светло.", "Солнце, село но было ещё светло.", "Солнце село но, было ещё светло.", "Солнце село но было, ещё светло."]),
            ("Как правильно написать НЕ с глаголом?", "не знал", ["незнал", "не знал", "ни знал", "не-знал"]),
            ("В каком варианте все слова написаны правильно?", "бережёт, шоссе, лестница", ["бережот, шоссе, лестница", "бережёт, шоссе, лестница", "бережёт, шосэ, лестница", "бережёт, шоссе, лесница"])
        ]
        let level5: [(String, String, [String])] = [
            ("Как правильно написать наречие?", "по-русски", ["по русски", "по-русски", "порусски", "по-русскии"]),
            ("В каком предложении правильно оформлено перечисление?", "На столе лежали книги, тетради и карандаши.", ["На столе лежали книги, тетради и карандаши.", "На столе лежали книги тетради, и карандаши.", "На столе, лежали книги тетради и карандаши.", "На столе лежали книги тетради и, карандаши."]),
            ("Выбери правильную форму слова.", "пять килограммов", ["пять килограмм", "пять килограммов", "пять килограммы", "пять килограмма"]),
            ("В каком предложении правильно написано слово с безударной гласной?", "Собака бежала по дорожке.", ["Сабака бежала по дорожке.", "Собака бежала по дорожке.", "Собака бижала по дорожке.", "Собака бежала по дарожке."])
        ]
        let questions: [(String, String, [String])]
        switch min(5, max(1, level)) {
        case 1: questions = basic
        case 2: questions = level2 + basic
        case 3: questions = level3 + level2
        case 4: questions = level4 + level3
        default: questions = level5 + level4
        }
        let item = questions.randomElement()!
        let prompt = item.0.lowercased()
        let answer = item.1
        let choices: [String]
        if prompt.contains("допущена ошибка") || prompt.contains("слове ошибка") || prompt.contains("слово с ошибкой") || prompt.contains("предложении есть ошибка") {
            // The keyed answer is the only intentionally incorrect word/sentence; all other options are valid.
            let cleanWords = ["собака", "машина", "жираф", "чайка", "щука", "класс", "деревья", "медведь", "лисица", "солнце", "корова", "щенок", "чувство", "пожалуйста", "морковь", "воробей", "искусство", "берёза", "молоко", "праздник", "апельсин", "ученик", "здравствуйте", "лестница", "снеговик", "аккуратно"]
            let validSentences = ["На ветке сидит воробей.", "На столе лежит тетрадь.", "Дети читают интересную книгу.", "За окном светит солнце."]
            let pool = prompt.contains("предложении") ? validSentences : cleanWords
            choices = ([answer] + Array(pool.filter { $0 != answer }.shuffled().prefix(3))).shuffled()
        } else if prompt.contains("правильно") || prompt.contains("верно") || prompt.contains("без ошибки") || prompt.contains("все слова написаны правильно") {
            // For "choose the correct spelling" questions, generate three visibly incorrect variants.
            if answer.contains(" ") && (answer.contains(".") || answer.contains("«") || answer.contains("»") || answer.contains(",") || answer.contains(":")) {
                let wrongSentences = [
                    answer.replacingOccurrences(of: ",", with: ""),
                    answer.replacingOccurrences(of: " ", with: ""),
                    answer.replacingOccurrences(of: ".", with: ","),
                    answer.replacingOccurrences(of: ":", with: ",")
                ].filter { $0 != answer }
                choices = ([answer] + Array(Array(wrongSentences + ["Ошибка: " + answer]).prefix(3))).shuffled()
            } else if answer.count > 3 && !answer.contains(" ") {
                let chars = Array(answer)
                let wrong1 = String(chars.enumerated().map { idx, ch in idx == max(0, chars.count / 2) ? (ch == "а" ? "о" : "а") : ch })
                let wrong2 = String(chars.dropLast()) 
                let wrong3 = String(chars) + String(chars.last ?? "а")
                let variants = [wrong1, wrong2, wrong3].filter { $0 != answer }
                choices = ([answer] + Array((variants + ["*" + answer]).prefix(3))).shuffled()
            } else {
                let variants = item.2.filter { $0 != answer }
                choices = ([answer] + Array(variants.prefix(3))).shuffled()
            }
        } else {
            // Letter/grammar questions retain their authored distractors, but duplicates and answer duplicates are removed.
            let uniqueWrong = Array(Set(item.2).filter { $0 != answer }).shuffled()
            choices = ([answer] + Array(uniqueWrong.prefix(3))).shuffled()
        }
        let uniqueWrongChoices = Array(Set(choices).filter { $0 != answer }.sorted()).prefix(3)
        let finalChoices = ([answer] + Array(uniqueWrongChoices)).shuffled()
        return Problem(text: item.0, answer: answer, isTatarChoice: true, tatarChoices: finalChoices)
    }


    private static func geometryQuestion(level: Int) -> Problem {
        // Геометрия начальной школы: больше визуального распознавания, единицы длины встречаются редко.
        let textBank: [(String, String, [String])] = [
            ("Сколько сторон у треугольника?", "3", ["3", "2", "4", "5"]),
            ("Сколько углов у квадрата?", "4", ["4", "3", "5", "6"]),
            ("Сколько вершин у прямоугольника?", "4", ["4", "2", "3", "6"]),
            ("Какая фигура круглая и не имеет углов?", "Круг", ["Круг", "Квадрат", "Треугольник", "Прямоугольник"]),
            ("Какая фигура имеет три стороны?", "Треугольник", ["Треугольник", "Круг", "Квадрат", "Прямоугольник"]),
            ("Сколько сторон у пятиугольника?", "5", ["5", "3", "4", "6"]),
            ("У квадрата все стороны…", "Равны", ["Равны", "Разной длины", "Только две равны", "Без длины"]),
            ("У какой фигуры четыре прямых угла?", "Прямоугольник", ["Прямоугольник", "Круг", "Треугольник", "Линия"]),
            ("Как называется фигура из нескольких соединённых отрезков?", "Ломаная", ["Ломаная", "Кривая", "Точка", "Луч"]),
            ("Сколько сторон у шестиугольника?", "6", ["6", "5", "4", "8"]),
            ("Периметр квадрата со сторонами по 2 см равен…", "8 см", ["8 см", "4 см", "6 см", "10 см"]),
            ("Периметр прямоугольника со сторонами 3 см и 2 см равен…", "10 см", ["10 см", "5 см", "6 см", "12 см"]),
            ("У треугольника стороны 2 см, 2 см и 3 см. Периметр равен…", "7 см", ["7 см", "5 см", "6 см", "8 см"]),
            ("Периметр квадрата со стороной 3 см равен…", "12 см", ["12 см", "9 см", "6 см", "15 см"]),
            ("Сколько сантиметров в 2 дм?", "20 см", ["20 см", "2 см", "12 см", "200 см"]),
            ("Что короче: отрезок 3 см или отрезок 5 см?", "3 см", ["3 см", "5 см", "Одинаковые", "Нельзя узнать"])
        ]
        // У визуальных заданий нет текстового условия: только рисунок и четыре варианта ответа.
        let illustrated: [(String, [String])] = [
            ("Квадрат", ["Квадрат", "Круг", "Треугольник", "Прямоугольник"]),
            ("Треугольник", ["Треугольник", "Квадрат", "Круг", "Трапеция"]),
            ("Прямоугольник", ["Прямоугольник", "Квадрат", "Ромб", "Круг"]),
            ("Трапеция", ["Трапеция", "Треугольник", "Квадрат", "Овал"]),
            ("Круг", ["Круг", "Овал", "Квадрат", "Треугольник"]),
            ("Овал", ["Овал", "Круг", "Ромб", "Трапеция"]),
            ("Прямая", ["Прямая", "Луч", "Отрезок", "Кривая"]),
            ("Луч", ["Луч", "Прямая", "Отрезок", "Точка"]),
            ("Отрезок", ["Отрезок", "Прямая", "Луч", "Кривая"]),
            ("Точка", ["Точка", "Отрезок", "Прямая", "Угол"]),
            ("Кривая", ["Кривая", "Пунктирная линия", "Прямая", "Отрезок"]),
            ("Пунктирная линия", ["Пунктирная линия", "Прямая", "Кривая", "Луч"]),
            ("Ломаная", ["Ломаная", "Кривая", "Прямая", "Точка"]),
            ("Перпендикулярные прямые", ["Перпендикулярные прямые", "Параллельные прямые", "Кривая", "Луч"]),
            ("Параллельные прямые", ["Параллельные прямые", "Перпендикулярные прямые", "Отрезок", "Кривая"]),
            ("Угол", ["Угол", "Круг", "Точка", "Овал"]),
            ("Прямой угол", ["Прямой угол", "Острый угол", "Тупой угол", "Круг"]),
            ("Острый угол", ["Острый угол", "Прямой угол", "Тупой угол", "Отрезок"]),
            ("Тупой угол", ["Тупой угол", "Острый угол", "Прямой угол", "Прямая"]),
            ("Ромб", ["Ромб", "Квадрат", "Трапеция", "Овал"]),
            ("Параллелограмм", ["Параллелограмм", "Трапеция", "Круг", "Треугольник"]),
            ("Пятиугольник", ["Пятиугольник", "Шестиугольник", "Треугольник", "Квадрат"]),
            ("Шестиугольник", ["Шестиугольник", "Пятиугольник", "Круг", "Трапеция"]),
            ("Призма", ["Призма", "Куб", "Конус", "Цилиндр"]),
            ("Цилиндр", ["Цилиндр", "Куб", "Конус", "Шар"]),
            ("Куб", ["Куб", "Цилиндр", "Шар", "Конус"]),
            ("Конус", ["Конус", "Цилиндр", "Куб", "Шар"]),
            ("Шар", ["Шар", "Куб", "Цилиндр", "Конус"]),
            ("Пирамида", ["Пирамида", "Призма", "Цилиндр", "Шар"])
        ]
        // Примерно 3 из 4 заданий — визуальные; правильный ответ принудительно входит в варианты.
        if Int.random(in: 0..<4) != 0 {
            let item = illustrated.randomElement()!
            let wrong = Array(Set(item.1).filter { $0 != item.0 }).shuffled()
            let choices = ([item.0] + Array(wrong.prefix(3))).shuffled()
            return Problem(text: "", answer: item.0, isTatarChoice: true, tatarChoices: choices, showIllustration: true)
        }
        let item = textBank.randomElement()!
        return Problem(text: item.0, answer: item.1, isTatarChoice: true, tatarChoices: item.2.shuffled(), showIllustration: false)
    }

    private static func languageOrWorldQuestion(for subject: StudySubject) -> Problem? {
        let bank: [(String, String, [String])]
        switch subject {
        case .english:
            bank = [
                ("Выбери правильную форму глагола to be: I ___ happy.", "am", ["am", "is", "are", "be"]),
                ("Вставь правильную форму: She ___ my sister.", "is", ["am", "is", "are", "be"]),
                ("Вставь правильную форму: They ___ at school.", "are", ["am", "is", "are", "be"]),
                ("Вставь правильную форму: We ___ friends.", "are", ["am", "is", "are", "be"]),
                ("Выбери правильное предложение.", "He is seven.", ["He is seven.", "He are seven.", "He am seven.", "He be seven."]),
                ("В каком слове есть сочетание «ee»?", "tree", ["tree", "cat", "dog", "sun"]),
                ("В каком слове есть сочетание «oo»?", "book", ["book", "pen", "bag", "bed"]),
                ("В каком слове есть сочетание «ai»?", "rain", ["rain", "red", "run", "fox"]),
                ("В каком слове есть сочетание «oa»?", "boat", ["boat", "bird", "fish", "cup"]),
                ("Какое слово начинается со звука /sh/?", "ship", ["ship", "cat", "dog", "pen"]),
                ("Какое слово начинается со звука /ch/?", "chair", ["chair", "table", "book", "door"]),
                ("Какое слово начинается со звука /th/?", "three", ["three", "tree", "free", "see"]),
                ("Как переводится на русский слово “pillow”? ", "подушка", ["подушка", "стол", "окно", "дверь"]),
                ("Как переводится на русский слово “mirror”? ", "зеркало", ["зеркало", "кровать", "полка", "лампа"]),
                ("Как переводится на русский слово “fridge”? ", "холодильник", ["холодильник", "диван", "ковёр", "стул"]),
                ("Как переводится на русский слово “sidewalk”? ", "тротуар", ["тротуар", "крыша", "потолок", "стена"]),
                ("Как переводится на русский слово “crosswalk”? ", "пешеходный переход", ["пешеходный переход", "остановка", "магазин", "парк"]),
                ("Как переводится на русский “traffic light”? ", "светофор", ["светофор", "автобус", "велосипед", "фонарь"]),
                ("Как переводится на русский “blackboard”? ", "школьная доска", ["школьная доска", "пенал", "ранец", "линейка"]),
                ("Как переводится на русский “ruler”? ", "линейка", ["линейка", "тетрадь", "мел", "клей"]),
                ("Выбери слово, обозначающее действие (глагол).", "jump", ["jump", "blue", "chair", "quiet"]),
                ("Выбери слово, обозначающее действие (глагол).", "write", ["write", "window", "green", "school"]),
                ("Что означает английское слово “carry”? ", "нести", ["нести", "спать", "петь", "рисовать"]),
                ("Что означает английское слово “listen”? ", "слушать", ["слушать", "бежать", "прыгать", "открывать"]),
                ("Что означает английское слово “draw”? ", "рисовать", ["рисовать", "читать", "пить", "сидеть"])
            ]
        case .tatar:
            bank = [
                ("Как по-татарски «мама»?", "Әни", ["Әни", "Әти", "Әби", "Бабай"]),
                ("Как по-татарски «папа»?", "Әти", ["Әни", "Әти", "Апа", "Абый"]),
                ("Как по-татарски «бабушка»?", "Әби", ["Әби", "Бабай", "Әни", "Апа"]),
                ("Как по-татарски «дедушка»?", "Бабай", ["Бабай", "Әби", "Әти", "Абый"]),
                ("Как по-татарски «семья»?", "Гаилә", ["Гаилә", "Мәктәп", "Дус", "Китап"]),
                ("Как по-татарски «друг»?", "Дус", ["Дус", "Дошман", "Укытучы", "Бала"]),
                ("Как по-татарски «книга»?", "Китап", ["Китап", "Дәфтәр", "Каләм", "Өстәл"]),
                ("Как по-татарски «тетрадь»?", "Дәфтәр", ["Дәфтәр", "Китап", "Ишек", "Тәрәзә"]),
                ("Как по-татарски «ручка»?", "Каләм", ["Каләм", "Урындык", "Китап", "Мәктәп"]),
                ("Как по-татарски «школа»?", "Мәктәп", ["Мәктәп", "Кибет", "Өй", "Урам"]),
                ("Как по-татарски «вода»?", "Су", ["Су", "Сөт", "Чәй", "Икмәк"]),
                ("Как по-татарски «молоко»?", "Сөт", ["Сөт", "Су", "Алма", "Икмәк"]),
                ("Как по-татарски «хлеб»?", "Икмәк", ["Икмәк", "Сөт", "Су", "Китап"]),
                ("Как по-татарски «яблоко»?", "Алма", ["Алма", "Балык", "Кош", "Өй"]),
                ("Как по-татарски «кошка»?", "Мәче", ["Мәче", "Эт", "Ат", "Кош"]),
                ("Как по-татарски «собака»?", "Эт", ["Эт", "Мәче", "Куян", "Балык"]),
                ("Как по-татарски «рыба»?", "Балык", ["Балык", "Кош", "Ат", "Мәче"]),
                ("Как по-татарски «птица»?", "Кош", ["Кош", "Балык", "Эт", "Сыер"]),
                ("Что означает татарское «хәерле иртә»?", "Доброе утро", ["Доброе утро", "Спокойной ночи", "До свидания", "Спасибо"]),
                ("Что означает татарское «рәхмәт»?", "Спасибо", ["Спасибо", "Пожалуйста", "Привет", "Извините"]),
                ("Что означает татарское «сау бул»?", "До свидания", ["До свидания", "Доброе утро", "Спокойной ночи", "Добро пожаловать"]),
                ("Что означает татарское «мин сине яратам»?", "Я тебя люблю", ["Я тебя люблю", "Я тебя знаю", "Я читаю книгу", "Я иду домой"]),
                ("Что означает татарское «хәерле төн»?", "Спокойной ночи", ["Спокойной ночи", "Доброе утро", "Добрый день", "До свидания"]),
                ("Что означает татарское «зинһар»?", "Пожалуйста", ["Пожалуйста", "Спасибо", "Привет", "Пока"]),
                ("Что означает татарское «минем исемем…»?", "Меня зовут…", ["Меня зовут…", "Как дела?", "До свидания", "Я дома"]),
                ("Что означает татарское «ничек хәлләр?»?", "Как дела?", ["Как дела?", "Как тебя зовут?", "Где школа?", "Сколько лет?"]),
                ("Как по-русски «Мин мәктәпкә барам»?", "Я иду в школу", ["Я иду в школу", "Я читаю книгу", "Я играю дома", "Я пью воду"]),
                ("Как по-русски «Мин китап укыйм»?", "Я читаю книгу", ["Я читаю книгу", "Я пишу письмо", "Я иду домой", "Я играю в мяч"]),
                ("Как по-русски «Минем әнием бар»?", "У меня есть мама", ["У меня есть мама", "Я люблю школу", "Мой папа дома", "У меня есть книга"]),
                ("Как по-русски «Зур рәхмәт»?", "Большое спасибо", ["Большое спасибо", "Доброе утро", "До скорой встречи", "Спокойной ночи"]),
                ("Как по-русски «Мин өйдә»?", "Я дома", ["Я дома", "Я в школе", "Я на улице", "Я в магазине"])
            ]
        case .world:
            bank = [
                ("Как называется природное явление, при котором гремит гром и сверкает молния?", "Гроза", ["Гроза", "Роса", "Туман", "Радуга"]),
                ("Как называется вода, падающая из облаков в виде капель?", "Дождь", ["Дождь", "Иней", "Роса", "Снег"]),
                ("Почему появляется радуга?", "Свет преломляется и отражается в каплях воды", ["Свет преломляется и отражается в каплях воды", "Из-за дыма", "Из-за мороза", "Из-за ветра"]),
                ("Как называется тонкий слой льда на ветках?", "Иней", ["Иней", "Туман", "Роса", "Пар"]),
                ("Какая птица остаётся зимовать в Татарстане?", "Синица", ["Синица", "Ласточка", "Стриж", "Аист"]),
                ("Зачем птицы строят гнёзда?", "Чтобы откладывать яйца и растить птенцов", ["Чтобы откладывать яйца и растить птенцов", "Чтобы выращивать цветы", "Чтобы хранить воду", "Чтобы прятать корни"]),
                ("Чем покрыто тело большинства птиц?", "Перьями", ["Перьями", "Шерстью", "Чешуёй", "Панцирем"]),
                ("Что нужно семени для прорастания?", "Вода, воздух и подходящая температура", ["Вода, воздух и подходящая температура", "Только песок", "Только темнота", "Только сахар"]),
                ("Как растения получают энергию для образования питательных веществ?", "Используют энергию солнечного света", ["Используют энергию солнечного света", "Питаются камнями", "Пьют молоко", "Получают пищу из воздуха без света"]),
                ("Для чего корням нужна почва?", "Чтобы закрепляться и получать воду с минеральными веществами", ["Чтобы закрепляться и получать воду с минеральными веществами", "Чтобы ловить насекомых у всех растений", "Чтобы создавать семена без цветков", "Чтобы поглощать солнечный свет вместо листьев"]),
                ("Какую функцию выполняет ствол дерева?", "Поддерживает крону и проводит воду и вещества", ["Поддерживает крону и проводит воду и вещества", "Поглощает пищу ртом", "Производит перья", "Помогает плавать"]),
                ("Почему осенью листья многих деревьев меняют цвет?", "Меняется количество зелёного пигмента в листьях", ["Меняется количество зелёного пигмента в листьях", "Дерево становится неживым", "Листья превращаются в цветы", "Солнце меняет цвет"]),
                ("Чем дышит рыба в воде?", "Жабрами", ["Жабрами", "Лёгкими как человек", "Плавниками", "Хвостом"]),
                ("Как рыбы обычно передвигаются в воде?", "Плавают с помощью плавников и движений тела", ["Плавают с помощью плавников и движений тела", "Летают крыльями", "Ходят на лапах", "Прыгают на корнях"]),
                ("Что помогает водным растениям получать свет?", "Расположение листьев в освещённой воде", ["Расположение листьев в освещённой воде", "Корни в полной темноте всегда", "Панцирь", "Перья"]),
                ("Что такое круговорот воды в природе?", "Переход воды между поверхностью, воздухом и осадками", ["Переход воды между поверхностью, воздухом и осадками", "Рост дерева из камня", "Перелёт птиц", "Движение рыб по реке"])
            ]
        default: return nil
        }
        guard let item = bank.randomElement() else { return nil }
        return Problem(text: item.0, answer: item.1, isTatarChoice: true, tatarChoices: item.2.shuffled())
    }

    fileprivate static func nextAdvancedQuestion(for subject: StudySubject, level: Int) -> Problem? {
        let bank: [(String, String, [String])]
        switch subject {
        case .math: return nil
        case .pdd: return trafficQuestion(level: level)
        case .orthography: return orthographyQuestion(level: level)
        case .geography: return geographyQuestion(level: level)
        case .geometry: return geometryQuestion(level: level)
        case .logic:
            bank = [("Продолжи ряд: 2, 4, 6, 8, …", "10", ["10", "9", "12", "14"]), ("Что лишнее: круг, квадрат, треугольник, яблоко?", "Яблоко", ["Яблоко", "Круг", "Квадрат", "Треугольник"]), ("У Маши 3 яблока, у Пети на 2 больше. Сколько у Пети?", "5", ["5", "1", "6", "8"]), ("Продолжи ряд: 1, 3, 5, 7, …", "9", ["9", "8", "10", "11"]), ("Если сегодня среда, какой день будет через 2 дня?", "Пятница", ["Пятница", "Четверг", "Суббота", "Воскресенье"]), ("Какой фигуры не хватает: круг, квадрат, круг, квадрат, …?", "Круг", ["Круг", "Треугольник", "Звезда", "Прямоугольник"]), ("У ряда фигур число углов увеличивается: 3, 4, 5, … Сколько углов у следующей?", "6", ["6", "5", "7", "8"]), ("На столе 4 красных и 2 синих кубика. Сколько всего кубиков?", "6", ["6", "5", "7", "8"]), ("Что тяжелее: килограмм ваты или килограмм железа?", "Одинаково", ["Одинаково", "Вата", "Железо", "Нельзя сравнить"]) ]
        case .biology:
            bank = [("Какой орган перекачивает кровь?", "Сердце", ["Сердце", "Лёгкие", "Желудок", "Мозг"]), ("Что нужно растениям для фотосинтеза?", "Свет", ["Свет", "Песок", "Пластик", "Темнота"]), ("Чем дышит рыба в воде?", "Жабрами", ["Жабрами", "Лёгкими", "Кожей головы", "Плавниками"]), ("Какая часть растения поглощает воду из почвы?", "Корень", ["Корень", "Цветок", "Плод", "Лист"]), ("К какой группе относится бабочка?", "Насекомые", ["Насекомые", "Птицы", "Млекопитающие", "Рыбы"]), ("Какая часть цветка превращается в плод?", "Завязь", ["Завязь", "Корень", "Лист", "Стебель"]), ("Какое животное проходит стадии гусеницы и куколки?", "Бабочка", ["Бабочка", "Кошка", "Воробей", "Карась"]), ("Как называется зелёный пигмент листьев?", "Хлорофилл", ["Хлорофилл", "Гемоглобин", "Крахмал", "Кальций"]), ("Какой орган помогает человеку думать?", "Мозг", ["Мозг", "Желудок", "Почка", "Лёгкое"]) ]
        case .world:
            switch level {
            case 2:
                bank = [("Какой орган перекачивает кровь?", "Сердце", ["Сердце", "Лёгкие", "Желудок", "Кожа"]), ("Что нужно семени для прорастания?", "Вода и тепло", ["Вода и тепло", "Только музыка", "Краска", "Сахар"]), ("Какое животное — млекопитающее?", "Дельфин", ["Дельфин", "Карась", "Бабочка", "Лягушка"])]
            case 3:
                bank = [("Как называется превращение воды в пар?", "Испарение", ["Испарение", "Замерзание", "Таяние", "Оседание"]), ("Как называется детёныш лягушки?", "Головастик", ["Головастик", "Цыплёнок", "Жеребёнок", "Теленок"]), ("Какую часть растения чаще всего посещают пчёлы ради нектара?", "Цветок", ["Цветок", "Корень", "Кора", "Сухой лист"])]
            case 4:
                bank = [("Почему растениям нужен свет?", "Для образования питательных веществ", ["Для образования питательных веществ", "Чтобы слышать", "Чтобы двигаться", "Чтобы менять породу"]), ("Как называется движение Земли вокруг Солнца?", "Обращение", ["Обращение", "Испарение", "Отражение", "Плавление"]), ("Что используют для отделения нерастворимых частиц от воды?", "Фильтр", ["Фильтр", "Термометр", "Линейка", "Компас"])]
            default:
                bank = [("Какое утверждение о пищевой цепи верно?", "Энергия передаётся от одного организма к другому", ["Энергия передаётся от одного организма к другому", "Все животные питаются камнями", "Растения не нуждаются в свете", "Цепь начинается с автомобиля"]), ("Почему важно сохранять разнообразие видов?", "Организмы связаны и поддерживают устойчивость природы", ["Организмы связаны и поддерживают устойчивость природы", "Чтобы исчезли все насекомые", "Чтобы не было растений", "Чтобы реки высыхали"]), ("Как называется регулярная смена дня и ночи?", "Вращение Земли вокруг оси", ["Вращение Земли вокруг оси", "Движение Луны вокруг Земли", "Испарение воды", "Движение облаков"])]
            }
        case .russian:
            switch level {
            case 2:
                bank = [("Какой глагол отвечает на вопрос «что делать?»", "читать", ["читать", "писать", "играть", "говорить"]), ("Какое слово является антонимом к слову «широкий»?", "узкий", ["узкий", "длинный", "высокий", "сильный"]), ("Какое имя собственное написано правильно?", "Казань", ["Казань", "город", "река", "улица"])]
            case 3:
                bank = [("Какое слово является именем прилагательным?", "весёлый", ["весёлый", "бежать", "радость", "быстро"]), ("Выбери существительное женского рода.", "тетрадь", ["тетрадь", "словарь", "карандаш", "портфель"]), ("Какое слово состоит из приставки и корня?", "прилетел", ["прилетел", "лес", "синий", "домик"])]
            case 4:
                bank = [("Какое слово — наречие?", "весело", ["весело", "весёлый", "веселье", "веселиться"]), ("Выбери предложение с однородными членами.", "На столе лежали книги, ручки и карандаши.", ["На столе лежали книги, ручки и карандаши.", "Утром взошло солнце.", "Ветер стих.", "Дети пришли домой."]), ("Какое слово образовано приставочным способом?", "переход", ["переход", "лесной", "берёзка", "столик"])]
            default:
                bank = [("В каком предложении есть обращение?", "Маша, помоги мне, пожалуйста.", ["Маша, помоги мне, пожалуйста.", "Маша помогла мне вчера.", "Я встретил Машу.", "Маша читает книгу."]), ("Какое слово образовано приставочным способом?", "переписать", ["переписать", "лесной", "берёзка", "столик"]), ("Какой знак ставят в конце вопросительного предложения?", "Вопросительный знак", ["Вопросительный знак", "Дефис", "Запятая всегда", "Точка с запятой всегда"])]
            }
        case .english:
            switch min(level, 5) {
            case 2: bank = [("Выбери форму множественного числа слова “book”.", "books", ["books", "bookes", "bookies", "book"]), ("Вставь правильную форму: I ___ a student.", "am", ["am", "is", "are", "be"])]
            case 3: bank = [("Выбери правильное предложение.", "She likes cats.", ["She likes cats.", "She like cats.", "She liking cats.", "She liked cats every day now."]), ("Выбери форму прошедшего времени глагола “play”.", "played", ["played", "playd", "plays", "playing"])]
            case 4: bank = [("Вставь правильную форму: There ___ two apples.", "are", ["are", "is", "am", "be"]), ("Выбери форму прошедшего времени глагола “go”.", "went", ["went", "goed", "goes", "going"])]
            default: bank = [("Выбери правильное предложение.", "Yesterday we went to school.", ["Yesterday we went to school.", "Yesterday we go to school.", "Yesterday we goes to school.", "Yesterday we going school."]), ("Вставь правильную форму: They ___ playing now.", "are", ["are", "is", "am", "be"])]
            }
        case .tatar:
            switch level {
            case 2:
                bank = [("Как переводится татарское слово «дуслык»?", "Дружба", ["Дружба", "Погода", "Карандаш", "Дорога"]), ("Как по-татарски «семья»?", "Гаилә", ["Гаилә", "Китап", "Яңгыр", "Өстәл"])]
            case 3:
                bank = [("Что значит татарское «Сау бул»?", "До свидания", ["До свидания", "Доброе утро", "Пожалуйста", "Спокойной ночи"]), ("Как по-татарски «спасибо»?", "Рәхмәт", ["Рәхмәт", "Исәнме", "Кояш", "Мәче"])]
            case 4:
                bank = [("Как переводится «Туган көн»?", "День рождения", ["День рождения", "Хороший день", "Новая книга", "Зимняя ночь"]), ("Как по-татарски «я читаю»?", "Мин укыйм", ["Мин укыйм", "Мин йөгерәм", "Мин уйлыйм", "Мин йоклыйм"])]
            default:
                bank = [("Что означает «Мин сине яратам»?", "Я тебя люблю", ["Я тебя люблю", "Я читаю книгу", "Я иду домой", "Я играю в мяч"]), ("Как по-татарски «добро пожаловать»?", "Рәхим итегез", ["Рәхим итегез", "Сау бул", "Кич утырып", "Рәхмәт"])]
            }
        case .art:
            switch level {
            case 2:
                bank = [("Что такое композиция рисунка?", "Расположение объектов на листе", ["Расположение объектов на листе", "Только выбор карандаша", "Название кисти", "Размер альбома"]), ("Какие цвета получатся из красного и синего?", "Фиолетовые оттенки", ["Фиолетовые оттенки", "Только зелёные", "Только жёлтые", "Белые"])]
            case 3:
                bank = [("Что такое контраст?", "Заметное различие цветов или светлоты", ["Заметное различие цветов или светлоты", "Одинаковость всех цветов", "Название карандаша", "Сгиб бумаги"]), ("Для чего нужна перспектива?", "Показывать глубину пространства", ["Показывать глубину пространства", "Смешивать краски", "Стирать линии", "Скреплять бумагу"])]
            case 4:
                bank = [("Что такое фактура?", "Характер поверхности предмета", ["Характер поверхности предмета", "Размер холста", "Название художника", "Тип рамки"]), ("Как можно выделить главный объект плаката?", "Контрастом, размером и расположением", ["Контрастом, размером и расположением", "Бледным текстом на бледном фоне", "Скрыть заголовок", "Сделать все детали одинаковыми"])]
            default:
                bank = [("Что такое цветовой круг?", "Схема взаимосвязи оттенков", ["Схема взаимосвязи оттенков", "Линейка", "Список художников", "Бумажный шаблон"]), ("Как называется рисунок, выполненный точками?", "Пуантилизм", ["Пуантилизм", "Оригами", "Коллаж", "Витраж"])]
            }
        case .chemistry:
            return chemistryQuestionBank().randomElement() ?? Problem(text: "Как называется формула воды?", answer: "H₂O", isTatarChoice: true, tatarChoices: ["H₂O", "CO₂", "O₂", "NaCl"])
        case .informatics:
            switch level {
            case 2:
                bank = [("Что такое папка на компьютере?", "Место для группировки файлов", ["Место для группировки файлов", "Кнопка питания", "Вид кабеля", "Звуковая волна"]), ("Какой пароль надёжнее?", "Длинный и непредсказуемый", ["Длинный и непредсказуемый", "12345", "Имя и дата рождения", "Слово «пароль»"])]
            case 3:
                bank = [("Для чего нужна резервная копия?", "Чтобы восстановить данные при потере оригинала", ["Чтобы восстановить данные при потере оригинала", "Чтобы сделать экран ярче", "Чтобы заменить клавиатуру", "Чтобы ускорить набор букв"]), ("Что делает цикл в алгоритме?", "Повторяет команды", ["Повторяет команды", "Удаляет монитор", "Меняет цвет кабеля", "Выключает интернет всегда"])]
            case 4:
                bank = [("Что делает условие в алгоритме?", "Позволяет выбрать действие по результату проверки", ["Позволяет выбрать действие по результату проверки", "Показывает только картинку", "Удаляет все файлы", "Выключает мышь"]), ("Какое расширение часто бывает у изображения?", ".png", [".png", ".mp3", ".exe", ".txt"])]
            default:
                bank = [("Что такое переменная в программе?", "Именованное место для хранения значения", ["Именованное место для хранения значения", "Физическая кнопка мыши", "Тип принтера", "Картинка на рабочем столе"]), ("Как лучше поступить с подозрительным вложением в письме?", "Не открывать и проверить отправителя со взрослым", ["Не открывать и проверить отправителя со взрослым", "Сразу запустить", "Отправить пароль автору", "Отключить защиту"])]
            }
        }
        return choiceProblem(bank.randomElement()!)
    }

    fileprivate static func nextInformatics(excluding seen: Set<String>) -> Problem {
        let unseen = informaticsQuestionBank.filter { !seen.contains($0.text) }
        return unseen.randomElement() ?? informaticsQuestionBank.randomElement()!
    }

    fileprivate static func next(for subject: StudySubject, difficulty: Int = 1) -> Problem {
        if let question = languageOrWorldQuestion(for: subject) { return question }
        if subject == .logic { return logicQuestion(level: difficulty) }
        if subject == .biology { return biologyQuestion(level: difficulty, illustrated: false) }
        if subject == .geometry { return geometryQuestion(level: difficulty) }
        if subject == .chemistry { return chemistryQuestionBank().randomElement() ?? Problem(text: "Как называется формула воды?", answer: "H₂O", isTatarChoice: true, tatarChoices: ["H₂O", "CO₂", "O₂", "NaCl"]) }
        if subject == .math { return next(difficulty: difficulty) }
        if difficulty > 1 && Int.random(in: 0...99) < 70,
           let advanced = nextAdvancedQuestion(for: subject, level: difficulty) { return advanced }
        if subject == .pdd { return trafficQuestion(level: 1) }
        if subject == .orthography { return orthographyQuestion(level: 1) }
        if subject == .geography { return geographyQuestion(level: 1) }
        let questions: [(String, String)]
        switch subject {
        case .math:
            return next(difficulty: difficulty)
        case .pdd:
            return trafficQuestion(level: 1)
        case .orthography:
            return orthographyQuestion(level: 1)
        case .geography:
            return geographyQuestion(level: 1)
        case .geometry:
            return geometryQuestion(level: difficulty)
        case .logic, .biology:
            let bank: [(String, String, [String])]
            if subject == .logic {
                bank = [("Продолжи ряд: 3, 6, 9, 12, …", "15", ["15", "14", "16", "18"]), ("Что лишнее: кошка, собака, воробей, стол?", "Стол", ["Стол", "Кошка", "Собака", "Воробей"]), ("У трёх братьев по одной сестре. Сколько всего детей?", "4", ["4", "3", "6", "7"]), ("Продолжи ряд: 10, 8, 6, 4, …", "2", ["2", "0", "3", "1"])]
            } else {
                bank = [("Какой орган помогает человеку дышать?", "Лёгкие", ["Лёгкие", "Сердце", "Печень", "Желудок"]), ("Что является живым организмом?", "Гриб", ["Гриб", "Камень", "Стекло", "Вода"]), ("Как называется детёныш лягушки?", "Головастик", ["Головастик", "Цыплёнок", "Щенок", "Теленок"]), ("Что переносит пыльцу между цветками?", "Насекомые", ["Насекомые", "Рыбы", "Камни", "Облака"])]
            }
            let item = bank.randomElement()!
            return Problem(text: item.0, answer: item.1, isTatarChoice: true, tatarChoices: item.2.shuffled())
        case .informatics:
            return informaticsQuestionBank.randomElement() ?? Problem(
                text: "Какое устройство помогает напечатать текст?",
                answer: "Клавиатура",
                isTatarChoice: true,
                tatarChoices: ["Клавиатура", "Монитор", "Колонки", "Принтер"]
            )
        case .world:
            let facts: [(String, String, [String])] = [
                ("Какое животное даёт молоко?", "Корова", ["Корова", "Лиса", "Воробей", "Лягушка"]),
                ("Что нужно растениям для роста?", "Свет", ["Свет", "Телевизор", "Игрушки", "Песни"]),
                ("Какое время года наступает после весны?", "Лето", ["Лето", "Зима", "Осень", "Снова весна"]),
                ("Что помогает человеку дышать?", "Лёгкие", ["Лёгкие", "Желудок", "Колено", "Локоть"]),
                ("Какая часть растения находится под землёй?", "Корень", ["Корень", "Цветок", "Лист", "Плод"]),
                ("Кто живёт в воде?", "Рыба", ["Рыба", "Кошка", "Курица", "Белка"]),
                ("Как называется дом пчёл?", "Улей", ["Улей", "Берлога", "Нора", "Гнездо"]),
                ("Что из этого — птица?", "Синица", ["Синица", "Карась", "Котёнок", "Бабочка"]),
                ("Что бывает зимой?", "Снег", ["Снег", "Жара", "Листопад", "Гроздья винограда"]),
                ("Какой орган помогает видеть?", "Глаза", ["Глаза", "Уши", "Нос", "Язык"]),
                ("Что нужно надеть в дождь?", "Дождевик", ["Дождевик", "Солнцезащитные очки", "Купальник", "Шапку для сауны"]),
                ("Какое животное впадает зимой в спячку?", "Медведь", ["Медведь", "Корова", "Лошадь", "Курица"]),
                ("Что из этого относится к овощам?", "Морковь", ["Морковь", "Яблоко", "Клубника", "Груша"]),
                ("Как называется замёрзшая вода?", "Лёд", ["Лёд", "Пар", "Песок", "Дым"]),
                ("Где восходит Солнце?", "На востоке", ["На востоке", "На западе", "На севере", "На юге"]),
                ("Что помогает ориентироваться днём в ясную погоду?", "Солнце", ["Солнце", "Фонарик в кармане", "Свеча", "Луна"]),
                ("Какое животное называют лучшим другом человека?", "Собака", ["Собака", "Волк", "Лось", "Ёж"]),
                ("Какой транспорт едет по рельсам?", "Поезд", ["Поезд", "Самокат", "Самолёт", "Лодка"]),
                ("Что нужно делать перед едой?", "Мыть руки", ["Мыть руки", "Надевать варежки", "Поливать цветы", "Чистить обувь"]),
                ("Какой месяц обычно бывает первым в году?", "Январь", ["Январь", "Май", "Август", "Октябрь"]),
                ("Что из этого — домашнее животное?", "Кошка", ["Кошка", "Тигр", "Лиса", "Волк"]),
                ("Как называется детёныш лошади?", "Жеребёнок", ["Жеребёнок", "Телёнок", "Щенок", "Котёнок"]),
                ("Какой предмет помогает измерить температуру?", "Термометр", ["Термометр", "Линейка", "Компас", "Лупа"]),
                ("Что делает пчела?", "Собирает нектар", ["Собирает нектар", "Ловит мышей", "Плетёт паутину", "Строит плотину"])
            ]
            let fact = facts.randomElement()!
            return Problem(text: fact.0, answer: fact.1, isTatarChoice: true, tatarChoices: fact.2.shuffled())
        case .russian:
            let words: [(String,String,String)] = [("интересный","увлекательный","скучный"),("смелый","храбрый","трусливый"),("быстрый","скорый","медленный"),("красивый","прекрасный","уродливый"),("радость","веселье","печаль"),("большой","огромный","маленький"),("говорить","разговаривать","молчать"),("холодный","студёный","горячий"),("умный","разумный","глупый"),("начало","старт","конец"),("свет","сияние","тьма"),("друг","товарищ","враг"),("труд","работа","отдых"),("добрый","отзывчивый","злой"),("дом","жилище","улица"),("лес","бор","пустыня"),("весёлый","радостный","грустный"),("сильный","мощный","слабый"),("тихий","спокойный","громкий"),("чистый","опрятный","грязный")]
            let item = words.randomElement()!
            switch Int.random(in: 0...25) {
            case 0: questions = [("Подбери синоним к слову «\(item.0)»", item.1)]
            case 1: questions = [("Подбери антоним к слову «\(item.0)»", item.2)]
            case 2: questions = [("Сколько букв в слове «\(item.0)»?", String(item.0.count))]
            case 3: questions = [("Напиши слово «\(item.0)» наоборот", String(item.0.reversed()))]
            case 4: questions = [("Сколько гласных в слове «\(item.0)»?", String(item.0.lowercased().filter { "аеёиоуыэюя".contains($0) }.count))]
            case 5: questions = [("Сколько согласных в слове «\(item.0)»?", String(item.0.lowercased().filter { "бвгджзйклмнпрстфхцчшщ".contains($0) }.count))]
            case 6: questions = [("Какой первый звук в слове «\(item.0)»?", String(item.0.lowercased().prefix(1)))]
            case 7:
                let lastLetter = item.0.lowercased().last.map(String.init) ?? ""
                let finalSoundMap = ["б":"п", "в":"ф", "г":"к", "д":"т", "ж":"ш", "з":"с"]
                let finalSound = finalSoundMap[lastLetter] ?? lastLetter
                questions = [("Какой последний звук в слове «\(item.0)»?", finalSound)]
            case 8: questions = [("Какой падеж у выделенного слова: «Я вижу кота» (вижу кого?)", "Винительный")]
            case 9: questions = [("Выбери глагол — слово, которое обозначает действие", "бежать")]
            case 10: questions = [("Найди подлежащее в предложении «Птицы поют»", "Птицы")]
            case 11: questions = [("Найди сказуемое в предложении «Дети играют»", "играют")]
            case 12: questions = [("Как называются слова, близкие по значению?", "Синонимы")]
            case 13: questions = [("Как называются слова с противоположным значением?", "Антонимы")]
            case 14: questions = [("В каком значении употреблено слово «ключ» в предложении «Из земли бил холодный ключ»?", "Родник")]
            case 15: questions = [("В каком значении употреблено слово «ключ» в предложении «Папа открыл дверь ключом»?", "Предмет для замка")]
            case 16: questions = [("Какое это предложение: «Сегодня мы читаем книгу.»", "Повествовательное")]
            case 17: questions = [("Какое это предложение: «Когда начнётся спектакль?»", "Вопросительное")]
            case 18: questions = [("Какое это предложение: «Пожалуйста, закрой окно.»", "Побудительное")]
            case 19: questions = [("Какое это предложение: «На улице идёт дождь.»", "Невосклицательное")]
            case 20: questions = [("Какое это предложение: «Как красиво вокруг!»", "Восклицательное")]
            case 21: questions = [("Какое слово обычно имеет одно лексическое значение: «берёза» или «ключ»?", "Берёза")]
            case 22: questions = [("Какое слово многозначное: «лук» или «тетрадь»?", "Лук")]
            case 23: questions = [("Какое это предложение: «На небе появились звёзды.»", "Распространённое")]
            case 24: questions = [("Какое это предложение: «Птицы поют.»", "Нераспространённое")]
            case 25: questions = [("Как называется раздел языка, который изучает значения слов и словарный состав?", "Лексика")]
            default: questions = [("Подбери синоним к слову «\(item.0)»", item.1)]
            }
            let question = questions.randomElement() ?? ("Попробуй ещё раз", "")
            let russianChoices: [String]
            func uniqueChoices(_ values: [String]) -> [String] {
                var seen = Set<String>()
                return values.filter { seen.insert($0).inserted }
            }
            if question.0.contains("синоним") {
                russianChoices = [question.1, "Антоним", "Омоним", "Предлог"]
            } else if question.0.contains("антоним") {
                russianChoices = [question.1, "Синоним", "Омоним", "Существительное"]
            } else if question.0.contains("Сколько букв") || question.0.contains("Сколько гласных") || question.0.contains("Сколько согласных") {
                let correct = Int(question.1) ?? 0
                russianChoices = [String(correct), String(max(0, correct - 1)), String(correct + 1), String(correct + 2)]
            } else if question.0.contains("наоборот") {
                let reversedDistractors = ["молоко", "машина", "собака", "берёза", "карандаш", "тетрадь"].map { String($0.reversed()) }
                russianChoices = Array(uniqueChoices([question.1] + reversedDistractors.filter { $0 != question.1 }).prefix(4))
            } else if question.0.contains("первый звук") {
                let soundPool = ["а", "о", "м", "с", "к", "т", "р", "п", "л", "н"]
                russianChoices = uniqueChoices([question.1] + soundPool.filter { $0 != question.1 }.shuffled()).prefix(4).map { $0 }
            } else if question.0.contains("последний звук") {
                let soundPool = ["п", "ф", "к", "т", "ш", "с", "м", "н", "р", "л"]
                russianChoices = uniqueChoices([question.1] + soundPool.filter { $0 != question.1 }.shuffled()).prefix(4).map { $0 }
            } else if question.0.contains("падеж") {
                russianChoices = ["Именительный", "Родительный", "Дательный", "Винительный"]
            } else if question.0.contains("глагол") {
                russianChoices = ["бежать", "красивый", "стол", "быстро"]
            } else if question.0.contains("подлежащее") {
                russianChoices = ["Птицы", "поют", "красиво", "быстро"]
            } else if question.0.contains("сказуемое") {
                russianChoices = ["играют", "Дети", "весёлые", "школа"]
            } else if question.0.contains("слова с противоположным") {
                russianChoices = ["Антонимы", "Синонимы", "Омонимы", "Предлоги"]
            } else if question.0.contains("слова, близкие") {
                russianChoices = ["Синонимы", "Антонимы", "Омонимы", "Предлоги"]
            } else if question.0.contains("Из земли бил холодный ключ") {
                russianChoices = ["Родник", "Предмет для замка", "Музыкальный знак", "Птица"]
            } else if question.0.contains("дверь ключом") {
                russianChoices = ["Предмет для замка", "Родник", "Музыкальный знак", "Растение"]
            } else if question.0.contains("Сегодня мы читаем") {
                russianChoices = ["Повествовательное", "Вопросительное", "Побудительное", "Назывное"]
            } else if question.0.contains("Когда начнётся") {
                russianChoices = ["Вопросительное", "Повествовательное", "Побудительное", "Назывное"]
            } else if question.0.contains("Пожалуйста, закрой окно") {
                russianChoices = ["Повествовательное", "Вопросительное", "Побудительное", "Назывное"]
            } else if question.0.contains("На улице идёт дождь") {
                russianChoices = ["Невосклицательное", "Восклицательное", "Вопросительное", "Побудительное"]
            } else if question.0.contains("Как красиво вокруг") {
                russianChoices = ["Восклицательное", "Невосклицательное", "Вопросительное", "Повествовательное"]
            } else if question.0.contains("одно лексическое значение") {
                russianChoices = ["Берёза", "Ключ", "Лук", "Коса"]
            } else if question.0.contains("многозначное") {
                russianChoices = ["Лук", "Тетрадь", "Берёза", "Карандаш"]
            } else if question.0.contains("На небе появились звёзды") {
                russianChoices = ["Распространённое", "Нераспространённое", "Вопросительное", "Побудительное"]
            } else if question.0.contains("Птицы поют") {
                russianChoices = ["Нераспространённое", "Распространённое", "Восклицательное", "Вопросительное"]
            } else if question.0.contains("раздел языка") {
                russianChoices = ["Лексика", "Фонетика", "Морфология", "Синтаксис"]
            } else {
                russianChoices = uniqueChoices([question.1, item.2, item.0, "слово"]).prefix(4).map { $0 }
            }
            var finalRussianChoices = uniqueChoices([question.1] + russianChoices.filter { $0 != question.1 })
            let russianFallbacks = ["молоко", "машина", "собака", "берёза", "карандаш", "тетрадь", "яблоко", "дорога", "город", "река", "облако", "звезда"]
            for fallback in russianFallbacks where !finalRussianChoices.contains(fallback) {
                finalRussianChoices.append(fallback)
                if finalRussianChoices.count == 4 { break }
            }
            if question.0.contains("наоборот") && finalRussianChoices.count < 4 {
                for word in ["молоко", "машина", "собака", "берёза", "карандаш"] {
                    let reversed = String(word.reversed())
                    if !finalRussianChoices.contains(reversed) { finalRussianChoices.append(reversed) }
                    if finalRussianChoices.count == 4 { break }
                }
            }
            return Problem(text: "\(["Задание:", "Проверь себя:", "Подумай:", "Вопрос:"].randomElement()!) \(question.0)", answer: question.1, isTatarChoice: true, tatarChoices: Array(finalRussianChoices.prefix(4)).shuffled())
        case .english:
            let words: [(String,String)] = [("cat","кот"),("dog","собака"),("sun","солнце"),("book","книга"),("apple","яблоко"),("water","вода"),("house","дом"),("school","школа"),("friend","друг"),("family","семья"),("mother","мама"),("father","папа"),("sister","сестра"),("brother","брат"),("bird","птица"),("fish","рыба"),("tree","дерево"),("flower","цветок"),("green","зелёный"),("blue","синий"),("red","красный"),("yellow","жёлтый"),("black","чёрный"),("white","белый"),("one","один"),("two","два"),("three","три"),("four","четыре"),("five","пять"),("happy","счастливый"),("small","маленький"),("big","большой"),("fast","быстрый"),("slow","медленный"),("bread","хлеб"),("milk","молоко"),("chair","стул"),("table","стол"),("window","окно"),("door","дверь"),("morning","утро"),("night","ночь"),("hello","привет"),("please","пожалуйста"),("pencil","карандаш"),("rain","дождь"),("snow","снег"),("star","звезда"),("orange","апельсин"),("cheese","сыр")]
            let item = words.randomElement()!
            let reverse = Int.random(in: 0...1) == 1
            let correct = reverse ? item.0 : item.1
            let distractors = words.map { reverse ? $0.0 : $0.1 }.filter { $0 != correct }.shuffled().prefix(3)
            let choices = ([correct] + Array(distractors)).shuffled()
            let prompt = reverse ? "Как по-английски «\(item.1)»?" : "Что значит английское слово «\(item.0)»?"
            return Problem(text: prompt, answer: correct, isTatarChoice: true, tatarChoices: choices)
        case .chemistry:
            // На первом уровне темы также разделены: либо символы/формулы, либо посуда.
            if Bool.random() {
                let equipment: [(String, String, [String])] = [
                    ("Как называется стеклянный сосуд с узким горлышком для реакций?", "Колба", ["Колба", "Чашка Петри", "Ступка", "Пипетка"]),
                    ("В чём измеряют объём жидкости в лаборатории?", "Мензурка", ["Мензурка", "Чашка Петри", "Шпатель", "Щипцы"]),
                    ("Для чего используют чашку Петри?", "Для выращивания культур и наблюдений", ["Для выращивания культур и наблюдений", "Для измерения массы", "Для нагрева металла", "Для перемешивания газа"]),
                    ("Какой инструмент переносит жидкость по каплям?", "Пипетка", ["Пипетка", "Стеклянная палочка", "Штатив", "Чашка Петри"])
                ]
                let item = equipment.randomElement()!
                return Problem(text: item.0, answer: item.1, isTatarChoice: true, tatarChoices: item.2.shuffled())
            }
            let elements: [(String, String, Int)] = [
                ("H", "Водород", 1), ("He", "Гелий", 2), ("Li", "Литий", 3), ("Be", "Бериллий", 4), ("B", "Бор", 5), ("C", "Углерод", 6), ("N", "Азот", 7), ("O", "Кислород", 8), ("F", "Фтор", 9), ("Ne", "Неон", 10),
                ("Na", "Натрий", 11), ("Mg", "Магний", 12), ("Al", "Алюминий", 13), ("Si", "Кремний", 14), ("P", "Фосфор", 15), ("S", "Сера", 16), ("Cl", "Хлор", 17), ("Ar", "Аргон", 18), ("K", "Калий", 19), ("Ca", "Кальций", 20),
                ("Fe", "Железо", 26), ("Cu", "Медь", 29), ("Zn", "Цинк", 30), ("Ag", "Серебро", 47), ("Sn", "Олово", 50), ("I", "Йод", 53), ("Au", "Золото", 79), ("Hg", "Ртуть", 80), ("Pb", "Свинец", 82), ("U", "Уран", 92),
                ("Cr", "Хром", 24), ("Mn", "Марганец", 25), ("Co", "Кобальт", 27), ("Ni", "Никель", 28), ("Br", "Бром", 35), ("Ba", "Барий", 56), ("Pt", "Платина", 78), ("W", "Вольфрам", 74), ("Ne", "Неон", 10), ("Se", "Селен", 34)
            ]
            let element = elements.randomElement()!
            let askForName = Bool.random()
            let correct = askForName ? element.1 : element.0
            let prompt = askForName
                ? "Как называется элемент с символом \(element.0)?"
                : "Какой символ у элемента «\(element.1)»?"
            let pool = askForName ? elements.map { $0.1 } : elements.map { $0.0 }
            let choices = ([correct] + Array(pool.filter { $0 != correct }.shuffled().prefix(3))).shuffled()
            return Problem(text: prompt, answer: correct, isTatarChoice: true, tatarChoices: choices)
        case .tatar:
            let words: [(String,String)] = [("Әни","мама"),("Әти","папа"),("Исәнме","здравствуй"),("Рәхмәт","спасибо"),("Су","вода"),("Икмәк","хлеб"),("Өй","дом"),("Мәктәп","школа"),("Дус","друг"),("Китап","книга"),("Алма","яблоко"),("Кояш","солнце"),("Ай","луна"),("Йолдыз","звезда"),("Эт","собака"),("Мәче","кошка"),("Ат","лошадь"),("Кош","птица"),("Балык","рыба"),("Агач","дерево"),("Чәчәк","цветок"),("Яшел","зелёный"),("Зәңгәр","синий"),("Кызыл","красный"),("Ак","белый"),("Кара","чёрный"),("Бер","один"),("Ике","два"),("Өч","три"),("Дүрт","четыре"),("Биш","пять"),("Алты","шесть"),("Җиде","семь"),("Сигез","восемь"),("Тугыз","девять"),("Ун","десять"),("Яхшы","хорошо"),("Матур","красивый"),("Зур","большой"),("Кечкенә","маленький"),("Сәлам","привет"),("Сау бул","до свидания"),("Яңгыр","дождь"),("Кар","снег"),("Көн","день"),("Төн","ночь"),("Сөт","молоко"),("Дуслык","дружба"),("Гаилә","семья"),("Бәхет","счастье")]
            let item = words.randomElement()!
            let reverse = Int.random(in: 0...1) == 1
            let correct = reverse ? item.0 : item.1
            let distractors = words.map { reverse ? $0.0 : $0.1 }.filter { $0 != correct }.shuffled().prefix(3)
            let choices = ([correct] + Array(distractors)).shuffled()
            let prompt = reverse ? "Как по-татарски «\(item.1)»?" : "Что значит татарское слово «\(item.0)»?"
            return Problem(text: prompt, answer: correct, isTatarChoice: true, tatarChoices: choices)
        case .art:
            // Разнообразные задания по цветам, материалам, жанрам, техникам и композиции.
            // Ответы — только текст, четыре варианта отображаются общей сеткой языковых заданий.
            let artQuestions: [(String, String, [String])] = [
                ("Какой цвет получится, если смешать жёлтую и синюю краски?", "Зелёный", ["Зелёный", "Оранжевый", "Фиолетовый", "Розовый"]),
                ("Какой цвет получится из красной и жёлтой красок?", "Оранжевый", ["Оранжевый", "Зелёный", "Синий", "Серый"]),
                ("Что получится при смешивании синей и красной красок?", "Фиолетовый", ["Фиолетовый", "Жёлтый", "Оранжевый", "Коричневый"]),
                ("Какой цвет обычно получают, смешивая белый и чёрный?", "Серый", ["Серый", "Зелёный", "Розовый", "Голубой"]),
                ("Какая группа состоит из основных цветов в традиционной живописи?", "Красный, жёлтый и синий", ["Красный, жёлтый и синий", "Зелёный, оранжевый и фиолетовый", "Чёрный, белый и серый", "Розовый, коричневый и голубой"]),
                ("Как называют цвета красного, оранжевого и жёлтого оттенков?", "Тёплые", ["Тёплые", "Холодные", "Прозрачные", "Бесцветные"]),
                ("Синий, голубой и сине-зелёный — это обычно какие цвета?", "Холодные", ["Холодные", "Тёплые", "Основные формы", "Нейтральные линии"]),
                ("Как называется изображение человека?", "Портрет", ["Портрет", "Пейзаж", "Натюрморт", "Орнамент"]),
                ("Как называется картина с лесом, рекой или горами?", "Пейзаж", ["Пейзаж", "Портрет", "Натюрморт", "Комикс"]),
                ("Как называется работа с вазой, фруктами или цветами на столе?", "Натюрморт", ["Натюрморт", "Портрет", "Пейзаж", "Архитектурный план"]),
                ("Как называется портрет, который художник рисует самого себя?", "Автопортрет", ["Автопортрет", "Натюрморт", "Мозаика", "Иллюстрация"]),
                ("Как называется рисунок, который сопровождает текст в книге?", "Иллюстрация", ["Иллюстрация", "Орнамент", "Эскиз здания", "Натюрморт"]),
                ("В каком виде искусства история рассказывается кадрами и репликами в облачках?", "Комикс", ["Комикс", "Пейзаж", "Натюрморт", "Витраж"]),
                ("Как называется смешной портрет с намеренно преувеличенными чертами лица?", "Карикатура", ["Карикатура", "Пейзаж", "Мозаика", "Натюрморт"]),
                ("Как называют повторяющийся декоративный узор из линий и фигур?", "Орнамент", ["Орнамент", "Портрет", "Натюрморт", "Автопортрет"]),
                ("Как называется изображение, собранное из маленьких кусочков стекла, камня или плитки?", "Мозаика", ["Мозаика", "Оригами", "Акварель", "Набросок"]),
                ("Как называется картинка из вырезанных и наклеенных на основу деталей?", "Аппликация", ["Аппликация", "Скульптура", "Пейзаж", "Гравюра"]),
                ("Как называется искусство складывания фигурок из бумаги?", "Оригами", ["Оригами", "Мозаика", "Коллаж", "Витраж"]),
                ("Как называют изображение, составленное из кусочков фотографий, бумаги и разных материалов?", "Коллаж", ["Коллаж", "Натюрморт", "Портрет", "Эскиз"]),
                ("Как называется объёмная фигура, которую можно рассматривать со всех сторон?", "Скульптура", ["Скульптура", "Плакат", "Иллюстрация", "Орнамент"]),
                ("Как называется изображение, сделанное цветными стёклами?", "Витраж", ["Витраж", "Акварель", "Коллаж", "Аппликация"]),
                ("Как называется быстрый предварительный рисунок будущей работы?", "Эскиз", ["Эскиз", "Мозаика", "Витраж", "Натюрморт"]),
                ("Как называется большой лист с изображением и коротким сообщением для зрителей?", "Плакат", ["Плакат", "Автопортрет", "Натюрморт", "Орнамент"]),
                ("Как называется простой условный рисунок-значок, который передаёт сообщение?", "Пиктограмма", ["Пиктограмма", "Пейзаж", "Фреска", "Шарж"]),
                ("Какой инструмент помогает провести ровную прямую линию?", "Линейка", ["Линейка", "Губка", "Палитра", "Ластик"]),
                ("Чем обычно стирают ненужную линию простого карандаша?", "Ластиком", ["Ластиком", "Кистью", "Ножницами", "Палитрой"]),
                ("Для чего художнику нужна палитра?", "Смешивать краски", ["Смешивать краски", "Резать бумагу", "Стирать карандаш", "Скреплять листы"]),
                ("Какой инструмент обычно используют, чтобы наносить акварель на бумагу?", "Кисть", ["Кисть", "Линейка", "Циркуль", "Ножницы"]),
                ("Какая краска обычно прозрачная и позволяет видеть бумагу сквозь цвет?", "Акварель", ["Акварель", "Гуашь", "Пластилин", "Уголь"]),
                ("Какая краска чаще всего плотная и хорошо закрывает предыдущий слой?", "Гуашь", ["Гуашь", "Акварель", "Вода", "Графит"]),
                ("Какой материал подходит для лепки небольшой фигурки?", "Пластилин", ["Пластилин", "Акварель", "Мелкая наждачная бумага", "Линейка"]),
                ("Чем лучше вырезать бумажные детали для аппликации?", "Ножницами", ["Ножницами", "Кистью", "Палитрой", "Ластиком"]),
                ("Какой материал помогает приклеить бумажные детали к листу?", "Клей", ["Клей", "Графит", "Уголь", "Акварель"]),
                ("Как называют самую дальнюю часть изображённого пространства?", "Задний план", ["Задний план", "Передний план", "Контур", "Орнамент"]),
                ("Как называют часть композиции, которая изображена ближе всего к зрителю?", "Передний план", ["Передний план", "Задний план", "Горизонт", "Фон листа"]),
                ("Как называется линия, которая отделяет землю или море от неба на пейзаже?", "Линия горизонта", ["Линия горизонта", "Линия сгиба", "Контур лица", "Ось симметрии"]),
                ("Как называют расположение предметов и частей изображения на листе?", "Композиция", ["Композиция", "Палитра", "Текстура", "Трафарет"]),
                ("Как называется свойство предмета, которое мы можем представить как гладкое, шероховатое или пушистое?", "Фактура", ["Фактура", "Горизонт", "Автопортрет", "Эскиз"]),
                ("Как называется совпадение двух половин рисунка относительно центральной линии?", "Симметрия", ["Симметрия", "Контраст", "Перспектива", "Мозаика"]),
                ("Как называют заметное различие между светлым и тёмным или между разными цветами?", "Контраст", ["Контраст", "Эскиз", "Орнамент", "Аппликация"]),
                ("Как называется линия, которая показывает внешнюю границу формы предмета?", "Контур", ["Контур", "Палитра", "Пейзаж", "Тон"]),
                ("Как можно показать тень на рисунке карандашом?", "Штриховкой", ["Штриховкой", "Складыванием бумаги", "Наклеиванием ткани", "Смешиванием воды"]),
                ("Какой материал оставляет мягкий чёрный след и подходит для выразительных набросков?", "Художественный уголь", ["Художественный уголь", "Прозрачная акварельная вода", "Клей-карандаш", "Линейка"]),
                ("Что лучше сделать перед тем, как раскрашивать сложный рисунок?", "Наметить лёгкий эскиз", ["Наметить лёгкий эскиз", "Сразу закрасить весь лист чёрным", "Смять бумагу", "Отрезать уголки листа"]),
                ("Какой приём помогает показать, что один предмет находится ближе, а другой дальше?", "Изменять размер и расположение предметов", ["Изменять размер и расположение предметов", "Рисовать все предметы одинаково", "Убирать линию горизонта всегда", "Использовать только один цвет"]),
                ("Как называется рисунок, в котором главное — здания и их формы?", "Архитектурный рисунок", ["Архитектурный рисунок", "Натюрморт", "Автопортрет", "Орнамент"]),
                ("Как называют сочетание нескольких оттенков одного цвета, например светло-синего и тёмно-синего?", "Цветовая гамма", ["Цветовая гамма", "Силуэт", "Комикс", "Аппликация"]),
                ("Как называется сплошная тёмная форма предмета без мелких деталей внутри?", "Силуэт", ["Силуэт", "Натюрморт", "Палитра", "Пейзаж"]),
                ("Что важно проверить, если рисунок должен быть хорошо виден издалека на плакате?", "Крупные формы и понятное сообщение", ["Крупные формы и понятное сообщение", "Как можно больше мелких деталей", "Очень бледные буквы", "Только тонкие линии"]),
                ("Как называется вид искусства, где красками украшают стены зданий?", "Настенная роспись", ["Настенная роспись", "Оригами", "Коллаж", "Гравировка"]),
                ("Какой способ подойдёт, чтобы повторять одну и ту же форму много раз?", "Использовать трафарет", ["Использовать трафарет", "Смочить лист целиком", "Стереть контур", "Сложить работу пополам"]),
                ("Какой цвет лучше выбрать для заметного предупреждающего знака?", "Яркий контрастный цвет", ["Яркий контрастный цвет", "Почти незаметный бледный цвет", "Только белый на белом", "Цвет, совпадающий с фоном"]),
                ("Как называется рисунок, который изображает только природный пейзаж моря?", "Морской пейзаж", ["Морской пейзаж", "Портрет", "Натюрморт", "Шарж"]),
                ("Что художник обычно делает в первую очередь при планировании большой работы?", "Продумывает идею и композицию", ["Продумывает идею и композицию", "Сразу выбрасывает эскиз", "Закрашивает все детали одним цветом", "Рисует подпись вместо изображения"]),
                ("Как называется техника, в которой цветные бумажные кусочки складывают в изображение?", "Бумажная мозаика", ["Бумажная мозаика", "Акварельная заливка", "Штриховка", "Автопортрет"])
            ]
            let item = artQuestions.randomElement()!
            return Problem(text: item.0, answer: item.1, isTatarChoice: true, tatarChoices: item.2.shuffled())
        }
        let question = questions.randomElement() ?? ("Попробуй ещё раз", "")
        let prefixes = ["Задание:", "Проверь себя:", "Подумай:", "Вопрос:", "Мини-вызов:", "Попробуй решить:", "Вспомни и ответь:", "Тренировка:", "Пора подумать:", "Небольшая задача:"]
        return Problem(text: "\(prefixes.randomElement()!) \(question.0)", answer: question.1)
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

private struct SubjectPerformance: Codable {
    var correct = 0
    var incorrect = 0
    var total: Int { correct + incorrect }
    var accuracy: Int { total == 0 ? 0 : Int((Double(correct) / Double(total) * 100).rounded()) }
}

private struct TopicPerformance: Codable {
    var correct = 0
    var incorrect = 0
    var total: Int { correct + incorrect }
    var accuracy: Int { total == 0 ? 0 : Int((Double(correct) / Double(total) * 100).rounded()) }
}

private struct MistakeRecord: Codable, Identifiable {
    let id: String
    let subject: String
    let question: String
    let selectedAnswer: String
    let correctAnswer: String
    let choices: [String]
    let explanation: String
    let date: String
}

private struct LifeSkillsReviewRecord: Codable, Identifiable {
    let id: String
    let prompt: String
    let answer: String
    let explanation: String
    let symbol: String
    let selectedAnswer: String
    let choices: [String]?
}

private struct ReviewAttemptRecord: Codable, Identifiable {
    let id: String
    let itemID: String
    let prompt: String
    let selectedAnswer: String
    let correctAnswer: String
    let isCorrect: Bool
    let date: String
}

private struct UnifiedReviewItem: Identifiable {
    let id: String
    let section: String
    let prompt: String
    let answer: String
    let choices: [String]
    let explanation: String
    let symbol: String
}

private struct ActivityQuestion: Identifiable {
    let id = UUID()
    let prompt: String
    let answer: String
    let choices: [String]
    let explanation: String
    let symbol: String

    init(prompt: String, answer: String, choices: [String], explanation: String, symbol: String) {
        self.prompt = prompt
        self.answer = answer
        var normalized = [answer]
        for choice in choices where !normalized.contains(choice) {
            normalized.append(choice)
            if normalized.count == 4 { break }
        }
        let fallback = ["Другой вариант", "Нужно подумать ещё раз", "Зависит от ситуации", "Верный ответ другой", "Попробуй рассуждать иначе"]
        for choice in fallback where !normalized.contains(choice) {
            normalized.append(choice)
            if normalized.count == 4 { break }
        }
        self.choices = Array(normalized.prefix(4)).shuffled()
        self.explanation = explanation
        self.symbol = symbol
    }
}

private enum ActivityQuestionBank {
    private static func fourChoices(_ answer: String, _ alternatives: [String]) -> [String] {
        var result = [answer]
        for value in alternatives where !result.contains(value) {
            result.append(value)
            if result.count == 4 { break }
        }
        let fallback = ["Другой вариант", "Ни один из этих вариантов", "Нужно подумать ещё раз", "Зависит от ситуации", "Верный ответ другой"]
        for value in fallback where !result.contains(value) {
            result.append(value)
            if result.count == 4 { break }
        }
        return Array(result.prefix(4)).shuffled()
    }
    // 1 200 automatically generated questions, with varying values and explanations.
    private static let generatedDetective: [ActivityQuestion] = {
        var bank: [ActivityQuestion] = []
        let weekdays = ["понедельник", "вторник", "среда", "четверг", "пятница", "суббота", "воскресенье"]
        for i in 0..<120 {
            let a = 2 + i % 12, b = 3 + (i / 12) % 10, answer = a * b
            bank.append(ActivityQuestion(prompt: "В коробках по \(b) фишек, коробок \(a). Сколько фишек всего?", answer: "\(answer)", choices: fourChoices("\(answer)", ["\(answer + b)", "\(answer - a)", "\(answer + a + 2)"]), explanation: "Количество фишек: \(a) × \(b) = \(answer).", symbol: "🧮"))
        }
        for i in 0..<120 {
            let divisor = 2 + i % 12, quotient = 3 + (i / 12) % 10, total = divisor * quotient
            bank.append(ActivityQuestion(prompt: "\(total) жетонов поровну разделили между \(divisor) игроками. Сколько получил каждый?", answer: "\(quotient)", choices: fourChoices("\(quotient)", ["\(quotient + 1)", "\(max(1, quotient - 2))", "\(quotient + divisor)"]), explanation: "Делим поровну: \(total) ÷ \(divisor) = \(quotient).", symbol: "🪙"))
        }
        for i in 0..<120 {
            let start = 3 + i % 35, step = 2 + (i / 35) % 9, answer = start + step * 4
            bank.append(ActivityQuestion(prompt: "Найди правило в ряду: \(start), \(start + step), \(start + step * 2), \(start + step * 3), …", answer: "\(answer)", choices: fourChoices("\(answer)", ["\(answer + 1)", "\(answer - step + 1)", "\(answer + step)"]), explanation: "Каждый раз прибавляем \(step): \(start + step * 3) + \(step) = \(answer).", symbol: "🔢"))
        }
        for i in 0..<120 {
            let a = 15 + i * 3, b = 12 + (i * 7) % 83, answer = a + b
            bank.append(ActivityQuestion(prompt: "в одном конверте \(a) марок, в другом \(b). Сколько марок вместе?", answer: "\(answer)", choices: fourChoices("\(answer)", ["\(answer + 10)", "\(answer - 7)", "\(abs(a - b))"]), explanation: "Складываем: \(a) + \(b) = \(answer).", symbol: "✉️"))
        }
        for i in 0..<120 {
            let price = 18 + (i * 7) % 72, paid = price + 20 + (i * 11) % 81, answer = paid - price
            bank.append(ActivityQuestion(prompt: "покупка стоит \(price) ₽, покупатель дал \(paid) ₽. Какова сдача?", answer: "\(answer) ₽", choices: fourChoices("\(answer) ₽", ["\(answer + 10) ₽", "\(max(1, answer - 5)) ₽", "\(price) ₽"]), explanation: "Сдача: \(paid) − \(price) = \(answer) рублей.", symbol: "🛍️"))
        }
        for i in 0..<120 {
            let dm = 2 + i % 18, answer = dm * 10
            bank.append(ActivityQuestion(prompt: "сколько сантиметров составляют \(dm) дм?", answer: "\(answer) см", choices: fourChoices("\(answer) см", ["\(dm) см", "\(answer + 10) см", "\(dm * 100) см"]), explanation: "В одном дециметре 10 см: \(dm) × 10 = \(answer) см.", symbol: "📏"))
        }
        for i in 0..<120 {
            let length = 4 + i % 27, width = 3 + (i * 5) % 19, answer = 2 * (length + width)
            bank.append(ActivityQuestion(prompt: "прямоугольник со сторонами \(length) см и \(width) см. Найди периметр.", answer: "\(answer) см", choices: fourChoices("\(answer) см", ["\(length * width) см", "\(answer + 4) см", "\(length + width) см"]), explanation: "Периметр: (\(length) + \(width)) × 2 = \(answer) см.", symbol: "📐"))
        }
        for i in 0..<120 {
            let n = 4 + i % 40, factor = 2 + (i / 10) % 5, answer = n * factor
            bank.append(ActivityQuestion(prompt: "Число \(n) увеличили в \(factor) раза. Какое число получилось?", answer: "\(answer)", choices: fourChoices("\(answer)", ["\(answer + n)", "\(answer - factor)", "\(n + factor)"]), explanation: "Умножаем: \(n) × \(factor) = \(answer).", symbol: "🔐"))
        }
        for i in 0..<120 {
            let day = i % 7, offset = 1 + (i / 7) % 6
            let answer = weekdays[(day + offset) % 7].capitalized
            let start = weekdays[day]
            bank.append(ActivityQuestion(prompt: "сегодня \(start). Какой день недели будет через \(offset) дней?", answer: answer, choices: fourChoices(answer, weekdays.map { $0.capitalized }.filter { $0 != answer }), explanation: "Через \(offset) дней после \(start) будет \(answer).", symbol: "📅"))
        }
        for i in 0..<120 {
            let side = 3 + i % 28, answer = side * side
            bank.append(ActivityQuestion(prompt: "у квадрата сторона \(side) см. Чему равна площадь?", answer: "\(answer) см²", choices: fourChoices("\(answer) см²", ["\(side * 4) см²", "\(answer + side) см²", "\(side + side) см²"]), explanation: "Площадь квадрата: \(side) × \(side) = \(answer) см².", symbol: "🟦"))
        }
        return bank
    }()
    static let detective: [ActivityQuestion] = generatedDetective + [
        ActivityQuestion(prompt: "Продолжи ряд: 2, 4, 6, 8, …", answer: "10", choices: ["9", "10", "12", "14"], explanation: "Каждый раз прибавляем 2: после 8 будет 10.", symbol: "🔢"),
        ActivityQuestion(prompt: "У Маши 3 красных и 2 синих карандаша. Сколько всего карандашей?", answer: "5", choices: ["4", "5", "6", "7"], explanation: "Складываем красные и синие карандаши: 3 + 2 = 5.", symbol: "✏️"),
        ActivityQuestion(prompt: "Что лишнее: кошка, собака, воробей, корова?", answer: "Воробей", choices: ["Кошка", "Собака", "Воробей", "Корова"], explanation: "Воробей — птица, остальные животные относятся к млекопитающим.", symbol: "🕵️"),
        ActivityQuestion(prompt: "У стола 4 ножки. Сколько ножек у двух таких столов?", answer: "8", choices: ["6", "8", "10", "12"], explanation: "У каждого стола по 4 ножки: 4 + 4 = 8.", symbol: "🪑"),
        ActivityQuestion(prompt: "Сегодня среда. Какой день будет через два дня?", answer: "Пятница", choices: ["Четверг", "Пятница", "Суббота", "Воскресенье"], explanation: "После среды идёт четверг, а ещё через день — пятница.", symbol: "📅"),
        ActivityQuestion(prompt: "У всех квадратов…", answer: "4 равные стороны", choices: ["3 стороны", "4 равные стороны", "5 углов", "Все стороны разные"], explanation: "У квадрата четыре стороны одинаковой длины и четыре прямых угла.", symbol: "🟪"),
        ActivityQuestion(prompt: "Найди число, которое не подходит: 5, 10, 15, 18, 20", answer: "18", choices: ["5", "10", "18", "20"], explanation: "Остальные числа делятся на 5, а 18 — нет.", symbol: "🔎"),
        ActivityQuestion(prompt: "Улитка ползёт вверх по лестнице. Что ей нужно сделать, чтобы подняться выше?", answer: "Продолжать двигаться вверх", choices: ["Двигаться вниз", "Остаться на месте", "Продолжать двигаться вверх", "Повернуть на месте"], explanation: "Чтобы оказаться выше, нужно продолжать движение вверх.", symbol: "🐌"),
        ActivityQuestion(prompt: "Какое слово лишнее: январь, март, среда, июнь?", answer: "Среда", choices: ["Январь", "Март", "Среда", "Июнь"], explanation: "Январь, март и июнь — месяцы, а среда — день недели.", symbol: "🔤"),
        ActivityQuestion(prompt: "У Лены 10 конфет. Она отдала половину. Сколько осталось?", answer: "5", choices: ["2", "4", "5", "8"], explanation: "Половина от 10 — это 5. Столько конфет и осталось.", symbol: "🍬"),
        ActivityQuestion(prompt: "Что тяжелее: килограмм яблок или килограмм крупы?", answer: "Одинаково", choices: ["Яблоки", "Крупа", "Одинаково", "Нельзя сравнить"], explanation: "И там и там по одному килограмму — масса одинаковая.", symbol: "⚖️"),
        ActivityQuestion(prompt: "Продолжи закономерность: круг, квадрат, круг, квадрат, …", answer: "Круг", choices: ["Круг", "Треугольник", "Квадрат", "Звезда"], explanation: "Фигуры чередуются: круг, квадрат, круг, квадрат. Следующий — круг.", symbol: "🧩")
    ]
    private static let trickyLifeSkills: [ActivityQuestion] = [
        ActivityQuestion(prompt: "Одно яйцо варится 5 минут. Сколько минут варятся 3 яйца, если варить их одновременно в одной кастрюле?", answer: "5 минут", choices: ["5 минут", "10 минут", "15 минут", "20 минут"], explanation: "Если все три яйца варятся одновременно в одной кастрюле, время не складывается: нужно 5 минут.", symbol: "🥚"),
        ActivityQuestion(prompt: "У папы 4 дочери. У каждой дочери есть один брат. Сколько всего детей в семье?", answer: "5 детей", choices: ["4 ребёнка", "5 детей", "8 детей", "9 детей"], explanation: "Брат у всех дочерей один и тот же: четыре дочери и один сын — всего пятеро.", symbol: "👨‍👧‍👧"),
        ActivityQuestion(prompt: "На столе горели 5 свечей. Две свечи погасили. Сколько свечей осталось на столе?", answer: "5 свечей", choices: ["2 свечи", "3 свечи", "5 свечей", "Ни одной"], explanation: "Погасшие свечи никуда не исчезли — на столе по-прежнему пять свечей.", symbol: "🕯️"),
        ActivityQuestion(prompt: "В корзине 6 яблок. Как раздать их 6 детям так, чтобы одно яблоко осталось в корзине?", answer: "Последнему ребёнку отдать яблоко вместе с корзиной", choices: ["Разрезать одно яблоко", "Последнему ребёнку отдать яблоко вместе с корзиной", "Оставить двух детей без яблок", "Спрятать яблоко"], explanation: "Пять детей получают по яблоку, а шестой — последнее яблоко вместе с корзиной.", symbol: "🍎"),
        ActivityQuestion(prompt: "Петух снёс яйцо на крыше. В какую сторону оно покатится?", answer: "Петухи не несут яйца", choices: ["Влево", "Вправо", "Вниз", "Петухи не несут яйца"], explanation: "Подвох в условии: яйца несут курицы, а не петухи.", symbol: "🐓"),
        ActivityQuestion(prompt: "Ты обогнал бегуна, который бежал вторым. На каком месте ты теперь?", answer: "На втором", choices: ["На первом", "На втором", "На третьем", "На последнем"], explanation: "Ты занял место бегуна, которого обогнал, то есть второе.", symbol: "🏃"),
        ActivityQuestion(prompt: "В комнате 4 угла. В каждом углу сидит кошка. Напротив каждой кошки сидят ещё 3 кошки. Сколько кошек в комнате, если они сидят по одной в каждом углу?", answer: "4 кошки", choices: ["4 кошки", "8 кошек", "12 кошек", "16 кошек"], explanation: "В каждом углу одна кошка, и все видят друг друга. Всего четыре.", symbol: "🐈"),
        ActivityQuestion(prompt: "Врач дал 3 таблетки и велел принимать по одной каждые полчаса, начиная прямо сейчас. За сколько времени будут приняты все таблетки?", answer: "1 час", choices: ["30 минут", "1 час", "1,5 часа", "2 часа"], explanation: "Первую принимают сразу, вторую через 30 минут, третью ещё через 30 минут. Всего проходит один час.", symbol: "⏱️")
    ]
    private static let baseLifeSkills: [ActivityQuestion] = [
        ActivityQuestion(prompt: "Карандаш стоит 12 ₽, блокнот — 28 ₽. Сколько нужно заплатить за оба товара?", answer: "40 ₽", choices: ["30 ₽", "36 ₽", "40 ₽", "42 ₽"], explanation: "Складываем цены: 12 + 28 = 40 рублей.", symbol: "🛍️"),
        ActivityQuestion(prompt: "Ты заплатил 100 ₽ за покупку стоимостью 67 ₽. Какая сдача?", answer: "33 ₽", choices: ["23 ₽", "33 ₽", "37 ₽", "43 ₽"], explanation: "Вычитаем стоимость покупки из оплаты: 100 − 67 = 33 рубля.", symbol: "🪙"),
        ActivityQuestion(prompt: "Занятие начинается в 15:00 и длится 45 минут. Когда оно закончится?", answer: "15:45", choices: ["15:15", "15:30", "15:45", "16:00"], explanation: "К 15:00 прибавляем 45 минут — получаем 15:45.", symbol: "🕒"),
        ActivityQuestion(prompt: "На прогулку нужно взять воду, куртку и ключи. Что лучше сделать перед выходом?", answer: "Проверить весь список", choices: ["Взять только воду", "Ничего не проверять", "Проверить весь список", "Оставить ключи дома"], explanation: "Короткая проверка списка помогает не забыть нужные вещи.", symbol: "🎒"),
        ActivityQuestion(prompt: "Что удобнее использовать, чтобы измерить длину карандаша?", answer: "Линейку", choices: ["Весы", "Линейку", "Часы", "Термометр"], explanation: "Линейка измеряет длину; весы измеряют массу, часы — время, термометр — температуру.", symbol: "📏"),
        ActivityQuestion(prompt: "У тебя 200 ₽. Ты хочешь купить книгу за 120 ₽. Сколько останется?", answer: "80 ₽", choices: ["60 ₽", "70 ₽", "80 ₽", "90 ₽"], explanation: "200 − 120 = 80 рублей. Это остаток после покупки.", symbol: "📚"),
        ActivityQuestion(prompt: "Ты видишь красный сигнал светофора у перехода. Что нужно сделать?", answer: "Остановиться и ждать разрешающего сигнала", choices: ["Быстро перебежать", "Остановиться и ждать разрешающего сигнала", "Идти за незнакомцем", "Играть у дороги"], explanation: "На красный сигнал нельзя начинать переход. Дождись разрешающего сигнала и убедись, что переход безопасен.", symbol: "🚦"),
        ActivityQuestion(prompt: "Как лучше поступить, если не успеваешь выполнить все домашние дела?", answer: "Составить план и попросить помощи взрослого", choices: ["Скрыть это", "Бросить всё", "Составить план и попросить помощи взрослого", "Выполнить всё наугад"], explanation: "План помогает расставить приоритеты, а взрослый подскажет, как распределить время.", symbol: "🗓️"),
        ActivityQuestion(prompt: "Что лучше сделать, прежде чем поделиться личными данными в интернете?", answer: "Посоветоваться с родителем", choices: ["Отправить любому", "Посоветоваться с родителем", "Написать пароль в чате", "Указать адрес всем"], explanation: "Адрес, пароль и другие личные сведения нельзя отправлять незнакомым людям. Обсуди это с родителем.", symbol: "🔐"),
        ActivityQuestion(prompt: "Рецепт требует 2 стакана воды. Ты уже налил 1 стакан. Сколько осталось добавить?", answer: "1 стакан", choices: ["Полстакана", "1 стакан", "2 стакана", "3 стакана"], explanation: "Нужно 2 стакана, один уже налит: осталось добавить ещё один.", symbol: "🥣")
    ]
   
    // 5 000 generated questions covering money, time, food, safety, planning, nature, transport, communication, home and measurement.
    private static let generatedLifeSkills: [ActivityQuestion] = {
        var bank: [ActivityQuestion] = []
        bank.reserveCapacity(5000)
        let symbols = ["🛍️", "🕒", "🥣", "🔐", "🎒", "🌱", "🚦", "💬", "🏡", "📏"]
        for i in 0..<5000 {
            let level = i % 3 + 1
            let a = level == 1 ? 10 + (i * 7 % 31) : (level == 2 ? 30 + (i * 7 % 61) : 80 + (i * 7 % 121))
            let b = level == 1 ? 2 + (i * 11 % 7) : (level == 2 ? 5 + (i * 11 % 15) : 10 + (i * 11 % 29))
            let c = level == 1 ? 2 + (i * 13 % 5) : (level == 2 ? 4 + (i * 13 % 9) : 8 + (i * 13 % 17))
            let d = level == 1 ? 3 + (i * 17 % 4) : (level == 2 ? 5 + (i * 17 % 8) : 9 + (i * 17 % 15))
            let q: String
            let answer: String
            let wrong: [String]
            let explanation: String
            switch i % 20 {
            case 0:
                q = "Товар стоит \(a) ₽, второй — \(b) ₽. Сколько стоят оба?."
                answer = "\(a + b) ₽"
                wrong = ["\(a + b + 5) ₽", "\(max(1, a + b - 3)) ₽", "\(a - b) ₽"]
                explanation = "Складываем цены: \(a) + \(b) = \(a + b) рублей."
            case 1:
                q = "У тебя было \(a) ₽, покупка стоит \(b) ₽. Сколько денег останется?."
                answer = "\(a - b) ₽"
                wrong = ["\(a + b) ₽", "\(a - b + 4) ₽", "\(max(0, a - b - 5)) ₽"]
                explanation = "Вычитаем стоимость покупки: \(a) − \(b) = \(a - b) рублей."
            case 2:
                let total = c + d
                q = "Для блюда нужно \(total) ложек ингредиента, уже добавили \(c). Сколько осталось?."
                answer = "\(d) ложек"
                wrong = ["\(d + 1) ложек", "\(total) ложек", "\(max(1, d - 1)) ложек"]
                explanation = "\(total) − \(c) = \(d): осталось добавить \(d) ложек."
            case 3:
                q = "Незнакомец в сети просит твой пароль. Как поступить?."
                answer = "Не сообщать пароль и рассказать взрослому"
                wrong = ["Отправить пароль", "Написать пароль в общем чате", "Отдать пароль за подарок"]
                explanation = "Пароль — личная информация. Не сообщай его и обратись к родителю или доверенному взрослому."
            case 4:
                q = "Ты собираешься выйти из дома и боишься забыть нужные вещи. Что поможет?."
                answer = "Проверить список необходимых вещей"
                wrong = ["Взять только одну случайную вещь", "Не проверять ничего", "Оставить ключи снаружи"]
                explanation = "Список и проверка перед выходом помогают ничего не забыть."
            case 5:
                q = "Ты видишь мусор рядом с контейнерами. Как поступить правильно?."
                answer = "Выбросить мусор в подходящий контейнер"
                wrong = ["Оставить мусор на тротуаре", "Бросить мусор в реку", "Спрятать мусор под кустом"]
                explanation = "Мусор нужно убирать в подходящий контейнер, а пригодные отходы — сортировать."
            case 6:
                q = "На переходе горит красный свет. Что нужно сделать?."
                answer = "Остановиться и дождаться разрешающего сигнала"
                wrong = ["Быстро перебежать", "Идти, не глядя по сторонам", "Побежать за незнакомцем"]
                explanation = "На красный сигнал переходить нельзя. Дождись зелёного и убедись, что путь безопасен."
            case 7:
                q = "Друг расстроен и хочет поговорить. Как лучше его поддержать?."
                answer = "Выслушать спокойно и спросить, чем помочь"
                wrong = ["Перебивать и смеяться", "Рассказывать всем его секрет", "Сразу обвинять его"]
                explanation = "Внимательное слушание и уважение чувств помогают поддержать друга."
            case 8:
                q = "Ты пролил воду рядом с электрической розеткой. Что делать?."
                answer = "Не трогать розетку и позвать взрослого"
                wrong = ["Вытереть воду рукой возле розетки", "Включить прибор", "Разобрать розетку самому"]
                explanation = "Вода и электричество опасны вместе. Не прикасайся к розетке и сразу предупреди взрослого."
            case 9:
                let cm = c * 10 + d
                q = "Лента длиной \(cm) см. Сколько это дециметров и сантиметров?."
                answer = "\(cm / 10) дм \(cm % 10) см"
                wrong = ["\(cm) дм", "\(cm / 10 + 1) дм", "\(cm % 10) дм \(cm / 10) см"]
                explanation = "10 см = 1 дм, значит \(cm) см = \(cm / 10) дм \(cm % 10) см."
            case 10:
                let minutes = 15 * (i % 4 + 1) + level * 5
                q = "Урок начинается в 09:00 и длится \(minutes) минут. Во сколько он закончится?."
                answer = String(format: "%02d:%02d", 9 + minutes / 60, minutes % 60)
                wrong = [String(format: "%02d:%02d", 9 + minutes / 60 + 1, minutes % 60), String(format: "%02d:%02d", 9, minutes % 60), String(format: "%02d:%02d", 9 + max(0, minutes / 60 - 1), minutes % 60)]
                explanation = "Прибавляем \(minutes) минут к 09:00 и получаем \(answer)."
            case 11:
                let budget = a + b + c
                q = "У тебя бюджет \(budget) ₽. Ты купил вещи за \(a) ₽ и \(b) ₽. Сколько осталось?."
                answer = "\(c) ₽"
                wrong = ["\(c + 5) ₽", "\(budget) ₽", "\(a + b) ₽"]
                explanation = "После покупки осталось \(c) рублей."
            case 12:
                let people = level + 2
                let each = c + 1
                q = "Нужно разложить по \(each) карандашей на каждое из \(people) мест. Сколько понадобится?."
                answer = "\(people * each)"
                wrong = ["\(people + each)", "\(people * each + 2)", "\(max(1, people * each - 3))"]
                explanation = "\(people) × \(each) = \(people * each) карандашей."
            case 13:
                q = "На улице сильный дождь, а тебе нужно идти в школу. Что разумнее сделать?."
                answer = "Взять подходящую одежду и предупредить взрослого, если погода опасная"
                wrong = ["Бежать по скользкой дороге", "Игнорировать грозу", "Играть с водой возле электропроводов"]
                explanation = "Одежда по погоде и осторожность помогают избежать травм."
            case 14:
                q = "Ты нашёл лекарство без упаковки. Как безопаснее поступить?."
                answer = "Не принимать его и показать взрослому"
                wrong = ["Попробовать на вкус", "Принять неизвестную таблетку", "Дать лекарство другу"]
                explanation = "Нельзя принимать неизвестные лекарства. Передай находку взрослому."
            case 15:
                q = "Ты случайно испортил чужую вещь. Что лучше сделать?."
                answer = "Честно рассказать владельцу и взрослому и помочь исправить ситуацию"
                wrong = ["Спрятать вещь", "Обвинить другого", "Убежать и никому не сказать"]
                explanation = "Честность и готовность исправить ошибку помогают восстановить доверие."
            case 16:
                q = "Ты заметил, что дома зря течёт вода. Как поступить?."
                answer = "Закрыть кран, если это безопасно, и сообщить взрослому"
                wrong = ["Оставить воду течь", "Играть с открытым краном", "Не сообщать о протечке"]
                explanation = "Так можно сберечь воду и вовремя устранить неисправность."
            case 17:
                q = "Тебе дали несколько поручений, и ты боишься забыть одно из них. Что поможет?."
                answer = "Записать поручения и выполнять по порядку"
                wrong = ["Надеяться, что всё запомнится", "Начать всё одновременно", "Скрыть, что забыл"]
                explanation = "Короткий список помогает распределить задачи и ничего не упустить."
            case 18:
                q = "В общественном месте ты потерялся и не видишь близких. Что безопаснее?."
                answer = "Остаться в безопасном месте и обратиться к сотруднику или полицейскому"
                wrong = ["Уйти с незнакомцем", "Искать выход через служебные двери", "Сесть в чужую машину"]
                explanation = "Обратись к сотруднику учреждения или полицейскому и не уходи с незнакомцами."
            default:
                q = "Как лучше подготовиться к важному школьному дню?."
                answer = "Заранее проверить расписание, собрать вещи и лечь вовремя спать"
                wrong = ["Собирать всё в последнюю минуту", "Не смотреть расписание", "Не отдыхать всю ночь"]
                explanation = "Планирование и достаточный отдых помогают быть готовым к занятиям."
            }
            bank.append(ActivityQuestion(prompt: q, answer: answer, choices: fourChoices(answer, wrong), explanation: explanation, symbol: symbols[i % symbols.count]))
        }
        return bank
    }()
    private static let practicalLifeSkills: [ActivityQuestion] = [
        ActivityQuestion(prompt: "Ты едешь на самокате по тротуару. Впереди маленький ребёнок. Что нужно сделать?", answer: "Снизить скорость и объехать только безопасно", choices: ["Разогнаться", "Снизить скорость и объехать только безопасно", "Громко кричать и ехать дальше", "Закрыть глаза"], explanation: "На тротуаре важно беречь пешеходов: сбрось скорость, предупреди о себе и объезжай только когда безопасно.", symbol: "🛴"),
        ActivityQuestion(prompt: "На велосипеде ты подъехал к пешеходному переходу. Как безопаснее поступить?", answer: "Остановиться, посмотреть по сторонам и перейти пешком", choices: ["Не сбавлять скорость", "Остановиться, посмотреть по сторонам и перейти пешком", "Ехать между машинами", "Смотреть только на телефон"], explanation: "Перед переходом нужно убедиться, что машины остановились. Безопаснее спешиться и перейти дорогу пешком.", symbol: "🚲"),
        ActivityQuestion(prompt: "Ты потерялся в торговом центре и не видишь родителей. Что делать?", answer: "Обратиться к сотруднику охраны или на стойку информации", choices: ["Уйти искать родителей на улицу", "Пойти с незнакомцем", "Обратиться к сотруднику охраны или на стойку информации", "Спрятаться в магазине"], explanation: "Оставайся в людном безопасном месте и попроси помощи у сотрудника в форме или на стойке информации.", symbol: "🏬"),
        ActivityQuestion(prompt: "Незнакомец в игре обещает бесплатные монеты, если ты пришлёшь пароль. Что делать?", answer: "Не отправлять пароль и рассказать взрослому", choices: ["Отправить пароль", "Назвать адрес дома", "Не отправлять пароль и рассказать взрослому", "Скачать неизвестный файл"], explanation: "Пароли и коды никому не сообщают. Бесплатные призы часто используют для обмана.", symbol: "🎮"),
        ActivityQuestion(prompt: "На телефон пришло сообщение от незнакомца с просьбой прислать код из SMS. Как поступить?", answer: "Не сообщать код и показать сообщение взрослому", choices: ["Сразу отправить код", "Не сообщать код и показать сообщение взрослому", "Переслать все свои пароли", "Ответить домашним адресом"], explanation: "Код из SMS может дать доступ к аккаунту. Не сообщай его даже тому, кто представляется сотрудником службы поддержки.", symbol: "📱"),
        ActivityQuestion(prompt: "Ты увидел открытый люк на тротуаре. Как правильно поступить?", answer: "Отойти подальше и предупредить взрослого или службу 112", choices: ["Подойти и заглянуть внутрь", "Положить туда палку", "Отойти подальше и предупредить взрослого или службу 112", "Перепрыгнуть через люк"], explanation: "Открытый люк опасен. Не подходи к краю, предупреди окружающих с безопасного расстояния и сообщи взрослому.", symbol: "⚠️"),
        ActivityQuestion(prompt: "Ты едешь в автобусе и хочешь выйти на следующей остановке. Что нужно сделать?", answer: "Заранее подойти к выходу, держась за поручень", choices: ["Бежать по движущемуся автобусу", "Заранее подойти к выходу, держась за поручень", "Встать у двери до полной остановки на ступеньке", "Толкать пассажиров"], explanation: "Держись за поручень и выходи спокойно после полной остановки автобуса.", symbol: "🚌"),
        ActivityQuestion(prompt: "Ты впервые едешь в метро и не знаешь, куда идти. Что безопаснее?", answer: "Посмотреть указатели и спросить сотрудника метро", choices: ["Перелезть через ограждение", "Идти за любым незнакомцем", "Посмотреть указатели и спросить сотрудника метро", "Подойти к краю платформы"], explanation: "Следуй указателям, держись подальше от края платформы и обращайся к сотрудникам метро.", symbol: "🚇"),
        ActivityQuestion(prompt: "В общественном месте ты не видишь родителей. Незнакомый взрослый предлагает отвезти тебя домой. Что делать?", answer: "Не уходить с ним и обратиться к сотруднику или полицейскому", choices: ["Сразу сесть в машину", "Не уходить с ним и обратиться к сотруднику или полицейскому", "Сообщить ему код от телефона", "Пойти за ним в тихое место"], explanation: "Не уходи с незнакомцем. Оставайся в безопасном людном месте и свяжись с родителями или сотрудником службы безопасности.", symbol: "👮"),
        ActivityQuestion(prompt: "Во дворе ты увидел дым из окна подъезда. Как поступить?", answer: "Отойти в безопасное место и позвонить 112, сообщить взрослому", choices: ["Зайти внутрь посмотреть", "Спрятаться в подъезде", "Отойти в безопасное место и позвонить 112, сообщить взрослому", "Открыть дверь и искать источник дыма"], explanation: "Не входи в задымлённое здание. Отойди на безопасное расстояние и вызови экстренную помощь.", symbol: "🚨"),
        ActivityQuestion(prompt: "Друг упал с велосипеда и сильно ударился, ему трудно встать. Что делать?", answer: "Позвать взрослого и вызвать помощь, не перемещать без необходимости", choices: ["Сразу резко поднять его", "Смеяться и уехать", "Позвать взрослого и вызвать помощь, не перемещать без необходимости", "Дать незнакомое лекарство"], explanation: "Позови взрослого. При серьёзной травме не двигай пострадавшего без необходимости и следуй указаниям диспетчера.", symbol: "🩹"),
        ActivityQuestion(prompt: "Ты хочешь съесть чипсы и запить их колой перед ужином. Какой выбор лучше для здоровья?", answer: "Выбрать воду и обычную еду, а сладости оставить редким угощением", choices: ["Есть только чипсы каждый день", "Выбрать воду и обычную еду, а сладости оставить редким угощением", "Заменить все приёмы пищи газировкой", "Не пить воду весь день"], explanation: "Чипсы и сладкая газировка не заменяют полноценную еду и воду. Важно разнообразное питание без запретов и переедания.", symbol: "🥗"),
        ActivityQuestion(prompt: "Ты нашёл на улице банковскую карту. Что лучше сделать?", answer: "Не пользоваться картой и передать её взрослому или сотруднику полиции", choices: ["Попробовать оплатить покупку", "Сфотографировать все данные и выложить в сеть", "Не пользоваться картой и передать её взрослому или сотруднику полиции", "Оставить себе"], explanation: "Чужая банковская карта — личная вещь. Не проверяй её и не публикуй данные.", symbol: "💳"),
        ActivityQuestion(prompt: "В магазине кассир дал сдачу больше, чем нужно. Как поступить?", answer: "Спокойно сказать кассиру об ошибке и вернуть лишнее", choices: ["Спрятать деньги", "Спокойно сказать кассиру об ошибке и вернуть лишнее", "Обвинить другого покупателя", "Убежать из магазина"], explanation: "Честно сообщи об ошибке — кассир сможет исправить расчёт.", symbol: "🛒"),
        ActivityQuestion(prompt: "Ты переходишь дорогу с родителем, а мяч укатился на проезжую часть. Что делать?", answer: "Не выбегать за мячом, остановиться и попросить взрослого помочь", choices: ["Сразу выбежать за мячом", "Не выбегать за мячом, остановиться и попросить взрослого помочь", "Попросить другого ребёнка выбежать", "Закрыть глаза и бежать"], explanation: "Мяч не стоит риска. Остановись у тротуара и попроси взрослого помочь, когда дорога будет безопасна.", symbol: "⚽"),
        ActivityQuestion(prompt: "В интернете незнакомый человек просит прислать фото паспорта или адрес. Что делать?", answer: "Не отправлять личные данные и сообщить взрослому", choices: ["Отправить всё сразу", "Написать номер квартиры", "Не отправлять личные данные и сообщить взрослому", "Сказать пароль от почты"], explanation: "Адрес, документы, пароли и коды — личные данные. Не отправляй их незнакомцам.", symbol: "🔒"),
        ActivityQuestion(prompt: "Ты услышал сигнал пожарной тревоги в школе или торговом центре. Что делать?", answer: "Следовать указаниям взрослых и идти к выходу без толкотни", choices: ["Вернуться за игрушкой", "Спрятаться в лифте", "Следовать указаниям взрослых и идти к выходу без толкотни", "Бежать навстречу толпе"], explanation: "Сохраняй спокойствие, не пользуйся лифтом и следуй плану эвакуации и указаниям взрослых.", symbol: "🏃"),
        ActivityQuestion(prompt: "Ты заметил, что после игры телефон стал горячим и незнакомое приложение просит доступ ко всем данным. Что сделать?", answer: "Закрыть приложение и попросить взрослого проверить телефон", choices: ["Разрешить все доступы", "Ввести пароль от банка", "Закрыть приложение и попросить взрослого проверить телефон", "Установить ещё неизвестные приложения"], explanation: "Не выдавай лишние разрешения неизвестным приложениям. Попроси взрослого проверить настройки и удалить подозрительную программу.", symbol: "📲"),
        ActivityQuestion(prompt: "Ты хочешь прокатиться на велосипеде вечером. Что важно проверить перед поездкой?", answer: "Тормоза, шлем, свет и видимость на дороге", choices: ["Только цвет велосипеда", "Тормоза, шлем, свет и видимость на дороге", "Громкость музыки в наушниках", "Ничего не проверять"], explanation: "Перед поездкой проверь исправность велосипеда, надень шлем и сделай себя заметным. Не отвлекайся на телефон и музыку.", symbol: "🚴"),
        ActivityQuestion(prompt: "В игре появился всплывающий экран «Ты выиграл приз — введи пароль». Как поступить?", answer: "Закрыть окно, ничего не вводить и рассказать взрослому", choices: ["Ввести пароль от почты", "Установить предложенный файл", "Закрыть окно, ничего не вводить и рассказать взрослому", "Отправить код из SMS"], explanation: "Неожиданные призы с запросом пароля часто являются мошенничеством. Не вводи данные и сообщи взрослому.", symbol: "🕹️")
    ]
    private static let additionalEverydayLifeSkills: [ActivityQuestion] = {
        // 10 000 additional scenarios covering school, nature, public places, family and healthy habits.
        let templates: [(String, String, [String], String, String)] = [
            ("{n} не понял объяснение учителя. Как лучше поступить?", "Вежливо поднять руку и попросить объяснить ещё раз", ["Перебивать учителя", "Списать у соседа", "Уйти с урока"], "Вежливый вопрос помогает разобраться и не мешает другим.", "🏫"),
            ("{n} увидел в лесу незнакомую ягоду. Что делать?", "Не пробовать её и показать взрослому", ["Сразу съесть ягоду", "Угостить друзей", "Спрятать в карман"], "Незнакомые ягоды могут быть ядовитыми. Спроси взрослого.", "🌲"),
            ("{n} едет в автобусе, а пассажиру трудно стоять. Как поступить?", "Если безопасно, предложить место", ["Делать вид, что не замечаешь", "Толкать пассажира", "Занять места вещами"], "Внимание к другим делает поездку комфортнее.", "🚌"),
            ("{n} пришёл в театр. Как вести себя во время спектакля?", "Сидеть спокойно и не разговаривать громко", ["Светить телефоном на сцену", "Громко обсуждать спектакль", "Ходить между рядами"], "Тишина помогает зрителям слышать артистов.", "🎭"),
            ("{n} смотрит фильм в кинотеатре. Как уважать других зрителей?", "Убрать телефон и не мешать другим", ["Включить громкий звук", "Пинать кресло впереди", "Разговаривать во весь голос"], "В кино важно не отвлекать окружающих.", "🎬"),
            ("{n} хочет качаться на занятых качелях. Что делать?", "Дождаться своей очереди", ["Толкнуть ребёнка", "Раскачать качели без спроса", "Занять их надолго"], "Очередь помогает играть безопасно и справедливо.", "🛝"),
            ("{n} пришёл в гости. Как вести себя правильно?", "Поздороваться и спрашивать разрешение брать вещи", ["Открывать все шкафы", "Требовать угощение", "Брать чужие вещи"], "В гостях важно быть вежливым и уважать хозяев.", "🏠"),
            ("{n} хочет помочь родителям. С чего начать?", "Спросить, какая посильная помощь нужна", ["Спрятать беспорядок", "Брать опасные инструменты без разрешения", "Обещать и не делать"], "Посильная помощь полезна и безопасна.", "🤝"),
            ("{n} закончил играть и оставил игрушки повсюду. Что лучше?", "Убрать игрушки на свои места", ["Оставить до следующего года", "Спрятать как попало", "Ждать, что уберут другие"], "Порядок помогает находить вещи и делает дом безопаснее.", "🧸"),
            ("{n} садится обедать. Как правильно начать?", "Вымыть руки и спокойно сесть за стол", ["Есть немытыми руками", "Бегать с едой", "Говорить с полным ртом"], "Чистые руки и спокойное поведение помогают сохранить здоровье.", "🍽️"),
            ("{n} пора спать, но хочется долго играть в телефон. Что лучше?", "Отложить экран и лечь спать вовремя", ["Не спать всю ночь", "Пить газировку вместо сна", "Будить всех громкой игрой"], "Регулярный сон помогает мозгу отдыхать и запоминать новое.", "🌙"),
            ("{n} начинает заниматься спортом. Как безопаснее?", "Начать с разминки и нагрузки по силам", ["Сразу тренироваться на пределе", "Не пить воду", "Продолжать при резкой боли"], "Разминка и постепенная нагрузка снижают риск травм.", "⚽"),
            ("{n} встретил незнакомое слово в книге. Что полезнее?", "Попробовать понять по контексту и уточнить значение", ["Закрыть книгу", "Пропустить всю страницу", "Не проверять догадку"], "Чтение расширяет словарный запас и помогает лучше понимать текст.", "📚"),
            ("{n} перебил одноклассника. Как поступить?", "Извиниться и дать ему закончить", ["Перекрикивать его", "Смеяться над ответом", "Не давать говорить"], "Уважение означает слушать и давать другим высказаться.", "💬"),
            ("{n} увидел мусор после пикника в лесу. Что делать?", "Собрать мусор и унести к контейнеру", ["Закопать пластик", "Оставить под деревом", "Бросить в ручей"], "Мусор загрязняет природу и опасен для животных.", "♻️"),
            ("{n} подошёл к дороге на красный сигнал. Что делать?", "Дождаться разрешающего сигнала и проверить безопасность", ["Перебежать на красный", "Играть на дороге", "Идти не глядя"], "Переходи дорогу по правилам, даже если машин не видно.", "🚦"),
            ("{n} не согласен с другом во время игры. Как решить спор?", "Спокойно объяснить свою мысль и выслушать друга", ["Обзывать друга", "Толкаться", "Ломать игру"], "Спокойный разговор помогает найти решение и сохранить дружбу.", "🤝"),
            ("{n} заметил воду на полу дома. Что сделать?", "Предупредить домашних и безопасно вытереть воду", ["Бежать по мокрому полу", "Оставить лужу", "Включить прибор рядом с водой"], "Мокрый пол скользкий, а вода опасна рядом с электричеством.", "🧽"),
            ("{n} собирается в школу завтра. Как подготовиться?", "Проверить расписание и собрать портфель", ["Искать всё утром в спешке", "Не брать учебники", "Сложить еду с открытыми чернилами"], "Подготовка вечером помогает ничего не забыть.", "🎒"),
            ("{n} нашёл чужой телефон в транспорте. Что правильно?", "Передать его водителю или сотруднику транспорта", ["Просматривать фотографии", "Угадывать пароль", "Оставить себе"], "Чужие вещи нужно вернуть через ответственного сотрудника.", "📱"),
            ("{n} хочет взять вещь брата или сестры. Как поступить?", "Спросить разрешение и вернуть вещь на место", ["Брать тайком", "Сломать и скрыть", "Обидеться на отказ"], "Просьба о разрешении помогает уважать личные границы.", "🧩"),
            ("{n} устал во время домашнего задания. Что лучше?", "Сделать короткий перерыв и затем продолжить", ["Работать без отдыха часами", "Бросить учёбу навсегда", "Списать ответы"], "Перерывы помогают восстановить внимание.", "✏️"),
            ("{n} заметил, что друг грустит и сидит один. Как помочь?", "Мягко спросить, как он, и при необходимости позвать взрослого", ["Распространять слухи", "Смеяться над ним", "Требовать всё рассказать"], "Поддержка начинается с уважительного вопроса.", "💗"),
            ("{n} не знает, где найти книгу в библиотеке. Что сделать?", "Посмотреть указатели или спросить библиотекаря", ["Кричать между полками", "Разбрасывать книги", "Рисовать в книге"], "Библиотекарь поможет найти книгу, а бережность сохранит её для других.", "📖"),
            ("{n} получил сообщение с просьбой сообщить пароль. Что делать?", "Не отвечать и сообщить взрослому", ["Отправить пароль", "Назвать адрес дома", "Переслать код"], "Пароли и коды нельзя сообщать другим людям.", "🔐"),
            ("{n} почувствовал головокружение после бега. Что делать?", "Остановиться, сообщить взрослому и отдохнуть", ["Продолжать любой ценой", "Скрывать самочувствие", "Принять чужое лекарство"], "При плохом самочувствии нельзя продолжать нагрузку.", "🏃"),
            ("{n} пришёл в гости и увидел угощение. Как быть вежливым?", "Дождаться приглашения и поблагодарить", ["Брать еду руками", "Требовать самое вкусное", "Критиковать хозяев"], "Вежливость — это спокойствие и благодарность.", "🍎"),
            ("{n} потерялся в торговом центре. Что безопаснее?", "Обратиться к охране или на стойку информации", ["Уйти искать родителей на улицу", "Пойти с незнакомцем", "Спрятаться"], "Оставайся в безопасном людном месте и попроси помощи у сотрудника.", "🏬"),
            ("{n} услышал пожарную тревогу. Как действовать?", "Следовать указаниям взрослых и спокойно идти к выходу", ["Спрятаться в лифте", "Вернуться за игрушкой", "Толкать людей"], "При тревоге нужно выйти безопасным путём и не пользоваться лифтом.", "🚨"),
            ("{n} увидел, что младший ребёнок плачет на площадке. Что делать?", "Позвать взрослого и спросить, нужна ли помощь", ["Увести ребёнка", "Дразнить его", "Давать лекарства"], "Если ребёнок потерялся или ему плохо, нужна помощь взрослого.", "🧒")
        ]
        let names = ["Аня", "Миша", "Саша", "Лена", "Тимур", "Амина", "Дима", "София", "Илья", "Марьям", "Кирилл", "Зара", "Рома", "Алия", "Егор", "Полина", "Артур", "Милана", "Даня", "Элина"]
        var bank: [ActivityQuestion] = []
        bank.reserveCapacity(10_000)
        for i in 0..<10_000 {
            let item = templates[i % templates.count]
            let name = names[(i / templates.count + i) % names.count]
            let prompt = item.0.replacingOccurrences(of: "{n}", with: name)
            bank.append(ActivityQuestion(prompt: prompt, answer: item.1, choices: fourChoices(item.1, item.2), explanation: item.3, symbol: item.4))
        }
        return bank
    }()
    // 1,000 focused questions for social skills, family, school, safety and healthy habits.
    private static let focusedLifeSkills: [ActivityQuestion] = {
        let names = ["Аня","Миша","Саша","Лена","Тимур","Амина","Дима","София","Илья","Марьям","Кирилл","Зара","Рома","Алия","Егор","Полина","Артур","Милана","Даня","Элина","Максим","Аделя","Руслан","Вика","Амир","Диана","Лев","Самира","Матвей","Ясмина","Игорь","Арина","Ринат","Лиза","Тимофей","Карина","Никита","Эмма","Дамир","Алёна","Артём","Малика","Павел","Сабина","Олег","Наиля","Степан","Мадина","Ярослав","Айгуль"]
        let templates: [(String, String, [String], String, String)] = [
            ("{n} не понял объяснение учителя. Как лучше поступить?", "Вежливо попросить объяснить ещё раз", ["Перебить учителя и спорить", "Списать у соседа, не разбираясь", "Сделать вид, что всё понятно"], "Спокойный вопрос помогает понять тему и не мешает классу.", "🏫"),
            ("{n} не согласен с замечанием учителя. Как ответить?", "Спокойно объяснить свою точку зрения и выслушать ответ", ["Кричать и оскорблять", "Уйти с урока без разрешения", "Высмеять учителя перед классом"], "Несогласие можно выражать уважительно.", "💬"),
            ("{n} заметил, что одноклассника постоянно дразнят. Что сделать?", "Поддержать его и рассказать надёжному взрослому", ["Присоединиться к насмешкам", "Снять видео и разослать всем", "Начать травить обидчика в ответ"], "Поддержка и помощь взрослого безопаснее ответной травли.", "🤝"),
            ("{n} пытаются втянуть в драку. Как защитить себя?", "Отойти в безопасное место и позвать взрослого", ["Ударить первым", "Назначить драку после уроков", "Продолжать толкаться"], "Важно выйти из опасной ситуации и обратиться за помощью.", "🛡️"),
            ("{n} очень злится из-за проигрыша. Что поможет?", "Сделать паузу, спокойно подышать и поговорить", ["Сломать игру соперника", "Обвинить всех и кричать", "Пообещать отомстить"], "Пауза помогает успокоиться и выбрать подходящие слова.", "🌿"),
            ("{n} едет в лифте с соседями. Как вести себя вежливо?", "Поздороваться, не толкаться и дать людям выйти", ["Нажимать все кнопки ради шутки", "Удерживать двери ногой", "Громко включить видео"], "В лифте важно уважать других и соблюдать безопасность.", "🛗"),
            ("{n} видит, что лифт переполнен. Что разумнее?", "Подождать следующую поездку", ["Протиснуться и прижать людей", "Удерживать двери, чтобы войти", "Заставить кого-то выйти"], "Не стоит перегружать лифт или толкать пассажиров.", "🛗"),
            ("{n} пришёл в гости к родственникам. Что сделать сначала?", "Поздороваться и дождаться приглашения пройти", ["Сразу открыть холодильник", "Осматривать личные вещи", "Требовать развлечений"], "Приветствие и уважение к правилам хозяев — хорошие манеры.", "🏡"),
            ("{n} хочет взять чужую игру в гостях. Как поступить?", "Спросить разрешение и бережно играть", ["Взять без спроса", "Унести игру домой", "Смешать детали с другими игрушками"], "Чужие вещи можно брать только с разрешения.", "🎲"),
            ("{n} на даче увидел незнакомые ягоды или грибы. Что делать?", "Не пробовать и показать находку взрослому", ["Попробовать маленький кусочек", "Угостить друга", "Дать попробовать животному"], "Незнакомые растения и грибы могут быть опасными.", "🌿"),
            ("{n} хочет помочь на даче рядом с острыми инструментами. Как поступить?", "Выбрать безопасное поручение под присмотром взрослого", ["Самому включить незнакомый инструмент", "Бегать с секатором в руках", "Оставить острый инструмент на дорожке"], "Опасные инструменты требуют контроля взрослого.", "🧤"),
            ("{n} хочет помочь бабушке или дедушке. С чего начать?", "Спросить, какая посильная помощь нужна", ["Самому переставлять тяжёлую мебель", "Переделать вещи без разрешения", "Пообещать помощь и уйти играть"], "Лучше учитывать пожелания близких и выбирать безопасное дело.", "💗"),
            ("{n} хочет порадовать родителей после работы. Что будет полезно?", "Выполнить посильное поручение и спросить, нужна ли ещё помощь", ["Спрятать беспорядок в шкафу", "Требовать награду за каждую мелочь", "Начать шумную игру рядом с отдыхающими"], "Забота выражается в полезных действиях и внимании.", "🏡"),
            ("{n} готовится к школьному дню. Как организовать учебники и тетради?", "Проверить расписание и сложить нужные предметы в портфель", ["Сложить всё вперемешку без проверки", "Оставить нужные книги в другой комнате", "Выбросить листы, не проверяя их"], "Подготовка по расписанию помогает ничего не забыть.", "🎒"),
            ("{n} долго сидит в телефоне и из-за этого поздно ложится. Что лучше?", "Договориться о времени без экрана и соблюдать режим сна", ["Играть до глубокой ночи", "Заменить сон сладкой газировкой", "Держать звук на максимуме"], "Телефон не должен вытеснять сон, движение и другие дела.", "📱"),
            ("{n} хочет потратить все карманные деньги на сладости. Как поступить?", "Проверить бюджет и оставить деньги на запланированные покупки", ["Потратить всё, не считая сдачу", "Взять товар без оплаты", "Купить неизвестный продукт только из-за упаковки"], "Планирование бюджета помогает избежать импульсивных покупок.", "🛒"),
            ("{n} кажется, что кассир дал неправильную сдачу. Что сделать?", "Пересчитать деньги и вежливо уточнить сумму", ["Обвинить кассира без проверки", "Молча уйти, не проверяя", "Отдать деньги незнакомому покупателю"], "Спокойная проверка помогает исправить ошибку.", "💰"),
            ("{n} хочет приготовить простой перекус. Как начать безопасно?", "Вымыть руки и попросить помощи с ножом или плитой", ["Включить плиту без разрешения", "Использовать продукт с подозрительным запахом", "Резать продукты на весу"], "Гигиена и осторожность с приборами важнее спешки.", "🥣"),
            ("{n} должен убрать комнату и не знает, с чего начать. Что поможет?", "Разделить уборку на шаги: вещи, стол, затем пол", ["Перенести весь беспорядок в коридор", "Смешать чистую одежду с грязной", "Начать много дел и бросить каждое"], "Небольшой план делает уборку проще.", "🧹"),
            ("{n} выбирает напиток на каждый день. Что разумнее?", "Чаще выбирать воду, а сладкие напитки не делать основой питья", ["Пить сладкую газировку вместо воды постоянно", "Выбирать только энергетики", "Отказываться от воды во время активности"], "Вода подходит для повседневного питья лучше сладких напитков.", "🥤")
        ]
        var bank: [ActivityQuestion] = []
        bank.reserveCapacity(1000)
        for i in 0..<1000 {
            let item = templates[i % templates.count]
            let name = names[(i / templates.count + i) % names.count]
            bank.append(ActivityQuestion(prompt: item.0.replacingOccurrences(of: "{n}", with: name), answer: item.1, choices: fourChoices(item.1, item.2), explanation: item.3, symbol: item.4))
        }
        return bank
    }()


    // 1,000 advanced everyday-life questions designed for ages 10–15.
    // They cover digital safety, money, critical thinking, boundaries, health, planning and practical independence.
    private static let teenLifeSkills: [ActivityQuestion] = {
        let names = ["Аня", "Миша", "Саша", "Лена", "Тимур", "Амина", "Дима", "София", "Илья", "Марьям", "Кирилл", "Зара", "Рома", "Алия", "Егор", "Полина", "Артур", "Милана", "Даня", "Элина", "Максим", "Аделя", "Руслан", "Вика", "Амир", "Диана", "Лев", "Самира", "Матвей", "Ясмина", "Игорь", "Арина", "Ринат", "Лиза", "Тимофей", "Карина", "Никита", "Эмма", "Дамир", "Алёна", "Артём", "Малика", "Павел", "Сабина", "Олег", "Наиля", "Степан", "Мадина", "Ярослав", "Айгуль"]
        var bank: [ActivityQuestion] = []
        bank.reserveCapacity(1000)
        for i in 0..<1000 {
            let name = names[(i / 30 + i) % names.count]
            let age = 10 + i % 6
            let amount = 100 + (i * 37 % 901)
            let price = (10 + (i * 7 % 40)) * 10
            let discount = price / 10
            let weekly = 150 + (i * 13 % 351)
            let saved = 50 + (i * 11 % 201)
            let minutes = 20 + (i * 17 % 101)
            let q: String
            let answer: String
            let wrong: [String]
            let explanation: String
            let symbol: String
            switch i % 30 {
            case 0:
                q = "\(name), \(age) лет, планирует покупку за \(price) ₽ при бюджете \(amount) ₽. Что нужно сделать перед оплатой?"
                answer = "Сверить цену с бюджетом и остатком"
                wrong = ["Сразу купить, не глядя на цену", "Потратить ещё и деньги, которых нет", "Не проверять сдачу и чек"]
                explanation = "Сравнение цены с бюджетом помогает принять обдуманное решение и не потратить лишнее."
                symbol = "💰"
            case 1:
                q = "Товар стоит \(price) ₽, на него скидка 10%. Сколько нужно заплатить?"
                answer = "\(price - discount) ₽"
                wrong = ["\(price + discount) ₽", "\(discount) ₽", "\(price) ₽"]
                explanation = "10% от \(price) ₽ — это \(discount) ₽. После скидки: \(price) − \(discount) = \(price - discount) ₽."
                symbol = "🛍️"
            case 2:
                q = "\(name) хочет накопить \(amount) ₽. Уже есть \(saved) ₽. Какой следующий шаг разумнее?"
                answer = "Рассчитать остаток и составить план"
                wrong = ["Сразу потратить все накопления", "Взять деньги у незнакомца без объяснений", "Покупать вещи, не проверяя остаток"]
                explanation = "Цель, остаток и регулярный план накоплений помогают контролировать деньги."
                symbol = "🐷"
            case 3:
                q = "\(name) получил сообщение: «Срочно перейди по ссылке и введи пароль, иначе аккаунт заблокируют». Что делать?"
                answer = "Не открывать ссылку; проверить сервис официально"
                wrong = ["Сразу ввести пароль", "Переслать сообщение всем друзьям", "Отправить код подтверждения автору"]
                explanation = "Срочность и угрозы часто используются в фишинге. Проверяй уведомления только в официальном приложении или на сайте."
                symbol = "🔐"
            case 4:
                q = "\(name) познакомился с человеком в игре, который просит домашний адрес и расписание. Как поступить?"
                answer = "Не делиться данными и сказать взрослому"
                wrong = ["Отправить адрес ради дружбы", "Сфотографировать документы", "Сообщить, когда дома никого не будет"]
                explanation = "Адрес, распорядок дня и документы — личные сведения. Незнакомому онлайн-собеседнику их не отправляют."
                symbol = "📱"
            case 5:
                q = "В школьном чате над \(name) насмехаются и распространяют обидную картинку. Что лучше сделать?"
                answer = "Сохранить доказательства и обратиться к взрослому"
                wrong = ["Начать травить в ответ", "Разослать картинку дальше", "Публиковать чужие личные данные"]
                explanation = "Не усиливай травлю. Сохрани доказательства и обратись к взрослому, который поможет остановить происходящее."
                symbol = "💬"
            case 6:
                q = "\(name) увидел громкий пост с невероятным фактом. Как проверить, правда ли это?"
                answer = "Найти первоисточник и проверить другие источники"
                wrong = ["Сразу поверить из-за большого числа лайков", "Переслать всем до проверки", "Считать правдой любой пост с яркой картинкой"]
                explanation = "Популярность публикации не доказывает её достоверность. Ищи первоисточник и независимые подтверждения."
                symbol = "🔎"
            case 7:
                q = "\(name) использует ИИ для школьного проекта. Как поступить честно и безопасно?"
                answer = "Проверить факты и оформить ответ своими словами"
                wrong = ["Сдать непроверенный текст как собственную работу", "Ввести в запрос личные данные одноклассников", "Верить каждому ответу ИИ без проверки"]
                explanation = "ИИ может ошибаться. Проверяй факты, не вводи личные данные и соблюдай правила выполнения задания."
                symbol = "🤖"
            case 8:
                q = "Друг хочет выложить фото \(name), но \(name) против. Как правильно поступить?"
                answer = "Уважать отказ и получить согласие"
                wrong = ["Опубликовать тайком", "Сказать, что согласие не имеет значения", "Отметить человека, чтобы его увидели все"]
                explanation = "У каждого есть право решать, какие его фотографии публиковать. Сначала нужно получить согласие."
                symbol = "🛡️"
            case 9:
                q = "\(name) поссорился с другом из-за недопонимания. Как повысить шанс договориться?"
                answer = "Спокойно поговорить и выслушать друга"
                wrong = ["Оскорбить друга при всех", "Распространить слухи", "Требовать извинений, не выслушав объяснение"]
                explanation = "Спокойный разговор помогает понять обе стороны и найти решение без унижения."
                symbol = "🤝"
            case 10:
                q = "\(name) заметил, что человеку на улице внезапно стало плохо. Как действовать безопаснее?"
                answer = "Позвать взрослого и вызвать помощь"
                wrong = ["Давать незнакомые лекарства", "Оставить человека одного, не сообщив никому", "Снимать происходящее для публикации"]
                explanation = "Не подвергай себя опасности и не давай лекарства. Позови взрослого и при необходимости вызови экстренную службу."
                symbol = "🆘"
            case 11:
                q = "\(name) заметил искрящуюся розетку дома. Что нужно сделать?"
                answer = "Отойти и сообщить взрослому"
                wrong = ["Проверить её металлическим предметом", "Попробовать починить самому", "Включить ещё один прибор"]
                explanation = "Повреждённая электрика опасна. Не прикасайся к ней и предупреди взрослого."
                symbol = "⚡"
            case 12:
                q = "\(name) едет на велосипеде и хочет посмотреть уведомление телефона. Как поступить?"
                answer = "Остановиться в безопасном месте"
                wrong = ["Читать сообщение на ходу", "Ехать одной рукой, печатая ответ", "Закрыть обзор капюшоном и продолжить"]
                explanation = "Телефон отвлекает от дороги. Сначала остановись в безопасном месте."
                symbol = "🚲"
            case 13:
                q = "\(name) едет один на знакомом автобусном маршруте, но нужная остановка неожиданно пропущена. Что делать?"
                answer = "Остаться в людном месте и позвонить близким"
                wrong = ["Уйти с незнакомцем, который предлагает подвезти", "Сесть в случайную машину", "Идти по проезжей части, сокращая путь"]
                explanation = "Заранее согласованный план связи и помощь сотрудника транспорта безопаснее случайных предложений."
                symbol = "🚌"
            case 14:
                q = "\(name) нужно подготовиться к контрольной и выполнить домашние дела за \(minutes) минут. Что поможет?"
                answer = "Разбить дела на этапы и выбрать главное"
                wrong = ["Откладывать всё до последней минуты", "Одновременно открыть много дел и не завершить ни одно", "Потратить всё время на оформление списка"]
                explanation = "Приоритеты и короткие рабочие блоки помогают начать вовремя и видеть прогресс."
                symbol = "🗓️"
            case 15:
                q = "\(name) хочет лучше запомнить тему к контрольной. Какой способ обычно эффективнее?"
                answer = "Повторять с перерывами и проверять себя"
                wrong = ["Прочитать один раз ночью без сна", "Только выделять текст цветом, не вспоминая его", "Оставить подготовку на последние пять минут"]
                explanation = "Распределённое повторение и активное воспроизведение помогают закреплять знания."
                symbol = "📚"
            case 16:
                q = "\(name) несколько вечеров подряд поздно играет на телефоне и не высыпается. Что изменить?"
                answer = "Завершать игры заранее и отдыхать без экрана"
                wrong = ["Заменить сон энергетиком", "Спать ещё меньше ради игры", "Держать телефон под подушкой с громкими уведомлениями"]
                explanation = "Регулярный сон поддерживает внимание и настроение. Полезно заранее завершать игры и соблюдать режим."
                symbol = "🌙"
            case 17:
                q = "\(name) выбирает перекус перед тренировкой. Что разумнее?"
                answer = "Выбрать привычный перекус и воду"
                wrong = ["Есть незнакомую еду, которая вызывает сомнения", "Совсем не пить воду", "Считать энергетик обязательным для любой тренировки"]
                explanation = "Подходящий перекус и вода помогают чувствовать себя комфортно. При особых ограничениях стоит спросить взрослого."
                symbol = "🍎"
            case 18:
                q = "\(name) сортирует отходы дома. Что важнее всего перед тем, как отправить упаковку в переработку?"
                answer = "Проверить правила местной переработки"
                wrong = ["Смешать все отходы в один контейнер", "Считать любую упаковку перерабатываемой", "Бросить батарейки в контейнер для бумаги"]
                explanation = "Правила приёма отличаются. Батарейки и другие опасные отходы сдают отдельно в специальные пункты."
                symbol = "♻️"
            case 19:
                q = "\(name) заметил дома протекающий кран. Какой вариант полезнее?"
                answer = "Безопасно перекрыть воду и позвать взрослого"
                wrong = ["Не обращать внимания несколько дней", "Оставить воду течь ради шума", "Самостоятельно разбирать кран без разрешения"]
                explanation = "Так можно уменьшить расход воды и вовремя устранить неисправность."
                symbol = "💧"
            case 20:
                q = "В командном проекте \(name) заметил, что один участник не успевает со своей частью. Что лучше?"
                answer = "Обсудить сроки и перераспределить задачи"
                wrong = ["Публично высмеять участника", "Удалить его имя из проекта без разговора", "Ничего не делать и обвинить всех после срока"]
                explanation = "Чёткие договорённости и уважительный разговор помогают команде справиться с трудностями."
                symbol = "🧩"
            case 21:
                q = "\(name) потерялся в большом торговом центре и не видит близких. Как безопаснее поступить?"
                answer = "Обратиться к охране или на стойку информации"
                wrong = ["Уйти из здания с незнакомым человеком", "Выйти на парковку и искать машину наугад", "Прятаться в служебных помещениях"]
                explanation = "Обращайся к сотрудникам учреждения и связывайся с близкими; не уходи с незнакомцами."
                symbol = "🧭"
            case 22:
                q = "После покупки за \(price) ₽ \(name) сомневается, что сумма в чеке верна. Что сделать?"
                answer = "Сверить чек с ценами и спросить кассира"
                wrong = ["Сразу обвинить кассира без проверки", "Уйти, не посмотрев чек, а потом выбросить его", "Отдать чек случайному человеку вместе с банковской картой"]
                explanation = "Проверка чека и вежливый вопрос помогают исправить ошибку, если она есть."
                symbol = "🧾"
            case 23:
                q = "\(name) получил предложение быстро заработать, если переведёт незнакомцу \(amount) ₽ «для активации». Что делать?"
                answer = "Не платить незнакомцу и спросить взрослого"
                wrong = ["Перевести деньги ради обещанного дохода", "Отправить данные карты и код из сообщения", "Взять деньги в долг, чтобы оплатить активацию"]
                explanation = "Обещание лёгкого заработка за предварительный перевод может быть мошенничеством. Не отправляй деньги и данные карты."
                symbol = "🚫"
            case 24:
                q = "\(name) хочет приготовить перекус и собирается пользоваться плитой впервые. Как поступить?"
                answer = "Попросить взрослого показать безопасный способ"
                wrong = ["Включить плиту без инструктажа", "Оставить нагрев без присмотра", "Проверять горячую сковороду рукой"]
                explanation = "Плита и горячая посуда могут вызвать ожоги. Первые действия нужно освоить со взрослым."
                symbol = "🍳"
            case 25:
                q = "\(name) использует один и тот же простой пароль для игр и почты. Как повысить безопасность?"
                answer = "Создать разные пароли и включить проверку входа"
                wrong = ["Отправить пароль другу для хранения", "Написать пароль в открытом профиле", "Сделать пароль из имени и даты рождения"]
                explanation = "Уникальные пароли уменьшают риск доступа к разным аккаунтам, а дополнительная проверка усиливает защиту."
                symbol = "🔑"
            case 26:
                q = "\(name) опубликовал эмоциональный комментарий и позже пожалел. Как лучше исправить ситуацию?"
                answer = "Исправить комментарий и при необходимости извиниться"
                wrong = ["Продолжить спор оскорблениями", "Публиковать личные данные собеседника", "Создать новые аккаунты для травли"]
                explanation = "Цифровой след может сохраняться. Исправление ошибки и уважительное общение лучше эскалации конфликта."
                symbol = "🌐"
            case 27:
                q = "Незнакомый онлайн-собеседник предлагает \(name) встретиться без ведома родителей. Что безопаснее?"
                answer = "Отказаться от тайной встречи и сказать взрослому"
                wrong = ["Согласиться и никому не говорить", "Отправить геолокацию и ждать в одиночестве", "Сесть к собеседнику в машину"]
                explanation = "Не встречайся тайно с людьми из интернета. Любую такую ситуацию нужно обсудить с доверенным взрослым."
                symbol = "🛡️"
            case 28:
                q = "\(name) получил код подтверждения, хотя сам не пытался войти в аккаунт. Что делать?"
                answer = "Не сообщать код; проверить аккаунт официально"
                wrong = ["Отправить код тому, кто его попросит", "Опубликовать код в чате", "Переслать код незнакомцу для отмены входа"]
                explanation = "Коды подтверждения предназначены только владельцу аккаунта. Никому не сообщай их."
                symbol = "📲"
            default:
                q = "\(name) должен выполнить несколько дел, а до выхода осталось \(minutes) минут. Что поможет не опоздать?"
                answer = "Выбрать главное и заложить время на дорогу"
                wrong = ["Начать самое необязательное дело", "Не учитывать время на дорогу", "Откладывать сборы до последней минуты"]
                explanation = "Приоритеты и запас времени уменьшают риск опоздания и помогают действовать спокойно."
                symbol = "⏱️"
            }
            bank.append(ActivityQuestion(prompt: q, answer: answer, choices: fourChoices(answer, wrong), explanation: explanation, symbol: symbol))
        }
        return bank
    }()

    static let lifeSkills: [ActivityQuestion] = focusedLifeSkills + trickyLifeSkills + practicalLifeSkills + additionalEverydayLifeSkills + generatedLifeSkills + baseLifeSkills + teenLifeSkills

    static func balancedLifeSkillsChoice(_ choice: String, among choices: [String]) -> String {
        let cleanChoice = choice.trimmingCharacters(in: .whitespacesAndNewlines)
        let wordCount: (String) -> Int = { value in
            value.split { $0.isWhitespace || $0.isPunctuation }.count
        }
        let longest = choices.map(wordCount).max() ?? wordCount(cleanChoice)
        var result = cleanChoice
        // Reduce the obvious word-count clue without changing the answer's core meaning.
        if longest - wordCount(cleanChoice) >= 3 {
            result += " — вариант для этой ситуации"
        }
        if let last = result.last, !" .!?…".contains(last) {
            result += "."
        }
        return result
    }

    static func lifeSkillsIndices(for difficulty: Int) -> [Int] {
        let a = focusedLifeSkills.count
        let b = a + trickyLifeSkills.count
        let c = b + practicalLifeSkills.count
        let d = c + additionalEverydayLifeSkills.count
        let e = d + generatedLifeSkills.count
        let f = e + baseLifeSkills.count
        let g = f + teenLifeSkills.count
        let tier = min(3, max(1, difficulty))
        let generated = (d..<e).filter { ($0 - d) % 3 + 1 == tier }
        let teenQuestions = tier == 3 ? Array(f..<g) : []
        if tier == 1 {
            return Array(0..<a) + Array(b..<c) + generated + Array(e..<f)
        }
        if tier == 2 {
            return Array(a..<b) + Array(c..<d) + generated + Array(e..<f)
        }
        return Array(a..<b) + Array(c..<d) + generated + Array(e..<f) + teenQuestions
    }
}

struct MonthlyStats: Codable, Identifiable {
    var monthKey: String
    var correct: Int
    var incorrect: Int
    var bestStreak: Int
    var days: [DayStats]
    var id: String { monthKey }
    var total: Int { correct + incorrect }
    var accuracy: Int { total == 0 ? 0 : Int((Double(correct) / Double(total) * 100).rounded()) }
}

@MainActor
final class StatsStore: ObservableObject {
    @Published var stats: TrainerStats
    @Published private(set) var monthlyHistory: [MonthlyStats]
    private let key = "MathTrainer.Stats.v2"
    private let monthlyHistoryKey = "MathTrainer.Stats.MonthlyHistory.v1"
    private let currentMonthStorageKey = "MathTrainer.Stats.CurrentMonth.v1"
    private var currentMonthKey: String

    init() {
        let defaults = UserDefaults.standard
        let loadedStats: TrainerStats
        if let data = defaults.data(forKey: "MathTrainer.Stats.v2"),
           let decoded = try? JSONDecoder().decode(TrainerStats.self, from: data) {
            loadedStats = decoded
        } else {
            loadedStats = TrainerStats()
        }
        if let data = defaults.data(forKey: "MathTrainer.Stats.MonthlyHistory.v1"),
           let decoded = try? JSONDecoder().decode([MonthlyStats].self, from: data) {
            monthlyHistory = decoded
        } else {
            monthlyHistory = []
        }
        stats = loadedStats
        let nowKey = Self.monthKey(Date())
        let storedMonth = defaults.string(forKey: currentMonthStorageKey)
        let lastRecordedMonth = loadedStats.days.map { String($0.date.prefix(7)) }.filter { $0.count == 7 }.max()
        currentMonthKey = storedMonth ?? lastRecordedMonth ?? nowKey

        if storedMonth == nil {
            migrateLegacyStats(to: nowKey, oldStats: loadedStats)
        } else if currentMonthKey != nowKey {
            archiveCurrentMonth()
            beginMonth(nowKey)
        } else {
            // Discard any stray day rows from other months without deleting their history.
            let thisMonthDays = stats.days.filter { $0.date.hasPrefix(nowKey) }
            if thisMonthDays.count != stats.days.count {
                archiveDaysOutsideCurrentMonth(nowKey: nowKey)
                stats.days = thisMonthDays
                stats.correct = thisMonthDays.reduce(0) { $0 + $1.correct }
                stats.incorrect = thisMonthDays.reduce(0) { $0 + $1.incorrect }
                stats.currentStreak = 0
                stats.bestStreak = thisMonthDays.isEmpty ? 0 : stats.bestStreak
            }
        }
        currentMonthKey = nowKey
        defaults.set(nowKey, forKey: currentMonthStorageKey)
        persistStats()
        persistMonthlyHistory()
    }

    /// Combines existing lifetime/day-based data into monthly buckets the first time
    /// the app with monthly stats is launched.
    private func migrateLegacyStats(to nowKey: String, oldStats: TrainerStats) {
        let grouped = Dictionary(grouping: oldStats.days) { String($0.date.prefix(7)) }
        let latestDay = oldStats.days.map(\.date).max()
        var migrated: [MonthlyStats] = []
        for (month, days) in grouped where month.count == 7 && month != nowKey {
            migrated.append(MonthlyStats(
                monthKey: month,
                correct: days.reduce(0) { $0 + $1.correct },
                incorrect: days.reduce(0) { $0 + $1.incorrect },
                bestStreak: 0,
                days: days.sorted { $0.date > $1.date }
            ))
        }
        // The active month stays in the live dashboard. Older months are archived.
        let activeDays = oldStats.days.filter { $0.date.hasPrefix(nowKey) }.sorted { $0.date > $1.date }
        if !activeDays.isEmpty {
            stats.days = activeDays
            stats.correct = activeDays.reduce(0) { $0 + $1.correct }
            stats.incorrect = activeDays.reduce(0) { $0 + $1.incorrect }
            stats.bestStreak = oldStats.bestStreak
            stats.currentStreak = latestDay?.hasPrefix(nowKey) == true ? oldStats.currentStreak : 0
        } else if oldStats.days.isEmpty && oldStats.total > 0 {
            // Early versions might have counters but no daily breakdown; preserve them as current.
            stats = oldStats
        } else {
            stats.correct = 0
            stats.incorrect = 0
            stats.currentStreak = 0
            stats.bestStreak = 0
            stats.days = []
            stats.celebratedStreaks = []
        }
        for item in migrated { mergeIntoHistory(item) }
    }

    private func archiveDaysOutsideCurrentMonth(nowKey: String) {
        let groups = Dictionary(grouping: stats.days.filter { !$0.date.hasPrefix(nowKey) }) {
            String($0.date.prefix(7))
        }
        for (month, days) in groups where month.count == 7 {
            mergeIntoHistory(MonthlyStats(
                monthKey: month,
                correct: days.reduce(0) { $0 + $1.correct },
                incorrect: days.reduce(0) { $0 + $1.incorrect },
                bestStreak: 0,
                days: days.sorted { $0.date > $1.date }
            ))
        }
    }

    /// Public UI view: history plus the live month, combined with any manual-reset
    /// snapshots already saved for this same month.
    var monthSummaries: [MonthlyStats] {
        var items = monthlyHistory
        if stats.total > 0 || !stats.days.isEmpty || stats.bestStreak > 0 {
            let active = MonthlyStats(
                monthKey: currentMonthKey,
                correct: stats.correct,
                incorrect: stats.incorrect,
                bestStreak: stats.bestStreak,
                days: stats.days
            )
            Self.merge(active, into: &items)
        }
        return items.sorted { $0.monthKey > $1.monthKey }
    }

    func record(correct isCorrect: Bool, grantDiamond: Bool = true) -> [String] {
        refreshMonthIfNeeded()
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
            if grantDiamond { let d = UserDefaults.standard; d.set(d.integer(forKey: "MathTrainer.GoldBalance.v1") + 1, forKey: "MathTrainer.GoldBalance.v1") }
            if grantDiamond {
                for milestone in [500, 1000, 1500, 2000, 2500, 3000]
                    where stats.diamonds >= milestone && !stats.celebratedDiamondMilestones.contains(milestone) {
                    stats.celebratedDiamondMilestones.append(milestone)
                }
            }
            stats.currentStreak += 1
            stats.bestStreak = max(stats.bestStreak, stats.currentStreak)

            if stats.currentStreak >= 5 && stats.currentStreak.isMultiple(of: 5)
                && !stats.celebratedStreaks.contains(stats.currentStreak) {
                stats.celebratedStreaks.append(stats.currentStreak)
                rewards.append("streak:\(stats.currentStreak)")
            }
            if grantDiamond {
                for milestone in [20, 50] where stats.diamonds >= milestone
                    && !stats.celebratedDiamondMilestones.contains(milestone) {
                    stats.celebratedDiamondMilestones.append(milestone)
                    rewards.append("diamonds:\(milestone)")
                }
            }
        } else {
            stats.incorrect += 1
            stats.currentStreak = 0
        }

        stats.days.sort { $0.date > $1.date }
        persistStats()
        return rewards
    }

    func addDiamonds(_ amount: Int) {
        guard amount > 0 else { return }
        stats.diamonds += amount
        for milestone in [500, 1000, 1500, 2000, 2500, 3000]
            where stats.diamonds >= milestone && !stats.celebratedDiamondMilestones.contains(milestone) {
            stats.celebratedDiamondMilestones.append(milestone)
        }
        persistStats()
    }

    func spendDiamonds(_ amount: Int) -> Bool {
        refreshMonthIfNeeded()
        guard amount > 0, stats.diamonds >= amount else { return false }
        stats.diamonds -= amount
        persistStats()
        return true
    }

    /// Starts a new active statistics period but never removes monthly history or diamonds.
    func resetCurrentMonthStats() {
        refreshMonthIfNeeded()
        archiveCurrentMonth()
        stats.correct = 0
        stats.incorrect = 0
        stats.currentStreak = 0
        stats.bestStreak = 0
        stats.days = []
        stats.celebratedStreaks = []
        persistStats()
        persistMonthlyHistory()
    }

    /// Also called on calendar-day notifications so an app left open overnight rolls over.
    func refreshMonthIfNeeded() {
        let nowKey = Self.monthKey(Date())
        guard nowKey != currentMonthKey else { return }
        archiveCurrentMonth()
        beginMonth(nowKey)
        currentMonthKey = nowKey
        UserDefaults.standard.set(nowKey, forKey: currentMonthStorageKey)
        persistStats()
        persistMonthlyHistory()
    }

    private func archiveCurrentMonth() {
        guard stats.total > 0 || !stats.days.isEmpty || stats.bestStreak > 0 else { return }
        mergeIntoHistory(MonthlyStats(
            monthKey: currentMonthKey,
            correct: stats.correct,
            incorrect: stats.incorrect,
            bestStreak: stats.bestStreak,
            days: stats.days
        ))
        persistMonthlyHistory()
    }

    private func beginMonth(_ month: String) {
        stats.correct = 0
        stats.incorrect = 0
        stats.currentStreak = 0
        stats.bestStreak = 0
        stats.days = []
        stats.celebratedStreaks = []
        currentMonthKey = month
    }

    private func mergeIntoHistory(_ item: MonthlyStats) {
        Self.merge(item, into: &monthlyHistory)
        monthlyHistory.sort { $0.monthKey > $1.monthKey }
    }

    private static func merge(_ item: MonthlyStats, into items: inout [MonthlyStats]) {
        guard let index = items.firstIndex(where: { $0.monthKey == item.monthKey }) else {
            items.append(item)
            return
        }
        items[index].correct += item.correct
        items[index].incorrect += item.incorrect
        items[index].bestStreak = max(items[index].bestStreak, item.bestStreak)
        var daysByDate = Dictionary(uniqueKeysWithValues: items[index].days.map { ($0.date, $0) })
        for day in item.days {
            if var old = daysByDate[day.date] {
                old.correct += day.correct
                old.incorrect += day.incorrect
                daysByDate[day.date] = old
            } else {
                daysByDate[day.date] = day
            }
        }
        items[index].days = daysByDate.values.sorted { $0.date > $1.date }
    }

    private func persistStats() {
        if let data = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func persistMonthlyHistory() {
        if let data = try? JSONEncoder().encode(monthlyHistory) {
            UserDefaults.standard.set(data, forKey: monthlyHistoryKey)
        }
    }

    static func monthKey(_ date: Date) -> String {
        let p = Calendar.current.dateComponents([.year, .month], from: date)
        return String(format: "%04d-%02d", p.year ?? 0, p.month ?? 0)
    }

    static func displayMonth(_ key: String) -> String {
        let parts = key.split(separator: "-")
        guard parts.count == 2, let year = Int(parts[0]), let month = Int(parts[1]),
              (1...12).contains(month) else { return key }
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        guard let date = Calendar.current.date(from: components) else { return key }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date)
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
private enum AppFontScale {
    static var factor: CGFloat {
        let saved = UserDefaults.standard.double(forKey: "MathTrainer.FontScale.Global.v1")
        return saved > 0 ? CGFloat(saved) : 1.0
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
    case mentor = "Мой наставник"
    case detective = "Ежедневный детектив"
    case memory = "Тренировка памяти"
    case lifeSkills = "Навыки жизни"
    case mistakeReview = "Повторить ошибки"
    case olympiad = "Олимпиада"
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
        case .detective: return "magnifyingglass"
        case .memory: return "brain.head.profile"
        case .lifeSkills: return "lightbulb.max.fill"
        case .mistakeReview: return "arrow.uturn.backward.circle.fill"
        case .olympiad: return "trophy.circle.fill"
        case .statistics: return "chart.bar.fill"
        case .mentor: return "graduationcap.fill"
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
    case coral = "Коралловая"
    case teal = "Бирюзовая"
    case denim = "Джинсовая"
    case amber = "Янтарная"
    case berry = "Ягодная"
    case darkRuby = "Лаванда на графите"
    case darkForest = "Мята на графите"
    case darkOcean = "Северное сияние"
    case darkGraphite = "Космический синий"
    case darkAmber = "Ночная роза"
    case gradientLavender = "Лавандовый градиент"
    case gradientOcean = "Морской градиент"
    case gradientSunset = "Градиент заката"
    case gradientMint = "Мятный градиент"
    case gradientBerry = "Ягодный градиент"
    case lightMidnight = "Светлая с тёмными блоками — индиго"
    case lightForest = "Светлая с тёмными блоками — лес"
    case lightOcean = "Светлая с тёмными блоками — океан"
    case lightBerry = "Светлая с тёмными блоками — ягода"
    case lightGraphite = "Светлая с тёмными блоками — графит"

    // Legacy cases remain valid for saved preferences, but only distinct themes
    // are offered in Settings.
    static var selectableThemes: [AppTheme] {
        [.lilac, .ocean, .mint, .peach, .night, .rose, .forest, .sky, .sunshine, .galaxy,
         .coral, .teal, .denim, .amber, .berry, .darkRuby, .darkForest, .darkOcean, .darkGraphite, .darkAmber]
    }

    var paletteBase: AppTheme {
        switch self {
        case .gradientLavender, .lightMidnight: .lilac
        case .gradientOcean, .lightOcean: .ocean
        case .gradientSunset: .peach
        case .gradientMint, .lightForest: .mint
        case .gradientBerry, .lightBerry: .berry
        case .lightGraphite: .denim
        default: self
        }
    }
    var id: String { rawValue }
    var isDark: Bool { switch self { case .darkRuby, .darkForest, .darkOcean, .darkGraphite, .darkAmber: true; default: false } }
    var darkText: Color { Color(red: 0.96, green: 0.97, blue: 1) }
    var darkAccent: Color {
        switch self {
        case .darkRuby: Color(red: 0.78, green: 0.52, blue: 1)
        case .darkForest: Color(red: 0.25, green: 0.88, blue: 0.72)
        case .darkOcean: Color(red: 0.38, green: 0.66, blue: 1)
        case .darkGraphite: Color(red: 0.63, green: 0.57, blue: 1)
        case .darkAmber: Color(red: 1, green: 0.48, blue: 0.62)
        default: Color(red: 0.72, green: 0.56, blue: 1)
        }
    }
    var darkPink: Color {
        switch self {
        case .darkRuby: Color(red: 0.66, green: 0.34, blue: 0.86)
        case .darkForest: Color(red: 0.10, green: 0.62, blue: 0.49)
        case .darkOcean: Color(red: 0.22, green: 0.40, blue: 0.80)
        case .darkGraphite: Color(red: 0.39, green: 0.30, blue: 0.67)
        case .darkAmber: Color(red: 0.69, green: 0.20, blue: 0.39)
        default: darkAccent
        }
    }
    var darkPanel: Color {
        switch self {
        case .darkRuby: Color(red: 0.22, green: 0.17, blue: 0.31)
        case .darkForest: Color(red: 0.15, green: 0.25, blue: 0.23)
        case .darkOcean: Color(red: 0.15, green: 0.22, blue: 0.34)
        case .darkGraphite: Color(red: 0.20, green: 0.19, blue: 0.31)
        case .darkAmber: Color(red: 0.31, green: 0.17, blue: 0.24)
        default: Color(red: 0.10, green: 0.09, blue: 0.15)
        }
    }
    var darkLine: Color {
        switch self {
        case .darkRuby: Color(red: 0.72, green: 0.56, blue: 0.82)
        case .darkForest: Color(red: 0.48, green: 0.72, blue: 0.64)
        case .darkOcean: Color(red: 0.56, green: 0.66, blue: 0.84)
        case .darkGraphite: Color(red: 0.66, green: 0.59, blue: 0.81)
        case .darkAmber: Color(red: 0.76, green: 0.53, blue: 0.68)
        default: darkAccent.opacity(0.5)
        }
    }
    var darkMuted: Color { Color(red: 0.72, green: 0.75, blue: 0.82) }
    var darkGreen: Color { Color(red: 0.36, green: 0.92, blue: 0.61) }
    var darkRed: Color { Color(red: 1, green: 0.40, blue: 0.47) }
    var darkCanvasTop: Color {
        switch self {
        case .darkRuby: Color(red: 0.29, green: 0.23, blue: 0.39)
        case .darkForest: Color(red: 0.20, green: 0.31, blue: 0.28)
        case .darkOcean: Color(red: 0.20, green: 0.29, blue: 0.42)
        case .darkGraphite: Color(red: 0.27, green: 0.25, blue: 0.40)
        case .darkAmber: Color(red: 0.38, green: 0.22, blue: 0.31)
        default: darkPanel
        }
    }
    var darkCanvasMiddle: Color {
        switch self {
        case .darkRuby: Color(red: 0.19, green: 0.14, blue: 0.27)
        case .darkForest: Color(red: 0.12, green: 0.22, blue: 0.19)
        case .darkOcean: Color(red: 0.12, green: 0.19, blue: 0.31)
        case .darkGraphite: Color(red: 0.18, green: 0.17, blue: 0.29)
        case .darkAmber: Color(red: 0.27, green: 0.13, blue: 0.21)
        default: darkPanel
        }
    }
    var darkCanvasBottom: Color { darkPanel }
    var darkSidebarTop: Color { darkPanel }
    var darkSidebarBottom: Color { darkCanvasBottom }
    var darkQuizTop: Color { darkPanel }
    var darkQuizBottom: Color { darkCanvasMiddle }
    var darkQuizGlow: Color { darkAccent.opacity(0.42) }
}
private struct AppPalette {
    let theme: AppTheme
    var isDark: Bool { theme.isDark }
    var cardSurface: Color { theme.isDark ? theme.darkPanel : .white }
    private func c(_ r: Double, _ g: Double, _ b: Double) -> Color { Color(red:r, green:g, blue:b) }
    var ink: Color { if theme.isDark { return theme.darkText }; return switch theme.paletteBase {  case .lilac:c(0.20,0.15,0.39); case .ocean:c(0.10,0.22,0.38); case .mint:c(0.12,0.32,0.29); case .peach:c(0.42,0.23,0.24); case .night:c(0.2,0.15,0.39); case .rose:c(0.45,0.19,0.27); case .forest:c(0.08,0.35,0.265); case .sky:c(0.075,0.245,0.415); case .sunshine:c(0.465,0.25,0.2); case .galaxy:c(0.16,0.13,0.3); case .coral:c(0.39,0.15,0.16); case .teal:c(0.09,0.26,0.29); case .denim:c(0.14,0.24,0.38); case .amber:c(0.36,0.24,0.08); case .berry:c(0.39,0.14,0.27); default: theme.darkText } }
    var purple: Color { if theme.isDark { return theme.darkAccent }; return switch theme.paletteBase {  case .lilac:c(0.56,0.37,0.83); case .ocean:c(0.23,0.46,0.76); case .mint:c(0.19,0.56,0.48); case .peach:c(0.80,0.42,0.42); case .night:c(0.62,0.48,0.94); case .rose:c(0.83,0.38,0.45); case .forest:c(0.15,0.59,0.455); case .sky:c(0.205,0.485,0.795); case .sunshine:c(0.845,0.44,0.38); case .galaxy:c(0.585,0.495,0.985); case .coral:c(0.73,0.27,0.27); case .teal:c(0.10,0.47,0.50); case .denim:c(0.22,0.41,0.65); case .amber:c(0.70,0.42,0.10); case .berry:c(0.66,0.25,0.43); default: theme.darkAccent } }
    var lilac: Color { if theme.isDark { return theme.darkAccent }; return switch theme.paletteBase {  case .lilac:c(0.76,0.65,0.96); case .ocean:c(0.62,0.82,0.98); case .mint:c(0.58,0.84,0.75); case .peach:c(1,0.70,0.54); case .night:c(0.42,0.30,0.75); case .rose:c(1,0.66,0.57); case .forest:c(0.54,0.87,0.725); case .sky:c(0.595,0.845,1); case .sunshine:c(1,0.72,0.5); case .galaxy:c(0.385,0.315,0.795); case .coral:c(0.94,0.54,0.43); case .teal:c(0.43,0.77,0.75); case .denim:c(0.50,0.70,0.88); case .amber:c(0.94,0.69,0.34); case .berry:c(0.86,0.49,0.67); default: theme.darkAccent } }
    var pink: Color { if theme.isDark { return theme.darkPink }; return switch theme.paletteBase {  case .lilac:c(0.96,0.70,0.86); case .ocean:c(0.63,0.88,0.94); case .mint:c(0.74,0.92,0.83); case .peach:c(1,0.75,0.66); case .night:c(0.83,0.45,0.75); case .rose:c(1,0.71,0.69); case .forest:c(0.7,0.95,0.805); case .sky:c(0.605,0.905,0.975); case .sunshine:c(1,0.77,0.62); case .galaxy:c(0.795,0.465,0.795); case .coral:c(0.97,0.60,0.50); case .teal:c(0.54,0.82,0.78); case .denim:c(0.59,0.78,0.92); case .amber:c(0.98,0.75,0.43); case .berry:c(0.91,0.57,0.73); default: theme.darkPink } }
    var palePink: Color { if theme.isDark { return theme.darkPanel }; return switch theme.paletteBase {  case .lilac:c(1,0.92,0.97); case .ocean:c(0.91,0.97,1); case .mint:c(0.91,0.98,0.94); case .peach:c(1,0.94,0.88); case .night:c(0.96,0.93,0.99); case .rose:c(1,0.9,0.91); case .forest:c(0.87,1,0.915); case .sky:c(0.885,0.995,1); case .sunshine:c(1,0.96,0.84); case .galaxy:c(0.96,0.94,1); case .coral:c(0.99,0.89,0.84); case .teal:c(0.88,0.96,0.94); case .denim:c(0.88,0.93,0.98); case .amber:c(1,0.94,0.81); case .berry:c(0.98,0.89,0.93); default: theme.darkPanel } }
    var green: Color { if theme.isDark { return theme.darkGreen }; return switch theme.paletteBase {  case .lilac:c(0.20,0.66,0.43); case .ocean:c(0.15,0.62,0.52); case .mint:c(0.15,0.62,0.42); case .peach:c(0.28,0.61,0.40); case .night:c(0.44,0.82,0.60); case .rose:c(0.31,0.57,0.43); case .forest:c(0.11,0.65,0.395); case .sky:c(0.125,0.645,0.555); case .sunshine:c(0.325,0.63,0.36); case .galaxy:c(0.405,0.835,0.645); case .coral:c(0.22,0.56,0.37); case .teal:c(0.11,0.55,0.46); case .denim:c(0.16,0.53,0.69); case .amber:c(0.39,0.57,0.20); case .berry:c(0.22,0.56,0.40); default: theme.darkGreen } }
    var red: Color { if theme.isDark { return theme.darkRed }; return switch theme.paletteBase {  case .lilac:c(0.89,0.28,0.42); case .ocean:c(0.84,0.34,0.40); case .mint:c(0.83,0.31,0.44); case .peach:c(0.84,0.28,0.31); case .night:c(0.98,0.46,0.58); case .rose:c(0.87,0.24,0.34); case .forest:c(0.79,0.34,0.415); case .sky:c(0.815,0.365,0.435); case .sunshine:c(0.885,0.3,0.27); case .galaxy:c(0.945,0.475,0.625); case .coral:c(0.79,0.19,0.22); case .teal:c(0.79,0.29,0.31); case .denim:c(0.76,0.29,0.34); case .amber:c(0.79,0.32,0.14); case .berry:c(0.78,0.21,0.39); default: theme.darkRed } }
    var muted: Color { if theme.isDark { return theme.darkMuted }; return switch theme.paletteBase {  case .lilac:c(0.51,0.47,0.63); case .ocean:c(0.32,0.47,0.62); case .mint:c(0.30,0.50,0.46); case .peach:c(0.56,0.39,0.39); case .night:c(0.36,0.31,0.48); case .rose:c(0.59,0.35,0.42); case .forest:c(0.26,0.53,0.435); case .sky:c(0.295,0.495,0.655); case .sunshine:c(0.605,0.41,0.35); case .galaxy:c(0.34,0.29,0.48); case .coral:c(0.47,0.28,0.26); case .teal:c(0.27,0.43,0.42); case .denim:c(0.28,0.39,0.52); case .amber:c(0.51,0.37,0.21); case .berry:c(0.48,0.29,0.39); default: theme.darkMuted } }
    var line: Color { if theme.isDark { return theme.darkLine }; return switch theme.paletteBase {  case .lilac:c(0.88,0.82,0.97); case .ocean:c(0.75,0.87,0.98); case .mint:c(0.76,0.91,0.84); case .peach:c(0.97,0.82,0.72); case .night:c(0.39,0.34,0.53); case .rose:c(1,0.78,0.75); case .forest:c(0.72,0.94,0.815); case .sky:c(0.725,0.895,1); case .sunshine:c(1,0.84,0.68); case .galaxy:c(0.355,0.355,0.575); case .coral:c(0.92,0.67,0.60); case .teal:c(0.69,0.88,0.84); case .denim:c(0.70,0.82,0.94); case .amber:c(0.95,0.82,0.60); case .berry:c(0.94,0.73,0.82); default: theme.darkLine } }
    var canvasTop: Color { if theme.isDark { return theme.darkCanvasTop }; return switch theme.paletteBase {  case .lilac:c(0.88,0.82,0.98); case .ocean:c(0.83,0.92,1); case .mint:c(0.82,0.96,0.89); case .peach:c(1,0.86,0.75); case .night:c(0.9,0.87,0.98); case .rose:c(1,0.82,0.78); case .forest:c(0.78,0.99,0.865); case .sky:c(0.805,0.945,1); case .sunshine:c(1,0.88,0.71); case .galaxy:c(0.88,0.84,0.99); case .coral:c(0.98,0.75,0.65); case .teal:c(0.77,0.93,0.89); case .denim:c(0.78,0.88,0.97); case .amber:c(0.99,0.85,0.60); case .berry:c(0.96,0.79,0.87); default: theme.darkCanvasTop } }
    var canvasMiddle: Color { if theme.isDark { return theme.darkCanvasMiddle }; return switch theme.paletteBase {  case .lilac:c(1,0.91,0.96); case .ocean:c(0.90,0.97,1); case .mint:c(0.94,1,0.96); case .peach:c(1,0.94,0.87); case .night:c(0.98,0.95,1); case .rose:c(1,0.9,0.9); case .forest:c(0.9,1,0.935); case .sky:c(0.875,0.995,1); case .sunshine:c(1,0.96,0.83); case .galaxy:c(0.96,0.94,1); case .coral:c(1,0.90,0.83); case .teal:c(0.91,0.97,0.95); case .denim:c(0.91,0.95,0.99); case .amber:c(1,0.94,0.77); case .berry:c(0.99,0.90,0.94); default: theme.darkCanvasMiddle } }
    var canvasBottom: Color { if theme.isDark { return theme.darkCanvasBottom }; return switch theme.paletteBase {  case .lilac:c(0.96,0.91,1); case .ocean:c(0.88,0.95,1); case .mint:c(0.83,0.95,0.90); case .peach:c(1,0.89,0.81); case .night:c(0.93,0.9,0.99); case .rose:c(1,0.85,0.84); case .forest:c(0.79,0.98,0.875); case .sky:c(0.855,0.975,1); case .sunshine:c(1,0.91,0.77); case .galaxy:c(0.91,0.89,1); case .coral:c(0.97,0.77,0.68); case .teal:c(0.80,0.93,0.89); case .denim:c(0.80,0.89,0.97); case .amber:c(0.99,0.87,0.65); case .berry:c(0.96,0.80,0.88); default: theme.darkCanvasBottom } }
    var sidebarTop: Color { if theme.isDark { return theme.darkSidebarTop }; return switch theme.paletteBase {  case .lilac:.white; case .ocean:c(0.96,0.99,1); case .mint:c(0.98,1,0.98); case .peach:c(1,0.99,0.96); case .night:c(0.98,0.97,1); case .rose:c(1,0.95,0.99); case .forest:c(0.94,1,0.955); case .sky:c(0.935,1,1); case .sunshine:c(1,1,0.92); case .galaxy:c(0.97,0.96,1); case .coral:c(1,0.91,0.87); case .teal:c(0.93,0.98,0.96); case .denim:c(0.93,0.96,1); case .amber:c(1,0.96,0.85); case .berry:c(1,0.93,0.96); default: theme.darkSidebarTop } }
    var sidebarBottom: Color { if theme.isDark { return theme.darkSidebarBottom }; return switch theme.paletteBase {  case .lilac:c(0.95,0.90,1); case .ocean:c(0.87,0.94,1); case .mint:c(0.86,0.97,0.91); case .peach:c(1,0.90,0.81); case .night:c(0.91,0.88,0.99); case .rose:c(1,0.86,0.84); case .forest:c(0.82,1,0.885); case .sky:c(0.845,0.965,1); case .sunshine:c(1,0.92,0.77); case .galaxy:c(0.9,0.88,0.99); case .coral:c(0.97,0.78,0.69); case .teal:c(0.83,0.94,0.91); case .denim:c(0.82,0.90,0.97); case .amber:c(1,0.88,0.67); case .berry:c(0.97,0.82,0.90); default: theme.darkSidebarBottom } }
    var quizTop: Color { if theme.isDark { return theme.darkQuizTop }; return switch theme.paletteBase {  case .lilac:c(1,0.99,1); case .ocean:c(0.97,1,1); case .mint:c(0.99,1,0.99); case .peach:c(1,0.99,0.96); case .night:c(1,0.98,1); case .rose:c(1,0.95,0.99); case .forest:c(0.95,1,0.965); case .sky:c(0.945,1,1); case .sunshine:c(1,1,0.92); case .galaxy:c(0.99,0.98,1); case .coral:c(1,0.97,0.94); case .teal:c(0.97,1,0.99); case .denim:c(0.97,0.99,1); case .amber:c(1,0.99,0.91); case .berry:c(1,0.97,0.99); default: theme.darkQuizTop } }
    var quizBottom: Color { if theme.isDark { return theme.darkQuizBottom }; return switch theme.paletteBase {  case .lilac:c(1,0.91,0.96); case .ocean:c(0.87,0.96,1); case .mint:c(0.88,0.98,0.92); case .peach:c(1,0.88,0.78); case .night:c(0.88,0.83,0.98); case .rose:c(1,0.84,0.81); case .forest:c(0.84,1,0.895); case .sky:c(0.845,0.985,1); case .sunshine:c(1,0.9,0.74); case .galaxy:c(0.88,0.84,1); case .coral:c(0.99,0.82,0.75); case .teal:c(0.83,0.95,0.91); case .denim:c(0.82,0.91,0.98); case .amber:c(1,0.90,0.70); case .berry:c(0.98,0.83,0.91); default: theme.darkQuizBottom } }
    var quizGlow: Color { if theme.isDark { return theme.darkQuizGlow }; return switch theme.paletteBase {  case .lilac:c(0.94,0.88,0.98); case .ocean:c(0.66,0.87,0.98); case .mint:c(0.70,0.91,0.82); case .peach:c(1,0.76,0.63); case .night:c(0.42,0.32,0.62); case .rose:c(1,0.72,0.66); case .forest:c(0.66,0.94,0.795); case .sky:c(0.635,0.895,1); case .sunshine:c(1,0.78,0.59); case .galaxy:c(0.385,0.335,0.665); case .coral:c(0.90,0.52,0.43); case .teal:c(0.40,0.72,0.70); case .denim:c(0.42,0.62,0.83); case .amber:c(0.91,0.64,0.25); case .berry:c(0.81,0.40,0.61); default: theme.darkQuizGlow } }
    static func make(_ theme: AppTheme) -> AppPalette { AppPalette(theme: theme) }
}
private enum StudySubject: String, CaseIterable, Identifiable {
    case math = "Математика"
    case world = "Окружающий мир"
    case russian = "Русский язык"
    case english = "Английский язык"
    case tatar = "Татарский язык"
    case art = "Рисование"
    case chemistry = "Химия"
    case informatics = "Информатика"
    case pdd = "ПДД"
    case orthography = "Орфография"
    case geography = "География"
    case logic = "Логика"
    case biology = "Биология"
    case geometry = "Геометрия"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .math: "function"
        case .world: "leaf.fill"
        case .russian: "book.closed.fill"
        case .english: "globe"
        case .tatar: "textformat"
        case .art: "paintpalette.fill"
        case .chemistry: "testtube.2"
        case .informatics: "desktopcomputer"
        case .pdd: "car.side.fill"
        case .orthography: "character.book.closed.fill"
        case .geography: "globe.americas.fill"
        case .logic: "brain.head.profile"
        case .biology: "leaf"
        case .geometry: "cube.transparent.fill"
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
    static let all: [Achievement] = {
        let base: [Achievement] = [
            Achievement(id: "first-answer", title: "Первый шаг", detail: "Реши свой первый пример", emoji: "🧸"),
            Achievement(id: "ten-correct", title: "Первые 25", detail: "25 правильных ответов", emoji: "🎁"),
            Achievement(id: "twenty-correct", title: "Полсотни", detail: "50 правильных ответов", emoji: "🪀"),
            Achievement(id: "fifty-correct", title: "Сотня знатока", detail: "100 правильных ответов", emoji: "🪇"),
            Achievement(id: "five-streak", title: "Десять подряд", detail: "10 верных ответов подряд", emoji: "🪈"),
            Achievement(id: "fifteen-streak", title: "Серия из 20", detail: "20 верных ответов подряд", emoji: "🪕"),
            Achievement(id: "twenty-streak", title: "Серия из 30", detail: "30 верных ответов подряд", emoji: "🪗"),
            Achievement(id: "daily-solver", title: "Учебный марафон", detail: "30 ответов за один день", emoji: "🪘"),
            Achievement(id: "three-days", title: "Пять учебных дней", detail: "Занимайся в 5 разных дней", emoji: "🪙"),
            Achievement(id: "five-days", title: "Десять учебных дней", detail: "Занимайся в 10 разных дней", emoji: "🧶"),
            Achievement(id: "perfect-ten", title: "Без ошибок", detail: "25 ответов без ошибок", emoji: "🧵"),
            Achievement(id: "accuracy-90", title: "Меткий ответ", detail: "Точность не ниже 90% после 100 ответов", emoji: "🪡"),
            Achievement(id: "hundred-answers", title: "Четверть тысячи", detail: "250 решённых примеров", emoji: "🧷"),
            Achievement(id: "five-hundred-answers", title: "Большой ум", detail: "1000 решённых примеров", emoji: "🧺"),
            Achievement(id: "diamond-100", title: "Алмазный запас", detail: "Накопи 150 алмазов", emoji: "🪣")
        ]
        let extra: [Achievement] = (1...100).map { number in
            let id: String
            let title: String
            let detail: String
            let emojis = ["🏅", "🌈", "🦄", "🐉", "🎯", "👑", "🪁", "🎨", "🎸", "🎹", "🎺", "🥁", "🎻", "🎲", "🧩", "🪄", "🧿", "🔮", "🪬", "🪷", "🌻", "🌼", "🌺", "🌷", "🌹", "🪻", "🍀", "🌴", "🌵", "🌲", "🌳", "🍄", "🌾", "🌿", "🍁", "🍂", "🍃", "🌙", "☀️", "🌤️", "🌦️", "🌧️", "⛈️", "❄️", "☃️", "🌊", "🔥", "⚡️", "☄️", "🪐", "🌍", "🌎", "🌏", "🌋", "🏔️", "⛰️", "🏕️", "🏝️", "🏜️", "🏖️", "🛸", "🚀", "🛰️", "✈️", "🚁", "🚂", "🚲", "🛶", "⛵", "🚤", "🚢", "🚗", "🚕", "🚌", "🚎", "🚓", "🚑", "🚒", "🚜", "🏎️", "🏍️", "🛵", "🚠", "🚡", "🛞", "⚽", "🏀", "🏈", "⚾", "🥎", "🎾", "🏐", "🏉", "🥏", "🎳", "🏓", "🏸", "🥊", "🥋", "⛸️"]
            switch number {
            case 1...25:
                let goal = number * 25
                id = "extra-total-\(goal)"
                title = ["Любознательный", "Исследователь", "Умный шаг", "Знаток", "Покоритель задач"][number % 5] + " №\(number)"
                detail = "Ответь на \(goal) вопросов в обычных занятиях и олимпиадах"
            case 26...50:
                let goal = (number - 25) * 15
                id = "extra-correct-\(goal)"
                title = ["Меткий ум", "Мастер точности", "Верный путь", "Золотой ответ", "Профи"][number % 5] + " №\(number)"
                detail = "Набери \(goal) правильных ответов"
            case 51...70:
                let goal = number - 45
                id = "extra-streak-\(goal)"
                title = "Огненная серия №\(number)"
                detail = "Дай \(goal) правильных ответов подряд"
            case 71...80:
                let level = number - 70
                let accuracy = 65 + level * 3
                let total = level * 25
                id = "extra-accuracy-\(accuracy)-\(total)"
                title = "Точность \(accuracy)%"
                detail = "Поддержи точность не ниже \(accuracy)% после \(total) ответов"
            case 81...91:
                let index = number - 81
                let subject = StudySubject.allCases[index].rawValue
                id = "extra-subject-\(index)-25"
                title = "Знаток: \(subject)"
                detail = "Реши 25 заданий по предмету «\(subject)»"
            case 92...97:
                let goals = [30, 60, 90, 120, 180, 240]
                let goal = goals[number - 92]
                id = "extra-active-minutes-\(goal)"
                title = "Время знаний: \(goal) мин"
                detail = "Проведи \(goal) минут активных занятий за компьютером"
            default:
                let goals = [1, 3, 5]
                let goal = goals[number - 98]
                id = "extra-olympiad-wins-\(goal)"
                title = "Олимпийская звезда ×\(goal)"
                detail = "Победи в олимпиаде \(goal) раз"
            }
            return Achievement(id: id, title: title, detail: detail, emoji: emojis[(number - 1) % emojis.count])
        }
        return base + extra
    }()
}
private struct Collectible: Identifiable {
    let id: String
    let title: String
    let detail: String
    let emoji: String

    var isRare: Bool {
        switch id {
        case "rainbow", "magic-star", "heart-gem", "dragon",
             "cosmic-unicorn", "rainbow-dragon", "gold-princess",
             "cosmic-mermaid", "rainbow-princess-pony",
             "rare-krosh", "rare-rainbow-unicorn", "rare-princess-pony":
            return true
        default:
            return false
        }
    }

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
            Collectible(id: "cat", title: "Котёнок", detail: "Самый любопытный в коллекции", emoji: "🐱"),
            Collectible(id: "rare-krosh", title: "Смешарик Крош 3D", detail: "Редкий коллекционный герой", emoji: "🐰"),
            Collectible(id: "rare-rainbow-unicorn", title: "Радужный единорог 3D", detail: "Редкая волшебная игрушка", emoji: "🦄"),
            Collectible(id: "rare-princess-pony", title: "Принцесса-пони 3D", detail: "Редкая игрушка из сказочной коллекции", emoji: "🦄")
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
            ("duck", "Утёнок", "🦆"), ("snail", "Улитка", "🐌"),
            ("pony", "Пони", "🐴"), ("rainbow-pony", "Радужный пони", "🦄"),
            ("princess", "Принцесса", "👸"), ("fairy", "Фея", "🧚"),
            ("smiley", "Смайлик", "😊"), ("heart-smiley", "Смайлик-сердечко", "🥰"),
            ("krosh", "Крош", "🐰"), ("nyusha", "Нюша", "🐷"),
            ("barash", "Бараш", "🐑"), ("pin", "Пин", "🐧"),
            ("losyash", "Лосяш", "🫎"), ("kar-karych", "Кар-Карыч", "🐦"),
            ("princess-pony", "Принцесса пони", "🦄"), ("mermaid", "Русалочка", "🧜"),
            ("red-panda", "Красная панда", "🐾"), ("axolotl", "Аксолотль", "🦎")
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
                            title: collection.id == "rainbow" ? (
                                mascot.id == "panda" ? "Радужная панда" :
                                mascot.id == "hedgehog" ? "Радужный ёжик" :
                                mascot.id == "fairy" ? "Радужная фея" :
                                "\(collection.name) \(mascot.title)"
                            ) : "\(collection.name) \(mascot.title)",
                            detail: collection.detail,
                            emoji: mascot.emoji)
            }
        }
        return legacy + themed
    }()
}

private struct Collectible3DView: View {
    let id: String
    let title: String
    let size: CGFloat
    var animated: Bool = true
    @State private var bounce = false
    private var key: String { (id + " " + title).lowercased() }
    private var symbol: String {
        if key.contains("единорог") || key.contains("unicorn") { return "sparkles" }
        if key.contains("пони") || key.contains("pony") || key.contains("принцесс") { return "crown.fill" }
        if key.contains("крош") || key.contains("bunny") || key.contains("зайч") || key.contains("крол") { return "hare.fill" }
        if key.contains("дракон") || key.contains("dragon") { return "flame.fill" }
        if key.contains("кот") || key.contains("cat") { return "cat.fill" }
        if key.contains("череп") || key.contains("turtle") { return "tortoise.fill" }
        if key.contains("коал") || key.contains("koala") { return "pawprint.fill" }
        if key.contains("планет") || key.contains("planet") || key.contains("космос") { return "globe.americas.fill" }
        if key.contains("робот") || key.contains("robot") { return "cpu.fill" }
        if key.contains("серд") || key.contains("heart") { return "heart.fill" }
        if key.contains("радуг") || key.contains("rainbow") { return "rainbow" }
        return "star.fill"
    }
    private var emoji: String {
        if key.contains("совён") || key.contains("совен") || key.contains("owl") { return "🦉" }
        if key.contains("крош") || key.contains("krosh") { return "🐰" }
        if key.contains("львён") || key.contains("львен") || key.contains("lion") { return "🦁" }
        // Distinct rare characters first: rare rewards must never fall back to a repeated mascot.
        if key.contains("rare-krosh") { return "🐰" }
        if key.contains("rare-rainbow-unicorn") { return "🦄" }
        if key.contains("rare-princess-pony") { return "🐴" }
        if key.contains("rainbow-princess-pony") { return "🦄" }
        if key.contains("cosmic-mermaid") { return "🧜" }
        if key.contains("gold-princess") { return "👸" }
        if key.contains("rainbow-dragon") { return "🐉" }
        if key.contains("cosmic-unicorn") { return "🦄" }
        if key.contains("heart-gem") { return "💎" }
        if key.contains("magic-star") { return "🌠" }
        // Радужные животные показывают самого персонажа, а не одну радугу.
        if key.contains("rainbow") && (key.contains("panda") || key.contains("панд")) { return "🐼" }
        if key.contains("rainbow") && (key.contains("hedgehog") || key.contains("ёжик") || key.contains("ежик")) { return "🦔" }
        if key.contains("rainbow") && (key.contains("fairy") || key.contains("фея")) { return "🧚" }
        if key.contains("rainbow") && (key.contains("dragon") || key.contains("дракон")) { return "🐉" }
        if key.contains("rainbow") && (key.contains("pony") || key.contains("пони")) { return "🦄" }
        if key.contains("rainbow") && (key.contains("unicorn") || key.contains("единорог")) { return "🦄" }
        if key.contains("rainbow") { return "🌈" }
        if key.contains("dragon") { return "🐉" }
        if key.contains("princess-pony") || key.contains("pony") { return "🐴" }
        if key.contains("unicorn") || key.contains("единорог") { return "🦄" }
        if key.contains("heart") || key.contains("серд") { return "💗" }
        if key.contains("magic-star") { return "🪄" }
        if key.contains("bunny-friend") { return "🐰" }
        if key.contains("медвед") || key.contains("мишка") || key.contains("bear") || key.contains("teddy") { return "🧸" }
        if key.contains("бабоч") || key.contains("butterfly") { return "🦋" }
        if key.contains("зай") || key.contains("крол") || key.contains("bunny") || key.contains("rabbit") { return "🐰" }
        if key.contains("кот") || key.contains("cat") { return "🐱" }
        if key.contains("собак") || key.contains("щен") || key.contains("dog") { return "🐶" }
        if key.contains("лиса") || key.contains("fox") { return "🦊" }
        if key.contains("панд") || key.contains("panda") { return "🐼" }
        if key.contains("динозав") || key.contains("dino") { return "🦕" }
        if key.contains("лягуш") || key.contains("frog") { return "🐸" }
        if key.contains("пчел") || key.contains("bee") { return "🐝" }
        if key.contains("пингвин") || key.contains("penguin") { return "🐧" }
        if key.contains("черепах") || key.contains("turtle") { return "🐢" }
        if key.contains("коал") || key.contains("koala") { return "🐨" }
        if key.contains("слон") || key.contains("elephant") { return "🐘" }
        if key.contains("жираф") || key.contains("giraffe") { return "🦒" }
        if key.contains("рыб") || key.contains("fish") { return "🐠" }
        if key.contains("звезд") || key.contains("star") { return "⭐️" }
        if key.contains("планет") || key.contains("космос") || key.contains("planet") { return "🪐" }
        if key.contains("робот") || key.contains("robot") { return "🤖" }
        if key.contains("цвет") || key.contains("flower") { return "🌸" }
        if key.contains("planet") { return "🪐" }
        return "🧸"
    }
    private var colors: [Color] {
        let hash = abs(key.unicodeScalars.reduce(0) { ($0 &* 31 &+ Int($1.value)) & 0x7fffffff })
        let palette: [[Color]] = [
            [Color(red: 0.99, green: 0.35, blue: 0.55), Color(red: 1.0, green: 0.73, blue: 0.25)],
            [Color(red: 0.36, green: 0.42, blue: 0.96), Color(red: 0.25, green: 0.78, blue: 0.95)],
            [Color(red: 0.13, green: 0.72, blue: 0.49), Color(red: 0.66, green: 0.88, blue: 0.35)],
            [Color(red: 0.65, green: 0.36, blue: 0.94), Color(red: 0.98, green: 0.42, blue: 0.72)],
            [Color(red: 1.0, green: 0.55, blue: 0.25), Color(red: 0.97, green: 0.31, blue: 0.38)]
        ]
        return palette[hash % palette.count]
    }
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.23, style: .continuous).fill(colors[0].opacity(0.07))
            Circle().fill(colors[1].opacity(0.11)).frame(width: size * 0.73, height: size * 0.73).offset(x: size * 0.20, y: -size * 0.20)
            Circle().fill(colors[0].opacity(0.085)).frame(width: size * 0.62, height: size * 0.62).offset(x: -size * 0.22, y: size * 0.23)
            Text(emoji).font(.system(size: size * 0.62 * AppFontScale.factor)).shadow(color: colors[0].opacity(0.13), radius: 3, y: 2)
                .padding(size * 0.12).background(colors[1].opacity(0.09), in: RoundedRectangle(cornerRadius: size * 0.22, style: .continuous))
            if key.contains("rainbow") && (key.contains("panda") || key.contains("панд") || key.contains("hedgehog") || key.contains("ёжик") || key.contains("ежик") || key.contains("fairy") || key.contains("фея")) {
                Text("🌈").font(.system(size: size * 0.25 * AppFontScale.factor)).rotationEffect(.degrees(-12))
                    .padding(3).background(.white.opacity(0.9), in: Circle())
                    .overlay(Circle().stroke(colors[0].opacity(0.35), lineWidth: 1))
                    .offset(x: size * 0.31, y: size * 0.28)
            }
            Image(systemName: "sparkle").font(.system(size: size * 0.16 * AppFontScale.factor, weight: .bold)).foregroundStyle(colors[1].opacity(0.8)).offset(x: size * 0.31, y: -size * 0.30)
        }
        .frame(width: size, height: size)
        .overlay(RoundedRectangle(cornerRadius: size * 0.23, style: .continuous).stroke(colors[0].opacity(0.28), lineWidth: 1.5))
        .scaleEffect(animated && bounce ? 1.035 : 1.0)
        .onAppear { guard animated else { return }; withAnimation(.easeInOut(duration: 1.7).repeatForever(autoreverses: true)) { bounce = true } }
        .accessibilityLabel(title)
    }
}

private struct Reward3DBadge: View {
    let symbol: String
    let tint: Color
    var size: CGFloat = 74
    var locked: Bool = false
    var fillProgress: Double = 1
    var artworkName: String? = nil

    private var progress: CGFloat { CGFloat(min(1, max(0, fillProgress))) }
    private var progressPercent: Int { Int((progress * 100).rounded()) }

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: locked
                    ? [Color.gray.opacity(0.24), Color.gray.opacity(0.10)]
                    : [tint.opacity(0.42), tint.opacity(0.12), Color.white.opacity(0.9)],
                    startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(color: tint.opacity(locked ? 0.02 : 0.28), radius: size * 0.12, x: 0, y: size * 0.07)

            // The progress indicator wraps around the whole medal, like a loading ring.
            Circle()
                .stroke(Color.black.opacity(locked ? 0.07 : 0.10), lineWidth: max(3, size * 0.065))
                .padding(size * 0.025)
            if !locked {
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(AngularGradient(colors: [tint, Color.yellow, tint], center: .center),
                            style: StrokeStyle(lineWidth: max(3, size * 0.065), lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .padding(size * 0.025)
                    .shadow(color: tint.opacity(0.5), radius: size * 0.045)
            }

            Circle()
                .stroke(LinearGradient(colors: [Color.white.opacity(0.95), tint.opacity(0.7), tint.opacity(0.35)],
                                       startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: max(2, size * 0.045))
                .padding(size * 0.105)
            Circle()
                .fill(LinearGradient(colors: locked
                    ? [Color.gray.opacity(0.18), Color.gray.opacity(0.08)]
                    : [tint.opacity(0.98), tint.opacity(0.68), Color(red: 0.20, green: 0.16, blue: 0.66)],
                    startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding(size * 0.17)
                .overlay {
                    Circle().stroke(Color.white.opacity(locked ? 0.12 : 0.8), lineWidth: max(1, size * 0.018)).padding(size * 0.19)
                }

            if !locked {
                Image(systemName: "sparkles")
                    .font(.system(size: size * 0.13 * AppFontScale.factor, weight: .black))
                    .foregroundStyle(Color.white.opacity(0.95))
                    .offset(x: size * 0.23, y: -size * 0.25)
                Image(systemName: "sparkle")
                    .font(.system(size: size * 0.09 * AppFontScale.factor, weight: .black))
                    .foregroundStyle(Color.yellow)
                    .offset(x: -size * 0.25, y: size * 0.13)
            }

            if let artworkName,
               let imageURL = Bundle.main.url(forResource: artworkName, withExtension: "png"),
               let medalImage = NSImage(contentsOf: imageURL) {
                Image(nsImage: medalImage)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
                    .frame(width: size * 0.78, height: size * 0.78)
                    .saturation(locked ? 0.18 : 1)
                    .opacity(locked ? 0.58 : 1)
                    .offset(y: -size * 0.12)
            } else {
                Image(systemName: symbol)
                    .font(.system(size: size * 0.43 * AppFontScale.factor, weight: .black))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(locked ? Color.gray.opacity(0.35) : Color.white, locked ? Color.gray.opacity(0.25) : Color.white.opacity(0.92))
                    .shadow(color: .black.opacity(locked ? 0 : 0.25), radius: size * 0.035, x: 0, y: size * 0.035)
                    .offset(y: -size * 0.035)
            }

            if locked {
                Image(systemName: "lock.fill")
                    .font(.system(size: size * 0.23 * AppFontScale.factor, weight: .black))
                    .foregroundStyle(Color.gray.opacity(0.85))
                    .padding(size * 0.10)
                    .background(Color.white.opacity(0.92), in: Circle())
                    .offset(y: size * 0.24)
            } else {
                // Percentage is always legible at the bottom center of the medal.
                Text("\(progressPercent)%")
                    .font(.system(size: max(10, size * 0.155) * AppFontScale.factor, weight: .black, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, size * 0.07)
                    .padding(.vertical, size * 0.025)
                    .background(Color.black.opacity(0.58), in: Capsule())
                    .overlay(Capsule().stroke(Color.white.opacity(0.85), lineWidth: max(0.8, size * 0.012)))
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
                    .offset(y: size * 0.34)
            }
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(locked ? "Награда закрыта" : "\(progressPercent)% прогресса")
    }
}

private struct ReleaseNote: Codable, Identifiable {
    let version: String
    let date: String
    let title: String
    let changes: [String]
    var id: String { version }
}

struct ContentView: View {
    @AppStorage("MathTrainer.Theme") private var themeName = AppTheme.lilac.rawValue
    @AppStorage("MathTrainer.SelectedSubject") private var selectedSubjectName = StudySubject.math.rawValue
    @AppStorage("MathTrainer.CurrentProblem.v2") private var savedProblemJSON = ""
    @AppStorage("MathTrainer.CurrentProblemSubject.v2") private var savedProblemSubject = ""
    @AppStorage("MathTrainer.UnlockedAchievements") private var unlockedAchievementStorage = ""
    @AppStorage("MathTrainer.AchievementThresholdsVersion") private var achievementThresholdsVersion = 0
    @AppStorage("MathTrainer.CorrectQuestions") private var correctQuestionStorage = "{}"
    @AppStorage("MathTrainer.RandomCollectibles") private var randomCollectiblesStorage = ""
    @AppStorage("MathTrainer.ShopPurchases") private var shopPurchasesStorage = ""
    @AppStorage("MathTrainer.GoldBalance.v1") private var goldBalance = 0
    @AppStorage("MathTrainer.RoomPlacedItems.v1") private var roomPlacedItemsStorage = ""
    @AppStorage("MathTrainer.ShopPrices.v3") private var shopPricesStorage = ""
    @AppStorage("MathTrainer.ReleaseNotes.v1") private var releaseNotesStorage = ""
    @AppStorage("MathTrainer.ScreenContrast.v1") private var screenContrast = 1.15
    @AppStorage("MathTrainer.ThemeBrightness.v1") private var themeBrightness = 0.0
    @AppStorage("MathTrainer.FontScale.Global.v1") private var fontScaleGlobal = 1.0
    @AppStorage("MathTrainer.FontScale.Headings.v1") private var fontScaleH1 = 1.0
    @AppStorage("MathTrainer.FontScale.H2.v1") private var fontScaleH2 = 1.0
    @AppStorage("MathTrainer.FontScale.H3.v1") private var fontScaleH3 = 1.0
    @AppStorage("MathTrainer.FontScale.H4.v1") private var fontScaleH4 = 1.0
    @AppStorage("MathTrainer.FontScale.H5.v1") private var fontScaleH5 = 1.0
    @AppStorage("MathTrainer.FontScale.H6.v1") private var fontScaleH6 = 1.0
    @AppStorage("MathTrainer.FontScale.H7.v1") private var fontScaleH7 = 1.0
    @AppStorage("MathTrainer.FontScale.Body.v1") private var fontScaleBody = 1.0
    @AppStorage("MathTrainer.FontScale.Hints.v1") private var fontScaleHints = 1.0
    @AppStorage("MathTrainer.Difficulty.v1") private var difficultyLevel = 1
    @AppStorage("MathTrainer.SubjectPerformance.v1") private var subjectPerformanceStorage = ""
    @AppStorage("MathTrainer.TopicPerformance.v1") private var topicPerformanceStorage = "{}"
    @AppStorage("MathTrainer.ActiveSecondsByDay.v1") private var activeSecondsStorage = ""
    @AppStorage("MathTrainer.ActiveSecondsBySubject.v1") private var activeSecondsBySubjectStorage = "{}"
    @AppStorage("MathTrainer.OlympiadWins.v1") private var olympiadWins = 0
    @AppStorage("MathTrainer.Mistakes.v1") private var mistakesStorage = ""
    @AppStorage("MathTrainer.ReviewAttempts.v1") private var reviewAttemptsStorage = "[]"
    @AppStorage("MathTrainer.ReviewMastery.v1") private var reviewMasteryStorage = "{}"
    @AppStorage("MathTrainer.DetectiveRewardDate.v1") private var detectiveRewardDate = ""
    @AppStorage("MathTrainer.DetectiveBestScore.v1") private var detectiveBestScore = 0
    @AppStorage("MathTrainer.MemoryBestLevel.v1") private var memoryBestLevel = 0
    @AppStorage("MathTrainer.MemoryCategoryStats.v1") private var memoryCategoryStatsStorage = ""
    @AppStorage("MathTrainer.LifeSkillsBestScore.v1") private var lifeSkillsBestScore = 0
    @AppStorage("MathTrainer.DetectiveAttempts.v1") private var detectiveTotalAttempts = 0
    @AppStorage("MathTrainer.DetectiveCorrect.v1") private var detectiveTotalCorrect = 0
    @AppStorage("MathTrainer.DetectiveWrong.v1") private var detectiveTotalWrong = 0
    @AppStorage("MathTrainer.DetectiveStreak.v1") private var detectiveCurrentStreak = 0
    @AppStorage("MathTrainer.DetectiveBestStreak.v1") private var detectiveBestStreak = 0
    @AppStorage("MathTrainer.LifeSkillsAttempts.v1") private var lifeSkillsTotalAttempts = 0
    @AppStorage("MathTrainer.LifeSkillsCorrect.v1") private var lifeSkillsTotalCorrect = 0
    @AppStorage("MathTrainer.LifeSkillsWrong.v1") private var lifeSkillsTotalWrong = 0
    @AppStorage("MathTrainer.LifeSkillsStreak.v2") private var lifeSkillsCurrentStreak = 0
    @AppStorage("MathTrainer.LifeSkillsBestStreak.v1") private var lifeSkillsBestStreak = 0
    @AppStorage("MathTrainer.LifeSkillsDifficulty.v2") private var lifeSkillsDifficultyLevel = 1
    @AppStorage("MathTrainer.LifeSkillsReview.v1") private var lifeSkillsReviewStorage = "[]"
    @AppStorage("MathTrainer.MentorActivityDates.v1") private var mentorActivityDatesStorage = "[]"
    @AppStorage("MathTrainer.MentorAvatar.v1") private var mentorAvatarEmoji = "🦉"
    @AppStorage("MathTrainer.AdaptiveDifficultyHistory.v1") private var adaptiveDifficultyHistoryStorage = "{}"
    @State private var mentorCalendarMonth = Date()
    @AppStorage("MathTrainer.CorrectAnswersLifetime.v1") private var lifetimeCorrectAnswers = 0
    @StateObject private var store = StatsStore()
    @State private var problem = ProblemGenerator.next()
    @State private var answer = ""
    @State private var selected: AppSection = .task
    @State private var mentorSpeechSynthesizer = AVSpeechSynthesizer()
    @State private var lastMentorGreeting = ""
    @State private var answerState: AnswerState = .neutral
    @State private var currentTip = "Внимательно прочитай условие и проверь ответ."
    @State private var hoveredStatsSubject: String? = nil
    @State private var showSubjectPicker = false
    @State private var showResetStatsConfirmation = false
    @State private var seenQuestionTexts: [String: Set<String>] = [:]
    @State private var showBunny = false
    @State private var celebration: String?
    @State private var showCelebration = false
    @State private var celebrationTokens: [CelebrationToken] = []
    @State private var sessionSeconds = 0
    @State private var lastMouseMovementAt = Date()
    @State private var lastMouseLocation = NSEvent.mouseLocation
    @State private var olympiadStarted = false
    @State private var olympiadPaused = false
    @State private var olympiadFinished = false
    @State private var olympiadWon = false
    @State private var olympiadSecondsRemaining = 1800
    @State private var olympiadDurationMinutes = 30
    @State private var olympiadTargetCount = 60
    @State private var olympiadCompleted = 0
    @State private var olympiadProblem = ProblemGenerator.next()
    @State private var olympiadOptions: [String] = []
    @State private var olympiadSubject = StudySubject.math
    @State private var olympiadSubjectOrder: [StudySubject] = []
    @State private var expandedMistakeSubject: String? = nil
    @State private var expandedAnalyticsSubject: String? = nil
    @State private var expandedAnalyticsTopic: String? = nil
    @State private var reviewingMistakeID: String? = nil
    @State private var activeUnifiedReviewID: String? = nil
    @State private var unifiedReviewSelectedAnswer: String? = nil
    @State private var olympiadAnswer = ""
    @State private var olympiadFeedback = ""
    @State private var detectiveQuestions = Array(ActivityQuestionBank.detective.shuffled().prefix(5))
    @State private var detectiveIndex = 0
    @State private var detectiveScore = 0
    @State private var detectiveSelectedAnswer: String? = nil
    @State private var detectiveShowDetailedError = false
    @State private var detectiveFinished = false
    @State private var memoryLevel = 1
    @State private var memoryRound = 0
    @State private var memorySelectedTypes: Set<String> = ["Картинки"]
    @State private var memorySequence: [String] = []
    @State private var memoryChoices: [String] = []
    @State private var memoryShowing = true
    @State private var memorySelectedAnswer: String? = nil
    @State private var lifeSkillsIndex = 0
    @State private var lifeSkillsOrder = ActivityQuestionBank.lifeSkillsIndices(for: 1).shuffled()
    @State private var lifeSkillsLevelUpPending = false
    @State private var memoryCountdown = 4
    @State private var lifeSkillsScore = 0
    @State private var lifeSkillsSelectedAnswer: String? = nil
    @State private var lifeSkillsFirstWrongAnswer: String? = nil
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
    private var decodedCorrectQuestions: [String: Set<String>] {
        guard let data = correctQuestionStorage.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String: [String]].self, from: data) else { return [:] }
        return decoded.mapValues { Set($0) }
    }
    private var decodedSubjectPerformance: [String: SubjectPerformance] {
        guard let data = subjectPerformanceStorage.data(using: .utf8), let value = try? JSONDecoder().decode([String: SubjectPerformance].self, from: data) else { return [:] }
        return value
    }
    private var decodedTopicPerformance: [String: TopicPerformance] {
        guard let data = topicPerformanceStorage.data(using: .utf8),
              let value = try? JSONDecoder().decode([String: TopicPerformance].self, from: data) else { return [:] }
        return value
    }
    private var decodedActiveSeconds: [String: Int] {
        guard let data = activeSecondsStorage.data(using: .utf8), let value = try? JSONDecoder().decode([String: Int].self, from: data) else { return [:] }
        return value
    }
    private var decodedActiveSecondsBySubject: [String: Int] {
        guard let data = activeSecondsBySubjectStorage.data(using: .utf8), let value = try? JSONDecoder().decode([String: Int].self, from: data) else { return [:] }
        return value
    }
    private var subjectActiveTimeLeaders: [(String, Int)] {
        var rows: [(String, Int)] = []
        for subject in StudySubject.allCases {
            let seconds = decodedActiveSecondsBySubject[subject.rawValue] ?? 0
            rows.append((subject.rawValue, seconds))
        }
        rows.sort { left, right in
            if left.1 == right.1 { return left.0 < right.0 }
            return left.1 > right.1
        }
        return Array(rows.prefix(4))
    }
    private var decodedMistakes: [MistakeRecord] {
        guard let data = mistakesStorage.data(using: .utf8), let value = try? JSONDecoder().decode([MistakeRecord].self, from: data) else { return [] }
        return value
    }
    private var todayActiveSeconds: Int { decodedActiveSeconds[StatsStore.dateKey(Date())] ?? 0 }
    private var weekActiveSeconds: Int {
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .weekOfYear, for: Date()) else { return todayActiveSeconds }
        var total = 0
        var day = interval.start
        while day < interval.end {
            total += decodedActiveSeconds[StatsStore.dateKey(day)] ?? 0
            day = calendar.date(byAdding: .day, value: 1, to: day) ?? interval.end
        }
        return total
    }
    private var monthActiveSeconds: Int {
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .month, for: Date()) else { return todayActiveSeconds }
        var total = 0
        var day = interval.start
        while day < interval.end {
            total += decodedActiveSeconds[StatsStore.dateKey(day)] ?? 0
            day = calendar.date(byAdding: .day, value: 1, to: day) ?? interval.end
        }
        return total
    }
    private var averageActiveSecondsPerDay: Int {
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .month, for: Date()) else { return todayActiveSeconds }
        var total = 0
        var activeDays = 0
        var day = interval.start
        while day < min(interval.end, calendar.startOfDay(for: Date()).addingTimeInterval(86400)) {
            let seconds = decodedActiveSeconds[StatsStore.dateKey(day)] ?? 0
            total += seconds
            if seconds > 0 { activeDays += 1 }
            day = calendar.date(byAdding: .day, value: 1, to: day) ?? interval.end
        }
        return activeDays == 0 ? 0 : total / activeDays
    }
    private var lifetimeActiveSeconds: Int { decodedActiveSeconds.values.reduce(0, +) }
    private var unlockedAchievementIDs: Set<String> { Set(unlockedAchievementStorage.split(separator: ",").map(String.init)) }
    private var unlockedCollectibleIDs: Set<String> { Set(randomCollectiblesStorage.split(separator: ",").map(String.init)) }
    private var shopOwnedIDs: Set<String> { Set(shopPurchasesStorage.split(separator: ",").map(String.init)) }
    private var allOwnedCollectibleIDs: Set<String> { unlockedCollectibleIDs.union(shopOwnedIDs) }
    private var roomPlacedIDs: Set<String> { Set(roomPlacedItemsStorage.split(separator: ",").map(String.init)) }
    private func toggleRoomItem(_ id: String) {
        var placed = roomPlacedIDs
        if placed.contains(id) { placed.remove(id) } else if allOwnedCollectibleIDs.contains(id) { placed.insert(id) }
        roomPlacedItemsStorage = placed.sorted().joined(separator: ",")
    }
    private var roomItems: [Collectible] {
        Collectible.all.filter { allOwnedCollectibleIDs.contains($0.id) }
    }
    private var shopPrices: [String: Int] {
        var result: [String: Int] = [:]
        for entry in shopPricesStorage.split(separator: ",") {
            let pair = entry.split(separator: "=", maxSplits: 1)
            if pair.count == 2, let price = Int(pair[1]) { result[String(pair[0])] = price }
        }
        for item in Collectible.all where item.isRare { result[item.id] = 500 }
        return result
    }
    private var levelNumber: Int { store.stats.total / 25 + 1 }
    private var levelProgress: Int { store.stats.total % 25 }
    private var builtInReleaseNotes: [ReleaseNote] {
        [
            ReleaseNote(version: "1.2.51", date: "19.10.2026", title: "Понятные обозначения в статистике по предметам", changes: ["В подробной статистике пояснено, что означают цветные значки, проценты и количество попыток по каждой теме.", "В строках тем теперь явно подписаны точность и число попыток, чтобы не приходилось догадываться по условным обозначениям.", "Сохранены все накопленные данные, статистика и история предыдущих выпусков."]),
            ReleaseNote(version: "1.2.50", date: "19.10.2026", title: "Исправлены прогресс и повторный ответ в олимпиаде", changes: ["Полоса прогресса рассчитывается по фактической цели олимпиады — 60 заданий, а не по старому значению 50.", "После неверного ответа варианты снова доступны: ребёнок может попробовать ещё раз, не теряя вопрос.", "Проверка качества теперь защищает от возврата обоих дефектов; сохранены текстовые задания, четыре варианта, пауза и история выпусков."]),
            ReleaseNote(version: "1.2.49", date: "18.10.2026", title: "Из олимпиады исключены вопросы, требующие картинки", changes: ["Исключены не только задания с иллюстрациями, но и текстовые формулировки, которые ссылаются на флаг, рисунок или изображение.", "Сохранены обычные текстовые вопросы по географии и другим предметам.", "Порядок четырёх вариантов ответа остаётся неизменным до перехода к следующему вопросу; статистика, награды и история выпусков сохранены."]),
            ReleaseNote(version: "1.2.48", date: "18.10.2026", title: "Ответы в олимпиаде больше не прыгают", changes: ["Четыре варианта ответа формируются один раз при появлении нового вопроса и сохраняют порядок до ответа.", "Перерисовка интерфейса и обновление таймера больше не перемешивают кнопки.", "Сохранены текстовый формат олимпиады, ровно четыре варианта ответа, статистика, награды и история предыдущих выпусков."]),
            ReleaseNote(version: "1.2.47", date: "18.10.2026", title: "В олимпиаде только текстовые вопросы с четырьмя вариантами", changes: ["Из олимпиады убраны иллюстрации: задания показываются только текстом.", "Каждый вопрос олимпиады содержит ровно четыре варианта ответа; поля ручного ввода удалены.", "Сохранены исправление паузы олимпиады, балансировка длины ответов в «Навыках жизни», статистика и история выпусков."]),
            ReleaseNote(version: "1.2.42", date: "18.10.2026", title: "Продвинутые навыки жизни и гибкое время памяти", changes: ["В «Навыки жизни» добавлены 1 000 дополнительных вопросов для возраста 10–15 лет: цифровая безопасность, деньги, критическое мышление, общение, самостоятельность и безопасность в быту. Новые вопросы доступны на высокой сложности; в каждом четыре варианта ответа.", "Голосовое приветствие теперь останавливается при выходе из «Моего наставника», поэтому оно не продолжается при переходе в другие разделы. В «Навыках жизни» озвучивание не запускается.", "В «Тренировке памяти» каждый новый уровень добавляет одну секунду на запоминание последовательности.", "История выпусков, статистика, достижения и накопленные награды сохранены."]),
            ReleaseNote(version: "1.2.41", date: "18.10.2026", title: "Естественные ответы и голосовое приветствие наставника", changes: ["Убрана повторяющаяся фраза «Это разумный и безопасный вариант действий…» из вариантов «Навыков жизни»: ответы больше не искусственно удлиняются и отображаются естественно.", "При каждом входе в «Мой наставник» Элину встречает новое случайное поддерживающее приветствие голосом. Используется доступный женский голос macOS на русском языке, если он установлен.", "История выпусков, статистика, достижения и накопленные награды сохранены."]),
            ReleaseNote(version: "1.2.40", date: "18.10.2026", title: "Размер ответов работает во всех режимах", changes: ["Ползунок H5 «Названия ответов и кнопок» теперь меняет размер вариантов в «Навыках жизни» и «Ежедневном детективе», как и в обычных заданиях.", "Ползунок H4 теперь управляет размером текста вопроса в этих двух режимах.", "Из настроек удалён неработающий информационный раздел «Учебные предметы»; выбор предметов по-прежнему доступен в левом меню.", "История выпусков, статистика, достижения и накопленные награды сохранены."]),
            ReleaseNote(version: "1.2.39", date: "18.10.2026", title: "Исправлен предпросмотр шрифтов и убраны дубли тем", changes: ["Пример варианта ответа теперь связан с настройкой H5 и меняется сразу; каждый пример размера шрифта использует собственный регулятор, а общий масштаб применяется один раз.", "Настройка H5 применяется к тексту вариантов ответа в сетке выбора перевода.", "В настройках оставлены 20 тем без повторяющихся вариантов: 15 самостоятельных светлых палитр и 5 контрастных тёмных тем. Старые сохранённые настройки темы не сбрасываются.", "История выпусков, статистика, достижения и накопленные награды сохранены."]),
            ReleaseNote(version: "1.2.35", date: "18.10.2026", title: "Адаптивная сложность навыков жизни", changes: ["В «Навыках жизни» после каждых пяти правильных ответов подряд уровень повышается на одну ступень, максимум — 5; после ошибки серия сбрасывается.", "После повышения уровня меняется набор вопросов на более сложный. Текущий уровень сохраняется между запусками.", "Карточки ответов теперь одинаковой высоты; длинный текст автоматически уменьшается, чтобы длина варианта меньше выдавала правильный ответ.", "История статистики и накопленные данные сохранены."]),
            ReleaseNote(version: "1.2.37", date: "18.10.2026", title: "Укорочены ответы и добавлен видимый индикатор сложности", changes: ["Укорочен нейтральный текст в вариантах «Навыков жизни»; карточки автоматически растут по высоте и показывают текст целиком.", "В конце каждого варианта ответа теперь есть знак препинания, если его не было в исходном тексте.", "Добавлен заметный блок уровня сложности с прогрессом 0–5 правильных ответов подряд; после пятого ответа уровень повышается, а ошибка сбрасывает серию. История и данные сохранены."]),
            ReleaseNote(version: "1.2.38", date: "18.10.2026", title: "Исправлены надписи прогресса и компактность ответов", changes: ["Исправлена интерполяция текста уровня и серии: приложение показывает реальные числа вместо технических названий переменных.", "Нейтральное дополнение ответов сокращено; текст вариантов заканчивается корректным знаком препинания, а карточки растут по высоте, чтобы не обрезать ответы.", "Индикатор показывает прогресс правильных ответов подряд и текущий уровень 1–5. После пятого верного ответа подряд уровень повышается, после ошибки серия сбрасывается. История и накопленные данные сохранены."]),            ReleaseNote(version: "1.2.36", date: "18.10.2026", title: "Сбалансированы ответы в «Навыках жизни» и исправлено повышение сложности", changes: ["Все четыре варианта ответа в «Навыках жизни» автоматически дополнены нейтральным текстом примерно одинакового объёма, чтобы длина исходного ответа не выдавала правильный вариант.", "Исправлена логика повышения уровня после каждых пяти правильных ответов подряд; серия сбрасывается при ошибке, уровень повышается до максимума 5.", "Для уровня и текущей серии использованы новые ключи сохранения, чтобы некорректное прежнее состояние не блокировало повышение сложности. Статистика, награды и история выпусков сохранены."]),
            ReleaseNote(version: "1.2.34", date: "18.10.2026", title: "Компактная статистика и время по предметам", changes: ["Шесть общих показателей в статистике стали компактнее: значок и подпись находятся в первой строке, число — во второй; сетка остаётся в три колонки и два ряда.", "В активное время добавлены четыре динамических лидера по времени занятий с предметами. Учёт времени по предметам начинается с этой версии и ведётся, когда открыт основной тренажёр и есть активность мыши.", "Для редких коллекционных игрушек восстановлена оплата 500 алмазами и исправлена иконка валюты на алмаз; обычные коллекционные игрушки по-прежнему покупаются за золото.", "Все накопленные данные и история предыдущих выпусков сохранены."]),
             ReleaseNote(version: "1.2.33", date: "18.10.2026", title: "Обмен валюты и разбор ошибок детектива", changes: ["В магазине доступны три обмена: 100 золота → 50 алмазов, 200 → 110, 300 → 170.", "В левой панели золотые монеты показаны слева, алмазы справа; в балансе магазина золото находится сверху, алмазы снизу.", "В ежедневном детективе добавлена кнопка подробного разбора неправильного ответа.", "Обычные коллекционные игрушки покупаются за золото; редкие — за 500 алмазов."]),
            ReleaseNote(version: "1.2.31", date: "17.10.2026", title: "Единый режим «Повторить ошибки»", changes: ["В левое меню добавлен отдельный раздел, объединяющий ошибки школьных предметов, ежедневного детектива и навыков жизни.", "Ребёнок отвечает на сохранённое задание заново, видит правильный ответ и понятное объяснение.", "Попытки записываются в отдельную историю. Ошибка не удаляется после первого правильного ответа: освоение отмечается после трёх верных ответов подряд.", "Все прежние ошибки, статистика и история версий сохранены."]),

            ReleaseNote(version: "1.2.30", date: "17.10.2026", title: "Автоматическая проверка качества заданий", changes: ["Перед каждой сборкой запускается аудит банка заданий: проверяются четыре варианта ответа, наличие правильного ответа и повторяющиеся варианты в статических заданиях.", "Проверяется наличие маршрутов генерации для школьных предметов, олимпиады, ежедневного детектива, навыков жизни, тренировки памяти и повторения ошибок.", "Подозрительные формулировки выводятся в отчёт как предупреждения; критические структурные ошибки останавливают упаковку приложения.", "Проверка не заменяет полноценную смысловую проверку языка и автоматически генерируемых примеров; результаты аудита выводятся в GitHub Actions."]),
            ReleaseNote(version: "1.2.29", date: "17.10.2026", title: "Подробная статистика по предметам без раскрытия", changes: ["Вернул подробную статистику по всем предметам: точность, попытки, правильные и ошибочные ответы, а также результаты по темам.", "Карточки предметов всегда показывают детали и размещены в два столбца; раскрывать карточки не нужно.", "В активное время добавлены показатели «За месяц» и «Среднее за день»; все шесть показателей расположены в два столбца.", "Сохранённые результаты, ошибки и история предыдущих версий не удалены."]),
            ReleaseNote(version: "1.2.28", date: "17.10.2026", title: "Компактный календарь и два столбца времени", changes: ["Ширина календаря дополнительно уменьшена на 20%: с 440 до 352 пунктов.", "Четыре показателя активного времени теперь размещены в два столбца.", "Удаление подробной статистики по предметам и показатель времени за неделю сохранены. История предыдущих версий не удалена."]),
            ReleaseNote(version: "1.2.27", date: "17.10.2026", title: "Упрощена статистика и добавлено время за неделю", changes: ["Полностью удалён блок подробной статистики по предметам, который нарушал расположение элементов; общие показатели и сохранённые данные не затронуты.", "Ширина календаря уменьшена примерно на 20% относительно прежней равной компоновки, активное время занимает больше места справа.", "В блок активного времени добавлен показатель «За неделю». История предыдущих версий сохранена."]),
            ReleaseNote(version: "1.2.26", date: "17.10.2026", title: "Исправлена компоновка статистики", changes: ["Календарь занятий размещён слева, а активное время — справа, в одном общем блоке.", "Карточки успеваемости отображаются в два столбца; при раскрытии подробностей сетка временно перестраивается в один столбец, чтобы детали находились ниже карточки и не ломали соседние элементы.", "Все сохранённые показатели и история версий сохранены."]),
            ReleaseNote(version: "1.2.25", date: "17.10.2026", title: "Два столбца успеваемости и общий блок занятий", changes: ["Карточки успеваемости по предметам расположены в два столбца; подробная аналитика и сохранённые ошибки доступны при раскрытии карточки.", "Активное время занятий и календарь объединены в один визуальный блок статистики.", "Накопленные показатели и полная история предыдущих версий сохранены."]),
            ReleaseNote(version: "1.2.24", date: "17.10.2026", title: "Исправлена подробная статистика и перенесён календарь", changes: ["Карточки предметов переведены в вертикальный список, поэтому раскрытая аналитика занимает всю ширину и видна сразу под выбранным предметом.", "В подробностях предмета отображаются попытки, точность, темы и рекомендации; сохранённые ошибки дополнительно группируются по темам.", "Календарь занятий перенесён из «Моего наставника» в раздел «Статистика». История версий и ранее накопленные показатели сохранены."]),
            ReleaseNote(version: "1.2.23", date: "17.10.2026", title: "Подробная аналитика знаний по предметам", changes: ["Экран успеваемости стал компактнее: подробности открываются только при выборе предмета.", "Добавлена сохраняемая статистика по темам: попытки, правильные и неправильные ответы, точность и короткие рекомендации.", "Для математики добавлена классификация основных тем; для остальных предметов — темы по распознаваемым типам заданий.", "Существующая статистика и ошибки для повторения сохранены; история версий дополнена новым выпуском."]),
            ReleaseNote(version: "1.2.22", date: "17.10.2026", title: "Исправлена работа всех ползунков", changes: ["Системные ползунки заменены на интерактивные регуляторы с прямым перетаскиванием, чтобы исключить перехват нажатий прозрачным элементом.", "Размер текста, яркость темы и контраст цветов обновляются сразу при перемещении бегунка.", "Сохранён компактный вид с чёрным бегунком и тонкой шкалой.", "История предыдущих версий сохранена."]),
            ReleaseNote(version: "1.2.21", date: "17.10.2026", title: "Выбор внешности наставника", changes: ["В настройках добавлен выбор из 20 вариантов персонажа для карточки «Мой наставник».", "Выбранный персонаж сразу отображается в карточке наставника и сохраняется после перезапуска приложения.", "История предыдущих версий сохранена."]),
            ReleaseNote(version: "1.2.20", date: "17.10.2026", title: "Исправлена работа ползунков размера текста", changes: ["Исправлено взаимодействие с ползунками размера текста: убран дополнительный контур поверх интерактивного элемента, который мог перехватывать нажатия.", "Сохранён единый чёрный дизайн ползунков без белого бегунка и его тени.", "Компактные настройки яркости темы и контраста сохранены.", "История предыдущих версий сохранена."]),
            ReleaseNote(version: "1.2.17", date: "17.10.2026", title: "Компактные настройки, наставник и статистика", changes: ["Настройки шрифта компактнее: ползунок занимает примерно половину строки, пример текста расположен рядом.", "Размеры текста в «Версиях и изменениях» реагируют на общий масштаб и настройки основного текста; заголовки и подписи используют соответствующие регуляторы.", "Сова в карточке «Мой наставник» увеличена в 1,5 раза.", "В «Статистике» удалены повторяющаяся карточка наставника и дневная история, доступные в отдельном разделе наставника; подробная статистика по предметам и ошибки для повторения сохранены.", "История предыдущих версий сохранена."]),
            ReleaseNote(version: "1.2.16", date: "16.10.2026", title: "Общий размер текста и исправления русского языка", changes: ["В вопросе о глаголе все четыре варианта теперь являются глаголами в начальной форме: читать, писать, играть, говорить.", "Настройки размеров шрифта стали примерно вдвое компактнее по высоте.", "Добавлен общий масштаб текста для всего приложения; он применяется к фиксированным размерам шрифта на разных страницах. Индивидуальные H1–H7, основной текст и подсказки сохранены.", "Пункт «Магазин» убран из левого меню: открыть магазин по-прежнему можно нажатием на блок баланса вверху слева.", "История предыдущих версий сохранена."]),
            ReleaseNote(version: "1.2.15", date: "16.10.2026", title: "Точная настройка размеров шрифта", changes: ["Пункт «Версии и изменения» убран из нижней части левого меню: история открывается кликом по версии вверху слева.", "Настройки шрифтов оформлены в том же градиентном стиле, что яркость и контраст; ползунки с чёрной дорожкой и заметным бегунком видны на светлых темах.", "Добавлены независимые настройки H1–H7, основного текста и подсказок с сохранением каждого значения.", "Размеры подключены к заголовкам страниц, основному вопросу задания, полю ответа и подсказкам."]),
            ReleaseNote(version: "1.2.14", date: "16.10.2026", title: "Удобнее меню и настройка шрифтов", changes: ["Календарь занятий в «Моём наставнике» ограничен по ширине, чтобы не растягиваться на всю страницу.", "Версия в верхней части левого блока стала кликабельной и открывает «Версии и изменения».", "«Мой наставник» перемещён в меню между «Задание» и «Ежедневный детектив». Раздел «Моя комната» убран из главного меню.", "В настройках появились отдельные регуляторы размера заголовков, основного текста и подсказок с сохранением значений. Размер заголовков страниц и пунктов меню связан с настройками."]),
            ReleaseNote(version: "1.2.13", date: "16.10.2026", title: "Единый наставник и календарь занятий", changes: ["«Мой наставник» вынесен в отдельный раздел левого меню и объединяет анализ школьных предметов, логики, памяти, детектива, навыков жизни и олимпиады.", "Добавлены единая статистика, календарь занятий, план на день, повторяющиеся ошибки и рекомендации по сложности. При недостатке данных наставник прямо сообщает об этом.", "В «Навыках жизни» разбор ошибки расширен: добавлены пошаговый анализ, оценка последствий и рекомендации для похожих ситуаций.", "Шрифт заголовков в «Версиях и изменениях» увеличен в 1,4 раза. Прежняя история выпусков и сохранённые достижения оставлены."]),
            ReleaseNote(version: "1.2.12", date: "16.10.2026", title: "Личный план обучения и разбор ошибок", changes: ["В «Навыках жизни» появился сохраняемый раздел «Разобрать ошибки»: можно повторно прочитать ситуацию, свой ответ, правильный ответ и объяснение; разобранные записи убираются из списка.", "В «Моём наставнике» добавлен личный план занятия на 10–15 минут с быстрым переходом к предмету для повторения.", "Добавлен поиск слабых мест по точности в предметах; учитываются только направления минимум с тремя ответами, а список показывает до пяти тем с наименьшей точностью.", "Сохранены прежняя история выпусков, статистика, достижения и накопленные награды."]),
            ReleaseNote(version: "1.2.11", date: "16.10.2026", title: "Аналитика игр и проверка русских ответов", changes: ["В «Ежедневном детективе» и «Навыках жизни» добавлены подробные сохраняемые отчёты: попытки, правильные и ошибочные ответы, точность, текущая и лучшая серии правильных ответов.", "В русском языке обеспечены четыре уникальных варианта ответа, в том числе для задания на написание слова наоборот.", "Из вопросов детектива удалены служебные номера и префиксы вроде «Логическая разминка №…»; остаётся формулировка задачи."]),
            ReleaseNote(version: "1.2.10", date: "16.10.2026", title: "Исправления языков и диапазон яркости 75–115%", changes: ["В татарском убраны подсказки в формулировках и добавлены задания на перевод слов в обоих направлениях; варианты ответа не подсказывают правильный ответ.", "В английском формулировки вопросов на русском, а английские слова и предложения для изучения сохранены.", "Выпадающий список предметов увеличен, чтобы нижний пункт не обрезался.", "Яркость темы теперь настраивается от 75% (темнее) до 115% (светлее); выбранное значение сохраняется.", "Фон и обводка блока «Яркость темы» совпадают с блоком «Контраст цветов»."]),
            ReleaseNote(version: "1.2.9", date: "15.10.2026", title: "Новые темы оформления и логические вопросы", changes: ["Добавлены пять новых тем с мягким градиентом и пять светлых вариантов с тёмными цветовыми акцентами.", "В выпадающем списке предметов высота подстраивается под число пунктов, чтобы список заканчивался на последнем предмете.", "В «Ежедневном детективе» убрана фраза «Код сейфа» перед вопросом.", "Фон блока «Яркость темы» приведён к стилю блока «Контраст цветов».", "В «Навыки жизни» добавлены вопросы с подвохом и объяснениями."]),
            ReleaseNote(version: "1.2.8", date: "15.10.2026", title: "Новые темы по английскому, татарскому и окружающему миру", changes: ["В английский добавлены to be, сочетания гласных, звуки, слова о доме, улице и школе, а также глаголы действия.", "В татарский добавлены гласные и согласные, слоги, транскрипция и слова о животных и предметах вокруг ребёнка.", "В окружающий мир добавлены природные явления, птицы, растения, деревья и рыбы.", "В математике появилось отдельное упражнение на вычитание по частям.", "В тренировке памяти добавлены геометрические формы, цвета и статистика правильных ответов и ошибок по направлениям.", "Тёмные темы стали светлее, убрана нумерация ситуаций в «Навыках жизни», список предметов стал компактнее."]),
            ReleaseNote(version: "1.2.7", date: "15.10.2026", title: "Четыре варианта, новые темы и звук метронома", changes: ["Каждый вопрос в активностях получает ровно четыре уникальных варианта ответа.", "Пять прежних тёмных тем заменены новыми цветовыми сочетаниями с тёмным фоном и светлым читаемым текстом.", "В «Ежедневном детективе» убрана нумерация «Расследование №» перед вопросом.", "В тренировке памяти появился обратный отсчёт с коротким звуковым сигналом на каждый удар.", "В «Навыках жизни» порядок ситуаций перемешивается при запуске и после прохождения колоды."]),
            ReleaseNote(version: "1.2.6", date: "15.10.2026", title: "Проверка русского языка и видимые ползунки", changes: ["Исправлено определение последнего звука: в слове «друг» последний звук — [к], а не [г].", "Вопросы по русскому языку используют варианты ответа из той же категории: звуки — звуки, типы предложений — типы предложений, лексические понятия — лексические понятия.", "Индикатор обоих ползунков сделан крупным чёрным кругом с белой обводкой, чтобы его было видно и можно было точно захватить на светлой теме.", "Пять тёмных тем заметно осветлены; сохранён светлый текст для читаемости."]),
            ReleaseNote(version: "1.2.5", date: "15.10.2026", title: "Контрастные ползунки, более светлые тёмные темы и новые учебные ситуации", changes: ["Ползунки яркости темы и контраста цветов получили чёрный индикатор и более заметную шкалу.", "Пять тёмных тем сделаны заметно светлее, сохранив контрастность текста.", "В «Навыки жизни» добавлено ещё 10 000 ситуаций о школе, природе, транспорте, театре, кино, площадке, гостях, помощи родителям, порядке, питании, сне, спорте, чтении и общении.", "В тренировке памяти символы и варианты ответов теперь чёрные на светлых темах и белые на тёмных.", "В русский язык добавлены вопросы о многозначных словах, лексике и типах предложений."]),
            ReleaseNote(version: "1.2.4", date: "15.10.2026", title: "Практические навыки, русская грамматика и исправленная тренировка памяти", changes: ["В «Навыки жизни» добавлены ситуации о самокате, велосипеде, транспорте, метро, безопасности в общественных местах, открытых люках, экстренной помощи, питании и мошенничестве в играх и телефоне.", "В русский язык добавлены задания для начальной школы на падежи, глаголы, подлежащее и сказуемое.", "Во время запоминания последовательность показывается отдельными крупными символами; кнопка «Стоп» возвращает к выбору режима и сложности.", "Баланс в левой колонке остаётся кликабельным и открывает магазин.", "История предыдущих версий сохранена; запись новой версии добавлена сверху."]),
            ReleaseNote(version: "1.2.3", date: "15.10.2026", title: "Удобный баланс и выбор символов для тренировки памяти", changes: ["Ползунок яркости стал заметнее на светлых темах благодаря контрастной рамке и фону.", "В левой панели блок «Баланс» использует изображения алмаза и золотой монеты в стиле магазина; баланс удалён из верхней панели задания.", "В «Навыках жизни» из текста вопроса убрана пометка уровня сложности.", "Перед тренировкой памяти можно выбрать картинки, буквы, цифры и знаки по отдельности или в любой комбинации."]),
            ReleaseNote(version: "1.2.2", date: "15.10.2026", title: "Настройка яркости и 5 000 заданий по жизненным навыкам", changes: ["Пять нижних тёмных тем стали заметно светлее; первые пять тем не изменены.", "Добавлен отдельный сохраняемый ползунок яркости темы.", "В «Навыки жизни» добавлено 5 000 автоматически сформированных заданий из разных бытовых сфер с тремя уровнями сложности.", "Баланс алмазов и золота перенесён в левую панель над выбором сложности и виден на всех страницах."]),
            ReleaseNote(version: "1.2.1", date: "15.10.2026", title: "Новые темы и улучшенные игровые задания", changes: ["Пять нижних тёмных тем получили новые цветовые сочетания и названия; темы «Лаванда», «Океан», «Мята», «Персик» и «Ночное небо» оставлены без изменений.", "В «Ежедневном детективе» добавлена расширенная база из более чем 1 000 разнообразных задач: вычисления, закономерности, деньги, измерения, календарь и геометрия.", "Кнопки перехода в детективе, тренировке памяти и навыках жизни выровнены по правому краю.", "В «Навыках жизни» после первой ошибки остаётся ещё одна попытка; правильный ответ и объяснение показываются только после второй ошибки."]),
            ReleaseNote(version: "1.2.0", date: "15.10.2026", title: "Крупное обновление: новые режимы развития", changes: ["Добавлены «Ежедневный детектив» с логическими загадками и ежедневным бонусом, «Тренировка памяти» с последовательностями и ростом сложности, а также «Навыки жизни» с практическими ситуациями.", "В статистике появился «Мой наставник» — персональная рекомендация по предмету на основе результатов ребёнка.", "В «Навыках жизни» после выбора ответа сначала показывается объяснение, а переход к следующей ситуации выполняется отдельной кнопкой.", "Номер версии приложения изменён на 1.2.0. Существующие предметы, накопленные награды, магазин и прежняя история выпусков сохранены."]),
            ReleaseNote(version: "1.0.146", date: "15.10.2026", title: "Новые развивающие режимы", changes: ["Добавлены «Ежедневный детектив» с пятью логическими загадками и ежедневным бонусом за идеальный результат, «Тренировка памяти» с последовательностями и постепенным ростом сложности, а также «Навыки жизни» с практическими ситуациями.", "В статистике появилась карточка «Мой наставник» с рекомендацией по предмету на основе результатов ребёнка.", "Новые разделы добавлены в прокручиваемое меню; существующие предметы, награды, магазин и история версий сохранены."]),
            ReleaseNote(version: "1.0.145", date: "15.10.2026", title: "Ускорена прокрутка магазина", changes: ["Снижена графическая нагрузка карточек игрушек при прокрутке длинного каталога.", "В магазине отключена постоянная анимация редких игрушек; оформление и покупки сохранены.", "История предыдущих версий сохранена."]),
        ReleaseNote(version: "1.0.144", date: "15.10.2026", title: "Уменьшены замки в магазине игрушек", changes: ["Размер замков на закрытых игрушках уменьшен в два раза, оформление магазина сохранено.", "История предыдущих версий сохранена."]),
            ReleaseNote(version: "1.0.143", date: "15.10.2026", title: "Четыре варианта ответа для математики и русского языка", changes: ["В математике и русском языке теперь показываются четыре варианта ответа, из которых один правильный.", "Процент прогресса оставлен на самой медали; дублирующая подпись с процентом под карточкой убрана.", "История предыдущих версий сохранена."]),
            ReleaseNote(version: "1.0.142", date: "15.10.2026", title: "Оригинальные медали из выбранного дизайна", changes: ["Восемь медалей за правильные ответы заменены оригинальными иллюстрациями из предоставленного изображения.", "Круговой индикатор прогресса и процент снизу по центру сохранены.", "Оригинальные изображения включены в ресурсы приложения для работы без интернета.", "История предыдущих версий сохранена."]),
            ReleaseNote(version: "1.0.141", date: "15.10.2026", title: "Восемь медалей и постепенное заполнение цветом", changes: ["В раздел «Награды» добавлены медали за 1200 и 1500 правильных ответов; всего теперь восемь целей: 200, 300, 500, 700, 850, 1000, 1200 и 1500.", "Карточки медалей расположены в два ряда по четыре колонки.", "Изображение каждой медали постепенно заполняется её цветом по мере роста процента прогресса.", "Следующая медаль открывается для прогресса после получения предыдущей; накопленные правильные ответы сохраняются между месяцами."]),
            ReleaseNote(version: "1.0.135", date: "12.10.2026", title: "Единый дизайн коллекции и новые рубежи наград", changes: ["Карточки коллекционных игрушек в разделе «Награды» оформлены в том же стиле, что и карточки магазина: крупная иллюстрация сверху, подписи ниже, золотое оформление редких игрушек.", "Добавлены новые рубежи наград за накопление 5500 и 6000 алмазов.", "История предыдущих версий сохранена."]),
            ReleaseNote(version: "1.0.134", date: "12.10.2026", title: "Цвет золота и удобные кнопки магазина", changes: ["Золотые монеты выделены ярким золотисто-жёлтым цветом.", "Кнопки покупки получили тёмно-фиолетовый фон и белый контрастный текст.", "Алмазы и золото на главной странице выровнены в одну строку на одном уровне.", "Сетки обычных и редких коллекционных игрушек изменены на пять столбцов."]),
            ReleaseNote(version: "1.0.133", date: "12.10.2026", title: "Золотые монеты и улучшенная комната", changes: ["В магазин добавлен обмен алмазов на золото: 100 монет за 50 алмазов, 200 за 95, 500 за 250. Покупка доступна только при достаточном балансе алмазов.", "В верхнем блоке главного экрана теперь одновременно видны балансы алмазов и золотых монет.", "В разделе «Моя комната» игрушки размещаются в шесть колонок. Баланс золота сохраняется между запусками приложения."]),
            ReleaseNote(version: "1.0.132", date: "12.10.2026", title: "Новая геометрия, жизненная математика и моя комната", changes: ["Геометрические рисунки полностью перерисованы в цветном векторном стиле: изображение строится по точному названию фигуры, а не по приблизительному системному значку или непроверенному SVG.", "В математику добавлен отдельный набор задач из реальной жизни: покупки, сдача, время, поездки, пицца, скидки и карманные деньги.", "Добавлен раздел «Моя комната» между магазином и настройками: можно размещать и убирать свои коллекционные игрушки, оформление сохраняется после перезапуска.", "Исправлено соответствие геометрической иллюстрации её правильному ответу для фигур, углов, линий и объёмных тел."]),
            ReleaseNote(version: "1.0.129", date: "12.10.2026", title: "Восстановление задания, геометрия и награды", changes: ["После повторного запуска восстанавливается последний выбранный предмет и последнее задание.", "Увеличена доля заданий по геометрии с иллюстрациями; добавлены ромб, параллелограмм и виды углов.", "Исправлена подготовка вариантов ответа в заданиях с рисунками: правильный ответ гарантированно включён в варианты.", "Заголовок «Коллекция достижений» перенесён над восемью карточками наград.", "Исправлена генерация недостающих номеров в истории версий; сохранены подробные описания известных выпусков."]),
            ReleaseNote(version: "1.0.119", date: "12.10.2026", title: "Больше геометрии и ускорение магазина", changes: ["В геометрию добавлено больше заданий-картинок без текстового условия: плоские фигуры, линии, точка, луч, отрезок, кривая, пунктир, параллельные и перпендикулярные прямые, призма и другие объёмные тела.", "Сокращено количество вопросов по дм и см; добавлены простые задачи на периметр квадрата, прямоугольника и треугольника.", "В наградах теперь восемь рубежей накопления алмазов: от 500 до 4000 с шагом 500.", "Упрощён рендер закрытых товаров в магазине, чтобы снизить нагрузку при прокрутке большого каталога.", "Сохранена полная история версий, включая записи 1.0.101–1.0.118."]),
            ReleaseNote(version: "1.0.118", date: "12.10.2026", title: "Исправлена геометрия, история версий и статистика", changes: ["Восстановлена полная история выпусков: сохранены записи 1.0.101–1.0.111 и все более ранние описания.", "Вопросы по объёмным фигурам показывают соответствующие исходные SVG-иллюстрации из Wikimedia Commons, включённые в приложение для работы офлайн.", "Изображение выбирается по правильному ответу; текстовые задания по геометрии не показывают несоответствующие картинки.", "Блок «По дням» удалён со страницы заданий и помещён внутрь «Статистики».", "Добавлены вопросы по геометрии без картинок для начальных классов."]),
            ReleaseNote(version: "1.0.117", date: "12.10.2026", title: "Восстановление истории версий", changes: ["Восстановлены записи версий 1.0.100 и ниже из предыдущего исходного кода.", "Исправлена структура встроенного списка истории, из-за которой одна из промежуточных сборок не компилировалась.", "Сборка запущена повторно после исправления."]),
            ReleaseNote(version: "1.0.116", date: "12.10.2026", title: "Неудачная попытка обновления истории", changes: ["Попытка добавить подробные записи 1.0.101–1.0.112 и переместить дневную статистику.", "Сборка завершилась ошибкой компиляции из-за некорректной структуры списка версий; установщик не выпускался."]),
            ReleaseNote(version: "1.0.115", date: "12.10.2026", title: "Неудачная попытка исправления геометрии", changes: ["Добавлено сопоставление геометрических вопросов и изображений, а также подключение исходных SVG.", "Сборка завершилась ошибкой компиляции из-за структуры истории версий; установщик не выпускался."]),
            ReleaseNote(version: "1.0.114", date: "12.10.2026", title: "Подключение открытых иллюстраций", changes: ["В сценарий сборки добавлено получение геометрических SVG из Wikimedia Commons и включение их в пакет приложения.", "Добавлен файл с источниками и лицензиями иллюстраций.", "При недоступности отдельного файла приложение использует системный значок как резервный вариант."]),
            ReleaseNote(version: "1.0.113", date: "12.10.2026", title: "Восстановление истории и перенос статистики", changes: ["Встроенная история версий дополнена подтверждёнными изменениями выпусков 1.0.101–1.0.112.", "Блок дневных результатов перенесён в раздел «Статистика», а не оставлен на странице задания."]),
            ReleaseNote(version: "1.0.112", date: "12.10.2026", title: "Редкие коллекционные изображения", changes: ["Упрощены составные эмодзи редких игрушек, которые могли отображаться некорректно на некоторых шрифтах macOS.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.111", date: "12.10.2026", title: "Геометрия: текстовые задания", changes: ["Добавлены задания по геометрии без иллюстраций для начальных классов.", "Вместо текстовых псевдорисунков включены системные векторные значки как промежуточное исправление.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.110", date: "12.10.2026", title: "Панель заданий и коллекционные игрушки", changes: ["Внесены правки в расположение панели заданий и элементов коллекции.", "Добавлена запись в журнал изменений для этой сборки.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.109", date: "12.10.2026", title: "Группировка статистики и геометрия", changes: ["Предпринята попытка объединить дневные результаты с разделом статистики.", "Обновлён чёрно-белый стиль геометрических фигур.", "Сборка завершилась успешно, но перенос блока на странице заданий оставался неполным."]),
            ReleaseNote(version: "1.0.108", date: "12.10.2026", title: "Версия в боковой панели и коллекция", changes: ["Уточнено размещение номера версии приложения.", "Изменена сетка коллекционных игрушек и монохромный стиль геометрии.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.107", date: "12.10.2026", title: "Выпадающий список предметов", changes: ["Исправлено закрытие списка предметов при щелчке вне меню без блокировки нажатий внутри меню.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.106", date: "12.10.2026", title: "Значки предметов геометрии", changes: ["Дополнено сопоставление геометрических фигур и значков.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.105", date: "12.10.2026", title: "Попытка исправления геометрических иллюстраций", changes: ["Внесено изменение для сопоставления иллюстраций с ответами.", "Сборка завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.104", date: "12.10.2026", title: "Добавление геометрии", changes: ["Добавлены задания по геометрии и изменения отображения закрытых коллекционных игрушек.", "Сборка завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.103", date: "12.10.2026", title: "Сохранение журнала и коллекционные изображения", changes: ["Исправлена логика сохранения истории выпусков, чтобы новые записи не заменяли предыдущие.", "Обновлены повторяющиеся изображения коллекционных игрушек.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.102", date: "12.10.2026", title: "Дизайн коллекции и копирование", changes: ["Обновлён дизайн коллекционных игрушек.", "Добавлены элементы копирования вопросов и записей истории версий.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.101", date: "12.10.2026", title: "Химия: бытовые вещества и элементы", changes: ["Добавлены вопросы по химии о бытовых предметах и химических элементах.", "Скорректировано распределение вопросов об элементах в банке заданий.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.100", date: "12.10.2026", title: "Геометрия и улучшенные коллекционные игрушки", changes: ["Добавлен предмет «Геометрия» с картинками объёмных тел и заданиями о точке, прямой, луче и отрезке.", "Замок увеличен втрое, закрытые игрушки затемнены сильнее.", "Выпадающий список предметов стал выше."]),
            ReleaseNote(version: "1.0.99", date: "12.10.2026", title: "Сохраняем историю и обновляем коллекционные игрушки", changes: ["История обновлений закреплена как единый список: новая запись добавляется отдельной версией, а описания предыдущих выпусков не заменяются.", "Убраны повторяющиеся изображения игрушек и обновлены редкие коллекционные персонажи уникальными значками.", "Закрытые игрушки сильнее затемнены и скрыты за замком, но остаются различимыми по силуэту."]),
            ReleaseNote(version: "1.0.98", date: "12.10.2026", title: "Коллекционные игрушки, копирование и химия в быту", changes: ["Игрушки получили единый современный стиль с яркими персонажами и более прозрачным фоном; закрытые игрушки видны под замком.", "В журнале версий можно выделять и копировать текст, а у задания есть кнопка копирования вопроса и вариантов ответа.", "В химию добавлены вопросы о железе, кислороде, алюминии, меди и других элементах в бытовых предметах."]),
            ReleaseNote(version: "1.0.97", date: "12.10.2026", title: "Химия: исправление банка элементов", changes: ["Список вопросов о символах элементов помещён внутрь банка химии; каждый вопрос предлагает четыре русских названия.", "Исправлены разделители массива химических заданий." ]),
            ReleaseNote(version: "1.0.96", date: "12.10.2026", title: "Химия: структура вопросов по символам", changes: ["Добавлены задания вида Fe → Железо, Au → Золото и Na → Натрий.", "Список химических вопросов инициализируется корректно; финальная проверка продолжается в следующих сборках."]),
            ReleaseNote(version: "1.0.95", date: "12.10.2026", title: "Химия и восстановление истории выпусков", changes: ["Добавлены задания на определение элемента по латинскому символу и восстановлены записи истории выпусков.", "Первая попытка сборки завершилась ошибкой структуры массива; исправление вошло в следующие версии."]),
            ReleaseNote(version: "1.0.94", date: "12.10.2026", title: "Сборка 1.0.94", changes: ["Изменение по журналу разработки: Keep biology question identity stable to prevent repeated mastered facts.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.93", date: "12.10.2026", title: "Сборка 1.0.93", changes: ["Изменение по журналу разработки: Add 80 biology organisms for 320 more question variants.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.92", date: "12.10.2026", title: "Сборка 1.0.92", changes: ["Изменение по журналу разработки: Fix collectible shop background and center reward icons; reduce repeated correct questions.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.91", date: "12.10.2026", title: "Сборка 1.0.91", changes: ["Изменение по журналу разработки: Fix achievement visibility, reward layout, chemistry rotation and release history.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.90", date: "12.10.2026", title: "Сборка 1.0.90", changes: ["Изменение по журналу разработки: Complete traffic sign reference mapping.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.89", date: "12.10.2026", title: "Сборка 1.0.89", changes: ["Изменение по журналу разработки: Apply requested rewards and achievement updates.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.88", date: "12.10.2026", title: "Сборка 1.0.88", changes: ["Изменение по журналу разработки: Persist diamond medal milestones after spending.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.87", date: "12.10.2026", title: "Сборка 1.0.87", changes: ["Изменение по журналу разработки: Use reference road-sign images in traffic-safety questions.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.86", date: "12.10.2026", title: "Сборка 1.0.86", changes: ["Изменение по журналу разработки: Update rewards, collectibles, and achievement pacing.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.85", date: "12.10.2026", title: "Сборка 1.0.85", changes: ["Изменение по журналу разработки: Guarantee complete release history through current build number.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.84", date: "12.10.2026", title: "Сборка 1.0.84", changes: ["Изменение по журналу разработки: Restore every build number in release history without inventing missing change details.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.83", date: "12.10.2026", title: "Сборка 1.0.83", changes: ["Изменение по журналу разработки: Fix chemistry and biology illustrations, PDD sign matching, and complete version history.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.82", date: "12.10.2026", title: "Сборка 1.0.82", changes: ["Изменение по журналу разработки: Connect chemistry bank to active generator; version history 1.0.82; restrict mismatched PDD illustrations.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.81", date: "12.10.2026", title: "Сборка 1.0.81", changes: ["Изменение по журналу разработки: Fix persistent release history and subject illustrations; add 300 chemistry questions.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.80", date: "12.10.2026", title: "Сборка 1.0.80", changes: ["Изменение по журналу разработки: Fix duplicate ViewBuilder attribute in PDD illustration.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.79", date: "12.10.2026", title: "Сборка 1.0.79", changes: ["Изменение по журналу разработки: Harden spelling choice array types and biology card styling.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.78", date: "12.10.2026", title: "Сборка 1.0.78", changes: ["Изменение по журналу разработки: Fix PDD sign rendering, spelling single-answer choices, biology illustrations and reward colors.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.77", date: "12.10.2026", title: "Сборка 1.0.77", changes: ["Изменение по журналу разработки: Align latest release history entry with current build changes.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.76", date: "12.10.2026", title: "Сборка 1.0.76", changes: ["Изменение по журналу разработки: Make olympiad completion message match selected format.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.75", date: "12.10.2026", title: "Сборка 1.0.75", changes: ["Изменение по журналу разработки: Restore detailed changelog entries from repository history.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.74", date: "12.10.2026", title: "Сборка 1.0.74", changes: ["Изменение по журналу разработки: Match PDD sign illustrations to the sign named in each question.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.73", date: "12.10.2026", title: "Сборка 1.0.73", changes: ["Изменение по журналу разработки: Polish olympiad selection and single-answer spelling choices.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.72", date: "12.10.2026", title: "Сборка 1.0.72", changes: ["Изменение по журналу разработки: Separate biology text/image modes and hide chemistry answer in element card.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.71", date: "12.10.2026", title: "Сборка 1.0.71", changes: ["Изменение по журналу разработки: Fix release history, PDD illustrations, spelling choices, geography and olympiad modes.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.70", date: "11.10.2026", title: "Сборка 1.0.70", changes: ["Изменение по журналу разработки: Match biology illustrations to the organism named in each question.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.69", date: "11.10.2026", title: "Сборка 1.0.69", changes: ["Изменение по журналу разработки: Harden answer-choice construction for generated biology questions.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.68", date: "11.10.2026", title: "Сборка 1.0.68", changes: ["Изменение по журналу разработки: Expand Russian traffic-sign question bank.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.67", date: "11.10.2026", title: "Сборка 1.0.67", changes: ["Изменение по журналу разработки: Draw additional national flags for geography picture questions.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.66", date: "11.10.2026", title: "Сборка 1.0.66", changes: ["Изменение по журналу разработки: Expand flag quiz bank, generate varied biology questions, and add periodic-table tiles.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.65", date: "11.10.2026", title: "Сборка 1.0.65", changes: ["Изменение по журналу разработки: Improve logic questions, expand biology generator, and show full subject menu.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.64", date: "11.10.2026", title: "Сборка 1.0.64", changes: ["Изменение по журналу разработки: Align release history entry with corrective build number.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.63", date: "11.10.2026", title: "Сборка 1.0.63", changes: ["Изменение по журналу разработки: Separate chemistry question banks and pin release notes to actual version.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.62", date: "11.10.2026", title: "Сборка 1.0.62", changes: ["Изменение по журналу разработки: Fix mismatched subject illustrations and version history.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.61", date: "11.10.2026", title: "Сборка 1.0.61", changes: ["Изменение по журналу разработки: Redesign toy rewards as bright flat 2D collectible illustrations.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.60", date: "11.10.2026", title: "Сборка 1.0.60", changes: ["Изменение по журналу разработки: Add colorful study illustrations and laboratory equipment questions.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.59", date: "11.10.2026", title: "Сборка 1.0.59", changes: ["Изменение по журналу разработки: Add Logic and beginner Biology subjects and Olympiad pause.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.58", date: "11.10.2026", title: "Сборка 1.0.58", changes: ["Изменение по журналу разработки: Fix SwiftUI builder annotation for traffic-sign illustrations.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.57", date: "11.10.2026", title: "Сборка 1.0.57", changes: ["Изменение по журналу разработки: Expand road signs, flags, spelling gaps and animated 3D-style rewards.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.56", date: "11.10.2026", title: "Сборка 1.0.56", changes: ["Изменение по журналу разработки: Harden mistake review state and road-crossing illustrations.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.55", date: "11.10.2026", title: "Сборка 1.0.55", changes: ["Изменение по журналу разработки: Complete mistake explanations for every subject.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.54", date: "11.10.2026", title: "Сборка 1.0.54", changes: ["Изменение по журналу разработки: Add PDD visual aids and rainbow fireworks, show bought gift on reveal.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.53", date: "11.10.2026", title: "Сборка 1.0.53", changes: ["Изменение по журналу разработки: Add mistake review with explanations and balanced olympiad question coverage.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.52", date: "11.10.2026", title: "Сборка 1.0.52", changes: ["Изменение по журналу разработки: Fix shop visibility, reward sizing, achievement difficulty and contrast.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.51", date: "11.10.2026", title: "Сборка 1.0.51", changes: ["Изменение по журналу разработки: Add beginner geography subject and persistent mistake model.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.50", date: "11.10.2026", title: "Сборка 1.0.50", changes: ["Изменение по журналу разработки: Add graduated question levels by subject and update release notes.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.49", date: "11.10.2026", title: "Сборка 1.0.49", changes: ["Изменение по журналу разработки: Add five difficulty-level buttons beside the app logo.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.48", date: "11.10.2026", title: "Сборка 1.0.48", changes: ["Изменение по журналу разработки: Add five dark themes, relocate contrast slider and enlarge reward icons.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.47", date: "11.10.2026", title: "Сборка 1.0.47", changes: ["Изменение по журналу разработки: Add PDD and orthography tests, difficulty levels and correct answer labels.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.46", date: "11.10.2026", title: "Сборка 1.0.46", changes: ["Изменение по журналу разработки: Build olympiad gameplay, subject analytics, contrast control and larger reward icons.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.45", date: "11.10.2026", title: "Сборка 1.0.45", changes: ["Изменение по журналу разработки: Add achievement system, session tracking and olympiad foundation.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.44", date: "11.10.2026", title: "Сборка 1.0.44", changes: ["Изменение по журналу разработки: Add 1000+ informatics tests and rare collectible shop pricing.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.43", date: "11.10.2026", title: "Сборка 1.0.43", changes: ["Изменение по журналу разработки: Fix separators in new theme color switches.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.42", date: "11.10.2026", title: "Сборка 1.0.42", changes: ["Изменение по журналу разработки: Add monthly stats archive, reset control, five themes and de-duplicate release notes.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.41", date: "11.10.2026", title: "Сборка 1.0.41", changes: ["Изменение по журналу разработки: Give overlay subject menu a stable height.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.40", date: "11.10.2026", title: "Сборка 1.0.40", changes: ["Изменение по журналу разработки: Overlay subject picker and rebuild art quiz as text choices.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.39", date: "10.10.2026", title: "Сборка 1.0.39", changes: ["Изменение по журналу разработки: Hide uncollected prizes and limit drawing answers to four.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.38", date: "10.10.2026", title: "Сборка 1.0.38", changes: ["Изменение по журналу разработки: Improve grade-two practice, art variety and shop visibility.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.37", date: "10.10.2026", title: "Сборка 1.0.37", changes: ["Изменение по журналу разработки: Simplify grade-two world and chemistry quizzes.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.36", date: "10.10.2026", title: "Сборка 1.0.36", changes: ["Изменение по журналу разработки: Add English choices, chemistry subject, no-repeat questions and fix shop unlock state.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.35", date: "10.10.2026", title: "Сборка 1.0.35", changes: ["Изменение по журналу разработки: Make subject picker unmistakable, add Tatar multiple-choice answers, update release notes.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.34", date: "10.10.2026", title: "Сборка 1.0.34", changes: ["Изменение по журналу разработки: Fix randomized question interpolation and improve subject dropdown.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.33", date: "10.10.2026", title: "Сборка 1.0.33", changes: ["Изменение по журналу разработки: Fix access level for subject-specific hint generator.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.32", date: "10.10.2026", title: "Сборка 1.0.32", changes: ["Изменение по журналу разработки: Avoid duplicate release IDs and expand randomized question variations.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.31", date: "10.10.2026", title: "Сборка 1.0.31", changes: ["Изменение по журналу разработки: Restore release history 1.0.22–1.0.29 and expand randomized question generators.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.30", date: "10.10.2026", title: "Сборка 1.0.30", changes: ["Изменение по журналу разработки: Make subject picker obvious and make hints match each task.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.29", date: "10.10.2026", title: "Сборка 1.0.29", changes: ["Изменение по журналу разработки: Keep comparison questions in the expanded math generator.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.28", date: "10.10.2026", title: "Сборка 1.0.28", changes: ["Изменение по журналу разработки: Persist release history, restore visible subject selector, add unit conversion math tasks.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.27", date: "10.10.2026", title: "Сборка 1.0.27", changes: ["Изменение по журналу разработки: Restore dashboard top bar after moving subject selector.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.26", date: "10.10.2026", title: "Сборка 1.0.26", changes: ["Изменение по журналу разработки: Add visual multiple-choice art exercises.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.25", date: "10.10.2026", title: "Сборка 1.0.25", changes: ["Изменение по журналу разработки: Move subject picker to sidebar and simplify settings.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.24", date: "10.10.2026", title: "Сборка 1.0.24", changes: ["Изменение по журналу разработки: Move subject picker to sidebar and simplify settings.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.23", date: "10.10.2026", title: "Сборка 1.0.23", changes: ["Изменение по журналу разработки: Restore missing version 1.0.21 in release history.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.22", date: "10.10.2026", title: "Сборка 1.0.22", changes: ["Изменение по журналу разработки: Restore toy shop and refine main dashboard.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.21", date: "10.10.2026", title: "Сборка 1.0.21", changes: ["Изменение по журналу разработки: Fix access level for subject-specific problem generator.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.20", date: "10.10.2026", title: "Сборка 1.0.20", changes: ["Изменение по журналу разработки: Polish task menu sizing and document current release changes.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.19", date: "10.10.2026", title: "Сборка 1.0.19", changes: ["Изменение по журналу разработки: Add subject practice, fix comparisons and update toy shop.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.18", date: "10.10.2026", title: "Сборка 1.0.18", changes: ["Изменение по журналу разработки: Fix missing comma in release notes for Build 17.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.17", date: "10.10.2026", title: "Сборка 1.0.17", changes: ["Изменение по журналу разработки: Improve canvas contrast for night and galaxy themes.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.16", date: "10.10.2026", title: "Сборка 1.0.16", changes: ["Изменение по журналу разработки: Fix changelog comma for successful build.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.15", date: "10.10.2026", title: "Сборка 1.0.15", changes: ["Изменение по журналу разработки: Fix night themes, date labels, expand shop and add mixed math problems.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.14", date: "10.10.2026", title: "Сборка 1.0.14", changes: ["Изменение по журналу разработки: Add brain training shop, themes, achievements and native icon.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.13", date: "10.10.2026", title: "Сборка 1.0.13", changes: ["Изменение по журналу разработки: Fix theme palette factory references.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.12", date: "10.10.2026", title: "Сборка 1.0.12", changes: ["Изменение по журналу разработки: Include date in each MathTrainer release.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.11", date: "10.10.2026", title: "Сборка 1.0.11", changes: ["Изменение по журналу разработки: Add customizable themes, subjects, changelog and gamification.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."]),
            ReleaseNote(version: "1.0.10", date: "09.10.2026", title: "Сборка 1.0.10", changes: ["Изменение по журналу разработки: Redesign MathTrainer interface to match pastel dashboard mockups.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.9", date: "09.10.2026", title: "Сборка 1.0.9", changes: ["Изменение по журналу разработки: Make app build version unmistakable.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.8", date: "09.10.2026", title: "Сборка 1.0.8", changes: ["Изменение по журналу разработки: Automatically version each MathTrainer build.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.7", date: "09.10.2026", title: "Сборка 1.0.7", changes: ["Изменение по журналу разработки: Add answer totals, 20 and 50 diamond rewards, and surprised bunny.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.6", date: "09.10.2026", title: "Сборка 1.0.6", changes: ["Изменение по журналу разработки: Harden SwiftUI celebration rendering.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.5", date: "09.10.2026", title: "Сборка 1.0.5", changes: ["Изменение по журналу разработки: Fix all celebration animation coordinates.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.4", date: "09.10.2026", title: "Сборка 1.0.4", changes: ["Изменение по журналу разработки: Fix celebration animation coordinates.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.3", date: "09.10.2026", title: "Сборка 1.0.3", changes: ["Изменение по журналу разработки: Add daily stats, diamonds and learning rewards.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.2", date: "08.10.2026", title: "Сборка 1.0.2", changes: ["Изменение по журналу разработки: Raise minimum macOS to 14.", "Сборка GitHub Actions завершилась успешно."]),
            ReleaseNote(version: "1.0.1", date: "08.10.2026", title: "Сборка 1.0.1", changes: ["Изменение по журналу разработки: Add root macOS DMG workflow.", "Попытка сборки завершилась ошибкой; готовый установщик этой попытки не выпускался."])
        ]
    }

    private var releaseNotes: [ReleaseNote] {
        // The bundled list is the source of truth. Local storage is never allowed to replace
        // or hide release descriptions, so an app update cannot erase the visible history.
        let merged = builtInReleaseNotes
        // Сохраняем все известные описания, затем гарантированно добавляем каждый номер сборки
        // от 1.0.1 до установленной версии. Для старых пропусков честно отмечаем, что описание
        // не сохранилось, вместо того чтобы придумывать содержание обновления.
        var byVersion: [String: ReleaseNote] = [:]
        for note in merged { if byVersion[note.version] == nil { byVersion[note.version] = note } }
        let installedVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.1"
        if byVersion[installedVersion] == nil {
            byVersion[installedVersion] = ReleaseNote(
                version: installedVersion,
                date: Bundle.main.infoDictionary?["AppReleaseDate"] as? String ?? "—",
                title: "Исправления коллекции, наград и химии",
                changes: [
                    "Коллекция достижений показывает только полученные награды; пороги получения увеличены, старые отметки сброшены для честного повторного открытия.",
                    "Карточки наград выровнены, а фон открытых обычных игрушек стал почти прозрачным.",
                    "Химия: вопросы о символах элементов периодической таблицы возвращены в регулярную ротацию без картинок.",
                    "История версий формируется с учётом установленной сборки, чтобы актуальный выпуск не пропадал."
                ]
            )
        }
        let versionParts = installedVersion.split(separator: ".").compactMap { Int($0) }
        let currentBuild = versionParts.count >= 3 && versionParts[0] == 1 && versionParts[1] == 0 ? versionParts[2] : 1
        if currentBuild >= 1 {
            for build in 1...currentBuild {
                let version = "1.0.\(build)"
                if byVersion[version] == nil {
                    byVersion[version] = ReleaseNote(
                        version: version,
                        date: "—",
                        title: "История выпуска",
                        changes: ["Номер версии сохранён, чтобы история была полной.", "Подробное описание изменений этого выпуска не сохранилось в текущем списке релизов."]
                    )
                }
            }
        }
        let sorted = Array(byVersion.values).sorted { lhs, rhs in
            let l = lhs.version.split(separator: ".").compactMap { Int($0) }
            let r = rhs.version.split(separator: ".").compactMap { Int($0) }
            for index in 0..<max(l.count, r.count) {
                let lv = index < l.count ? l[index] : 0
                let rv = index < r.count ? r[index] : 0
                if lv != rv { return lv > rv }
            }
            return lhs.date > rhs.date
        }
        var seenDescriptions = Set<String>()
        return sorted.filter { note in
            return seenDescriptions.insert(note.version).inserted
        }
    }

    private func persistReleaseNotes() {
        let data = (try? JSONEncoder().encode(releaseNotes))
        if let data, let value = String(data: data, encoding: .utf8), value != releaseNotesStorage {
            releaseNotesStorage = value
        }
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
                    .onTapGesture { if showSubjectPicker { showSubjectPicker = false } }
            }
            .background(palette.cardSurface.opacity(palette.isDark ? 0.96 : 0.72), in: RoundedRectangle(cornerRadius: 25))
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(.white.opacity(0.94), lineWidth: 1.2))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .contrast(screenContrast)
            .brightness(themeBrightness)
            .padding(13)

            if showCelebration {
                celebrationOverlay
                    .transition(.opacity)
                    .zIndex(20)
            }
        }
        .frame(minWidth: 1180, minHeight: 760)
        .onAppear { prepareShopPrices(); prepareAchievementThresholds(); persistReleaseNotes(); restoreCurrentProblem(); store.refreshMonthIfNeeded(); lastMouseLocation = NSEvent.mouseLocation; lastMouseMovementAt = Date(); answerFocused = true }
        .onChange(of: problem.answer) { _, _ in persistCurrentProblem() }
        .onChange(of: problem.text) { _, _ in persistCurrentProblem() }
        .onChange(of: problem.tatarChoices) { _, _ in persistCurrentProblem() }
        .onChange(of: selectedSubjectName) { _, newValue in
            guard savedProblemSubject != newValue, let subject = StudySubject(rawValue: newValue) else { return }
            problem = makeUniqueProblem(for: subject)
            currentTip = ProblemGenerator.tip(for: subject, problem: problem)
            answer = ""
            answerState = .neutral
            persistCurrentProblem()
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in tickTimers() }
        .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in
            store.refreshMonthIfNeeded()
        }
    }

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 17).fill(LinearGradient(colors: [palette.purple, Color(red: 0.85, green: 0.43, blue: 0.74)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    Image(systemName: "brain.head.profile").font(.system(size: 27 * AppFontScale.factor, weight: .heavy)).foregroundStyle(.white)
                }.frame(width: 48, height: 48)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Тренировка мозга").font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink).lineLimit(2).minimumScaleFactor(0.78)
                    Button { selected = .versionHistory } label: { Text("Версия \(appVersion)").font(.system(size: 10 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple).underline() }.buttonStyle(.plain).help("Открыть «Версии и изменения»")
                        .padding(.horizontal, 8).padding(.vertical, 4).background(palette.cardSurface.opacity(0.75), in: Capsule())
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 12).padding(.top, 22).padding(.bottom, 10)

            VStack(alignment: .leading, spacing: 7) {
                Text("БАЛАНС").font(.system(size: 10 * AppFontScale.factor, weight: .black, design: .rounded)).tracking(0.6).foregroundStyle(palette.ink)
                Button { openShop() } label: {
                    HStack(spacing: 7) {
                        HStack(spacing: 4) {
                            goldCoinIcon(size: 18)
                            Text("\(goldBalance)").font(.system(size: 12 * AppFontScale.factor, weight: .black, design: .rounded)).foregroundStyle(Color(red: 0.83, green: 0.55, blue: 0.02))
                        }.frame(maxWidth: .infinity)
                        Rectangle().fill(palette.line).frame(width: 1, height: 22)
                        HStack(spacing: 4) {
                            Text("💎").font(.system(size: 18 * AppFontScale.factor))
                            Text("\(store.stats.diamonds)").font(.system(size: 12 * AppFontScale.factor, weight: .black, design: .rounded)).foregroundStyle(palette.ink)
                        }.frame(maxWidth: .infinity)
                    }.padding(.horizontal, 8).padding(.vertical, 9)
                     .background(palette.cardSurface, in: RoundedRectangle(cornerRadius: 11))
                     .overlay(RoundedRectangle(cornerRadius: 11).stroke(palette.line, lineWidth: 1))
                }.buttonStyle(.plain).help("Открыть магазин")
            }.padding(.horizontal, 12).padding(.bottom, 12)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("УРОВЕНЬ СЛОЖНОСТИ")
                        .font(.system(size: 9 * AppFontScale.factor, weight: .black, design: .rounded))
                        .tracking(0.45).foregroundStyle(palette.ink)
                    Spacer(minLength: 2)
                    Text("\(difficultyLevel)/5")
                        .font(.system(size: 10 * AppFontScale.factor, weight: .heavy, design: .rounded))
                        .foregroundStyle(palette.purple)
                }
                HStack(spacing: 5) {
                    ForEach(1...5, id: \.self) { level in
                        Button {
                            difficultyLevel = level
                            answer = ""
                            answerState = .neutral
                            problem = makeUniqueProblem(for: selectedSubject)
                            currentTip = ProblemGenerator.tip(for: selectedSubject, problem: problem)
                            answerFocused = false
                        } label: {
                            Text("\(level)")
                                .font(.system(size: 15 * AppFontScale.factor, weight: .black, design: .rounded))
                                .foregroundStyle(difficultyLevel == level ? .white : palette.ink)
                                .frame(maxWidth: .infinity)
                                .frame(height: 32)
                                .background(difficultyLevel == level ? palette.purple : palette.cardSurface, in: RoundedRectangle(cornerRadius: 9))
                                .overlay(RoundedRectangle(cornerRadius: 9).stroke(difficultyLevel == level ? palette.purple : palette.line, lineWidth: difficultyLevel == level ? 2 : 1))
                        }
                        .buttonStyle(.plain)
                        .help("Уровень сложности \(level)")
                    }
                }
                Text("1 — базовый · 5 — самый сложный")
                    .font(.system(size: 9 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
            }
            .padding(.horizontal, 12).padding(.bottom, 12)

            VStack(alignment: .leading, spacing: 9) {
                Text("ВЫБЕРИ ПРЕДМЕТ")
                    .font(.system(size: 10 * AppFontScale.factor, weight: .black, design: .rounded)).tracking(0.6).foregroundStyle(palette.ink)
                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                        showSubjectPicker.toggle()
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: selectedSubject.icon)
                            .font(.system(size: 19 * AppFontScale.factor, weight: .heavy))
                            .frame(width: 40, height: 40)
                            .background(palette.cardSurface.opacity(0.22), in: RoundedRectangle(cornerRadius: 11))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(selectedSubject.rawValue)
                                .font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded))
                                .lineLimit(1).minimumScaleFactor(0.75)
                            Text("НАЖМИ ЗДЕСЬ ДЛЯ СМЕНЫ")
                                .font(.system(size: 8 * AppFontScale.factor, weight: .black, design: .rounded))
                                .tracking(0.2)
                        }
                        Spacer(minLength: 1)
                        Image(systemName: showSubjectPicker ? "chevron.up" : "chevron.down")
                            .font(.system(size: 13 * AppFontScale.factor, weight: .black))
                            .frame(width: 28, height: 28)
                            .background(palette.cardSurface.opacity(0.22), in: Circle())
                    }
                    .foregroundStyle(.white)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(LinearGradient(colors: [Color(red: 0.42, green: 0.20, blue: 0.78), Color(red: 0.78, green: 0.25, blue: 0.62)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 15))
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 2.5))
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(red: 0.35, green: 0.15, blue: 0.62), lineWidth: 1))
                    .shadow(color: Color.purple.opacity(0.30), radius: 6, x: 0, y: 3)
                    .contentShape(RoundedRectangle(cornerRadius: 15))
                }
                .buttonStyle(.plain)
                .overlay(alignment: .topLeading) {
                    if showSubjectPicker {
                        subjectPickerMenu
                            .offset(y: 66)
                            .transition(.opacity.combined(with: .scale(scale: 0.97, anchor: .top)))
                            .zIndex(50)
                    }
                }
                .help("Нажми, чтобы выбрать другой учебный предмет")


            }
            .padding(.horizontal, 12).padding(.bottom, 18)
            .zIndex(showSubjectPicker ? 10 : 0)

            ScrollView(.vertical) {
            VStack(spacing: 8) {
                ForEach(AppSection.allCases.filter { $0 != .days && $0 != .versionHistory && $0 != .shop }) { section in
                    Button {
                        selected = section
                        if section == .task {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { answerFocused = true }
                        }
                    } label: {
                        HStack(spacing: 13) {
                            Image(systemName: section.icon)
                                .font(.system(size: 18 * AppFontScale.factor, weight: .bold))
                                .frame(width: 24)
                            Text(section.rawValue)
                                .font(.system(size: 15 * AppFontScale.factor * fontScaleBody, weight: .semibold, design: .rounded))
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
            }
            .scrollIndicators(.hidden)

            Spacer(minLength: 12)

            HStack(spacing: 7) {
                Image(systemName: "heart.fill").foregroundStyle(palette.pink)
                Text("Для маленьких побед")
                    .font(.system(size: 12 * AppFontScale.factor, weight: .semibold, design: .rounded))
                    .foregroundStyle(palette.muted)
            }
            .padding(.horizontal, 19)

        }
        .frame(maxHeight: .infinity)
        .background(LinearGradient(
            colors: [palette.sidebarTop, palette.sidebarBottom],
            startPoint: .topLeading, endPoint: .bottomTrailing
        ))
    }

    private var mainContent: some View {
        Group {
            switch selected {
            case .task:
                taskDashboard
            case .mentor:
                mentorPage
            case .detective:
                detectivePage
            case .memory:
                memoryPage
            case .lifeSkills:
                lifeSkillsPage
            case .mistakeReview:
                unifiedMistakeReviewPage
            case .olympiad:
                olympiadPage
            case .statistics:
                statisticsPage
            case .days:
                daysPage
            case .rewards:
                rewardsPage
            case .shop:
                shopPage
            case .settings:
                settingsPage
            case .versionHistory:
                versionHistoryPage
            }
        }
        .onChange(of: selected) { _, newValue in
            if newValue != .mentor {
                mentorSpeechSynthesizer.stopSpeaking(at: .immediate)
            }
        }
    }

    private var subjectComingSoon: some View {
        VStack(alignment: .leading, spacing: 25) {
            pageHeading(selectedSubject.rawValue, subtitle: "Новый предмет в твоём учебном пространстве")
            Spacer()
            VStack(spacing: 18) {
                Text(subjectEmoji).font(.system(size: 86 * AppFontScale.factor))
                Text("Готовим задания!").font(.system(size: 30 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                Text("Раздел уже создан. Задания для этого предмета появятся в следующем обновлении. Математика продолжает работать как обычно.")
                    .font(.system(size: 16 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    .multilineTextAlignment(.center).frame(maxWidth: 510)
                Button {
                    selectedSubjectName = StudySubject.math.rawValue
                    selected = .task
                    problem = ProblemGenerator.next()
                    answer = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { answerFocused = true }
                } label: {
                    Label("Вернуться к математике", systemImage: "function")
                        .font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                        .padding(.horizontal, 20).padding(.vertical, 13).background(palette.purple, in: Capsule())
                }.buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity).padding(40).cardStyle(palette)
            Spacer()
        }
        .padding(28).frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var subjectPickerMenu: some View {
        ScrollView {
            VStack(spacing: 3) {
                ForEach(StudySubject.allCases) { subject in
                    Button {
                        selectedSubjectName = subject.rawValue
                        selected = .task
                        reviewingMistakeID = nil
                        answerState = .neutral
                        answer = ""
                        problem = makeUniqueProblem(for: subject)
                        currentTip = ProblemGenerator.tip(for: subject, problem: problem)
                        showSubjectPicker = false
                        answerFocused = false
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: subject.icon)
                                .font(.system(size: 15 * AppFontScale.factor, weight: .bold))
                                .frame(width: 30, height: 30)
                                .foregroundStyle(subject == selectedSubject ? .white : palette.purple)
                                .background(subject == selectedSubject ? palette.purple : palette.palePink, in: RoundedRectangle(cornerRadius: 9))
                            Text(subject.rawValue)
                                .font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded))
                                .foregroundStyle(palette.ink)
                            Spacer()
                            if subject == selectedSubject {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 16 * AppFontScale.factor, weight: .heavy))
                                    .foregroundStyle(palette.purple)
                            }
                        }
                        .padding(.horizontal, 9).padding(.vertical, 4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(subject == selectedSubject ? palette.palePink : palette.cardSurface, in: RoundedRectangle(cornerRadius: 11))
                        .overlay(RoundedRectangle(cornerRadius: 11).stroke(subject == selectedSubject ? palette.purple : palette.line, lineWidth: subject == selectedSubject ? 2 : 1))
                        .contentShape(RoundedRectangle(cornerRadius: 11))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 7).padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity)
        .frame(height: min(800, CGFloat(StudySubject.allCases.count * 45 + 32)))
        .background(palette.cardSurface, in: RoundedRectangle(cornerRadius: 15))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(palette.purple, lineWidth: 2))
        .shadow(color: palette.purple.opacity(0.22), radius: 10, x: 0, y: 5)
    }

    private var subjectEmoji: String {
        switch selectedSubject {
        case .math: "🔢"
        case .world: "🌍"
        case .russian: "📚"
        case .english: "🔤"
        case .tatar: "🌿"
        case .art: "🎨"
        case .chemistry: "⚗️"
        case .informatics: "💻"
        case .pdd: "🚦"
        case .orthography: "🔤"
        case .geography: "🌎"
        case .logic: "🧩"
        case .biology: "🧬"
        case .geometry: "📐"
        }
    }

    private var taskDashboard: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 11) {
                topBar
                quizCard.frame(maxWidth: .infinity, minHeight: 430)
                tipBar
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            rightDashboard.frame(maxWidth: 286, maxHeight: .infinity)
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var topBar: some View {
        HStack(spacing: 10) {
                Text("🔥").font(.system(size: 30 * AppFontScale.factor))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Серия").font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.muted)
                    Text("\(store.stats.currentStreak) подряд").font(.system(size: 17 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                }
                Spacer(minLength: 2)
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { index in
                        Circle().fill(index < store.stats.currentStreak % 5 ? palette.purple : palette.line).frame(width: 8, height: 8)
                    }
                }
            }.padding(.horizontal, 12).frame(maxWidth: .infinity).frame(height: 70)
             .background(palette.cardSurface.opacity(0.76), in: RoundedRectangle(cornerRadius: 20))
             .overlay(RoundedRectangle(cornerRadius: 20).stroke(palette.line, lineWidth: 1))
    }

    private var quizCard: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 16)
            Text("РЕШИ ПРИМЕР")
                .font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded))
                .tracking(1.1)
                .foregroundStyle(palette.isDark ? Color(red: 0.88, green: 0.82, blue: 1) : palette.purple)
                .padding(.horizontal, 22)
                .padding(.vertical, 11)
                .background(palette.cardSurface.opacity(0.84), in: Capsule())
                .overlay(Capsule().stroke(.white, lineWidth: 1))
                .shadow(color: palette.pink.opacity(0.18), radius: 9, y: 3)

            Spacer(minLength: 24)

            if !(selectedSubject == .geometry && problem.showIllustration) {
                HStack {
                    Spacer()
                    Button {
                        var textToCopy = problem.text
                        if problem.isTatarChoice { textToCopy += "\nВарианты: " + problem.tatarChoices.joined(separator: " | ") }
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(textToCopy, forType: .string)
                    } label: {
                        Label("Копировать вопрос", systemImage: "doc.on.doc")
                            .font(.system(size: 11 * AppFontScale.factor, weight: .semibold, design: .rounded))
                            .foregroundStyle(palette.purple)
                    }.buttonStyle(.plain).help("Скопировать вопрос и варианты ответов")
                }.padding(.horizontal, 25)
            }
            if !(selectedSubject == .geometry && problem.showIllustration) {
                Text(problem.text)
                    .textSelection(.enabled)
                    .font(.system(size: (selectedSubject == .math ? 62 : 38) * fontScaleH4 * AppFontScale.factor, weight: .heavy, design: .rounded))
                    .foregroundStyle(palette.ink)
                    .multilineTextAlignment(.center)
                    .contentTransition(.numericText())
                    .minimumScaleFactor(0.42)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 12)
            }

            if selectedSubject == .pdd && shouldShowPDDIllustration(for: problem.text) {
                pddIllustration(for: problem.text).padding(.horizontal, 24).padding(.top, 5)
            } else if selectedSubject == .geography && problem.text.localizedCaseInsensitiveContains("флаг") {
                geographyFlagIllustration(for: problem).padding(.horizontal, 24).padding(.top, 5)
            } else if shouldShowStudyIllustration(for: problem, subject: selectedSubject) {
                StudyIllustration(subject: selectedSubject, prompt: problem.text + (selectedSubject == .geometry ? " " + problem.answer : "")).frame(maxWidth: .infinity).frame(height: 126).padding(.horizontal, 30).padding(.top, 8)
            }

            Spacer(minLength: selectedSubject == .pdd ? 7 : 34)

            if problem.isTatarChoice {
                tatarChoiceGrid
            } else {
                HStack(spacing: 11) {
                    TextField(problem.isComparison ? "Выбери знак ниже" : "Введи ответ...", text: $answer)
                        .font(.system(size: 23 * AppFontScale.factor * fontScaleH5, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(answerColor)
                        .textFieldStyle(.plain)
                        .focusEffectDisabled()
                        .frame(height: 74)
                        .background(palette.cardSurface.opacity(0.9), in: RoundedRectangle(cornerRadius: 21))
                        .overlay(RoundedRectangle(cornerRadius: 21).stroke(answerColor.opacity(0.78), lineWidth: 2))
                        .focused($answerFocused)
                        .onSubmit(checkAnswer)
                        .onChange(of: answer) { _, newValue in
                            if problem.isComparison {
                                let filtered = String(newValue.filter { ["<", ">", "="].contains(String($0)) }.prefix(1))
                                if filtered != newValue { answer = filtered }
                            } else if selectedSubject == .math {
                                let filtered = String(newValue.filter(\.isNumber).prefix(4))
                                if filtered != newValue { answer = filtered }
                            } else if newValue.count > 24 {
                                answer = String(newValue.prefix(24))
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
                                        .font(.system(size: 24 * AppFontScale.factor, weight: .heavy, design: .rounded))
                                        .foregroundStyle(answer == symbol ? .white : palette.ink)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 49)
                                        .background(answer == symbol ? palette.purple : palette.cardSurface.opacity(palette.isDark ? 0.98 : 0.90), in: RoundedRectangle(cornerRadius: 14))
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
                        .font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded))
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
            }

            Text(stateMessage)
                .font(.system(size: 18 * AppFontScale.factor, weight: .heavy, design: .rounded))
                .foregroundStyle(answerColor)
                .frame(height: 31)
                .padding(.top, 13)

            Spacer(minLength: 22)
            HStack(spacing: 8) {
                Text("✨")
                Text("Ты можешь! У тебя всё получится!")
                    .font(.system(size: 14 * AppFontScale.factor, weight: .bold, design: .rounded))
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
            Text("✦").font(.system(size: 24 * AppFontScale.factor)).foregroundStyle(Color(red: 1, green: 0.74, blue: 0.44)).padding(23)
        }
        .overlay(alignment: .topTrailing) {
            Text("✧").font(.system(size: 30 * AppFontScale.factor)).foregroundStyle(palette.pink).padding(26)
        }
        .overlay(alignment: .bottomTrailing) {
            Text("✦").font(.system(size: 22 * AppFontScale.factor)).foregroundStyle(Color(red: 1, green: 0.78, blue: 0.52)).padding(23)
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

    @ViewBuilder
    private func geographyFlagIllustration(for problem: Problem) -> some View {
        VStack(spacing: 6) {
            flagDesign(for: problem.answer).frame(width: 172, height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 8)).overlay(RoundedRectangle(cornerRadius: 8).stroke(.white, lineWidth: 2))
                .shadow(color: .black.opacity(0.20), radius: 8, y: 4)
            Text("ФЛАГ СТРАНЫ").font(.system(size: 10 * AppFontScale.factor, weight: .black, design: .rounded)).tracking(1.1).foregroundStyle(palette.muted)
        }
        .padding(10).background(palette.cardSurface.opacity(0.96), in: RoundedRectangle(cornerRadius: 15))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(palette.line, lineWidth: 1))
    }

    @ViewBuilder
    private func flagDesign(for country: String) -> some View {
        switch country {
        case "Германия":
            VStack(spacing: 0) { Color.black; Color(red: 0.83, green: 0.12, blue: 0.18); Color(red: 1, green: 0.79, blue: 0.13) }
        case "Франция":
            HStack(spacing: 0) { Color(red: 0.12, green: 0.24, blue: 0.61); Color.white; Color(red: 0.85, green: 0.15, blue: 0.22) }
        case "Италия":
            HStack(spacing: 0) { Color(red: 0.0, green: 0.57, blue: 0.31); Color.white; Color(red: 0.85, green: 0.15, blue: 0.19) }
        case "Испания":
            VStack(spacing: 0) { Color(red: 0.73, green: 0.08, blue: 0.13); Color(red: 1, green: 0.78, blue: 0.13); Color(red: 0.73, green: 0.08, blue: 0.13) }
        case "Япония":
            ZStack { Color.white; Circle().fill(Color(red: 0.73, green: 0.06, blue: 0.16)).frame(width: 42, height: 42) }
        case "Бразилия":
            ZStack { Color(red: 0.0, green: 0.48, blue: 0.25); FlagDiamond().fill(Color(red: 1, green: 0.82, blue: 0.15)).padding(.horizontal, 22).padding(.vertical, 17); Circle().fill(Color(red: 0.05, green: 0.20, blue: 0.52)).frame(width: 37, height: 37) }
        case "Китай":
            ZStack(alignment: .topLeading) { Color(red: 0.87, green: 0.09, blue: 0.16); Image(systemName: "star.fill").font(.system(size: 30 * AppFontScale.factor)).foregroundStyle(Color(red: 1, green: 0.83, blue: 0.20)).padding(12) }
        case "Индия":
            VStack(spacing: 0) { Color(red: 1, green: 0.57, blue: 0.17); Color.white; ZStack { Color(red: 0.07, green: 0.44, blue: 0.28); Circle().fill(Color(red: 0.09, green: 0.22, blue: 0.52)).frame(width: 24, height: 24).overlay(Circle().stroke(Color.white, lineWidth: 1)) } }
        case "Польша":
            VStack(spacing: 0) { Color.white; Color(red: 0.85, green: 0.12, blue: 0.24) }
        case "США":
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) { ForEach(0..<13, id: \.self) { i in (i.isMultiple(of: 2) ? Color.white : Color(red: 0.78, green: 0.12, blue: 0.20)) } }
                Color(red: 0.10, green: 0.20, blue: 0.47).frame(width: 72, height: 51).overlay(Image(systemName: "star.fill").font(.system(size: 20 * AppFontScale.factor)).foregroundStyle(.white))
            }
        case "Великобритания":
            ZStack { Color(red: 0.06, green: 0.15, blue: 0.39); Rectangle().fill(.white).frame(height: 25); Rectangle().fill(.white).frame(width: 25); Rectangle().fill(Color(red: 0.78, green: 0.07, blue: 0.18)).frame(height: 12); Rectangle().fill(Color(red: 0.78, green: 0.07, blue: 0.18)).frame(width: 12) }
        case "Украина":
            VStack(spacing: 0) { Color(red: 0, green: 0.37, blue: 0.78); Color(red: 1, green: 0.83, blue: 0.18) }
        case "Нидерланды":
            HStack(spacing: 0) { Color(red: 0.68, green: 0.08, blue: 0.16); Color.white; Color(red: 0.08, green: 0.22, blue: 0.55) }
        case "Австрия":
            VStack(spacing: 0) { Color(red: 0.78, green: 0.08, blue: 0.16); Color.white; Color(red: 0.78, green: 0.08, blue: 0.16) }
        case "Бельгия":
            HStack(spacing: 0) { Color.black; Color(red: 0.98, green: 0.82, blue: 0.10); Color(red: 0.83, green: 0.10, blue: 0.16) }
        case "Швейцария":
            ZStack { Color(red: 0.82, green: 0.08, blue: 0.16); Rectangle().fill(.white).frame(width: 48, height: 15); Rectangle().fill(.white).frame(width: 15, height: 48) }
        case "Швеция":
            ZStack { Color(red: 0.05, green: 0.29, blue: 0.60); Rectangle().fill(Color(red: 0.98, green: 0.79, blue: 0.12)).frame(height: 13).offset(y: -5); Rectangle().fill(Color(red: 0.98, green: 0.79, blue: 0.12)).frame(width: 13).offset(x: -28) }
        case "Норвегия":
            ZStack { Color(red: 0.78, green: 0.08, blue: 0.16); Rectangle().fill(.white).frame(height: 25); Rectangle().fill(.white).frame(width: 25); Rectangle().fill(Color(red: 0.05, green: 0.18, blue: 0.43)).frame(height: 12); Rectangle().fill(Color(red: 0.05, green: 0.18, blue: 0.43)).frame(width: 12) }
        case "Дания":
            ZStack { Color(red: 0.78, green: 0.08, blue: 0.16); Rectangle().fill(.white).frame(height: 13).offset(y: -7); Rectangle().fill(.white).frame(width: 13).offset(x: -34) }
        case "Финляндия":
            ZStack { Color.white; Rectangle().fill(Color(red: 0.08, green: 0.22, blue: 0.55)).frame(height: 14); Rectangle().fill(Color(red: 0.08, green: 0.22, blue: 0.55)).frame(width: 14).offset(x: -30) }
        case "Греция":
            VStack(spacing: 0) { ForEach(0..<9, id: \.self) { i in i.isMultiple(of: 2) ? Color(red: 0.05, green: 0.24, blue: 0.55) : Color.white } }
        case "Ирландия":
            HStack(spacing: 0) { Color(red: 0.06, green: 0.55, blue: 0.30); Color.white; Color(red: 0.96, green: 0.42, blue: 0.12) }
        case "Мексика":
            HStack(spacing: 0) { Color(red: 0.02, green: 0.40, blue: 0.24); ZStack { Color.white; Image(systemName: "bird.fill").foregroundStyle(Color(red: 0.45, green: 0.28, blue: 0.12)) }; Color(red: 0.82, green: 0.10, blue: 0.17) }
        case "Аргентина":
            VStack(spacing: 0) { Color(red: 0.42, green: 0.75, blue: 0.91); ZStack { Color.white; Circle().fill(Color(red: 0.96, green: 0.72, blue: 0.13)).frame(width: 20, height: 20) }; Color(red: 0.42, green: 0.75, blue: 0.91) }
        case "Южная Корея":
            ZStack { Color.white; Circle().trim(from: 0, to: 0.5).fill(Color(red: 0.82, green: 0.12, blue: 0.18)).frame(width: 36, height: 36).rotationEffect(.degrees(-90)); Circle().trim(from: 0.5, to: 1).fill(Color(red: 0.05, green: 0.22, blue: 0.55)).frame(width: 36, height: 36).rotationEffect(.degrees(-90)) }
        case "Турция":
            ZStack(alignment: .leading) { Color(red: 0.85, green: 0.08, blue: 0.16); HStack(spacing: 2) { Image(systemName: "moon.fill"); Image(systemName: "star.fill").font(.system(size: 15 * AppFontScale.factor)) }.font(.system(size: 28 * AppFontScale.factor)).foregroundStyle(.white).padding(.leading, 24) }
        case "Саудовская Аравия":
            ZStack { Color(red: 0.02, green: 0.38, blue: 0.22); Text("لا إله إلا الله").font(.system(size: 15 * AppFontScale.factor, weight: .bold)).foregroundStyle(.white); Rectangle().fill(.white).frame(width: 58, height: 3).offset(y: 24) }
        case "Пакистан":
            HStack(spacing: 0) { Color.white.frame(width: 35); ZStack { Color(red: 0.01, green: 0.36, blue: 0.23); Image(systemName: "moon.fill").font(.system(size: 31 * AppFontScale.factor)).foregroundStyle(.white); Image(systemName: "star.fill").font(.system(size: 12 * AppFontScale.factor)).foregroundStyle(.white).offset(x: 10, y: -8) } }
        case "Индонезия":
            VStack(spacing: 0) { Color(red: 0.82, green: 0.08, blue: 0.16); Color.white }
        case "Вьетнам":
            ZStack { Color(red: 0.82, green: 0.08, blue: 0.16); Image(systemName: "star.fill").font(.system(size: 38 * AppFontScale.factor)).foregroundStyle(Color(red: 1, green: 0.83, blue: 0.16)) }
        case "Таиланд":
            VStack(spacing: 0) { Color(red: 0.75, green: 0.06, blue: 0.16); Color.white; Color(red: 0.05, green: 0.12, blue: 0.32).frame(height: 32); Color.white; Color(red: 0.75, green: 0.06, blue: 0.16) }
        default:
            VStack(spacing: 0) { Color.white; Color(red: 0.1, green: 0.35, blue: 0.9); Color(red: 0.86, green: 0.10, blue: 0.18) }
        }
    }

    private struct TriangleShape: Shape {
        func path(in rect: CGRect) -> Path {
            Path { p in
                p.move(to: CGPoint(x: rect.midX, y: rect.minY))
                p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                p.closeSubpath()
            }
        }
    }
    private struct FlagDiamond: Shape {
        func path(in rect: CGRect) -> Path {
            Path { p in
                p.move(to: CGPoint(x: rect.midX, y: rect.minY))
                p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
                p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
                p.closeSubpath()
            }
        }
    }

    private func shouldShowPDDIllustration(for question: String) -> Bool {
        let q = question.lowercased()
        // General road-safety questions should not receive a random-looking sign.
        if q.contains("светофор") { return true }
        guard q.contains("знак") else { return false }
        let supportedSignDescriptions = [
            "стоянка запрещена", "остановка запрещена", "въезд запрещ",
            "главная дорога", "уступите дорогу", "числом 40", "число 40",
            "скорости 40", "парков", "буквой p", "велосипедная дорожка",
            "круговое движение", "пешеходного перехода", "обгон запрещ",
            "предупреждающий дорожный знак", "дети", "железнодорож",
            "дорожные работы", "движение прямо",
            "поворот направо запрещ", "поворот налево запрещ", "разворот запрещ", "движение запрещено"
        ]
        return supportedSignDescriptions.contains(where: { q.contains($0) })
    }

    @ViewBuilder
    private func pddIllustration(for question: String) -> some View {
        let q = question.lowercased()
        let signCode: String? = {
            // Use reference PNGs of Russian road signs rather than hand-drawn approximations.
            // Source: Team6hakaton/Road_signs, directory "8. Эталонные знаки".
            if q.contains("стоянка запрещена") { return "3.28" }
            if q.contains("остановка запрещена") { return "3.27" }
            if q.contains("въезд запрещ") { return "3.1" }
            if q.contains("движение запрещено") { return "3.2" }
            if q.contains("главная дорога") { return "2.1" }
            if q.contains("уступите дорогу") { return "2.4" }
            if q.contains("числом 40") || q.contains("число 40") || q.contains("скорости 40") || q.contains("ограничение максимальной скорости") { return "3.24" }
            if q.contains("парков") || q.contains("буквой p") { return "6.4" }
            if q.contains("велосипедная дорожка") { return "4.4.1" }
            if q.contains("круговое движение") { return "4.3" }
            if q.contains("пешеходного перехода") || q.contains("знак пешеходного перехода") { return "5.19.1" }
            if q.contains("обгон запрещ") { return "3.20" }
            if q.contains("предупреждающий дорожный знак") || q.contains("прочие опасности") { return "1.33" }
            if q.contains("дети") { return "1.23" }
            if q.contains("железнодорож") { return "1.1" }
            if q.contains("дорожные работы") { return "1.25" }
            if q.contains("синий круг с белой стрелкой вверх") || q.contains("движение прямо") { return "4.1.1" }
            if q.contains("поворот направо запрещ") { return "3.18.1" }
            if q.contains("поворот налево запрещ") { return "3.18.2" }
            if q.contains("разворот запрещ") { return "3.19" }
            if q.contains("скользкая дорога") || q.contains("скользкая") { return "1.15" }
            if q.contains("неровност") { return "1.16" }
            if q.contains("конец ограничения скорости") { return "3.25" }
            if q.contains("движение пешеходов запрещено") { return "3.10" }
            if q.contains("крутой спуск") { return "1.13" }
            if q.contains("падение камней") { return "1.28" }
            if q.contains("сужение") { return "1.20.1" }
            return nil
        }()
        VStack(spacing: 7) {
            if let signCode {
                let encodedFolder = "8.%20%D0%AD%D1%82%D0%B0%D0%BB%D0%BE%D0%BD%D0%BD%D1%8B%D0%B5%20%D0%B7%D0%BD%D0%B0%D0%BA%D0%B8"
                AsyncImage(url: URL(string: "https://raw.githubusercontent.com/Team6hakaton/Road_signs/main/\(encodedFolder)/\(signCode).png")) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .empty:
                        ProgressView().controlSize(.large)
                    case .failure:
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable().scaledToFit().foregroundStyle(.orange)
                    @unknown default:
                        Image(systemName: "road.lanes")
                            .resizable().scaledToFit()
                    }
                }
                .frame(width: 104, height: 104)
                .padding(8)
                .background(Color.white, in: RoundedRectangle(cornerRadius: 16))
                Text("ОФИЦИАЛЬНОЕ ИЗОБРАЖЕНИЕ ДОРОЖНОГО ЗНАКА")
                    .font(.system(size: 9 * AppFontScale.factor, weight: .black, design: .rounded))
                    .tracking(0.3)
                    .foregroundStyle(palette.muted)
            } else {
                HStack(spacing: 16) {
                    Image(systemName: q.contains("светофор") ? "trafficlight.fill" : (q.contains("размет") || q.contains("зебр") ? "road.lanes" : "figure.walk"))
                        .font(.system(size: 44 * AppFontScale.factor, weight: .bold))
                        .foregroundStyle(palette.purple)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(q.contains("светофор") ? "СВЕТОФОР" : "БЕЗОПАСНОСТЬ")
                            .font(.system(size: 12 * AppFontScale.factor, weight: .black, design: .rounded))
                            .foregroundStyle(palette.ink)
                        Text("Смотри по сторонам")
                            .font(.system(size: 11 * AppFontScale.factor, weight: .semibold, design: .rounded))
                            .foregroundStyle(palette.muted)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 104)
            }
        }
        .padding(8)
        .background(palette.cardSurface.opacity(0.96), in: RoundedRectangle(cornerRadius: 19))
        .overlay(RoundedRectangle(cornerRadius: 19).stroke(palette.line, lineWidth: 1))
    }

    private var tatarChoiceGrid: some View {
        VStack(spacing: 12) {
            Text(selectedSubject == .tatar ? "ВЫБЕРИ ПРАВИЛЬНЫЙ ПЕРЕВОД" : "ВЫБЕРИ ПРАВИЛЬНЫЙ ОТВЕТ")
                .font(.system(size: 11 * AppFontScale.factor, weight: .black, design: .rounded))
                .tracking(0.35)
                .foregroundStyle(palette.purple)
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                ForEach(Array(problem.tatarChoices.enumerated()), id: \.element) { index, choice in
                    Button {
                        answer = choice
                        answerFocused = false
                        DispatchQueue.main.async { checkAnswer() }
                    } label: {
                        HStack(spacing: 8) {
                            Text(["А", "Б", "В", "Г"][index])
                                .font(.system(size: 13 * AppFontScale.factor, weight: .black, design: .rounded))
                                .frame(width: 27, height: 27)
                                .background(answer == choice ? Color.white.opacity(0.22) : palette.palePink, in: Circle())
                            Text(choice)
                                .font(.system(size: 14 * AppFontScale.factor * fontScaleH5, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            Spacer(minLength: 0)
                        }
                        .foregroundStyle(answer == choice ? .white : palette.ink)
                        .padding(10)
                        .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
                        .background(answer == choice ? palette.purple : palette.cardSurface, in: RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(answer == choice ? palette.purple : palette.line, lineWidth: answer == choice ? 2.5 : 1.5))
                    }
                    .buttonStyle(.plain)
                    .disabled(answerState == .correct)
                }
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 8)
    }

    private var bunnySticker: some View {
        VStack(spacing: 0) {
            Text("😱").font(.system(size: 27 * AppFontScale.factor)).offset(x: 22, y: 12)
            Text("🐰").font(.system(size: 92 * AppFontScale.factor))
            Text("Ой!").font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded))
                .foregroundStyle(palette.purple).offset(y: -8)
        }
        .frame(width: 112, height: 150)
        .background(LinearGradient(colors: [palette.cardSurface, palette.palePink], startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 27))
        .overlay(RoundedRectangle(cornerRadius: 27).stroke(.white, lineWidth: 2))
        .shadow(color: palette.purple.opacity(0.23), radius: 14, x: 3, y: 5)
        .allowsHitTesting(false)
    }

    private var tipBar: some View {
        HStack(spacing: 12) {
            Text("💡").font(.system(size: 29 * AppFontScale.factor))
            VStack(alignment: .leading, spacing: 3) {
                Text("Маленькая подсказка")
                    .font(.system(size: 13 * AppFontScale.factor * fontScaleH6, weight: .heavy, design: .rounded))
                    .foregroundStyle(palette.ink)
                Text(currentTip)
                    .font(.system(size: 12 * AppFontScale.factor * fontScaleHints, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.muted)
            }
            Spacer(minLength: 4)
            Rectangle().fill(palette.line).frame(width: 1, height: 34)
            Button { nextProblem() } label: {
                Label("Новый пример", systemImage: "arrow.clockwise")
                    .font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.purple)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(palette.cardSurface.opacity(0.75), in: RoundedRectangle(cornerRadius: 19))
        .overlay(RoundedRectangle(cornerRadius: 19).stroke(palette.line.opacity(0.75), lineWidth: 1))
    }

    private var rightDashboard: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    sectionTitle("Общая статистика", icon: "chart.bar.fill")
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 6), GridItem(.flexible(), spacing: 6)], spacing: 6) {
                        miniStat("Всего", value: "\(store.stats.total)", icon: "list.number", color: palette.purple)
                        miniStat("Верных", value: "\(store.stats.correct)", icon: "checkmark.circle.fill", color: palette.green)
                        miniStat("Ошибок", value: "\(store.stats.incorrect)", icon: "xmark.circle.fill", color: palette.red)
                        miniStat("Точность", value: "\(store.stats.accuracy)%", icon: "percent", color: Color(red: 0.29, green: 0.57, blue: 0.87))
                    }
                    Divider().overlay(palette.line).padding(.vertical, 3)

                }.padding(9).cardStyle(palette)

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        sectionTitle("Сегодня", icon: "calendar")
                        Spacer()
                        Text("За день").font(.system(size: 10 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
                    }
                    todayStat("Верных ответов", value: today.correct, icon: "checkmark.circle.fill", color: palette.green)
                    todayStat("Неверных ответов", value: today.incorrect, icon: "xmark.circle.fill", color: palette.red)
                    todayStat("Всего ответов", value: today.total, icon: "list.number", color: palette.purple)
                    HStack {
                        Text("Точность").font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                        Spacer()
                        Text("\(today.accuracy)%").font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple)
                    }
                }
                .padding(13)
                .cardStyle(palette)

                .padding(13)
                .cardStyle(palette)

                VStack(alignment: .leading, spacing: 10) {
                    sectionTitle("Награды", icon: "trophy.fill")
                    rewardPreview(emoji: "🧸", title: "20 алмазов", subtitle: "Салют из игрушек", progress: min(store.stats.diamonds, 20), goal: 20)
                    rewardPreview(emoji: "🦋", title: "50 алмазов", subtitle: "Птички и бабочки", progress: min(store.stats.diamonds, 50), goal: 50)
                    Button("Все награды →") { selected = .rewards }
                        .font(.system(size: 11 * AppFontScale.factor, weight: .bold, design: .rounded))
                        .foregroundStyle(palette.purple).buttonStyle(.plain)
                }
                .padding(13)
                .cardStyle(palette)
            }
        }
        .scrollIndicators(.hidden)
    }

    private var dailyHistorySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("По дням", icon: "calendar")
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    tableHead("Дата занятия", align: .leading)
                    tableHead("Верных", align: .trailing).frame(width: 58)
                    tableHead("Ошибок", align: .trailing).frame(width: 58)
                    tableHead("Всего", align: .trailing).frame(width: 52)
                    tableHead("%", align: .trailing).frame(width: 42)
                }
                if store.stats.days.isEmpty {
                    emptyHint("Пока занятий нет. Реши первый пример — здесь появятся результаты по каждому дню.")
                } else {
                    ForEach(store.stats.days) { day in
                        HStack(spacing: 8) {
                            Text(StatsStore.displayDate(day.date)).foregroundStyle(palette.ink).lineLimit(1).minimumScaleFactor(0.65).frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(day.correct)").foregroundStyle(palette.green).frame(width: 58, alignment: .trailing)
                            Text("\(day.incorrect)").foregroundStyle(palette.red).frame(width: 58, alignment: .trailing)
                            Text("\(day.total)").foregroundStyle(palette.ink).frame(width: 52, alignment: .trailing)
                            Text("\(day.accuracy)%").foregroundStyle(palette.purple).frame(width: 42, alignment: .trailing)
                        }
                        .font(.system(size: 11 * AppFontScale.factor, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 8).padding(.vertical, 7)
                        .background(palette.cardSurface.opacity(0.55), in: RoundedRectangle(cornerRadius: 9))
                    }
                }
            }
            VStack(alignment: .leading, spacing: 10) {
                sectionTitle("История по месяцам", icon: "calendar")
                if store.monthSummaries.isEmpty {
                    emptyHint("История появится после первых занятий; завершённые месяцы сохраняются отдельно.")
                } else {
                    ForEach(store.monthSummaries) { month in
                        VStack(alignment: .leading, spacing: 7) {
                            HStack {
                                Text(StatsStore.displayMonth(month.monthKey)).font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                                Spacer()
                                Text("\(month.accuracy)%").font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple)
                            }
                            HStack(spacing: 10) {
                                Text("\(month.correct) верно").foregroundStyle(palette.green)
                                Text("\(month.incorrect) ошибок").foregroundStyle(palette.red)
                                Spacer(minLength: 0)
                                Text("Всего: \(month.total)").foregroundStyle(palette.ink)
                            }.font(.system(size: 10 * AppFontScale.factor, weight: .semibold, design: .rounded))
                            HStack {
                                Text("Лучшая серия: \(month.bestStreak)")
                                Spacer()
                                Text("Дней с занятиями: \(month.days.filter { $0.total > 0 }.count)")
                            }.font(.system(size: 10 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                        }
                        .padding(11).background(palette.cardSurface.opacity(0.55), in: RoundedRectangle(cornerRadius: 11))
                    }
                }
            }
        }
        .padding(14)
        .cardStyle(palette)
    }

    private var dailyPreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                sectionTitle("Статистика по дням", icon: "calendar")
                Spacer()
                Button("Показать все") { selected = .days }
                    .font(.system(size: 11 * AppFontScale.factor, weight: .bold, design: .rounded))
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
                    .font(.system(size: 11 * AppFontScale.factor, weight: .semibold, design: .rounded))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 7)
                    .background(palette.cardSurface.opacity(0.48), in: RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(12)
        .cardStyle(palette)
    }


    private var detectivePage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                pageHeading("Ежедневный детектив", subtitle: "Пять небольших загадок для внимательного сыщика 🔎")
                HStack(spacing: 14) {
                    Text("🕵️").font(.system(size: 54 * AppFontScale.factor))
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Дело дня").font(.system(size: 22 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                        Text("Реши 5 заданий. За правильные ответы получишь алмазы, а за идеальный результат — дополнительный бонус раз в день.")
                            .font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    }
                    Spacer(minLength: 0)
                }.padding(18).cardStyle(palette)
                VStack(alignment: .leading, spacing: 12) {
                    Label("Подробный отчёт", systemImage: "chart.bar.xaxis")
                        .font(.system(size: 17 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        miniStat("Всего попыток", value: "\(detectiveTotalAttempts)", icon: "list.number", color: palette.purple)
                        miniStat("Верно", value: "\(detectiveTotalCorrect)", icon: "checkmark.circle.fill", color: palette.green)
                        miniStat("Ошибки", value: "\(detectiveTotalWrong)", icon: "xmark.circle.fill", color: palette.red)
                        miniStat("Точность", value: "\(detectiveTotalAttempts == 0 ? 0 : Int((Double(detectiveTotalCorrect) / Double(detectiveTotalAttempts) * 100).rounded()))%", icon: "target", color: palette.purple)
                        miniStat("Серия сейчас", value: "\(detectiveCurrentStreak)", icon: "flame.fill", color: Color.orange)
                        miniStat("Лучшая серия", value: "\(detectiveBestStreak)", icon: "trophy.fill", color: Color.orange)
                    }
                }.padding(16).cardStyle(palette)
                if detectiveFinished {
                    VStack(spacing: 14) {
                        Text(detectiveScore == detectiveQuestions.count ? "🏆" : "✨").font(.system(size: 64 * AppFontScale.factor))
                        Text(detectiveScore == detectiveQuestions.count ? "Дело раскрыто идеально!" : "Расследование завершено!")
                            .font(.system(size: 25 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                        Text("Правильных ответов: \(detectiveScore) из \(detectiveQuestions.count)")
                            .font(.system(size: 18 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.purple)
                        if detectiveRewardDate == StatsStore.dateKey(Date()) {
                            Text("Награда за сегодня уже получена. Можно сыграть ещё раз и потренироваться.")
                                .font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted).multilineTextAlignment(.center)
                        }
                        Button {
                            detectiveQuestions = Array(ActivityQuestionBank.detective.shuffled().prefix(5))
                            detectiveIndex = 0; detectiveScore = 0; detectiveSelectedAnswer = nil; detectiveShowDetailedError = false; detectiveFinished = false
                        } label: {
                            Label("Новое расследование", systemImage: "arrow.clockwise")
                                .font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                                .padding(.horizontal, 22).padding(.vertical, 13).background(palette.purple, in: Capsule())
                        }.buttonStyle(.plain)
                    }.frame(maxWidth: .infinity).padding(28).cardStyle(palette)
                } else if detectiveQuestions.indices.contains(detectiveIndex) {
                    let item = detectiveQuestions[detectiveIndex]
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("ЗАДАНИЕ \(detectiveIndex + 1) ИЗ \(detectiveQuestions.count)")
                                .font(.system(size: 11 * AppFontScale.factor, weight: .black, design: .rounded)).tracking(0.7).foregroundStyle(palette.purple)
                            Spacer()
                            Text("⭐ \(detectiveScore)").font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                        }
                        HStack(alignment: .center, spacing: 14) {
                            Text(item.symbol).font(.system(size: 52 * AppFontScale.factor)).frame(width: 72, height: 72).background(palette.cardSurface, in: RoundedRectangle(cornerRadius: 18))
                            Text(item.prompt).font(.system(size: 20 * AppFontScale.factor * fontScaleH4, weight: .bold, design: .rounded)).foregroundStyle(palette.ink).fixedSize(horizontal: false, vertical: true)
                        }
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(item.choices, id: \.self) { choice in
                                Button {
                                    guard detectiveSelectedAnswer == nil else { return }
                                    detectiveSelectedAnswer = choice
                                    detectiveTotalAttempts += 1
                                    markMentorActivity()
                                    if choice == item.answer {
                                        detectiveScore += 1
                                        detectiveTotalCorrect += 1
                                        detectiveCurrentStreak += 1
                                        detectiveBestStreak = max(detectiveBestStreak, detectiveCurrentStreak)
                                        goldBalance += 1
                                    } else {
                                        detectiveTotalWrong += 1
                                        detectiveCurrentStreak = 0
                                        recordActivityMistake(source: "Ежедневный детектив", prompt: item.prompt, selectedAnswer: choice, correctAnswer: item.answer, choices: item.choices, explanation: item.explanation)
                                    }
                                } label: {
                                    Text(choice).font(.system(size: 15 * AppFontScale.factor * fontScaleH5, weight: .bold, design: .rounded))
                                        .foregroundStyle(detectiveSelectedAnswer == choice ? .white : palette.ink)
                                        .frame(maxWidth: .infinity, minHeight: 54)
                                        .padding(.horizontal, 8)
                                        .background(detectiveSelectedAnswer == choice ? (choice == item.answer ? palette.green : palette.red) : palette.cardSurface, in: RoundedRectangle(cornerRadius: 13))
                                        .overlay(RoundedRectangle(cornerRadius: 13).stroke(palette.line, lineWidth: 1))
                                }.buttonStyle(.plain).disabled(detectiveSelectedAnswer != nil)
                            }
                        }
                        if let picked = detectiveSelectedAnswer {
                            Text(picked == item.answer ? "Верно! \(item.explanation)" : "Пока не получилось. Правильный ответ: \(item.answer). \(item.explanation)")
                                .font(.system(size: 14 * AppFontScale.factor, weight: .medium, design: .rounded))
                                .foregroundStyle(picked == item.answer ? palette.green : palette.red)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(12).frame(maxWidth: .infinity, alignment: .leading)
                                .background((picked == item.answer ? palette.green : palette.red).opacity(0.09), in: RoundedRectangle(cornerRadius: 12))
                            if picked != item.answer {
                                VStack(alignment: .leading, spacing: 10) {
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.2)) { detectiveShowDetailedError.toggle() }
                                    } label: {
                                        Label(detectiveShowDetailedError ? "Скрыть подробный разбор" : "Разобрать ошибку подробно",
                                              systemImage: detectiveShowDetailedError ? "chevron.up.circle.fill" : "lightbulb.max.fill")
                                            .font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded))
                                            .foregroundStyle(palette.purple)
                                    }.buttonStyle(.plain)
                                    if detectiveShowDetailedError {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Label("Разбор ошибки", systemImage: "magnifyingglass")
                                                .font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded))
                                                .foregroundStyle(palette.ink)
                                            Text("Твой ответ: \(picked)")
                                                .font(.system(size: 13 * AppFontScale.factor, weight: .semibold, design: .rounded))
                                                .foregroundStyle(palette.red)
                                            Text("Правильный ответ: \(item.answer)")
                                                .font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded))
                                                .foregroundStyle(palette.green)
                                            Text(item.explanation)
                                                .font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded))
                                                .foregroundStyle(palette.ink)
                                                .fixedSize(horizontal: false, vertical: true)
                                            Text("Запомни: сначала внимательно прочитай условие, затем сравни свой вариант с объяснением и попробуй применить это правило в следующей загадке.")
                                                .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded))
                                                .foregroundStyle(palette.muted)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                        .padding(14)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(palette.cardSurface, in: RoundedRectangle(cornerRadius: 13))
                                        .overlay(RoundedRectangle(cornerRadius: 13).stroke(palette.line, lineWidth: 1))
                                    }
                                }
                                .padding(12)
                                .background(palette.red.opacity(0.06), in: RoundedRectangle(cornerRadius: 13))
                            }
                            HStack {
                                Spacer()
                                Button {
                                    if detectiveIndex + 1 < detectiveQuestions.count {
                                        detectiveIndex += 1
                                        detectiveSelectedAnswer = nil
                                        detectiveShowDetailedError = false
                                    } else {
                                        detectiveFinished = true
                                        detectiveBestScore = max(detectiveBestScore, detectiveScore)
                                        if detectiveScore == detectiveQuestions.count && detectiveRewardDate != StatsStore.dateKey(Date()) {
                                            store.addDiamonds(5)
                                            detectiveRewardDate = StatsStore.dateKey(Date())
                                        }
                                    }
                                } label: {
                                    Label(detectiveIndex + 1 == detectiveQuestions.count ? "Завершить расследование" : "Следующая загадка", systemImage: "arrow.right")
                                        .font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                                        .padding(.horizontal, 20).padding(.vertical, 12).background(palette.purple, in: Capsule())
                                }.buttonStyle(.plain)
                            }
                        }
                    }.padding(20).cardStyle(palette)
                }
                HStack {
                    Label("Лучший результат: \(detectiveBestScore)/5", systemImage: "trophy.fill")
                    Spacer()
                    Label("Алмазы: \(store.stats.diamonds)", systemImage: "sparkles")
                }.font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.purple)
            }.padding(24)
        }
    }

    private let memoryImageSymbols = ["🐸", "🦊", "🐼", "🦋", "🍓", "🚀", "⭐", "🐢", "🌈", "🐙", "🍉", "🎈"]
    private let memoryLetterSymbols = Array("АБВГДЕЖЗИКЛМНОПРСТУФХ").map(String.init)
    private let memoryDigitSymbols = Array("0123456789").map(String.init)
    private let memorySignSymbols = ["+", "−", "×", "÷", "=", "<", ">", "△", "○", "□"]
    private let memoryShapeSymbols = ["○", "□", "△", "⏢", "◇", "🍦"]
    private let memoryColorSymbols = ["🔴", "🟠", "🟡", "🟢", "🔵", "🟣", "⚫", "⚪"]
    private var mentorActivityDates: Set<String> {
        guard let data = mentorActivityDatesStorage.data(using: .utf8), let dates = try? JSONDecoder().decode([String].self, from: data) else { return [] }
        return Set(dates)
    }
    private func markMentorActivity() {
        var dates = mentorActivityDates
        dates.insert(StatsStore.dateKey(Date()))
        if let data = try? JSONEncoder().encode(Array(dates.sorted().suffix(730))) { mentorActivityDatesStorage = String(decoding: data, as: UTF8.self) }
    }
    private var decodedLifeSkillsReview: [LifeSkillsReviewRecord] {
        guard let data = lifeSkillsReviewStorage.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([LifeSkillsReviewRecord].self, from: data) else { return [] }
        return decoded
    }
    private var decodedReviewAttempts: [ReviewAttemptRecord] {
        guard let data = reviewAttemptsStorage.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([ReviewAttemptRecord].self, from: data) else { return [] }
        return decoded
    }
    private var decodedReviewMastery: [String: Int] {
        guard let data = reviewMasteryStorage.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String: Int].self, from: data) else { return [:] }
        return decoded
    }
    private var unifiedReviewItems: [UnifiedReviewItem] {
        let studyAndDetective = decodedMistakes.map { record in
            UnifiedReviewItem(id: "mistake:\(record.id)", section: record.subject, prompt: record.question, answer: record.correctAnswer,
                choices: reviewChoices(record.choices, answer: record.correctAnswer, extra: record.selectedAnswer),
                explanation: record.explanation, symbol: record.subject == "Ежедневный детектив" ? "🕵️" : "📘")
        }
        let lifeSkills = decodedLifeSkillsReview.map { record in
            UnifiedReviewItem(id: "life:\(record.id)", section: "Навыки жизни", prompt: record.prompt, answer: record.answer,
                choices: reviewChoices(record.choices ?? [], answer: record.answer, extra: record.selectedAnswer),
                explanation: record.explanation, symbol: record.symbol)
        }
        return (studyAndDetective + lifeSkills).sorted { $0.section < $1.section }
    }
    private var pendingUnifiedReviewItems: [UnifiedReviewItem] {
        unifiedReviewItems.filter { (decodedReviewMastery[$0.id] ?? 0) < 3 }
    }
    private func reviewChoices(_ original: [String], answer: String, extra: String) -> [String] {
        var values: [String] = []
        for value in [answer] + original + [extra, "Нужно подумать ещё раз", "Другой вариант", "Попробуй ещё раз", "Верный ответ другой"] {
            if !value.isEmpty && !values.contains(value) { values.append(value) }
            if values.count == 4 { break }
        }
        return Array(values.prefix(4))
    }
    private func saveLifeSkillsReview(_ item: ActivityQuestion, selected: String) {
        var records = decodedLifeSkillsReview
        guard !records.contains(where: { $0.prompt == item.prompt && $0.answer == item.answer }) else { return }
        records.insert(LifeSkillsReviewRecord(id: UUID().uuidString, prompt: item.prompt, answer: item.answer, explanation: item.explanation, symbol: item.symbol, selectedAnswer: selected, choices: item.choices), at: 0)
        if records.count > 100 { records = Array(records.prefix(100)) }
        if let data = try? JSONEncoder().encode(records) { lifeSkillsReviewStorage = String(decoding: data, as: UTF8.self) }
    }
    private func recordUnifiedReviewAttempt(_ item: UnifiedReviewItem, selected: String) {
        let correct = selected == item.answer
        var attempts = decodedReviewAttempts
        attempts.append(ReviewAttemptRecord(id: UUID().uuidString, itemID: item.id, prompt: item.prompt, selectedAnswer: selected, correctAnswer: item.answer, isCorrect: correct, date: StatsStore.dateKey(Date())))
        if let data = try? JSONEncoder().encode(attempts) { reviewAttemptsStorage = String(decoding: data, as: UTF8.self) }
        var mastery = decodedReviewMastery
        mastery[item.id] = correct ? min(3, (mastery[item.id] ?? 0) + 1) : 0
        if let data = try? JSONEncoder().encode(mastery) { reviewMasteryStorage = String(decoding: data, as: UTF8.self) }
    }
    private func startUnifiedReview(_ item: UnifiedReviewItem) {
        activeUnifiedReviewID = item.id
        unifiedReviewSelectedAnswer = nil
        selected = .mistakeReview
    }
    private func startNextUnifiedReview(after currentID: String? = nil) {
        let candidates = pendingUnifiedReviewItems
        let next = candidates.first(where: { $0.id != currentID }) ?? candidates.first
        activeUnifiedReviewID = next?.id
        unifiedReviewSelectedAnswer = nil
    }
    private func recordActivityMistake(source: String, prompt: String, selectedAnswer: String, correctAnswer: String, choices: [String], explanation: String) {
        var items = decodedMistakes
        guard !items.contains(where: { $0.subject == source && $0.question == prompt }) else { return }
        items.insert(MistakeRecord(id: UUID().uuidString, subject: source, question: prompt, selectedAnswer: selectedAnswer, correctAnswer: correctAnswer,
            choices: reviewChoices(choices, answer: correctAnswer, extra: selectedAnswer), explanation: explanation, date: StatsStore.dateKey(Date())), at: 0)
        if let data = try? JSONEncoder().encode(items) { mistakesStorage = String(decoding: data, as: UTF8.self) }
    }
    private func removeLifeSkillsReview(_ id: String) {
        let records = decodedLifeSkillsReview.filter { $0.id != id }
        if let data = try? JSONEncoder().encode(records) { lifeSkillsReviewStorage = String(decoding: data, as: UTF8.self) }
    }
    private var decodedMemoryCategoryStats: [String: [Int]] {
        guard let data = memoryCategoryStatsStorage.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String: [Int]].self, from: data) else { return [:] }
        return decoded
    }
    private func recordMemoryAnswer(correct: Bool) {
        markMentorActivity()
        var stats = decodedMemoryCategoryStats
        let outcomeIndex = correct ? 0 : 1
        for type in memorySelectedTypes {
            var counts = stats[type] ?? [0, 0]
            if counts.count < 2 { counts = [0, 0] }
            counts[outcomeIndex] += 1
            stats[type] = counts
        }
        if let data = try? JSONEncoder().encode(stats) {
            memoryCategoryStatsStorage = String(decoding: data, as: UTF8.self)
        }
    }
    private var availableMemorySymbols: [String] {
        var result: [String] = []
        if memorySelectedTypes.contains("Картинки") { result += memoryImageSymbols }
        if memorySelectedTypes.contains("Буквы") { result += memoryLetterSymbols }
        if memorySelectedTypes.contains("Цифры") { result += memoryDigitSymbols }
        if memorySelectedTypes.contains("Знаки") { result += memorySignSymbols }
        if memorySelectedTypes.contains("Геометрические формы") { result += memoryShapeSymbols }
        if memorySelectedTypes.contains("Цвета") { result += memoryColorSymbols }
        return result.isEmpty ? memoryImageSymbols : result
    }

    private func makeMemoryChoices(for sequence: [String]) -> [String] {
        let correct = sequence.joined(separator: " ")
        var choices = [correct]
        while choices.count < 4 {
            var altered = sequence
            if altered.count > 1 {
                let a = Int.random(in: 0..<altered.count)
                var b = Int.random(in: 0..<altered.count)
                while b == a { b = Int.random(in: 0..<altered.count) }
                altered.swapAt(a, b)
            }
            let option = altered.joined(separator: " ")
            if !choices.contains(option) { choices.append(option) }
        }
        return choices.shuffled()
    }

    private func startMemoryRound() {
        let count = min(8, 3 + memoryLevel)
        let symbols = availableMemorySymbols
        memorySequence = Array(symbols.shuffled().prefix(min(count, symbols.count)))
        memoryChoices = makeMemoryChoices(for: memorySequence)
        memoryShowing = true
        memoryCountdown = 3 + memoryLevel
        memorySelectedAnswer = nil
        memoryRound += 1
    }

    private func stopMemoryTraining() {
        memorySequence = []
        memoryChoices = []
        memoryShowing = true
        memoryCountdown = 3 + memoryLevel
        memorySelectedAnswer = nil
        memoryRound += 1
    }

    private var memoryPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                pageHeading("Тренировка памяти", subtitle: "Запоминай последовательности и постепенно повышай уровень 🧠")
                HStack(spacing: 14) {
                    Text("🧠").font(.system(size: 54 * AppFontScale.factor))
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Уровень \(memoryLevel)").font(.system(size: 22 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                        Text("Посмотри на последовательность, запомни порядок и выбери её среди вариантов. На каждом новом уровне символов становится больше, а время запоминания увеличивается на 1 секунду. Сейчас: \(3 + memoryLevel) сек.")
                            .font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    }
                }.padding(18).cardStyle(palette)
                VStack(alignment: .leading, spacing: 18) {
                    HStack {
                        Text(memoryShowing ? "ЗАПОМНИ ПО ПОРЯДКУ" : "ВОССТАНОВИ ПО ПАМЯТИ")
                            .font(.system(size: 12 * AppFontScale.factor, weight: .black, design: .rounded)).tracking(0.5).foregroundStyle(palette.purple)
                        Spacer()
                        Text("Рекорд: \(memoryBestLevel)").font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.muted)
                        if !memorySequence.isEmpty {
                            Button { stopMemoryTraining() } label: {
                                Label("Стоп", systemImage: "stop.fill")
                                    .font(.system(size: 12 * AppFontScale.factor, weight: .heavy, design: .rounded))
                                    .foregroundStyle(palette.red)
                                    .padding(.horizontal, 11).padding(.vertical, 7)
                                    .background(palette.red.opacity(0.10), in: Capsule())
                            }.buttonStyle(.plain).help("Завершить тренировку и вернуться к настройкам")
                        }
                    }
                    if memorySequence.isEmpty {
                        Text("Выбери, что нужно запоминать:")
                            .font(.system(size: 16 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 9) {
                            ForEach(["Картинки", "Буквы", "Цифры", "Знаки", "Геометрические формы", "Цвета"], id: \.self) { type in
                                Button {
                                    if memorySelectedTypes.contains(type) {
                                        if memorySelectedTypes.count > 1 { memorySelectedTypes.remove(type) }
                                    } else {
                                        memorySelectedTypes.insert(type)
                                    }
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: memorySelectedTypes.contains(type) ? "checkmark.circle.fill" : "circle")
                                            .font(.system(size: 18 * AppFontScale.factor, weight: .bold))
                                        Text(type).font(.system(size: 14 * AppFontScale.factor, weight: .bold, design: .rounded))
                                        Spacer(minLength: 0)
                                    }
                                    .foregroundStyle(memorySelectedTypes.contains(type) ? .white : palette.ink)
                                    .padding(12).frame(maxWidth: .infinity)
                                    .background(memorySelectedTypes.contains(type) ? palette.purple : palette.cardSurface, in: RoundedRectangle(cornerRadius: 12))
                                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(memorySelectedTypes.contains(type) ? palette.purple : palette.line, lineWidth: 1))
                                }.buttonStyle(.plain)
                            }
                        }
                        Text("Можно выбрать несколько вариантов сразу.")
                            .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    } else if memoryShowing {
                        HStack(spacing: 8) {
                            Image(systemName: "metronome")
                                .font(.system(size: 20 * AppFontScale.factor, weight: .bold))
                            Text("\(memoryCountdown)")
                                .font(.system(size: 28 * AppFontScale.factor, weight: .black, design: .rounded).monospacedDigit())
                        }
                        .foregroundStyle(palette.ink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        HStack(spacing: 8) {
                            ForEach(Array(memorySequence.enumerated()), id: \.offset) { _, symbol in
                                Text(symbol)
                                    .font(.system(size: 39 * AppFontScale.factor, weight: .black, design: .rounded))
                                    .foregroundStyle(palette.isDark ? Color.white : Color.black)
                                    .monospacedDigit()
                                    .frame(maxWidth: .infinity, minHeight: 86)
                                    .background(palette.cardSurface, in: RoundedRectangle(cornerRadius: 13))
                                    .overlay(RoundedRectangle(cornerRadius: 13).stroke(palette.purple.opacity(0.35), lineWidth: 1.5))
                            }
                        }.frame(maxWidth: .infinity)
                            .padding(12).background(palette.cardSurface.opacity(0.65), in: RoundedRectangle(cornerRadius: 18))
                        Text("Запоминай и порядок, и сами символы. Последовательность скроется после обратного отсчёта.")
                            .font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    } else {
                        Text("Какая последовательность была показана?").font(.system(size: 19 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink)
                        VStack(spacing: 9) {
                            ForEach(memoryChoices, id: \.self) { choice in
                                Button {
                                    guard memorySelectedAnswer == nil else { return }
                                    memorySelectedAnswer = choice
                                    let correct = memorySequence.joined(separator: " ")
                                    let isCorrect = choice == correct
                                    recordMemoryAnswer(correct: isCorrect)
                                    if isCorrect {
                                        memoryBestLevel = max(memoryBestLevel, memoryLevel)
                                        store.addDiamonds(1)
                                    } else {
                                        memoryLevel = max(1, memoryLevel - 1)
                                    }
                                } label: {
                                    Text(choice).font(.system(size: 21 * AppFontScale.factor, weight: .bold, design: .rounded)).frame(maxWidth: .infinity, minHeight: 56)
                                        .foregroundStyle(memorySelectedAnswer == choice ? .white : (palette.isDark ? Color.white : Color.black))
                                        .background(memorySelectedAnswer == choice ? (choice == memorySequence.joined(separator: " ") ? palette.green : palette.red) : palette.cardSurface, in: RoundedRectangle(cornerRadius: 13))
                                        .overlay(RoundedRectangle(cornerRadius: 13).stroke(palette.line, lineWidth: 1))
                                }.buttonStyle(.plain).disabled(memorySelectedAnswer != nil)
                            }
                        }
                        if let picked = memorySelectedAnswer {
                            Text(picked == memorySequence.joined(separator: " ") ? "Отличная память! Ты заработал 1 алмаз." : "Не беда — тренировка помогает запоминать лучше. Попробуй ещё раз.")
                                .font(.system(size: 14 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(picked == memorySequence.joined(separator: " ") ? palette.green : palette.muted)
                            HStack {
                                Spacer()
                                Button {
                                    if memorySelectedAnswer == memorySequence.joined(separator: " ") { memoryLevel = min(6, memoryLevel + 1) }
                                    startMemoryRound()
                                } label: {
                                    Label("Следующая последовательность", systemImage: "arrow.right")
                                        .font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                                        .padding(.horizontal, 20).padding(.vertical, 12).background(palette.purple, in: Capsule())
                                }.buttonStyle(.plain)
                            }
                        }
                    }
                    if memorySequence.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Статистика по направлениям").font(.system(size: 16 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                            Text("Верные ответы и ошибки помогают понять, какой материал стоит повторить.").font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                            ForEach(["Картинки", "Цифры", "Буквы", "Знаки", "Геометрические формы", "Цвета"], id: \.self) { type in
                                let counts = decodedMemoryCategoryStats[type] ?? [0, 0]
                                let correct = counts.indices.contains(0) ? counts[0] : 0
                                let wrong = counts.indices.contains(1) ? counts[1] : 0
                                HStack(spacing: 8) {
                                    Text(type).font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink)
                                    Spacer()
                                    Text("Верно: \(correct)").foregroundStyle(palette.green)
                                    Text("Ошибки: \(wrong)").foregroundStyle(wrong > 0 ? palette.red : palette.muted)
                                    if correct + wrong > 0 { Text("\(Int(Double(correct) * 100 / Double(correct + wrong)))%").foregroundStyle(palette.purple) }
                                }.font(.system(size: 12 * AppFontScale.factor, weight: .semibold, design: .rounded)).padding(.vertical, 5)
                                Divider().overlay(palette.line)
                            }
                        }.padding(14).background(palette.cardSurface, in: RoundedRectangle(cornerRadius: 14))
                    }
                    if memorySequence.isEmpty {
                        Button { startMemoryRound() } label: {
                            Label("Начать тренировку", systemImage: "play.fill")
                                .font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                                .padding(.horizontal, 20).padding(.vertical, 12).background(palette.purple, in: Capsule())
                        }.buttonStyle(.plain)
                    }
                }.padding(22).cardStyle(palette)
            }.padding(24)
        }
        .task(id: memoryRound) {
            guard memoryShowing, !memorySequence.isEmpty else { return }
            for beat in stride(from: 3 + memoryLevel, through: 1, by: -1) {
                if Task.isCancelled { return }
                memoryCountdown = beat
                NSSound.beep()
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
            if !Task.isCancelled { memoryShowing = false }
        }
    }

    private var lifeSkillsPage: some View {
        let item = ActivityQuestionBank.lifeSkills[lifeSkillsOrder[lifeSkillsIndex % lifeSkillsOrder.count]]
        return ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                pageHeading("Навыки жизни", subtitle: "Сложность: уровень \(lifeSkillsDifficultyLevel) из 5")
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Повышение сложности", systemImage: "arrow.up.circle.fill")
                            .font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded))
                        Spacer()
                        Text(lifeSkillsDifficultyLevel >= 5 ? "Максимум · 5/5" : "Уровень \(lifeSkillsDifficultyLevel)/5")
                            .font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded))
                    }
                    if lifeSkillsDifficultyLevel < 5 {
                        let progress = Double(lifeSkillsCurrentStreak % 5) / 5.0
                        ProgressView(value: progress).tint(palette.purple)
                        Text("Правильных подряд: \(lifeSkillsCurrentStreak % 5) из 5. После пятого правильного ответа подряд уровень повысится автоматически.")
                            .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded))
                            .foregroundStyle(palette.muted)
                    } else {
                        Text("Ты достиг максимального уровня сложности!")
                            .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded))
                            .foregroundStyle(palette.muted)
                    }
                }
                .foregroundStyle(palette.ink)
                .padding(14)
                .cardStyle(palette)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    miniStat("Решено", value: "\(lifeSkillsIndex)", icon: "checkmark.circle.fill", color: palette.purple)
                    miniStat("Верно в этой сессии", value: "\(lifeSkillsScore)", icon: "target", color: palette.green)
                    miniStat("Лучший результат", value: "\(lifeSkillsBestScore)", icon: "trophy.fill", color: Color(red: 0.94, green: 0.52, blue: 0.24))
                }
                VStack(alignment: .leading, spacing: 12) {
                    Label("Подробный отчёт", systemImage: "chart.bar.xaxis")
                        .font(.system(size: 17 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        miniStat("Всего попыток", value: "\(lifeSkillsTotalAttempts)", icon: "list.number", color: palette.purple)
                        miniStat("Верно", value: "\(lifeSkillsTotalCorrect)", icon: "checkmark.circle.fill", color: palette.green)
                        miniStat("Ошибки", value: "\(lifeSkillsTotalWrong)", icon: "xmark.circle.fill", color: palette.red)
                        miniStat("Точность", value: "\(lifeSkillsTotalAttempts == 0 ? 0 : Int((Double(lifeSkillsTotalCorrect) / Double(lifeSkillsTotalAttempts) * 100).rounded()))%", icon: "target", color: palette.purple)
                        miniStat("Серия сейчас", value: "\(lifeSkillsCurrentStreak)", icon: "flame.fill", color: Color.orange)
                        miniStat("Лучшая серия", value: "\(lifeSkillsBestStreak)", icon: "trophy.fill", color: Color.orange)
                    }
                }.padding(16).cardStyle(palette)
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 14) {
                        Text(item.symbol).font(.system(size: 52 * AppFontScale.factor)).frame(width: 72, height: 72).background(palette.cardSurface, in: RoundedRectangle(cornerRadius: 18))
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Ситуация из жизни").font(.system(size: 12 * AppFontScale.factor, weight: .black, design: .rounded)).foregroundStyle(palette.purple)
                            Text(item.prompt).font(.system(size: 20 * AppFontScale.factor * fontScaleH4, weight: .bold, design: .rounded)).foregroundStyle(palette.ink).fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(item.choices, id: \.self) { choice in
                            Button {
                                guard lifeSkillsSelectedAnswer == nil, choice != lifeSkillsFirstWrongAnswer else { return }
                                lifeSkillsTotalAttempts += 1
                                markMentorActivity()
                                if choice == item.answer {
                                    lifeSkillsSelectedAnswer = choice
                                    lifeSkillsTotalCorrect += 1
                                    lifeSkillsCurrentStreak += 1
                                    lifeSkillsBestStreak = max(lifeSkillsBestStreak, lifeSkillsCurrentStreak)
                                    if lifeSkillsCurrentStreak > 0 && lifeSkillsCurrentStreak % 5 == 0 && lifeSkillsDifficultyLevel < 5 {
                                        lifeSkillsDifficultyLevel += 1
                                        lifeSkillsLevelUpPending = true
                                    }
                                    lifeSkillsScore += 1
                                    lifeSkillsBestScore = max(lifeSkillsBestScore, lifeSkillsScore)
                                    goldBalance += 1
                                } else if lifeSkillsFirstWrongAnswer == nil {
                                    lifeSkillsTotalWrong += 1
                                    lifeSkillsCurrentStreak = 0
                                    saveLifeSkillsReview(item, selected: choice)
                                    lifeSkillsFirstWrongAnswer = choice
                                } else {
                                    lifeSkillsTotalWrong += 1
                                    lifeSkillsCurrentStreak = 0
                                    lifeSkillsSelectedAnswer = choice
                                }
                            } label: {
                                Text(ActivityQuestionBank.balancedLifeSkillsChoice(choice, among: item.choices))
                                    .font(.system(size: 14 * AppFontScale.factor * fontScaleH5, weight: .bold, design: .rounded))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundStyle((lifeSkillsSelectedAnswer == choice || lifeSkillsFirstWrongAnswer == choice) ? .white : palette.ink)
                                    .frame(maxWidth: .infinity, minHeight: 78)
                                    .padding(.horizontal, 8).padding(.vertical, 10)
                                    .background(
                                        lifeSkillsSelectedAnswer == choice
                                            ? (choice == item.answer ? palette.green : palette.red)
                                            : (lifeSkillsFirstWrongAnswer == choice ? palette.red : palette.cardSurface),
                                        in: RoundedRectangle(cornerRadius: 13)
                                    )
                                    .overlay(RoundedRectangle(cornerRadius: 13).stroke(palette.line, lineWidth: 1))
                            }.buttonStyle(.plain).disabled(lifeSkillsSelectedAnswer != nil || lifeSkillsFirstWrongAnswer == choice)
                        }
                    }
                    if let picked = lifeSkillsSelectedAnswer {
                        Text(picked == item.answer ? (lifeSkillsLevelUpPending ? "Верно! Пять правильных ответов подряд — уровень повышен до \(lifeSkillsDifficultyLevel). \(item.explanation)" : "Верно! \(item.explanation)") : "Вторая попытка использована. Правильный ответ: \(item.answer). \(item.explanation)")
                            .font(.system(size: 14 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(picked == item.answer ? palette.green : palette.red)
                            .fixedSize(horizontal: false, vertical: true).padding(12)
                            .background((picked == item.answer ? palette.green : palette.red).opacity(0.09), in: RoundedRectangle(cornerRadius: 12))
                        HStack {
                            Spacer()
                            Button {
                                if lifeSkillsLevelUpPending {
                                    lifeSkillsOrder = ActivityQuestionBank.lifeSkillsIndices(for: lifeSkillsDifficultyLevel).shuffled()
                                    lifeSkillsIndex = 0
                                    lifeSkillsLevelUpPending = false
                                } else {
                                    lifeSkillsIndex += 1
                                    if lifeSkillsIndex >= lifeSkillsOrder.count {
                                        lifeSkillsIndex = 0
                                        lifeSkillsOrder = ActivityQuestionBank.lifeSkillsIndices(for: lifeSkillsDifficultyLevel).shuffled()
                                    }
                                }
                                lifeSkillsSelectedAnswer = nil
                                lifeSkillsFirstWrongAnswer = nil
                            } label: {
                                Label("Следующая ситуация", systemImage: "arrow.right")
                                    .font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                                    .padding(.horizontal, 20).padding(.vertical, 12).background(palette.purple, in: Capsule())
                            }.buttonStyle(.plain)
                        }
                    } else if let firstWrong = lifeSkillsFirstWrongAnswer {
                        Text("Не совсем верно: «\(firstWrong)». Попробуй ещё раз — у тебя осталась одна попытка.")
                            .font(.system(size: 14 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.red)
                            .fixedSize(horizontal: false, vertical: true).padding(12)
                            .background(palette.red.opacity(0.09), in: RoundedRectangle(cornerRadius: 12))
                    }
                }.padding(22).cardStyle(palette)
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("Разобрать ошибки", systemImage: "arrow.uturn.backward.circle.fill")
                            .font(.system(size: 17 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                        Spacer()
                        Text("\(decodedLifeSkillsReview.count)").font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.purple)
                    }
                    Text("Вернись к ситуации, вспомни правильное решение и закрепи тему.")
                        .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    if decodedLifeSkillsReview.isEmpty {
                        Text("Ошибок для разбора пока нет. Если ответ окажется неверным, ситуация появится здесь.")
                            .font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted).padding(.vertical, 8)
                    } else {
                        ForEach(decodedLifeSkillsReview) { record in
                            HStack(alignment: .top, spacing: 10) {
                                Text(record.symbol).font(.system(size: 27 * AppFontScale.factor))
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(record.prompt).font(.system(size: 14 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink).fixedSize(horizontal: false, vertical: true)
                                    Text("Твой ответ: \(record.selectedAnswer)").font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.red)
                                    Text("Правильный ответ: \(record.answer)").font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.green)
                                    Text("Почему это важно: \(record.explanation)").font(.system(size: 14 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.ink).fixedSize(horizontal: false, vertical: true)
                                    Text("Разберём по шагам").font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple)
                                    Text("1. Вспомни, чего добивался герой ситуации и какие факты были важны. 2. Сравни свой выбор с правильным ответом: что могло произойти после каждого варианта? 3. Выдели правило, которое можно применить в похожей ситуации.").font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.ink).fixedSize(horizontal: false, vertical: true)
                                    Text("Как поступить в следующий раз").font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple)
                                    Text("Не спеши выбирать первый вариант. Остановись, оцени возможные последствия, подумай о безопасности и о том, кому можно обратиться за помощью. Если ситуация неоднозначная — объясни свой выбор взрослому и обсуди альтернативы.").font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.ink).fixedSize(horizontal: false, vertical: true)
                                }
                                Spacer(minLength: 0)
                                Button { removeLifeSkillsReview(record.id) } label: {
                                    Image(systemName: "checkmark.circle.fill").font(.system(size: 18 * AppFontScale.factor)).foregroundStyle(palette.green)
                                }.buttonStyle(.plain).help("Убрать из списка после повторения")
                            }.padding(12).background(palette.cardSurface, in: RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }.padding(16).cardStyle(palette)
            }.padding(24)
        }
    }

    private var unifiedMistakeReviewPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                pageHeading("Повторить ошибки", subtitle: "Тренируйся, пока не получится три раза подряд 💜")
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    miniStat("Всего заданий", value: "\(unifiedReviewItems.count)", icon: "text.book.closed", color: palette.purple)
                    miniStat("К повторению", value: "\(pendingUnifiedReviewItems.count)", icon: "arrow.uturn.backward.circle.fill", color: palette.red)
                    miniStat("Попыток сохранено", value: "\(decodedReviewAttempts.count)", icon: "clock.arrow.circlepath", color: palette.green)
                }
                if let active = unifiedReviewItems.first(where: { $0.id == activeUnifiedReviewID }) {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Label(active.section, systemImage: "book.closed.fill").font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple)
                            Spacer()
                            Text("Верно подряд: \(decodedReviewMastery[active.id] ?? 0)/3").font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.muted)
                        }
                        HStack(alignment: .top, spacing: 12) {
                            Text(active.symbol).font(.system(size: 34 * AppFontScale.factor))
                            Text(active.prompt).font(.system(size: 20 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink).fixedSize(horizontal: false, vertical: true)
                        }
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 9) {
                            ForEach(active.choices, id: \.self) { choice in
                                Button {
                                    guard unifiedReviewSelectedAnswer == nil else { return }
                                    unifiedReviewSelectedAnswer = choice
                                    recordUnifiedReviewAttempt(active, selected: choice)
                                } label: {
                                    Text(choice).font(.system(size: 14 * AppFontScale.factor, weight: .bold, design: .rounded))
                                        .foregroundStyle(unifiedReviewSelectedAnswer == choice ? .white : palette.ink)
                                        .frame(maxWidth: .infinity, minHeight: 58).padding(.horizontal, 8)
                                        .background(unifiedReviewSelectedAnswer == choice ? (choice == active.answer ? palette.green : palette.red) : palette.cardSurface, in: RoundedRectangle(cornerRadius: 13))
                                        .overlay(RoundedRectangle(cornerRadius: 13).stroke(palette.line, lineWidth: 1))
                                }.buttonStyle(.plain).disabled(unifiedReviewSelectedAnswer != nil)
                            }
                        }
                        if let picked = unifiedReviewSelectedAnswer {
                            let correct = picked == active.answer
                            let streak = decodedReviewMastery[active.id] ?? 0
                            VStack(alignment: .leading, spacing: 7) {
                                Text(correct ? (streak >= 3 ? "Отлично! Тема освоена 🎉" : "Верно! Ещё немного практики.") : "Ничего страшного — разберём вместе.")
                                    .font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(correct ? palette.green : palette.red)
                                Text("Правильный ответ: \(active.answer)").font(.system(size: 14 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink)
                                Text(active.explanation).font(.system(size: 14 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.ink).fixedSize(horizontal: false, vertical: true)
                                Text("История: \(decodedReviewAttempts.filter { $0.itemID == active.id }.count) попыток. Ошибка остаётся в истории.")
                                    .font(.system(size: 11 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                            }.padding(12).frame(maxWidth: .infinity, alignment: .leading).background((correct ? palette.green : palette.red).opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                            HStack {
                                Button { unifiedReviewSelectedAnswer = nil } label: {
                                    Label("Попробовать ещё", systemImage: "arrow.clockwise").font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded))
                                        .foregroundStyle(palette.purple).padding(.horizontal, 14).padding(.vertical, 10).background(palette.cardSurface, in: Capsule())
                                }.buttonStyle(.plain)
                                Spacer()
                                Button { startNextUnifiedReview(after: active.id) } label: {
                                    Label("Следующее", systemImage: "arrow.right").font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded))
                                        .foregroundStyle(.white).padding(.horizontal, 16).padding(.vertical, 10).background(palette.purple, in: Capsule())
                                }.buttonStyle(.plain)
                            }
                        }
                    }.padding(18).cardStyle(palette)
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(unifiedReviewItems.isEmpty ? "Пока ошибок нет" : (pendingUnifiedReviewItems.isEmpty ? "Все задания освоены! 🌟" : "Начнём повторение?"))
                            .font(.system(size: 19 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                        Text(unifiedReviewItems.isEmpty ? "Когда ребёнок ошибётся в школьном предмете, ежедневном детективе или навыках жизни, задание появится здесь." : (pendingUnifiedReviewItems.isEmpty ? "Все сохранённые ошибки остаются в истории. Можно открыть любое задание ниже и потренироваться ещё раз." : "Есть задания, которые стоит повторить. Ответь правильно три раза подряд, чтобы закрепить тему."))
                            .font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                        if let first = (pendingUnifiedReviewItems.first ?? unifiedReviewItems.first) {
                            Button { startUnifiedReview(first) } label: {
                                Label("Повторить задание", systemImage: "play.fill").font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded))
                                    .foregroundStyle(.white).padding(.horizontal, 16).padding(.vertical, 11).background(palette.purple, in: Capsule())
                            }.buttonStyle(.plain)
                        }
                    }.padding(18).cardStyle(palette)
                }
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Сохранённые ошибки", icon: "books.vertical.fill")
                    Text("Три верных ответа подряд отмечают тему как освоенную, но не удаляют ошибку или историю попыток.")
                        .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    if unifiedReviewItems.isEmpty {
                        emptyHint("Ошибки появятся здесь автоматически после неверного ответа.")
                    } else {
                        ForEach(unifiedReviewItems) { item in
                            HStack(alignment: .top, spacing: 10) {
                                Text(item.symbol).font(.system(size: 25 * AppFontScale.factor))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.prompt).font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink).fixedSize(horizontal: false, vertical: true)
                                    Text(item.section).font(.system(size: 11 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
                                    Text("Попыток: \(decodedReviewAttempts.filter { $0.itemID == item.id }.count) · Верно подряд: \(decodedReviewMastery[item.id] ?? 0)/3")
                                        .font(.system(size: 11 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle((decodedReviewMastery[item.id] ?? 0) >= 3 ? palette.green : palette.red)
                                }
                                Spacer(minLength: 0)
                                Button { startUnifiedReview(item) } label: {
                                    Image(systemName: "play.circle.fill").font(.system(size: 22 * AppFontScale.factor)).foregroundStyle(palette.purple)
                                }.buttonStyle(.plain).help("Повторить это задание")
                            }.padding(11).background(palette.cardSurface, in: RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }.padding(16).cardStyle(palette)
                if !decodedReviewAttempts.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        sectionTitle("История попыток", icon: "clock.arrow.circlepath")
                        ForEach(Array(decodedReviewAttempts.reversed().prefix(30))) { attempt in
                            HStack(alignment: .top, spacing: 9) {
                                Image(systemName: attempt.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill").foregroundStyle(attempt.isCorrect ? palette.green : palette.red)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(attempt.prompt).font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink).lineLimit(2)
                                    Text("Ответ: \(attempt.selectedAnswer) · Правильно: \(attempt.correctAnswer)").font(.system(size: 11 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                                }
                                Spacer()
                                Text(StatsStore.displayDate(attempt.date)).font(.system(size: 10 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
                            }.padding(.vertical, 4)
                        }
                    }.padding(16).cardStyle(palette)
                }
            }.padding(24)
        }
    }

    private var mentorCard: some View {
        let weakest = StudySubject.allCases
            .map { subject in (subject, decodedSubjectPerformance[subject.rawValue] ?? SubjectPerformance()) }
            .filter { $0.1.total >= 3 }
            .min { $0.1.accuracy < $1.1.accuracy }
        let message: String
        let action: String
        if let weakest, weakest.1.accuracy < 80 {
            message = "Давай уделим немного внимания предмету «\(weakest.0.rawValue)». В нём пока верно \(weakest.1.accuracy)% ответов. Несколько спокойных упражнений помогут закрепить знания."
            action = "Потренировать \(weakest.0.rawValue)"
        } else if store.stats.total < 10 {
            message = "Начни с короткой тренировки на 5–10 минут. Ошибки — это подсказки, которые помогают учиться. Попробуй разные предметы и найди любимый!"
            action = "Начать занятие"
        } else {
            message = "Ты уже решил \(store.stats.total) заданий с точностью \(store.stats.accuracy)%. Продолжай заниматься понемногу и делай перерывы — регулярность важнее спешки."
            action = "Продолжить занятие"
        }
        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text(mentorAvatarEmoji).font(.system(size: 63 * AppFontScale.factor)).frame(width: 93, height: 93).background(palette.cardSurface, in: RoundedRectangle(cornerRadius: 16))
                VStack(alignment: .leading, spacing: 5) {
                    Text("Мой наставник").font(.system(size: 19 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                    Text("Совет на основе твоих результатов").font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                }
                Spacer(minLength: 0)
            }
            Text(message).font(.system(size: 14 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.ink).fixedSize(horizontal: false, vertical: true)
            HStack {
                Label("Сегодня: \(store.stats.correct) верных", systemImage: "checkmark.circle.fill")
                Spacer()
                Text("Без оценок и упрёков 💜")
            }.font(.system(size: 11 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
            Button {
                if let weakest, weakest.1.accuracy < 80 { selectedSubjectName = weakest.0.rawValue }
                selected = .task
                answer = ""; answerState = .neutral
                problem = makeUniqueProblem(for: selectedSubject)
                currentTip = ProblemGenerator.tip(for: selectedSubject, problem: problem)
            } label: {
                Label(action, systemImage: "play.fill")
                    .font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                    .padding(.horizontal, 17).padding(.vertical, 11).background(palette.purple, in: Capsule())
            }.buttonStyle(.plain)
            Divider().overlay(palette.line)
            VStack(alignment: .leading, spacing: 10) {
                Label("Личный план обучения", systemImage: "calendar.badge.clock")
                    .font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                Text("План на 10–15 минут, который подстраивается под твои результаты.")
                    .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                let planSubject = weakest?.0 ?? selectedSubject
                HStack(alignment: .top, spacing: 9) {
                    Text("1").font(.system(size: 13 * AppFontScale.factor, weight: .heavy)).foregroundStyle(.white).frame(width: 25, height: 25).background(palette.purple, in: Circle())
                    VStack(alignment: .leading, spacing: 3) {
                        Text("5 минут — \(planSubject.rawValue)").font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink)
                        if let weakest {
                            Text("Начни с темы, где точность ниже всего: \(weakest.1.accuracy)% верных ответов.")
                                .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                        } else {
                            Text("Потренируй выбранный предмет и собери первые результаты.")
                                .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                        }
                    }
                }
                HStack(alignment: .top, spacing: 9) {
                    Text("2").font(.system(size: 13 * AppFontScale.factor, weight: .heavy)).foregroundStyle(.white).frame(width: 25, height: 25).background(palette.purple, in: Circle())
                    VStack(alignment: .leading, spacing: 3) {
                        Text("3–5 минут — закрепление").font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink)
                        Text("Реши несколько заданий и перечитай объяснения ошибок.")
                            .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    }
                }
                HStack(alignment: .top, spacing: 9) {
                    Text("3").font(.system(size: 13 * AppFontScale.factor, weight: .heavy)).foregroundStyle(.white).frame(width: 25, height: 25).background(palette.purple, in: Circle())
                    VStack(alignment: .leading, spacing: 3) {
                        Text("2 минуты — проверка результата").font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink)
                        Text("Посмотри, стало ли больше правильных ответов. Если устал — сделай перерыв.")
                            .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    }
                }
                Button {
                    selectedSubjectName = planSubject.rawValue
                    selected = .task
                    answer = ""; answerState = .neutral
                    problem = makeUniqueProblem(for: selectedSubject)
                    currentTip = ProblemGenerator.tip(for: selectedSubject, problem: problem)
                } label: {
                    Label("Начать личный план", systemImage: "play.fill")
                        .font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                        .padding(.horizontal, 15).padding(.vertical, 10).background(palette.purple, in: Capsule())
                }.buttonStyle(.plain)
            }
            Divider().overlay(palette.line)
            VStack(alignment: .leading, spacing: 8) {
                Label("Поиск слабых мест", systemImage: "scope")
                    .font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                Text("Результаты сравниваются по предметам. Для вывода нужно минимум 3 ответа по каждому предмету.")
                    .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                let rankedSubjects = StudySubject.allCases
                    .map { subject in (subject, decodedSubjectPerformance[subject.rawValue] ?? SubjectPerformance()) }
                    .filter { $0.1.total >= 3 }
                    .sorted { $0.1.accuracy < $1.1.accuracy }
                if rankedSubjects.isEmpty {
                    Text("Пока мало данных. Реши хотя бы по 3 задания в нескольких предметах — наставник найдёт темы для повторения.")
                        .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                } else {
                    ForEach(Array(rankedSubjects.prefix(5).enumerated()), id: \.offset) { _, entry in
                        HStack(spacing: 8) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(entry.0.rawValue).font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink)
                                Text("\(entry.1.correct) верно из \(entry.1.total) ответов").font(.system(size: 11 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                            }
                            Spacer()
                            Text("\(entry.1.accuracy)%").font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(entry.1.accuracy < 70 ? palette.red : (entry.1.accuracy < 85 ? Color.orange : palette.green))
                        }.padding(.vertical, 3)
                    }
                }
            }
        }.padding(18).cardStyle(palette)
        .onAppear { mentorSpeechSynthesizer.stopSpeaking(at: .immediate) }
    }

    private var mentorPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                pageHeading("Мой наставник", subtitle: "Единый анализ занятий, бережные рекомендации и план на сегодня")
                mentorCard
                mentorDailyPlan
                mentorUnifiedAnalysis
            }.padding(24)
        }
        .scrollIndicators(.hidden)
        .onDisappear { mentorSpeechSynthesizer.stopSpeaking(at: .immediate) }
    }

    private func speakRandomMentorGreeting() {
        let greetings = [
            "Привет, Элина! Давай приступим к занятиям. Ты молодец, у тебя хорошо получается!",
            "Здравствуй, Элина! Я рада тебя видеть. Сегодня у нас всё получится — ты большая умница!",
            "Привет, Элина! Готова к новым открытиям? Ты стараешься, и у тебя становится всё лучше!",
            "Элина, привет! Как здорово, что ты снова здесь. Давай учиться вместе — у тебя отлично получается!",
            "Привет, Элина! Вперёд к новым знаниям. Я верю в тебя, ты справишься!",
            "Здравствуй, Элина! Ты уже многому научилась. Давай сделаем ещё один маленький шаг к большой победе!",
            "Привет, Элина! Рада нашей встрече. Улыбнись — сегодня тебя ждут интересные задания!",
            "Элина, привет! Ты умная, старательная и любознательная. Давай посмотрим, что у тебя получится сегодня!",
            "Привет, Элина! Каждое занятие делает тебя сильнее. Я рядом, и мы со всем справимся!",
            "Здравствуй, Элина! Ты такая молодец, что продолжаешь заниматься. Начнём с хорошим настроением!",
            "Привет, Элина! Готова потренировать свой ум? У тебя уже многое получается, и дальше будет ещё лучше!",
            "Элина, привет! Я тобой горжусь. Давай спокойно и уверенно начнём наше занятие!"
        ]
        let options = greetings.filter { $0 != lastMentorGreeting }
        let greeting = options.randomElement() ?? greetings[0]
        lastMentorGreeting = greeting
        mentorSpeechSynthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: greeting)
        utterance.rate = 0.47
        utterance.pitchMultiplier = 1.08
        utterance.volume = 0.9
        let russianVoices = AVSpeechSynthesisVoice.speechVoices().filter {
            $0.language.hasPrefix("ru") && $0.gender == .female
        }
        utterance.voice = russianVoices.first ?? AVSpeechSynthesisVoice(language: "ru-RU")
        mentorSpeechSynthesizer.speak(utterance)
    }

    private var mentorDailyPlan: some View {
        let weakest = StudySubject.allCases.map { ($0, decodedSubjectPerformance[$0.rawValue] ?? SubjectPerformance()) }.filter { $0.1.total >= 5 }.min { $0.1.accuracy < $1.1.accuracy }
        return VStack(alignment: .leading, spacing: 12) {
            Label("Личный план на день", systemImage: "sun.max.fill").font(.system(size: 19 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
            Text("Три коротких блока, чтобы тренировать разные навыки, а не заниматься всё время одним и тем же. План адаптируется к имеющимся данным; если их мало, начинаем с разнообразия и собираем статистику.").font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
            Button {
                if let weakest { selectedSubjectName = weakest.0.rawValue }
                selected = .task
                answer = ""; answerState = .neutral
                problem = makeUniqueProblem(for: selectedSubject)
                currentTip = ProblemGenerator.tip(for: selectedSubject, problem: problem)
            } label: {
                HStack { Text("1").font(.system(size: 13 * AppFontScale.factor, weight: .heavy)).foregroundStyle(.white).frame(width: 26, height: 26).background(palette.purple, in: Circle()); VStack(alignment: .leading, spacing: 2) { Text("5 минут · школьный предмет").font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink); Text(weakest.map { "Повторить \($0.0.rawValue): \($0.1.correct) верных из \($0.1.total) попыток." } ?? "Выбери предмет и собери первые результаты.").font(.system(size: 11 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted) }; Spacer(); Image(systemName: "play.fill").foregroundStyle(palette.purple) }
            }.buttonStyle(.plain)
            Button { selected = .memory } label: {
                HStack { Text("2").font(.system(size: 13 * AppFontScale.factor, weight: .heavy)).foregroundStyle(.white).frame(width: 26, height: 26).background(palette.purple, in: Circle()); VStack(alignment: .leading, spacing: 2) { Text("3 минуты · тренировка памяти").font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink); Text("Короткий блок на внимание и запоминание.").font(.system(size: 11 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted) }; Spacer(); Image(systemName: "play.fill").foregroundStyle(palette.purple) }
            }.buttonStyle(.plain)
            Button { selected = lifeSkillsTotalAttempts <= detectiveTotalAttempts ? .lifeSkills : .detective } label: {
                HStack { Text("3").font(.system(size: 13 * AppFontScale.factor, weight: .heavy)).foregroundStyle(.white).frame(width: 26, height: 26).background(palette.purple, in: Circle()); VStack(alignment: .leading, spacing: 2) { Text("3–5 минут · практические ситуации или логика").font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink); Text("Чередуем режимы, чтобы развивать рассуждение и применение знаний.").font(.system(size: 11 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted) }; Spacer(); Image(systemName: "play.fill").foregroundStyle(palette.purple) }
            }.buttonStyle(.plain)
        }.padding(17).cardStyle(palette)
    }

    private var mentorUnifiedAnalysis: some View {
        let subjectRows = StudySubject.allCases.map { ($0.rawValue, decodedSubjectPerformance[$0.rawValue] ?? SubjectPerformance()) }.filter { $0.1.total > 0 }
        let memoryTotal = decodedMemoryCategoryStats.values.reduce(0) { $0 + $1.reduce(0, +) }
        let memoryCorrect = decodedMemoryCategoryStats.values.reduce(0) { $0 + ($1.first ?? 0) }
        let modeRows: [(String, Int, Int, String)] = [
            ("Школьные предметы", subjectRows.reduce(0) { $0 + $1.1.total }, subjectRows.reduce(0) { $0 + $1.1.correct }, "book.fill"),
            ("Ежедневный детектив", detectiveTotalAttempts, detectiveTotalCorrect, "magnifyingglass"),
            ("Навыки жизни", lifeSkillsTotalAttempts, lifeSkillsTotalCorrect, "lightbulb.max.fill"),
            ("Тренировка памяти", memoryTotal, memoryCorrect, "brain.head.profile"),
            ("Олимпиада", olympiadCompleted, olympiadCompleted, "trophy.fill")
        ]
        let repeatedErrors = Dictionary(grouping: decodedMistakes, by: { "\($0.subject)|\($0.question)" }).filter { $0.value.count > 1 }.count
        return VStack(alignment: .leading, spacing: 13) {
            Label("Единый анализ", systemImage: "chart.xyaxis.line").font(.system(size: 19 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
            Text("Наставник собирает результаты школьных предметов, логики и других учебных тем, детектива, памяти, навыков жизни и олимпиады. Учитываются число попыток, количество ошибок и повторяющиеся ошибки; точность — не единственный показатель. Данные о сложности доступны не для каждого режима, поэтому там, где их нет, наставник не делает вид, что измерил её.").font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted).fixedSize(horizontal: false, vertical: true)
            ForEach(Array(modeRows.enumerated()), id: \.offset) { entry in
                let row = entry.element
                HStack(spacing: 10) {
                    Image(systemName: row.3).font(.system(size: 17 * AppFontScale.factor, weight: .bold)).foregroundStyle(palette.purple).frame(width: 28)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(row.0).font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink)
                        Text(row.1 >= 5 ? "Попыток: \(row.1) · верных: \(row.2)" : "Пока мало данных: \(row.1) попыток. Нужны дополнительные занятия.").font(.system(size: 11 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    }
                    Spacer()
                    if row.1 >= 5 { Text("\(Int(Double(row.2) * 100 / Double(max(1, row.1))))%").font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple) }
                    else { Text("Недостаточно").font(.system(size: 10 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted) }
                }.padding(10).background(palette.cardSurface, in: RoundedRectangle(cornerRadius: 12))
            }
            HStack {
                Label("Повторяющиеся ошибки: \(repeatedErrors)", systemImage: "arrow.trianglehead.2.clockwise.rotate.90")
                Spacer()
                Label("Ошибок для разбора: \(decodedMistakes.count + decodedLifeSkillsReview.count)", systemImage: "text.book.closed")
            }.font(.system(size: 11 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
            if subjectRows.reduce(0, { $0 + $1.1.total }) < 5 && detectiveTotalAttempts < 5 && lifeSkillsTotalAttempts < 5 && memoryTotal < 5 {
                Text("Пока недостаточно данных для надёжных выводов. Проведи несколько коротких занятий в разных режимах. Наставник не будет объявлять предмет слабым только из-за пары ошибок.").font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink).padding(12).background(palette.palePink.opacity(0.45), in: RoundedRectangle(cornerRadius: 12))
            }
            let trendDays = store.stats.days.filter { $0.total > 0 }.sorted { $0.date > $1.date }
            if trendDays.count >= 4 {
                let recent = Array(trendDays.prefix(7))
                let previous = Array(trendDays.dropFirst(7).prefix(7))
                if !previous.isEmpty {
                    let recentTotal = recent.reduce(0) { $0 + $1.total }
                    let previousTotal = previous.reduce(0) { $0 + $1.total }
                    let recentCorrect = recent.reduce(0) { $0 + $1.correct }
                    let previousCorrect = previous.reduce(0) { $0 + $1.correct }
                    let recentRate = Int(Double(recentCorrect) * 100 / Double(max(1, recentTotal)))
                    let previousRate = Int(Double(previousCorrect) * 100 / Double(max(1, previousTotal)))
                    Label("Изменение результатов", systemImage: "chart.line.uptrend.xyaxis").font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                    Text("По сохранённой дневной статистике основного тренажёра: в последних \(recent.count) активных днях точность \(recentRate)%, в предыдущих \(previous.count) активных днях — \(previousRate)%. \(recentRate > previousRate ? "Результат растёт." : (recentRate < previousRate ? "Есть смысл повторить темы и посмотреть на результат позже." : "Показатель примерно не изменился.") )").font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted).fixedSize(horizontal: false, vertical: true)
                } else {
                    Text("Для сравнения результатов во времени пока мало дневных записей. Продолжай заниматься — наставник сможет сравнить периоды, когда накопится история.").font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                }
            } else {
                Text("Для анализа изменений во времени пока мало дневных записей. Наставник не будет делать вывод о прогрессе по одной тренировке.").font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
            }
            Label("Умная сложность", systemImage: "slider.horizontal.3").font(.system(size: 16 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
            Text("Не меняй сложность по одному ответу. Если несколько занятий подряд проходят уверенно и ошибки редки, можно поднять уровень на один шаг. Если ошибки повторяются или ребёнок часто затрудняется — вернись к более простым заданиям, разбей решение на шаги и снова проверь результат. Сейчас это рекомендации; автоматическое изменение уровня применяется только там, где режим поддерживает управление сложностью.").font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted).fixedSize(horizontal: false, vertical: true)
        }.padding(17).cardStyle(palette)
    }

    private var mentorCalendar: some View {
        let calendar = Calendar.current
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: mentorCalendarMonth)) ?? mentorCalendarMonth
        let dayRange = calendar.range(of: .day, in: .month, for: monthStart) ?? (1..<29)
        let firstWeekday = (calendar.component(.weekday, from: monthStart) + 5) % 7
        let activityDates = mentorActivityDates.union(Set(store.stats.days.filter { $0.total > 0 }.map(\.date))).union(Set(decodedActiveSeconds.filter { $0.value > 0 }.map(\.key)))
        return VStack(alignment: .leading, spacing: 12) {
            Label("Календарь занятий", systemImage: "calendar").font(.system(size: 19 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
            HStack {
                Button { mentorCalendarMonth = calendar.date(byAdding: .month, value: -1, to: monthStart) ?? monthStart } label: {
                    Image(systemName: "chevron.left").font(.system(size: 13 * AppFontScale.factor, weight: .heavy)).foregroundStyle(palette.purple).frame(width: 32, height: 30)
                }.buttonStyle(.plain)
                Spacer()
                Text(monthStart.formatted(.dateTime.month(.wide).year())).font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                Spacer()
                Button { mentorCalendarMonth = calendar.date(byAdding: .month, value: 1, to: monthStart) ?? monthStart } label: {
                    Image(systemName: "chevron.right").font(.system(size: 13 * AppFontScale.factor, weight: .heavy)).foregroundStyle(palette.purple).frame(width: 32, height: 30)
                }.buttonStyle(.plain)
            }
            HStack { ForEach(["Пн","Вт","Ср","Чт","Пт","Сб","Вс"], id: \.self) { day in Text(day).font(.system(size: 11 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.muted).frame(maxWidth: .infinity) } }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 7), spacing: 7) {
                ForEach(0..<42, id: \.self) { index in
                    let day = index - firstWeekday + 1
                    if day >= 1 && day <= dayRange.count, let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                        let key = StatsStore.dateKey(date)
                        let isFuture = calendar.startOfDay(for: date) > calendar.startOfDay(for: Date())
                        let active = activityDates.contains(key)
                        Text("\(day)").font(.system(size: 12 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(active ? .white : palette.ink).frame(maxWidth: .infinity).frame(height: 32).background(active ? palette.green : (isFuture ? palette.cardSurface.opacity(0.35) : palette.red.opacity(0.13)), in: Circle()).overlay(Circle().stroke(active ? palette.green : palette.line.opacity(0.5), lineWidth: 1))
                    } else { Color.clear.frame(height: 32) }
                }
            }
            HStack(spacing: 15) {
                Label("Было занятие", systemImage: "circle.fill").foregroundStyle(palette.green)
                Label("Пропуск", systemImage: "circle.fill").foregroundStyle(palette.red)
            }.font(.system(size: 11 * AppFontScale.factor, weight: .semibold, design: .rounded))
            Text("Зелёный — приложение зафиксировало занятие в одном из режимов. Красный — прошедший день без записанной активности. Дни до установки версии с календарём могут быть отмечены только по сохранившейся статистике.").font(.system(size: 11 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted).fixedSize(horizontal: false, vertical: true)
        }.padding(.top, 4).frame(maxWidth: .infinity, alignment: .leading)
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
                HStack(alignment: .top, spacing: 18) {
                    mentorCalendar
                        .frame(maxWidth: 352, alignment: .leading)
                    VStack(alignment: .leading, spacing: 12) {
                        sectionTitle("Активное время занятий", icon: "clock.fill")
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], alignment: .leading, spacing: 10) {
                            miniStat("Сегодня", value: formattedTime(todayActiveSeconds), icon: "calendar", color: palette.purple)
                            miniStat("За неделю", value: formattedTime(weekActiveSeconds), icon: "calendar.badge.clock", color: palette.green)
                            miniStat("За месяц", value: formattedTime(monthActiveSeconds), icon: "calendar", color: palette.purple)
                            miniStat("Среднее за день", value: formattedTime(averageActiveSecondsPerDay), icon: "chart.bar.fill", color: palette.green)
                            miniStat("Текущая сессия", value: formattedTime(sessionSeconds), icon: "timer", color: palette.green)
                            miniStat("Всего", value: formattedTime(lifetimeActiveSeconds), icon: "hourglass", color: palette.purple)
                            ForEach(Array(subjectActiveTimeLeaders.enumerated()), id: \.offset) { index, leader in
                                miniStat("\(["1-е", "2-е", "3-е", "4-е"][index]) место · \(leader.0)", value: formattedTime(leader.1), icon: index == 0 ? "trophy.fill" : "clock.fill", color: index == 0 ? Color(red: 0.94, green: 0.62, blue: 0.12) : palette.purple)
                            }
                        }
                        Text("Общее время считается по активности мыши. Если мышь не двигается более 5 минут, счётчик останавливается. Лидеры учитывают время только в основном тренажёре и начинают накапливаться с версии 1.2.34.")
                            .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded))
                            .foregroundStyle(palette.muted)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardStyle(palette)
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Твой прогресс", icon: "chart.bar.fill")
                    HStack {
                        Text("Правильные ответы").font(.system(size: 14 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.ink)
                        Spacer()
                        Text("\(store.stats.accuracy)%").font(.system(size: 17 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.green)
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
                        .font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                }
                .padding(22)
                .cardStyle(palette)
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Подробная статистика по предметам", icon: "chart.xyaxis.line")
                    Text("Как читать результаты: процент справа от названия предмета — общий результат по всем заданиям этого предмета. Строки ниже — отдельные темы внутри этого предмета, а не повтор общего результата. Например, в математике это могут быть «Сложение», «Вычитание» и «Умножение»; в русском языке — «Глаголы» или «Правописание»; в английском — «Слова и перевод» или «Грамматика». В других предметах показываются их собственные темы. Для каждой темы написано название и число правильных ответов из всех попыток. Зелёный кружок означает 80–100%, оранжевый — 60–79%, красный — меньше 60%. Показаны до двух тем, которые стоит повторить в первую очередь.")
                        .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded))
                        .foregroundStyle(palette.muted)
                        .fixedSize(horizontal: false, vertical: true)
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], alignment: .leading, spacing: 10) {
                        ForEach(StudySubject.allCases) { subject in
                            let result = decodedSubjectPerformance[subject.rawValue] ?? SubjectPerformance()
                            let topicRows = decodedTopicPerformance
                                .filter { $0.key.hasPrefix(subject.rawValue + "::") }
                                .map { (String($0.key.dropFirst(subject.rawValue.count + 2)), $0.value) }
                                // Keep topic rows in a fixed order so they do not jump around
                                // whenever a new answer changes accuracy or attempt totals.
                                .sorted { lhs, rhs in
                                    lhs.0.localizedStandardCompare(rhs.0) == .orderedAscending
                                }
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 6) {
                                    Image(systemName: subject.icon)
                                        .foregroundStyle(palette.purple)
                                        .frame(width: 18)
                                    Text(subject.rawValue)
                                        .font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded))
                                        .foregroundStyle(palette.ink)
                                        .lineLimit(2)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .contentShape(Rectangle())
                                        .onHover { isHovering in
                                            hoveredStatsSubject = isHovering ? subject.rawValue : nil
                                        }
                                        .popover(
                                            isPresented: Binding(
                                                get: { hoveredStatsSubject == subject.rawValue },
                                                set: { if !$0 && hoveredStatsSubject == subject.rawValue { hoveredStatsSubject = nil } }
                                            ),
                                            arrowEdge: .top
                                        ) {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("\(subject.rawValue) — подробная успеваемость")
                                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                                Text("Общий результат: \(result.accuracy)% · отставание до 100%: \(max(0, 100 - result.accuracy)) п.п.")
                                                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                                                Divider()
                                                if topicRows.isEmpty {
                                                    Text("По темам пока недостаточно данных. Выполняй задания по этому предмету — результаты появятся здесь.")
                                                        .font(.system(size: 11, design: .rounded))
                                                } else {
                                                    ForEach(Array(topicRows.enumerated()), id: \.offset) { entry in
                                                        let topic = entry.element.0
                                                        let stats = entry.element.1
                                                        VStack(alignment: .leading, spacing: 3) {
                                                            HStack(alignment: .firstTextBaseline) {
                                                                Text(topic)
                                                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                                                    .lineLimit(2)
                                                                Spacer(minLength: 8)
                                                                Text("\(stats.accuracy)%")
                                                                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                                                                    .foregroundStyle(stats.accuracy < 60 ? palette.red : (stats.accuracy >= 80 ? palette.green : Color.orange))
                                                            }
                                                            GeometryReader { bar in
                                                                ZStack(alignment: .leading) {
                                                                    Capsule().fill(palette.line.opacity(0.6))
                                                                    Capsule()
                                                                        .fill(stats.accuracy < 60 ? palette.red : (stats.accuracy >= 80 ? palette.green : Color.orange))
                                                                        .frame(width: bar.size.width * CGFloat(stats.accuracy) / 100)
                                                                }
                                                            }
                                                            .frame(height: 4)
                                                            Text("Верно \(stats.correct) из \(stats.total) · отставание: \(max(0, 100 - stats.accuracy)) п.п.")
                                                                .font(.system(size: 10, design: .rounded))
                                                                .foregroundStyle(palette.muted)
                                                        }
                                                        .padding(.vertical, 2)
                                                    }
                                                }
                                            }
                                            .padding(12)
                                            .frame(width: 285, alignment: .leading)
                                            .foregroundStyle(palette.ink)
                                            .background(palette.cardSurface)
                                        }
                                    Spacer(minLength: 2)
                                    Text(result.total > 0 ? "\(result.accuracy)%" : "—")
                                        .font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded))
                                        .foregroundStyle(result.total == 0 ? palette.muted : (result.accuracy < 60 ? palette.red : (result.accuracy >= 80 ? palette.green : palette.purple)))
                                }
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule().fill(palette.line.opacity(0.65))
                                        Capsule()
                                            .fill(result.total == 0 ? palette.line : (result.accuracy < 60 ? palette.red : (result.accuracy >= 80 ? palette.green : palette.purple)))
                                            .frame(width: geo.size.width * CGFloat(result.accuracy) / 100)
                                    }
                                }
                                .frame(height: 5)
                                HStack(spacing: 5) {
                                    Label("\(result.total)", systemImage: "list.number")
                                    Spacer(minLength: 2)
                                    Label("\(result.correct)", systemImage: "checkmark.circle.fill").foregroundStyle(palette.green)
                                    Label("\(result.incorrect)", systemImage: "xmark.circle.fill").foregroundStyle(palette.red)
                                }
                                .font(.system(size: 10 * AppFontScale.factor, weight: .semibold, design: .rounded))
                                .foregroundStyle(palette.muted)
                                if topicRows.isEmpty {
                                    Text(result.total == 0 ? "Пока нет результатов" : "Подробности по темам появятся после накопления данных")
                                        .font(.system(size: 10 * AppFontScale.factor, weight: .medium, design: .rounded))
                                        .foregroundStyle(palette.muted)
                                        .lineLimit(2)
                                } else {
                                    ForEach(Array(topicRows.prefix(2).enumerated()), id: \.offset) { entry in
                                        let topic = entry.element.0
                                        let stats = entry.element.1
                                        VStack(alignment: .leading, spacing: 3) {
                                            HStack(alignment: .top, spacing: 5) {
                                                Circle()
                                                    .fill(stats.accuracy < 60 ? palette.red : (stats.accuracy >= 80 ? palette.green : Color.orange))
                                                    .frame(width: 7, height: 7)
                                                    .padding(.top, 4)
                                                Text("Тема: \(topic)")
                                                    .fontWeight(.bold)
                                                    .foregroundStyle(palette.ink)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            Text("Правильных ответов: \(stats.correct) из \(stats.total) (\(stats.accuracy)%)")
                                                .foregroundStyle(palette.muted)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                        .font(.system(size: 10 * AppFontScale.factor, weight: .medium, design: .rounded))
                                        .padding(.vertical, 3)
                                    }
                                }
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(palette.cardSurface.opacity(0.78), in: RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(palette.line.opacity(0.55), lineWidth: 1))
                        }
                    }
                }
                .padding(17)
                .cardStyle(palette)

                Button("Посмотреть статистику по дням →") { selected = .days }
                    .font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded))
                    .foregroundStyle(palette.purple).buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 10) {
                    sectionTitle("Статистика текущего месяца", icon: "arrow.counterclockwise")
                    Text("В начале нового месяца счётчики обнуляются автоматически. История по месяцам, достижения, коллекция и алмазы сохраняются.")
                        .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded))
                        .foregroundStyle(palette.muted).fixedSize(horizontal: false, vertical: true)
                    Button {
                        showResetStatsConfirmation = true
                    } label: {
                        Label("Сбросить статистику текущего месяца", systemImage: "trash")
                            .font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded))
                            .foregroundStyle(palette.red)
                            .padding(.horizontal, 14).padding(.vertical, 11)
                            .background(palette.red.opacity(0.10), in: Capsule())
                    }.buttonStyle(.plain)
                }
                .padding(18)
                .cardStyle(palette)
            }
            .padding(25)
        }
        .scrollIndicators(.hidden)
        .alert("Сбросить статистику текущего месяца?", isPresented: $showResetStatsConfirmation) {
            Button("Отмена", role: .cancel) {}
            Button("Сбросить", role: .destructive) {
                store.resetCurrentMonthStats()
            }
        } message: {
            Text("Текущие ответы и серия будут обнулены. История по месяцам, алмазы, достижения и игрушки сохранятся.")
        }
    }


    private var olympiadPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                pageHeading("Олимпиада", subtitle: "Выбери длительность и количество заданий")
                if olympiadFinished {
                    VStack(spacing: 18) {
                        Text(olympiadWon ? "🎁" : "😔")
                            .font(.system(size: olympiadWon ? 132 : 100 * AppFontScale.factor))
                            .shadow(color: (olympiadWon ? palette.purple : palette.muted).opacity(0.22), radius: 18, y: 7)
                        Text(olympiadWon ? "ОЛИМПИАДА ПРОЙДЕНА!" : "В ЭТОТ РАЗ НЕ ПОЛУЧИЛОСЬ")
                            .font(.system(size: 27 * AppFontScale.factor, weight: .heavy, design: .rounded))
                            .foregroundStyle(olympiadWon ? palette.green : palette.ink)
                            .multilineTextAlignment(.center)
                        if olympiadWon {
                            Text("💎 +100 алмазов 💎")
                                .font(.system(size: 30 * AppFontScale.factor, weight: .heavy, design: .rounded))
                                .foregroundStyle(palette.purple)
                            Text("Ты решил все \(olympiadTargetCount) заданий за отведённое время. Большая награда уже добавлена в магазин!")
                                .font(.system(size: 15 * AppFontScale.factor, weight: .semibold, design: .rounded))
                                .foregroundStyle(palette.muted).multilineTextAlignment(.center)
                        } else {
                            Text("Не расстраивайся! Сложные задания помогают становиться сильнее. Отдохни и попробуй пройти олимпиаду попозже 💜")
                                .font(.system(size: 16 * AppFontScale.factor, weight: .semibold, design: .rounded))
                                .foregroundStyle(palette.muted).multilineTextAlignment(.center)
                        }
                        Text("Выполнено заданий: \(olympiadCompleted) из \(olympiadTargetCount)")
                            .font(.system(size: 15 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink)
                        Button("Попробовать ещё раз") { resetOlympiad() }
                            .font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                            .padding(.horizontal, 24).padding(.vertical, 14)
                            .background(LinearGradient(colors: [palette.purple, palette.pink], startPoint: .leading, endPoint: .trailing), in: Capsule())
                            .buttonStyle(.plain)
                    }
                    .frame(maxWidth: .infinity).padding(35).cardStyle(palette)
                } else if !olympiadStarted {
                    VStack(alignment: .leading, spacing: 18) {
                        HStack(spacing: 18) {
                            Text("🏆").font(.system(size: 70 * AppFontScale.factor)).frame(width: 110, height: 110)
                                .background(LinearGradient(colors: [palette.pink, palette.lilac], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 28))
                            VStack(alignment: .leading, spacing: 7) {
                                Text("Большое испытание").font(.system(size: 22 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                                Text("\(olympiadTargetCount) заданий · \(olympiadDurationMinutes) минут").font(.system(size: 17 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.purple)
                                Text("Вопросы выбираются случайно из всех учебных предметов. Нужно правильно ответить на каждый вопрос до окончания таймера.")
                                    .font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                            }
                        }
                        HStack(alignment: .top, spacing: 12) {
                            Label("Математика", systemImage: "function")
                            Label("Языки", systemImage: "text.book.closed")
                            Label("Наука и мир", systemImage: "globe")
                            Label("Информатика", systemImage: "desktopcomputer")
                        }.font(.system(size: 11 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
                        HStack(spacing: 10) {
                            Button { olympiadDurationMinutes = 10; olympiadTargetCount = 20 } label: {
                                VStack(spacing: 4) { Text("10 минут").font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded)); Text("20 заданий").font(.system(size: 12 * AppFontScale.factor, weight: .semibold, design: .rounded)) }
                                    .frame(maxWidth: .infinity).padding(.vertical, 13).foregroundStyle(olympiadDurationMinutes == 10 ? .white : palette.ink)
                                    .background(olympiadDurationMinutes == 10 ? palette.purple : palette.cardSurface, in: RoundedRectangle(cornerRadius: 13))
                                    .overlay(RoundedRectangle(cornerRadius: 13).stroke(olympiadDurationMinutes == 10 ? palette.purple : palette.line, lineWidth: 1))
                            }.buttonStyle(.plain)
                            Button { olympiadDurationMinutes = 20; olympiadTargetCount = 40 } label: {
                                VStack(spacing: 4) { Text("20 минут").font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded)); Text("40 заданий").font(.system(size: 12 * AppFontScale.factor, weight: .semibold, design: .rounded)) }
                                    .frame(maxWidth: .infinity).padding(.vertical, 13).foregroundStyle(olympiadDurationMinutes == 20 ? .white : palette.ink)
                                    .background(olympiadDurationMinutes == 20 ? palette.purple : palette.cardSurface, in: RoundedRectangle(cornerRadius: 13))
                                    .overlay(RoundedRectangle(cornerRadius: 13).stroke(olympiadDurationMinutes == 20 ? palette.purple : palette.line, lineWidth: 1))
                            }.buttonStyle(.plain)
                            Button { olympiadDurationMinutes = 30; olympiadTargetCount = 60 } label: {
                                VStack(spacing: 4) { Text("30 минут").font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded)); Text("60 заданий").font(.system(size: 12 * AppFontScale.factor, weight: .semibold, design: .rounded)) }
                                    .frame(maxWidth: .infinity).padding(.vertical, 13).foregroundStyle(olympiadDurationMinutes == 30 ? .white : palette.ink)
                                    .background(olympiadDurationMinutes == 30 ? palette.purple : palette.cardSurface, in: RoundedRectangle(cornerRadius: 13))
                                    .overlay(RoundedRectangle(cornerRadius: 13).stroke(olympiadDurationMinutes == 30 ? palette.purple : palette.line, lineWidth: 1))
                            }.buttonStyle(.plain)
                        }
                        Button { startOlympiad() } label: {
                            Label("Начать олимпиаду", systemImage: "play.fill")
                                .font(.system(size: 17 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                                .padding(.horizontal, 25).padding(.vertical, 15)
                                .background(LinearGradient(colors: [palette.purple, palette.pink], startPoint: .leading, endPoint: .trailing), in: Capsule())
                        }.buttonStyle(.plain)
                    }.padding(25).cardStyle(palette)
                    VStack(alignment: .leading, spacing: 10) {
                        sectionTitle("Правила", icon: "checkmark.seal.fill")
                        Text("• На выбор: 10 минут / 20 заданий, 20 минут / 40 заданий или 30 минут / 60 заданий.\n• При неправильном ответе можно попробовать ещё раз, пока идёт время.\n• За прохождение всех заданий вовремя начисляется 100 алмазов.\n• Если время закончится, награда не начисляется — можно пройти олимпиаду позже.")
                            .font(.system(size: 14 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }.padding(20).cardStyle(palette)
                } else {
                    VStack(alignment: .leading, spacing: 18) {
                        HStack {
                            Label("Задание \(olympiadCompleted + 1) из \(olympiadTargetCount)", systemImage: "flag.checkered")
                                .font(.system(size: 17 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                            Spacer()
                            Text(String(format: "%02d:%02d", olympiadSecondsRemaining / 60, olympiadSecondsRemaining % 60))
                                .font(.system(size: 24 * AppFontScale.factor, weight: .heavy, design: .monospaced))
                                .foregroundStyle(olympiadSecondsRemaining <= 300 ? palette.red : palette.purple)
                                .padding(.horizontal, 13).padding(.vertical, 9)
                                .background((olympiadSecondsRemaining <= 300 ? palette.red : palette.purple).opacity(0.12), in: Capsule())
                        }
                        HStack {
                            Button {
                                olympiadPaused.toggle()
                            } label: {
                                Label(olympiadPaused ? "Продолжить олимпиаду" : "Пауза", systemImage: olympiadPaused ? "play.fill" : "pause.fill")
                                    .font(.system(size: 14 * AppFontScale.factor, weight: .bold, design: .rounded))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 16).padding(.vertical, 10)
                                    .background(olympiadPaused ? palette.green : palette.purple, in: Capsule())
                            }.buttonStyle(.plain)
                            if olympiadPaused { Text("Таймер остановлен").font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.muted) }
                            Spacer()
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(palette.line)
                                Capsule().fill(palette.green).frame(width: geo.size.width * min(1, CGFloat(olympiadCompleted) / CGFloat(max(1, olympiadTargetCount))))
                            }
                        }.frame(height: 12)
                        HStack(spacing: 8) {
                            Image(systemName: olympiadSubject.icon).font(.system(size: 20 * AppFontScale.factor, weight: .heavy)).foregroundStyle(.white)
                                .frame(width: 45, height: 45).background(palette.purple, in: RoundedRectangle(cornerRadius: 12))
                            Text(olympiadSubject.rawValue.uppercased()).font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple)
                        }
                        Text(olympiadProblem.text)
                            .font(.system(size: 31 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                            .multilineTextAlignment(.center).frame(maxWidth: .infinity, minHeight: 100).padding(15)
                            .background(palette.cardSurface.opacity(0.65), in: RoundedRectangle(cornerRadius: 18))
                        let choices = olympiadOptions
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(choices, id: \.self) { choice in
                                Button { submitOlympiadAnswer(choice) } label: {
                                    Text(choice)
                                        .font(.system(size: 16 * AppFontScale.factor, weight: .bold, design: .rounded))
                                        .foregroundStyle(palette.ink)
                                        .frame(maxWidth: .infinity, minHeight: 62)
                                        .padding(10)
                                        .background(palette.cardSurface, in: RoundedRectangle(cornerRadius: 15))
                                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(palette.line, lineWidth: 1))
                                }
                                .buttonStyle(.plain)
                                .disabled(olympiadPaused || olympiadFeedback.hasPrefix("Верно"))
                            }
                        }
                        if !olympiadFeedback.isEmpty {
                            Text(olympiadFeedback).font(.system(size: 14 * AppFontScale.factor, weight: .bold, design: .rounded))
                                .foregroundStyle(olympiadFeedback.hasPrefix("Верно") ? palette.green : palette.red)
                                .frame(maxWidth: .infinity, alignment: .center).padding(10)
                                .background(palette.cardSurface.opacity(0.65), in: RoundedRectangle(cornerRadius: 12))
                        }
                        Text("Каждый ответ записывается в статистику предмета. Алмазы за олимпиаду начисляются только после победы.")
                            .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    }.padding(24).cardStyle(palette)
                }
            }.padding(25)
        }.scrollIndicators(.hidden)
    }

    private func startOlympiad() {
        reviewingMistakeID = nil
        olympiadPaused = false
        olympiadStarted = true
        olympiadFinished = false
        olympiadWon = false
        olympiadSecondsRemaining = olympiadDurationMinutes * 60
        olympiadCompleted = 0
        olympiadSubjectOrder = StudySubject.allCases.shuffled()
        olympiadFeedback = ""
        nextOlympiadProblem()
    }

    private func resetOlympiad() {
        olympiadStarted = false
        olympiadPaused = false
        olympiadFinished = false
        olympiadWon = false
        olympiadCompleted = 0
        olympiadSecondsRemaining = olympiadDurationMinutes * 60
        olympiadAnswer = ""
        olympiadFeedback = ""
    }

    private func isTextOnlyOlympiadProblem(_ problem: Problem) -> Bool {
        // Olympiad questions must be fully answerable from text alone.
        // Exclude both actual illustration-backed items and prompts that refer to a missing image.
        guard !problem.showIllustration else { return false }
        let prompt = problem.text.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
        let imageReferences = [
            "флаг", "на рисунке", "на картинке", "на изображении",
            "изображен", "изображена", "изображено", "изображены",
            "показан", "показана", "показано", "показаны",
            "посмотри на рисунок", "посмотри на картинку",
            "какой предмет изображен", "что изображено"
        ]
        return !imageReferences.contains { prompt.contains($0) }
    }

    private func nextOlympiadProblem() {
        if olympiadSubjectOrder.isEmpty { olympiadSubjectOrder = StudySubject.allCases.shuffled() }
        // Try several subjects/questions; never present a prompt whose image was removed.
        var candidateSubject = olympiadSubjectOrder[olympiadCompleted % olympiadSubjectOrder.count]
        var candidate = ProblemGenerator.next(for: candidateSubject, difficulty: difficultyLevel)
        var attempts = 0
        while !isTextOnlyOlympiadProblem(candidate) && attempts < 250 {
            attempts += 1
            candidateSubject = StudySubject.allCases.randomElement() ?? .math
            candidate = ProblemGenerator.next(for: candidateSubject, difficulty: difficultyLevel)
        }
        // Safe fallback: text-only arithmetic questions, independent of image-backed banks.
        if !isTextOnlyOlympiadProblem(candidate) {
            candidateSubject = .math
            repeat {
                candidate = ProblemGenerator.next(for: .math, difficulty: difficultyLevel)
            } while !isTextOnlyOlympiadProblem(candidate)
        }
        olympiadSubject = candidateSubject
        olympiadProblem = candidate
        olympiadOptions = olympiadChoices(for: olympiadProblem)
        olympiadAnswer = ""
        olympiadFeedback = ""
    }

    private func olympiadChoices(for problem: Problem) -> [String] {
        let correct = problem.answer.trimmingCharacters(in: .whitespacesAndNewlines)
        var choices: [String] = [correct]
        if problem.isComparison {
            choices = ["<", "=", ">", "≠"]
        } else if problem.isTatarChoice {
            choices.append(contentsOf: problem.tatarChoices.filter { $0 != correct })
        } else if let number = Int(correct) {
            let offsets = [-2, -1, 1, 2, 3, -3].shuffled()
            choices.append(contentsOf: offsets.map { String(number + $0) })
        } else {
            // For non-numeric text answers, offer text-only distractors based on common confusions.
            choices.append(contentsOf: ["Не подходит", "Другой вариант", "Неверный ответ"])
        }
        var unique: [String] = []
        for choice in choices where !unique.contains(choice) {
            unique.append(choice)
        }
        while unique.count < 4 {
            unique.append("Вариант \(unique.count + 1)")
        }
        if unique.count > 4 { unique = Array(unique.prefix(4)) }
        return unique.shuffled()
    }

    private func submitOlympiadAnswer(_ rawAnswer: String) {
        guard olympiadStarted, !olympiadPaused, !olympiadFinished, !rawAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let normalized = rawAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let correctAnswer = olympiadProblem.answer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let correct = normalized == correctAnswer
        _ = store.record(correct: correct, grantDiamond: false)
        if correct { goldBalance += 1 }
        markMentorActivity()
        recordSubjectAnswer(subject: olympiadSubject, correct: correct, question: olympiadProblem.text)
        _ = unlockEligibleAchievements()
        let salute = correct ? countCorrectTowardMilestone() : false
        if correct {
            olympiadCompleted += 1
            olympiadFeedback = "Верно! Отличная работа 🎉"
            if olympiadCompleted >= olympiadTargetCount {
                finishOlympiad(won: true, salute: salute)
            } else {
                if salute { triggerCelebration("milestone:50") }
                nextOlympiadProblem()
            }
        } else {
            recordMistake(subject: olympiadSubject, item: olympiadProblem, selectedAnswer: rawAnswer)
            olympiadAnswer = ""
            olympiadFeedback = "Пока неверно. Попробуй ещё раз — время ещё есть!"
        }
    }

    private func finishOlympiad(won: Bool, salute: Bool = false) {
        guard olympiadStarted, !olympiadFinished else { return }
        olympiadStarted = false
        olympiadFinished = true
        olympiadWon = won
        if won {
            store.addDiamonds(100)
            olympiadWins += 1
            _ = unlockEligibleAchievements()
            triggerCelebration(salute ? "milestone:50" : "olympiad:win")
        }
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
                            .font(.system(size: 14 * AppFontScale.factor, weight: .semibold, design: .rounded))
                            .padding(12)
                            .background(palette.cardSurface.opacity(0.65), in: RoundedRectangle(cornerRadius: 11))
                        }
                    }
                }
                .padding(20)
                .cardStyle(palette)

                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("История статистики по месяцам", icon: "calendar")
                    if store.monthSummaries.isEmpty {
                        emptyHint("История появится после первых занятий. Каждый месяц будет сохранён отдельно.")
                    } else {
                        ForEach(store.monthSummaries) { month in
                            VStack(alignment: .leading, spacing: 7) {
                                HStack(alignment: .firstTextBaseline) {
                                    Text(StatsStore.displayMonth(month.monthKey))
                                        .font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded))
                                        .foregroundStyle(palette.ink)
                                    Spacer()
                                    Text("\(month.accuracy)%")
                                        .font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded))
                                        .foregroundStyle(palette.purple)
                                }
                                HStack(spacing: 12) {
                                    Label("\(month.correct) верно", systemImage: "checkmark.circle.fill")
                                        .foregroundStyle(palette.green)
                                    Label("\(month.incorrect) ошибок", systemImage: "xmark.circle.fill")
                                        .foregroundStyle(palette.red)
                                    Spacer(minLength: 0)
                                    Text("Всего: \(month.total)")
                                        .foregroundStyle(palette.ink)
                                }
                                .font(.system(size: 11 * AppFontScale.factor, weight: .semibold, design: .rounded))
                                HStack {
                                    Text("Лучшая серия: \(month.bestStreak)")
                                    Spacer()
                                    Text("Дней с занятиями: \(month.days.filter { $0.total > 0 }.count)")
                                }
                                .font(.system(size: 10 * AppFontScale.factor, weight: .medium, design: .rounded))
                                .foregroundStyle(palette.muted)
                            }
                            .padding(13)
                            .background(palette.cardSurface.opacity(0.58), in: RoundedRectangle(cornerRadius: 13))
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
                        Text("⭐️").font(.system(size: 38 * AppFontScale.factor))
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Уровень \(levelNumber)").font(.system(size: 21 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                            Text("Всего решено примеров: \(store.stats.total)").font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                        }
                        Spacer()
                        Text("💎 \(store.stats.diamonds)").font(.system(size: 17 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple)
                    }
                    ProgressView(value: Double(levelProgress), total: 25).tint(palette.purple)
                    Text("До уровня \(levelNumber + 1): ещё \(25 - levelProgress) ответов").font(.system(size: 12 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
                }.padding(18).cardStyle(palette)
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Коллекция достижений", icon: "rosette")
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 6), spacing: 10) {
                    medalCard("🥉", title: "500 алмазов", detail: "Накопи 500 алмазов", progress: store.stats.celebratedDiamondMilestones.contains(500) ? 500 : min(store.stats.diamonds, 500), goal: 500, color: Color(red: 0.78, green: 0.49, blue: 0.30))
                    medalCard("🥈", title: "1000 алмазов", detail: "Накопи 1000 алмазов", progress: store.stats.celebratedDiamondMilestones.contains(1000) ? 1000 : min(store.stats.diamonds, 1000), goal: 1000, color: Color(red: 0.68, green: 0.73, blue: 0.80))
                    medalCard("🥇", title: "1500 алмазов", detail: "Накопи 1500 алмазов", progress: store.stats.celebratedDiamondMilestones.contains(1500) ? 1500 : min(store.stats.diamonds, 1500), goal: 1500, color: Color(red: 0.95, green: 0.72, blue: 0.22))
                    medalCard("💠", title: "2000 алмазов", detail: "Накопи 2000 алмазов", progress: store.stats.celebratedDiamondMilestones.contains(2000) ? 2000 : min(store.stats.diamonds, 2000), goal: 2000, color: palette.lilac)
                    medalCard("🏅", title: "2500 алмазов", detail: "Накопи 2500 алмазов", progress: store.stats.celebratedDiamondMilestones.contains(2500) ? 2500 : min(store.stats.diamonds, 2500), goal: 2500, color: Color(red: 0.84, green: 0.62, blue: 0.18))
                    medalCard("🏆", title: "3000 алмазов", detail: "Накопи 3000 алмазов", progress: store.stats.celebratedDiamondMilestones.contains(3000) ? 3000 : min(store.stats.diamonds, 3000), goal: 3000, color: Color(red: 0.55, green: 0.42, blue: 0.88))
                    medalCard("💎", title: "3500 алмазов", detail: "Накопи 3500 алмазов", progress: store.stats.celebratedDiamondMilestones.contains(3500) ? 3500 : min(store.stats.diamonds, 3500), goal: 3500, color: Color(red: 0.25, green: 0.72, blue: 0.91))
                    medalCard("👑", title: "4000 алмазов", detail: "Накопи 4000 алмазов", progress: store.stats.celebratedDiamondMilestones.contains(4000) ? 4000 : min(store.stats.diamonds, 4000), goal: 4000, color: Color(red: 0.92, green: 0.58, blue: 0.25))
                    medalCard("🌟", title: "4500 алмазов", detail: "Накопи 4500 алмазов", progress: store.stats.celebratedDiamondMilestones.contains(4500) ? 4500 : min(store.stats.diamonds, 4500), goal: 4500, color: Color(red: 0.35, green: 0.72, blue: 0.55))
                    medalCard("💎", title: "5000 алмазов", detail: "Накопи 5000 алмазов", progress: store.stats.celebratedDiamondMilestones.contains(5000) ? 5000 : min(store.stats.diamonds, 5000), goal: 5000, color: Color(red: 0.32, green: 0.62, blue: 0.95))
                    medalCard("🌈", title: "5500 алмазов", detail: "Накопи 5500 алмазов", progress: store.stats.celebratedDiamondMilestones.contains(5500) ? 5500 : min(store.stats.diamonds, 5500), goal: 5500, color: Color(red: 0.72, green: 0.43, blue: 0.88))
                    medalCard("🏆", title: "6000 алмазов", detail: "Накопи 6000 алмазов", progress: store.stats.celebratedDiamondMilestones.contains(6000) ? 6000 : min(store.stats.diamonds, 6000), goal: 6000, color: Color(red: 0.98, green: 0.66, blue: 0.22))
                    }
                }
                Button { openShop() } label: {
                    Label("Открыть магазин коллекционных игрушек", systemImage: "storefront.fill")
                        .font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(.white)
                        .padding(.horizontal, 19).padding(.vertical, 13)
                        .background(LinearGradient(colors: [palette.purple, palette.pink], startPoint: .leading, endPoint: .trailing), in: Capsule())
                }.buttonStyle(.plain)
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Медали за правильные ответы", icon: "medal.fill")
                    Text("Правильные ответы накапливаются за всё время, даже после смены месяца. Каждая следующая медаль становится доступна после предыдущей.")
                        .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                        .fixedSize(horizontal: false, vertical: true)
                    let answerGoals: [(Int, String, String, Color)] = [
                        (200, "🥉", "Первые 200", Color(red: 0.72, green: 0.43, blue: 0.25)),
                        (300, "🥈", "Уверенный старт", Color(red: 0.63, green: 0.68, blue: 0.76)),
                        (500, "🥇", "Полтысячи", Color(red: 0.96, green: 0.72, blue: 0.20)),
                        (700, "🏆", "Мастер ответов", Color(red: 0.40, green: 0.65, blue: 0.92)),
                        (850, "👑", "Знаток", Color(red: 0.68, green: 0.43, blue: 0.88)),
                        (1000, "💎", "Гений знаний", Color(red: 0.28, green: 0.78, blue: 0.75)),
                        (1200, "🌈", "Мастер знаний", Color(red: 0.96, green: 0.42, blue: 0.66)),
                        (1500, "🚀", "Легенда учёбы", Color(red: 0.35, green: 0.65, blue: 0.98))
                    ]
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 12) {
                        ForEach(Array(answerGoals.enumerated()), id: \.offset) { index, item in
                            correctAnswerMilestoneCard(goal: item.0, emoji: item.1, title: item.2, color: item.3, previousGoal: index == 0 ? 0 : answerGoals[index - 1].0)
                        }
                    }
                }.padding(18).cardStyle(palette)
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Полученные достижения", icon: "rosette")
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(AchievementCatalog.all.filter { unlockedAchievementIDs.contains($0.id) }) { item in achievementCard(item) }
                    }
                }.padding(18).cardStyle(palette)
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Коллекционные игрушки", icon: "sparkles")
                    Text("\(Collectible.all.filter { allOwnedCollectibleIDs.contains($0.id) }.count) из \(Collectible.all.count) игрушек открыто")
                        .font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.muted)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 6), spacing: 12) {
                        ForEach(Collectible.all.filter { allOwnedCollectibleIDs.contains($0.id) }) { item in collectibleCard(item) }
                    }
                    if !Collectible.all.contains(where: { allOwnedCollectibleIDs.contains($0.id) }) {
                        Text("Пока нет открытых игрушек. Решай задания или загляни в магазин за секретным призом.")
                            .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                            .fixedSize(horizontal: false, vertical: true).padding(.vertical, 5)
                    }
                }.padding(18).cardStyle(palette)
            }.padding(25)
        }.scrollIndicators(.hidden)
    }
    private func correctAnswerMilestoneCard(goal: Int, emoji: String, title: String, color: Color, previousGoal: Int) -> some View {
        let lifetime = lifetimeCorrectAnswers
        let earned = lifetime >= goal
        let active = previousGoal == 0 || lifetime >= previousGoal
        let shownProgress = active ? min(lifetime, goal) : 0
        let percent = goal == 0 ? 0 : Int((Double(shownProgress) / Double(goal) * 100).rounded())
        return VStack(alignment: .center, spacing: 8) {
            Reward3DBadge(symbol: medalSymbol(for: emoji), tint: color, size: 116, locked: false, fillProgress: Double(shownProgress) / Double(goal), artworkName: "medal-\(goal)")
                .frame(width: 110, height: 110)
                .background(
                    LinearGradient(colors: earned ? [color.opacity(0.24), color.opacity(0.08)] : [Color.gray.opacity(0.08), palette.canvasMiddle],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 17)
                )
                .overlay(RoundedRectangle(cornerRadius: 17).stroke(earned ? color : Color.gray.opacity(0.35), lineWidth: earned ? 2 : 1))
                .opacity(active || earned ? 1 : 0.58)
            Text(title)
                .font(.system(size: 12 * AppFontScale.factor, weight: .heavy, design: .rounded))
                .foregroundStyle(earned ? color : palette.ink)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(minHeight: 30, alignment: .center)
            Text("\(goal) правильных ответов")
                .font(.system(size: 10 * AppFontScale.factor, weight: .medium, design: .rounded))
                .foregroundStyle(palette.muted)
                .multilineTextAlignment(.center)
            ProgressView(value: Double(shownProgress), total: Double(goal))
                .tint(earned ? color : (active ? palette.purple : Color.gray.opacity(0.35)))
        }
        .frame(maxWidth: .infinity, minHeight: 205, alignment: .top)
        .padding(10)
        .background(palette.cardSurface.opacity(0.94), in: RoundedRectangle(cornerRadius: 17))
        .overlay(RoundedRectangle(cornerRadius: 17).stroke(earned ? color.opacity(0.8) : palette.line.opacity(0.7), lineWidth: earned ? 1.8 : 1))
    }

    private func medalCard(_ emoji: String, title: String, detail: String, progress: Int, goal: Int, color: Color) -> some View {
        let earned = progress >= goal
        return VStack(alignment: .leading, spacing: 9) {
            Reward3DBadge(symbol: medalSymbol(for: emoji), tint: color, size: 70, locked: !earned)
                .frame(width: 117, height: 94, alignment: .center)
                .background(LinearGradient(colors: earned ? [color.opacity(0.18), palette.pink.opacity(0.10)] : [palette.line, palette.canvasMiddle], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(earned ? color : palette.line, lineWidth: 1.5))
            Text(title).font(.system(size: 16 * AppFontScale.factor * fontScaleH3, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
            Text(detail).font(.system(size: 12 * AppFontScale.factor * fontScaleBody, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
            ProgressView(value: Double(progress), total: Double(goal)).tint(earned ? color : palette.purple)
            Text(earned ? "Медаль получена!" : "\(progress) из \(goal)").font(.system(size: 11 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(earned ? palette.green : palette.purple)
        }.frame(maxWidth: .infinity, alignment: .leading).padding(17).cardStyle(palette)
    }
    private var shopPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                pageHeading("Магазин", subtitle: "Зарабатывай золото за правильные ответы и собирай игрушки 🎁")

                HStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Твой баланс").font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.muted)
                        HStack(spacing: 7) {
                            goldCoinIcon(size: 24)
                            Text("\(goldBalance)").font(.system(size: 22 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                            Text("золота").font(.system(size: 11 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
                        }
                        HStack(spacing: 7) {
                            Text("💎").font(.system(size: 25 * AppFontScale.factor))
                            Text("\(store.stats.diamonds)").font(.system(size: 22 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                            Text("алмазов").font(.system(size: 11 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
                        }
                    }
                    Spacer(minLength: 4)
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(Collectible.all.filter { !allOwnedCollectibleIDs.contains($0.id) }.count)")
                            .font(.system(size: 22 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple)
                        Text("призов осталось").font(.system(size: 11 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.muted)
                    }
                }.padding(17).cardStyle(palette)

                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 10) {
                        goldCoinIcon(size: 32)
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Алмазы за золото").font(.system(size: 19 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                            Text("Обменяй золото на алмазы: 100 → 50, 200 → 110, 300 → 170").font(.system(size: 12 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
                        }
                        Spacer()
                        Text("Золото: \(goldBalance)").font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple)
                    }
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        goldDiamondExchangeCard(gold: 100, diamonds: 50)
                        goldDiamondExchangeCard(gold: 200, diamonds: 110)
                        goldDiamondExchangeCard(gold: 300, diamonds: 170)
                    }
                }.padding(16).cardStyle(palette)

                // Rare collectible block deliberately stays at the top. Owned items remain visible here.
                if Collectible.all.contains(where: { $0.isRare }) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles").font(.system(size: 20 * AppFontScale.factor, weight: .black))
                                .foregroundStyle(palette.isDark ? Color(red: 1, green: 0.78, blue: 0.25) : Color(red: 0.72, green: 0.43, blue: 0.06))
                            Text("Редкие коллекционные").font(.system(size: 19 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                            Spacer(minLength: 0)
                            Text("500 💎").font(.system(size: 15 * AppFontScale.factor, weight: .black, design: .rounded))
                                .foregroundStyle(palette.isDark ? Color(red: 1, green: 0.78, blue: 0.25) : Color(red: 0.60, green: 0.34, blue: 0.02))
                        }
                        Text("Редкие подарки — вверху страницы. Редкая игрушка стоит 500 алмазов; купленные и уже открытые игрушки остаются видимыми в коллекции.")
                            .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                            .fixedSize(horizontal: false, vertical: true)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 6), spacing: 13) {
                            ForEach(Collectible.all.filter { $0.isRare }) { item in
                                shopItemCard(item)
                            }
                        }
                    }
                    .padding(18)
                    .background(
                        palette.isDark
                            ? palette.cardSurface
                            : Color(red: 1.0, green: 0.95, blue: 0.75),
                        in: RoundedRectangle(cornerRadius: 21)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 21).stroke(palette.isDark ? palette.purple : Color(red: 0.84, green: 0.60, blue: 0.18), lineWidth: 2))
                    .shadow(color: .clear, radius: 0)
                }

                if Collectible.all.contains(where: { !$0.isRare }) {
                    VStack(alignment: .leading, spacing: 12) {
                        sectionTitle("Коллекционные игрушки", icon: "gift")
                        Text("Купленные игрушки остаются в списке с отметкой «Открыта!». Их можно рассмотреть, даже если алмазы уже потрачены.")
                            .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 6), spacing: 13) {
                            ForEach(Collectible.all.filter { !$0.isRare }) { item in
                                shopItemCard(item)
                            }
                        }
                    }.padding(18).cardStyle(palette)
                }

                if Collectible.all.allSatisfy({ allOwnedCollectibleIDs.contains($0.id) }) {
                    Text("Поздравляем! Все игрушки собраны 🎉")
                        .font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.green)
                        .frame(maxWidth: .infinity).padding(22)
                }
                Text("За правильный ответ начисляется 1 золотая монета. Обычные коллекционные игрушки покупаются за золото, редкие — за 500 алмазов. Обмен: 100 золотых монет на 50 алмазов.")
                    .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }.padding(25)
        }.scrollIndicators(.hidden)
    }

    private func goldCoinIcon(size: CGFloat) -> some View {
        ZStack {
            Circle().fill(LinearGradient(colors: [Color(red: 1.0, green: 0.88, blue: 0.20), Color(red: 0.94, green: 0.62, blue: 0.02)], startPoint: .topLeading, endPoint: .bottomTrailing))
            Circle().stroke(Color(red: 0.72, green: 0.40, blue: 0.0), lineWidth: max(1, size * 0.07)).padding(size * 0.14)
            Image(systemName: "star.fill").font(.system(size: size * 0.34 * AppFontScale.factor, weight: .black)).foregroundStyle(Color(red: 0.62, green: 0.34, blue: 0.0))
        }.frame(width: size, height: size).accessibilityLabel("Золотая монета")
    }

    private func goldPackCard(gold: Int, cost: Int) -> some View {
        let canBuy = store.stats.diamonds >= cost
        return VStack(spacing: 8) {
            goldCoinIcon(size: 35)
            Text("\(gold)").font(.system(size: 22 * AppFontScale.factor, weight: .black, design: .rounded)).foregroundStyle(palette.ink)
            Text("золотых монет").font(.system(size: 10 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
            Button {
                guard store.spendDiamonds(cost) else { return }
                goldBalance += gold
            } label: {
                VStack(spacing: 3) {
                    Text("💎 \(cost)").font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded))
                    Text(canBuy ? "Купить сейчас" : "Не хватает алмазов").font(.system(size: 10 * AppFontScale.factor, weight: .bold, design: .rounded))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 8)
                .background(Color(red: 0.24, green: 0.08, blue: 0.55), in: RoundedRectangle(cornerRadius: 9))
            }
            .buttonStyle(.plain)
            .disabled(!canBuy)
            .opacity(canBuy ? 1 : 0.62)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(palette.cardSurface, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(palette.line, lineWidth: 1))
    }

    private func shopItemCard(_ item: Collectible) -> some View {
        let owned = allOwnedCollectibleIDs.contains(item.id)
        let price = shopPrices[item.id] ?? (item.isRare ? 500 : 25)
        let gold = Color(red: 0.82, green: 0.58, blue: 0.12)
        return VStack(alignment: .leading, spacing: 9) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 17).fill(
                    LinearGradient(
                        colors: item.isRare
                            ? [Color(red: 1.0, green: 0.97, blue: 0.82), Color(red: 0.98, green: 0.82, blue: 0.48)]
                            : (owned ? [Color.clear, Color.clear] : [palette.line.opacity(0.5), palette.palePink]),
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                if owned {
                    Collectible3DView(id: item.id, title: item.title, size: item.isRare ? 112 : 94, animated: false)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture { if item.isRare { triggerCelebration("rare:\(item.id)") } }
                } else {
                    ZStack {
                        // Лёгкая заглушка вместо декоративного 3D-рендера для закрытых товаров.
                        // Это снижает нагрузку при прокрутке длинного каталога.
                        Text("🎁")
                            .font(.system(size: item.isRare ? 62 : 52 * AppFontScale.factor))
                            .opacity(0.16)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Image(systemName: "lock.fill")
                            .font(.system(size: 31.5 * AppFontScale.factor, weight: .black))
                            .foregroundStyle(.white)
                            .padding(5.5)
                            .background(palette.purple.opacity(0.98), in: Circle())
                            .overlay(Circle().stroke(.white.opacity(0.95), lineWidth: 1.0))
                            .shadow(color: .black.opacity(0.18), radius: 2, y: 1)
                            .offset(x: item.isRare ? 42 : 36, y: item.isRare ? 48 : 39)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                if item.isRare {
                    Image(systemName: "sparkles")
                        .font(.system(size: 18 * AppFontScale.factor, weight: .black))
                        .foregroundStyle(gold)
                        .padding(7)
                }
            }
            .frame(height: item.isRare ? 144 : 125)
            .overlay(RoundedRectangle(cornerRadius: 17).stroke(item.isRare ? gold : palette.line.opacity(owned ? 0.12 : 0.7), lineWidth: item.isRare ? 2 : 1))

            if item.isRare {
                Label("РЕДКИЙ КОЛЛЕКЦИОННЫЙ", systemImage: "sparkles")
                    .font(.system(size: 9 * AppFontScale.factor, weight: .black, design: .rounded))
                    .foregroundStyle(palette.isDark ? Color(red: 1, green: 0.80, blue: 0.30) : Color(red: 0.52, green: 0.31, blue: 0.02))
                    .lineLimit(1).minimumScaleFactor(0.7)
            }
            Text(owned ? item.title : (item.isRare ? "Редкий коллекционный приз" : "Секретный приз"))
                .font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink).lineLimit(2)
            Text(owned ? "Открыта · \(item.detail)" : (item.isRare ? "Редкая коллекционная игрушка за 500 алмазов" : "Коллекционная игрушка за золотые монеты"))
                .font(.system(size: 10 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted).lineLimit(2)

            if owned {
                Label("Открыта!", systemImage: "checkmark.seal.fill").font(.system(size: 11 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.green).frame(maxWidth: .infinity).padding(.vertical, 8)
            } else {
                Button { buyCollectible(item) } label: {
                    HStack(spacing: 5) {
                        if item.isRare { Text("💎").font(.system(size: 14 * AppFontScale.factor)) }
                        else { goldCoinIcon(size: 14) }
                        Text("\(price)").font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded))
                        Text(item.isRare ? "Открыть" : "Купить").font(.system(size: 10 * AppFontScale.factor, weight: .bold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity).padding(.vertical, 8)
                    .foregroundStyle((item.isRare ? store.stats.diamonds >= price : goldBalance >= price) ? .white : palette.muted)
                    .background((item.isRare ? store.stats.diamonds >= price : goldBalance >= price) ? palette.purple : palette.line, in: Capsule())
                }.buttonStyle(.plain).disabled(item.isRare ? store.stats.diamonds < price : goldBalance < price)
            }
        }
        .padding(11)
        .background(
            item.isRare && !palette.isDark
                ? LinearGradient(colors: [Color(red: 1.0, green: 0.985, blue: 0.91), Color(red: 1.0, green: 0.94, blue: 0.77)], startPoint: .topLeading, endPoint: .bottomTrailing)
                : LinearGradient(colors: [palette.cardSurface.opacity(0.98), palette.cardSurface.opacity(0.92)], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 19)
        )
        .overlay(RoundedRectangle(cornerRadius: 19).stroke(item.isRare ? gold.opacity(0.8) : palette.line.opacity(0.7), lineWidth: item.isRare ? 2 : 1))
        .shadow(color: .clear, radius: 0)
    }

    private func prepareAchievementThresholds() {
        guard achievementThresholdsVersion < 3 else { return }
        // Сбрасываем коллекцию, чтобы новые пороги по алмазам начинались заново.
        unlockedAchievementStorage = ""
        achievementThresholdsVersion = 3
    }

    private func prepareShopPrices() {
        var prices: [String: Int] = [:]
        var ordinaryIndex = 0
        for item in Collectible.all {
            if item.isRare {
                prices[item.id] = 500
            } else {
                prices[item.id] = 25 + ordinaryIndex
                ordinaryIndex += 1
            }
        }
        shopPricesStorage = prices.keys.sorted().map { "\($0)=\(prices[$0]!)" }.joined(separator: ",")
    }

    private func openShop() {
        prepareShopPrices()
        selected = .shop
    }

    private func goldDiamondExchangeCard(gold amount: Int, diamonds: Int) -> some View {
        let affordable = goldBalance >= amount
        return Button {
            guard goldBalance >= amount else { return }
            goldBalance -= amount
            store.addDiamonds(diamonds)
        } label: {
            VStack(spacing: 7) {
                HStack(spacing: 5) {
                    goldCoinIcon(size: 19)
                    Text("\(amount)").font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded))
                }
                Image(systemName: "arrow.down").font(.system(size: 11, weight: .black))
                HStack(spacing: 4) {
                    Text("💎").font(.system(size: 17 * AppFontScale.factor))
                    Text("\(diamonds)").font(.system(size: 15 * AppFontScale.factor, weight: .heavy, design: .rounded))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .foregroundStyle(affordable ? .white : palette.muted)
            .background(affordable ? Color(red: 0.24, green: 0.08, blue: 0.55) : palette.line, in: RoundedRectangle(cornerRadius: 13))
        }
        .buttonStyle(.plain)
        .disabled(!affordable)
        .help("Обменять \(amount) золотых монет на \(diamonds) алмазов")
    }

    private func buyCollectible(_ item: Collectible) {
        // Не выдаём и не продаём коллекционную игрушку второй раз.
        guard !allOwnedCollectibleIDs.contains(item.id) else { return }
        let price = shopPrices[item.id] ?? (item.isRare ? 500 : 25)
        if item.isRare {
            guard store.spendDiamonds(price) else { return }
        } else {
            guard goldBalance >= price else { return }
            goldBalance -= price
        }
        shopPurchasesStorage = shopOwnedIDs.union([item.id]).sorted().joined(separator: ",")
        triggerCelebration(item.isRare ? "rare:\(item.id)" : "bonus:\(item.id)")
    }

    private var roomPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                pageHeading("Моя комната", subtitle: "Обустраивай своё пространство игрушками, которые ты заработал и купил")
                ZStack(alignment: .bottom) {
                    LinearGradient(colors: [Color(red: 0.83, green: 0.91, blue: 1.0), Color(red: 0.96, green: 0.84, blue: 0.93)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    VStack(spacing: 0) {
                        HStack {
                            Image(systemName: "cloud.fill").font(.system(size: 26 * AppFontScale.factor)).foregroundStyle(.white.opacity(0.9))
                            Spacer()
                            Image(systemName: "sun.max.fill").font(.system(size: 29 * AppFontScale.factor)).foregroundStyle(Color(red: 1, green: 0.75, blue: 0.25))
                        }.padding(.horizontal, 24).padding(.top, 18)
                        Spacer(minLength: 12)
                        HStack(alignment: .bottom, spacing: 12) {
                            RoundedRectangle(cornerRadius: 8).fill(Color(red: 0.66, green: 0.43, blue: 0.30)).frame(width: 72, height: 70)
                                .overlay(VStack(spacing: 4) { RoundedRectangle(cornerRadius: 4).fill(Color(red: 0.93, green: 0.72, blue: 0.53)).frame(height: 8); Spacer(); RoundedRectangle(cornerRadius: 4).fill(Color(red: 0.93, green: 0.72, blue: 0.53)).frame(height: 8) }.padding(8))
                            Spacer()
                            VStack(spacing: 4) {
                                Text("МОЯ КОЛЛЕКЦИЯ").font(.system(size: 10 * AppFontScale.factor, weight: .black, design: .rounded)).tracking(1).foregroundStyle(Color(red: 0.32, green: 0.25, blue: 0.45))
                                Text("\(roomPlacedIDs.count) украшений").font(.system(size: 16 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(Color(red: 0.32, green: 0.25, blue: 0.45))
                            }.padding(12).background(.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 14))
                            Spacer()
                            RoundedRectangle(cornerRadius: 9).fill(Color(red: 0.54, green: 0.70, blue: 0.90)).frame(width: 70, height: 64)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.white.opacity(0.9), lineWidth: 4))
                        }.padding(.horizontal, 22).padding(.bottom, 18)
                        Rectangle().fill(Color(red: 0.80, green: 0.64, blue: 0.55)).frame(height: 18)
                    }
                }
                .frame(height: 190).clipShape(RoundedRectangle(cornerRadius: 22))
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(palette.line, lineWidth: 1))
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Расставь любимые игрушки").font(.system(size: 18 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                        Text("Нажми «Поставить в комнату», чтобы украсить комнату.").font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    }
                    Spacer()
                    Button { openShop() } label: { Label("В магазин", systemImage: "storefront.fill").font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded)) }
                        .buttonStyle(.borderedProminent).tint(palette.purple)
                }
                if roomItems.isEmpty {
                    VStack(spacing: 10) {
                        Text("🧸").font(.system(size: 48 * AppFontScale.factor))
                        Text("Комната пока пустая").font(.system(size: 17 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                        Text("Заработай алмазы и открой первую игрушку в магазине — она появится здесь.").font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted).multilineTextAlignment(.center)
                    }.frame(maxWidth: .infinity).padding(28).cardStyle(palette)
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 6), spacing: 8) {
                        ForEach(roomItems) { item in
                            VStack(spacing: 8) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 17).fill(roomPlacedIDs.contains(item.id) ? Color(red: 0.87, green: 0.94, blue: 1) : palette.cardSurface)
                                    Collectible3DView(id: item.id, title: item.title, size: 86, animated: false).padding(8)
                                    if roomPlacedIDs.contains(item.id) {
                                        Image(systemName: "checkmark.seal.fill").font(.system(size: 19 * AppFontScale.factor, weight: .bold)).foregroundStyle(.green).padding(6).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    }
                                }.frame(height: 118)
                                Text(item.title).font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.ink).lineLimit(2).multilineTextAlignment(.center).frame(height: 30)
                                Button { toggleRoomItem(item.id) } label: {
                                    Label(roomPlacedIDs.contains(item.id) ? "Убрать" : "Поставить в комнату",
                                          systemImage: roomPlacedIDs.contains(item.id) ? "minus.circle" : "plus.circle")
                                        .font(.system(size: 10 * AppFontScale.factor, weight: .bold, design: .rounded))
                                        .frame(maxWidth: .infinity)
                                }.buttonStyle(.bordered).tint(palette.purple)
                            }.padding(10).cardStyle(palette)
                        }
                    }
                }
            }.padding(24)
        }.scrollIndicators(.hidden)
    }

    private var settingsPage: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                pageHeading("Настройки", subtitle: "Настрой своё учебное пространство")
                VStack(alignment: .leading, spacing: 9) {
                    Label("ВНЕШНОСТЬ НАСТАВНИКА", systemImage: "person.crop.square.fill")
                        .font(.system(size: 15 * AppFontScale.factor * fontScaleH2, weight: .black, design: .rounded))
                        .foregroundStyle(palette.ink)
                    Text("Выбери персонажа для карточки «Мой наставник». Выбор сохранится автоматически.")
                        .font(.system(size: 11 * AppFontScale.factor * fontScaleBody, weight: .medium, design: .rounded))
                        .foregroundStyle(palette.muted)
                    let mentorOptions: [(String, String)] = [
                        ("🦉", "Совёнок"), ("🐻", "Медвежонок"), ("🦊", "Лисёнок"), ("🐧", "Пингвин"),
                        ("🤖", "Робот"), ("🐉", "Дракончик"), ("🚀", "Космонавт"), ("🧙", "Волшебник"),
                        ("🦁", "Львёнок"), ("🐰", "Зайчик"), ("🐼", "Панда"), ("🐱", "Кот-учёный"),
                        ("🦋", "Бабочка"), ("👻", "Привидение"), ("🦖", "Динозаврик"), ("🧑‍🔬", "Учёный"),
                        ("🦸", "Супергерой"), ("🌳", "Дух природы"), ("⭐", "Звёздочка"), ("☁️", "Облачко")
                    ]
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 7), count: 5), spacing: 8) {
                        ForEach(mentorOptions, id: \.0) { option in
                            Button { mentorAvatarEmoji = option.0 } label: {
                                VStack(spacing: 4) {
                                    Text(option.0).font(.system(size: 27 * AppFontScale.factor))
                                        .frame(maxWidth: .infinity).frame(height: 42)
                                    Text(option.1).font(.system(size: 9 * AppFontScale.factor, weight: .semibold, design: .rounded))
                                        .foregroundStyle(palette.ink).lineLimit(1).minimumScaleFactor(0.75)
                                    if mentorAvatarEmoji == option.0 {
                                        Image(systemName: "checkmark.circle.fill").font(.system(size: 12)).foregroundStyle(palette.green)
                                    } else {
                                        Image(systemName: "circle").font(.system(size: 12)).foregroundStyle(palette.muted.opacity(0.5))
                                    }
                                }
                                .padding(5)
                                .background(mentorAvatarEmoji == option.0 ? palette.purple.opacity(0.16) : palette.cardSurface, in: RoundedRectangle(cornerRadius: 10))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(mentorAvatarEmoji == option.0 ? palette.purple : palette.line, lineWidth: mentorAvatarEmoji == option.0 ? 2 : 1))
                            }.buttonStyle(.plain)
                        }
                    }
                }
                .padding(10)
                .background(LinearGradient(colors: [palette.purple.opacity(0.18), palette.pink.opacity(0.14)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(palette.purple.opacity(0.7), lineWidth: 1))
                VStack(alignment: .leading, spacing: 7) {
                    Label("РАЗМЕР ШРИФТОВ", systemImage: "textformat.size").font(.system(size: 17 * AppFontScale.factor * fontScaleH2, weight: .black, design: .rounded)).foregroundStyle(palette.ink)
                    Text("Общий масштаб действует на всё приложение; ниже — тонкая настройка отдельных типов текста.").font(.system(size: 10 * AppFontScale.factor * fontScaleBody, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    fontScaleControl("Все страницы приложения", scale: $fontScaleGlobal, example: "Пример общего текста во всех разделах", baseSize: 14)
                    fontScaleControl("H1 · Главные заголовки страниц", scale: $fontScaleH1, example: "Пример главного заголовка", baseSize: 25)
                    fontScaleControl("H2 · Заголовки разделов", scale: $fontScaleH2, example: "Пример заголовка раздела", baseSize: 21)
                    fontScaleControl("H3 · Заголовки карточек и блоков", scale: $fontScaleH3, example: "Пример заголовка карточки", baseSize: 18)
                    fontScaleControl("H4 · Вопросы и крупный текст задания", scale: $fontScaleH4, example: "Сколько будет 7 × 8?", baseSize: 24)
                    fontScaleControl("H5 · Названия ответов и кнопок", scale: $fontScaleH5, example: "Пример варианта ответа", baseSize: 15)
                    fontScaleControl("H6 · Подзаголовки и подписи", scale: $fontScaleH6, example: "Пример подписи под заголовком", baseSize: 13)
                    fontScaleControl("H7 · Мелкий служебный текст", scale: $fontScaleH7, example: "Пример небольшого пояснения", baseSize: 11)
                    fontScaleControl("Основной текст", scale: $fontScaleBody, example: "Обычный текст в разделах и меню", baseSize: 14)
                    fontScaleControl("Подсказки и пояснения", scale: $fontScaleHints, example: "Не спеши, внимательно прочитай вопрос ещё раз.", baseSize: 12)
                    Button("Сбросить все размеры шрифта") {
                        fontScaleH1 = 1; fontScaleH2 = 1; fontScaleH3 = 1; fontScaleH4 = 1
                        fontScaleGlobal = 1; fontScaleH5 = 1; fontScaleH6 = 1; fontScaleH7 = 1; fontScaleBody = 1; fontScaleHints = 1
                    }.font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.purple).buttonStyle(.plain)
                }
                .padding(8)
                .background(LinearGradient(colors: [palette.purple.opacity(0.22), palette.pink.opacity(0.18)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(palette.purple, lineWidth: 1))
                VStack(alignment: .leading, spacing: 5) {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("ЯРКОСТЬ ТЕМЫ", systemImage: "sun.max.fill").font(.system(size: 10 * AppFontScale.factor, weight: .black, design: .rounded)).foregroundStyle(palette.ink)
                        Text("Настрой яркость интерфейса. Значение сохраняется между запусками.").font(.system(size: 10 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted).lineLimit(2).foregroundStyle(palette.muted)
                        interactiveSlider(value: $themeBrightness, range: -0.25...0.15, step: 0.01, knobSize: 18)
                            .padding(.horizontal, 3)
                        HStack { Text("Темнее").foregroundStyle(palette.ink); Spacer(); Text("\(Int((100 + themeBrightness * 100).rounded()))%").font(.system(size: 11 * AppFontScale.factor, weight: .black, design: .rounded)).foregroundStyle(Color(red: 0.30, green: 0.08, blue: 0.78)); Spacer(); Text("Светлее").foregroundStyle(palette.ink) }.font(.system(size: 10 * AppFontScale.factor, weight: .black, design: .rounded))
                    }.padding(5)
                    .background(LinearGradient(colors: [palette.purple.opacity(0.22), palette.pink.opacity(0.18)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(palette.purple, lineWidth: 1))
                    VStack(alignment: .leading, spacing: 10) {
                        Label("КОНТРАСТ ЦВЕТОВ", systemImage: "circle.lefthalf.filled")
                            .font(.system(size: 10 * AppFontScale.factor, weight: .black, design: .rounded)).foregroundStyle(palette.ink)
                        Text("Передвинь ползунок — внешний вид изменится сразу.")
                            .font(.system(size: 10 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                        interactiveSlider(value: $screenContrast, range: 0.75...1.55, step: 0.05, knobSize: 18)
                            .padding(.horizontal, 5)
                        HStack {
                            Text("75% · мягче").foregroundStyle(palette.muted)
                            Spacer()
                            Text("\(Int((screenContrast * 100).rounded()))%")
                                .font(.system(size: 11 * AppFontScale.factor, weight: .black, design: .rounded)).foregroundStyle(palette.purple)
                            Spacer()
                            Text("155% · ярче").foregroundStyle(palette.muted)
                        }.font(.system(size: 10 * AppFontScale.factor, weight: .bold, design: .rounded))
                    }
                    .padding(16)
                    .background(LinearGradient(colors: [palette.purple.opacity(0.22), palette.pink.opacity(0.18)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 17))
                    .overlay(RoundedRectangle(cornerRadius: 17).stroke(palette.purple, lineWidth: 2))
                    Label("Тема оформления", systemImage: "paintpalette.fill").font(.system(size: 18 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                    Text("Выбери одну из 20 неповторяющихся тем: 15 светлых цветовых палитр и 5 контрастных тёмных тем.").font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 10) {
                        ForEach(AppTheme.selectableThemes) { theme in themeSwatch(theme) }
                    }
                }.padding(22).cardStyle(palette)
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 9) {
                        Image(systemName: "app.badge.checkmark").foregroundStyle(palette.purple)
                        Text("Версия \(appVersion)").font(.system(size: 18 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                    }
                    Text("Дата выпуска: \(appReleaseDate)").font(.system(size: 13 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.muted)
                    Button("Открыть историю версий →") { selected = .versionHistory }.font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.purple).buttonStyle(.plain)
                    Text("Журнал выпусков и описания изменений сохраняются в программе. Статистика по месяцам, алмазы и коллекции сохраняются на этом Mac.")
                        .font(.system(size: 13 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                    Divider().overlay(palette.line)
                    Text("© 2026 Муллагалиев Рустам. Все права защищены.")
                        .font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                    Text("Разработчик: Муллагалиев Рустам")
                        .font(.system(size: 12 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
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
                            Image(systemName: "checkmark").font(.system(size: 12 * AppFontScale.factor, weight: .heavy)).foregroundStyle(theme.isDark || theme == .night || theme == .galaxy ? .white : p.ink)
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 9).stroke(p.line, lineWidth: 1))
                Text(theme.rawValue).font(.system(size: 9 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted).lineLimit(1)
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
                            Image(systemName: "app.badge.checkmark").font(.system(size: 23 * AppFontScale.factor, weight: .bold)).foregroundStyle(palette.purple)
                                .frame(width: 42, height: 42).background(palette.palePink, in: RoundedRectangle(cornerRadius: 13))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(note.version == appVersion ? "Версия \(note.version) (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"))" : "Версия \(note.version)").textSelection(.enabled).font(.system(size: 24 * AppFontScale.factor * fontScaleH2, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                                Text(note.title).textSelection(.enabled).font(.system(size: 13 * AppFontScale.factor * fontScaleH3, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
                            }
                            Spacer()
                            Text(note.date).font(.system(size: 11 * AppFontScale.factor * fontScaleHints, weight: .bold, design: .rounded)).foregroundStyle(palette.purple)
                                .padding(.horizontal, 9).padding(.vertical, 6).background(palette.lilac.opacity(0.28), in: Capsule())
                        }
                        Divider().overlay(palette.line)
                        ForEach(note.changes, id: \.self) { change in
                            HStack(alignment: .top, spacing: 9) {
                                Image(systemName: "checkmark.circle.fill").font(.system(size: 13 * AppFontScale.factor, weight: .semibold)).foregroundStyle(palette.green).padding(.top, 2)
                                Text(change).textSelection(.enabled).font(.system(size: 13 * AppFontScale.factor * fontScaleBody, weight: .medium, design: .rounded)).foregroundStyle(palette.ink).fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        Button {
                            let entry = "Версия \(note.version) · \(note.date)\n\(note.title)\n" + note.changes.map { "• " + $0 }.joined(separator: "\n")
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(entry, forType: .string)
                        } label: {
                            Label("Копировать изменения", systemImage: "doc.on.doc")
                                .font(.system(size: 11 * AppFontScale.factor, weight: .semibold, design: .rounded))
                                .foregroundStyle(palette.purple)
                        }.buttonStyle(.plain)
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
                .font(.system(size: 15 * AppFontScale.factor, weight: .heavy))
                .foregroundStyle(palette.purple)
            Text(text)
                .font(.system(size: 15 * AppFontScale.factor * fontScaleH2, weight: .heavy, design: .rounded))
                .foregroundStyle(palette.ink)
        }
    }

    private func miniStat(_ title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 11 * AppFontScale.factor, weight: .heavy)).foregroundStyle(color)
                Text(title).font(.system(size: 9 * AppFontScale.factor * fontScaleH7, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted).lineLimit(1).minimumScaleFactor(0.68)
            }
            Text(value).font(.system(size: 19 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink).lineLimit(1).minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, minHeight: 49, alignment: .leading)
        .padding(7).background(palette.cardSurface.opacity(0.75), in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(palette.line.opacity(0.7), lineWidth: 1))
    }

    private func todayStat(_ title: String, value: Int, icon: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon).font(.system(size: 15 * AppFontScale.factor, weight: .bold)).foregroundStyle(color)
            Text(title).font(.system(size: 11 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
            Spacer(minLength: 2)
            Text("\(value)").font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(color)
        }
        .padding(.vertical, 5)
        .overlay(alignment: .bottom) { Rectangle().fill(palette.line.opacity(0.55)).frame(height: 1) }
    }

    private func tableHead(_ text: String, align: Alignment) -> some View {
        Text(text)
            .font(.system(size: 10 * AppFontScale.factor * fontScaleH7, weight: .bold, design: .rounded))
            .foregroundStyle(palette.muted)
            .frame(maxWidth: align == .leading ? .infinity : nil, alignment: align)
    }

    private func emptyHint(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11 * AppFontScale.factor * fontScaleH7, weight: .medium, design: .rounded))
            .foregroundStyle(palette.muted)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(palette.cardSurface.opacity(0.56), in: RoundedRectangle(cornerRadius: 11))
    }

    private func rewardPreview(emoji: String, title: String, subtitle: String, progress: Int, goal: Int) -> some View {
        HStack(spacing: 9) {
            Text(emoji).font(.system(size: 40 * AppFontScale.factor))
                .frame(width: 63, height: 68)
                .background(palette.palePink, in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.system(size: 12 * AppFontScale.factor * fontScaleH5, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                Text(subtitle).font(.system(size: 10 * AppFontScale.factor * fontScaleBody, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                ProgressView(value: Double(progress), total: Double(goal)).tint(palette.purple).scaleEffect(x: 1, y: 0.72, anchor: .center)
            }
            Spacer(minLength: 0)
        }
        .padding(7)
        .background(palette.cardSurface.opacity(0.65), in: RoundedRectangle(cornerRadius: 13))
    }

    private func largeStat(_ title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 7) {
                Image(systemName: icon).font(.system(size: 15 * AppFontScale.factor, weight: .bold)).foregroundStyle(color)
                Text(title).font(.system(size: 10 * AppFontScale.factor, weight: .semibold, design: .rounded)).foregroundStyle(palette.muted)
                    .lineLimit(1).minimumScaleFactor(0.65)
            }
            Text(value).font(.system(size: 22 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                .minimumScaleFactor(0.65).lineLimit(1)
        }
        .frame(maxWidth: .infinity, minHeight: 67, alignment: .leading)
        .padding(.horizontal, 11).padding(.vertical, 9)
        .cardStyle(palette)
    }

    private func medalSymbol(for emoji: String) -> String {
        switch emoji {
        case "🥉", "🥈", "🥇": return "medal.fill"
        case "💠": return "diamond.fill"
        default: return "trophy.fill"
        }
    }

    private func rewardTint(for id: String) -> Color {
        let colors: [Color] = [
            Color(red: 0.96, green: 0.25, blue: 0.38),
            Color(red: 0.98, green: 0.55, blue: 0.12),
            Color(red: 0.93, green: 0.73, blue: 0.12),
            Color(red: 0.12, green: 0.68, blue: 0.39),
            Color(red: 0.08, green: 0.62, blue: 0.83),
            Color(red: 0.35, green: 0.42, blue: 0.96),
            Color(red: 0.65, green: 0.32, blue: 0.92),
            Color(red: 0.94, green: 0.30, blue: 0.67)
        ]
        let index = id.unicodeScalars.reduce(0) { $0 + Int($1.value) } % colors.count
        return colors[index]
    }

    private func achievementSymbol(for id: String) -> String {
        switch id {
        case "first-answer": return "leaf.fill"
        case "ten-correct": return "star.fill"
        case "twenty-correct": return "sparkles"
        case "fifty-correct": return "medal.fill"
        case "five-streak", "fifteen-streak", "twenty-streak": return "bolt.fill"
        case "daily-solver": return "figure.run"
        case "three-days", "five-days": return "calendar"
        case "perfect-ten": return "diamond.fill"
        case "accuracy-90": return "scope"
        case "hundred-answers", "five-hundred-answers": return "brain.head.profile"
        case "diamond-100": return "diamond.fill"
        default:
            if id.contains("olympiad") { return "trophy.fill" }
            if id.contains("subject") { return "books.vertical.fill" }
            if id.contains("streak") { return "bolt.fill" }
            if id.contains("diamond") { return "diamond.fill" }
            if id.contains("day") { return "calendar" }
            return "star.circle.fill"
        }
    }

    private func achievementCard(_ item: Achievement) -> some View {
        let unlocked = unlockedAchievementIDs.contains(item.id)
        return HStack(alignment: .top, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 19)
                    .fill(LinearGradient(colors: unlocked ? [rewardTint(for: item.id).opacity(0.19), rewardTint(for: item.id).opacity(0.05)] : [Color.gray.opacity(0.06), palette.canvasMiddle.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                Text(item.emoji)
                    .font(.system(size: 43 * AppFontScale.factor))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .frame(width: 82, height: 82)
            .overlay(RoundedRectangle(cornerRadius: 19).stroke(unlocked ? rewardTint(for: item.id) : Color.gray.opacity(0.35), lineWidth: unlocked ? 2.2 : 1.2))
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title).font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
                Text(item.detail).font(.system(size: 11 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted).fixedSize(horizontal: false, vertical: true)
                Text(unlocked ? "Получено!" : "Ещё впереди").font(.system(size: 10 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(unlocked ? palette.green : palette.muted)
            }
            Spacer(minLength: 0)
        }.frame(maxWidth: .infinity, minHeight: 92, alignment: .leading).padding(12)
            .background(palette.cardSurface.opacity(0.94), in: RoundedRectangle(cornerRadius: 19))
            .overlay(RoundedRectangle(cornerRadius: 19).stroke(palette.line.opacity(0.7), lineWidth: 1))
    }
    private func collectibleCard(_ item: Collectible) -> some View {
        let unlocked = allOwnedCollectibleIDs.contains(item.id)
        let gold = Color(red: 0.82, green: 0.58, blue: 0.12)
        return VStack(alignment: .leading, spacing: 9) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 17).fill(
                    LinearGradient(
                        colors: item.isRare
                            ? [Color(red: 1.0, green: 0.97, blue: 0.82), Color(red: 0.98, green: 0.82, blue: 0.48)]
                            : [palette.line.opacity(0.5), palette.palePink],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                Collectible3DView(id: item.id, title: item.title, size: item.isRare ? 112 : 94, animated: item.isRare)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture { if item.isRare { triggerCelebration("rare:\(item.id)") } }
                if item.isRare {
                    Image(systemName: "sparkles")
                        .font(.system(size: 18 * AppFontScale.factor, weight: .black))
                        .foregroundStyle(gold)
                        .padding(7)
                }
            }
            .frame(height: item.isRare ? 144 : 125)
            .overlay(RoundedRectangle(cornerRadius: 17).stroke(item.isRare ? gold : palette.line.opacity(0.12), lineWidth: item.isRare ? 2 : 1))

            if item.isRare {
                Label("РЕДКИЙ КОЛЛЕКЦИОННЫЙ", systemImage: "sparkles")
                    .font(.system(size: 9 * AppFontScale.factor, weight: .black, design: .rounded))
                    .foregroundStyle(palette.isDark ? Color(red: 1, green: 0.80, blue: 0.30) : Color(red: 0.52, green: 0.31, blue: 0.02))
                    .lineLimit(1).minimumScaleFactor(0.7)
            }
            Text(item.title)
                .font(.system(size: 13 * AppFontScale.factor, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink).lineLimit(2)
            Text(item.detail)
                .font(.system(size: 10 * AppFontScale.factor, weight: .medium, design: .rounded)).foregroundStyle(palette.muted).lineLimit(2)

            Label("Открыта!", systemImage: "checkmark.seal.fill")
                .font(.system(size: 11 * AppFontScale.factor, weight: .heavy, design: .rounded))
                .foregroundStyle(palette.green).frame(maxWidth: .infinity).padding(.vertical, 8)
        }
        .padding(11)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(
            item.isRare && !palette.isDark
                ? LinearGradient(colors: [Color(red: 1.0, green: 0.985, blue: 0.91), Color(red: 1.0, green: 0.94, blue: 0.77)], startPoint: .topLeading, endPoint: .bottomTrailing)
                : LinearGradient(colors: [palette.cardSurface.opacity(0.98), palette.cardSurface.opacity(0.92)], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 19)
        )
        .overlay(RoundedRectangle(cornerRadius: 19).stroke(item.isRare ? gold.opacity(0.8) : palette.line.opacity(0.7), lineWidth: item.isRare ? 2 : 1))
        .shadow(color: item.isRare ? gold.opacity(0.16) : palette.purple.opacity(0.035), radius: item.isRare ? 10 : 8, y: 3)
    }
    private func unlockEligibleAchievements() -> [Achievement] {
        let already = unlockedAchievementIDs
        let diamonds = store.stats.diamonds
        let newly = AchievementCatalog.all.enumerated().compactMap { index, item -> Achievement? in
            guard !already.contains(item.id) else { return nil }
            let requiredDiamonds = 50 + index * 20
            return diamonds >= requiredDiamonds ? item : nil
        }
        if !newly.isEmpty {
            unlockedAchievementStorage = already.union(newly.map(\.id)).sorted().joined(separator: ",")
        }
        return newly
    }
    private func isExtraAchievementUnlocked(_ id: String) -> Bool {
        func number(after prefix: String) -> Int? { Int(id.dropFirst(prefix.count)) }
        if id.hasPrefix("extra-total-") { return ((number(after: "extra-total-") ?? Int.max) <= store.stats.total / 2) }
        if id.hasPrefix("extra-correct-") { return ((number(after: "extra-correct-") ?? Int.max) <= store.stats.correct / 2) }
        if id.hasPrefix("extra-streak-") { return ((number(after: "extra-streak-") ?? Int.max) <= store.stats.bestStreak / 2) }
        if id.hasPrefix("extra-active-minutes-") { return (number(after: "extra-active-minutes-") ?? Int.max) * 60 <= lifetimeActiveSeconds }
        if id.hasPrefix("extra-olympiad-wins-") { return (number(after: "extra-olympiad-wins-") ?? Int.max) <= olympiadWins }
        if id.hasPrefix("extra-accuracy-") {
            let parts = id.split(separator: "-")
            if parts.count == 4, let goal = Int(parts[2]), let minimum = Int(parts[3]) { return store.stats.total >= minimum && store.stats.accuracy >= goal }
        }
        if id.hasPrefix("extra-subject-") {
            let parts = id.split(separator: "-")
            if parts.count == 4, let index = Int(parts[2]), let goal = Int(parts[3]), StudySubject.allCases.indices.contains(index) {
                return (decodedSubjectPerformance[StudySubject.allCases[index].rawValue]?.total ?? 0) >= goal
            }
        }
        return false
    }

    private func topicName(for subject: StudySubject, question: String) -> String {
        let text = question.lowercased()
        func has(_ terms: [String]) -> Bool { terms.contains { text.contains($0) } }
        switch subject {
        case .math:
            if has(["таблица умножения", "×", "умнож"]) { return "Умножение" }
            if has(["делен", "÷", "остаток от деления"]) { return "Деление" }
            if has(["по частям", "десятки", "единицы"]) { return "Вычитание по частям" }
            if has(["вычитан", "−", "минус", "убрали", "осталось"]) { return "Вычитание" }
            if has(["сравни", "больше", "меньше", ">, <", "на сколько больше", "на сколько меньше"]) { return "Сравнение чисел" }
            if has(["часов", "часа", " час ", "час:", "минут", "время", "который час", "длится"]) { return "Время и часы" }
            if has(["рубл", "копе", "скидк", "покуп", "стоим", "цен", "деньг", "сдач"]) { return "Деньги и покупки" }
            if has(["км", "метр", "сантиметр", "килограмм", "грамм", "литр", "сантиметр", "длина", "масса", "объём"]) { return "Величины и измерения" }
            if has(["задач", "всего", "вместе", "кажд", "поезд", "пицц", "путь", "расстояни"]) { return "Текстовые задачи" }
            if has([" + ", "прибав", "сложен", "плюс"]) { return "Сложение" }
            if has(["по частям", "десятки", "единицы"]) { return "Вычитание по частям" }
            return "Другие задания"
        case .russian, .orthography:
            if has(["глагол", "что делать", "что сделать"]) { return "Глаголы" }
            if has(["существительн", "кто? что?", "род", "падеж", "склонен"]) { return "Имя существительное и падежи" }
            if has(["прилагательн", "какой?", "какая?", "какое?", "какие?"]) { return "Имена прилагательные" }
            if has(["ударен", "безударн", "проверочн", "орфограмм", "правописан", "букв"]) { return "Правописание" }
            if has(["слог", "перенос", "звук", "гласн", "согласн"]) { return "Звуки и слоги" }
            if has(["предложен", "подлежа", "сказуем", "текст"]) { return "Предложения и текст" }
            return "Другие задания"
        case .english:
            if has(["to be", "am ", " is ", " are ", "was ", "were "]) { return "Глагол to be" }
            if has(["переведи", "как переводится", "значит", "слово", "перевод"]) { return "Слова и перевод" }
            if has(["букв", "гласн", "согласн", "звук"]) { return "Буквы и звуки" }
            if has(["множествен", "предложен", "местоимен", "вопрос"]) { return "Грамматика" }
            return "Другие задания"
        case .tatar:
            if has(["әни", "әти", "апа", "абый", "эне", "сеңел", "гаилә"]) { return "Семья и близкие" }
            if has(["исәнме", "рәхмәт", "зинһар", "сау бул"]) { return "Приветствия и вежливость" }
            if has(["ничек", "нәрсә", "кем", "кайда", "күпме"]) { return "Вопросительные слова" }
            if has(["перев", "как читается", "значит"]) { return "Перевод слов" }
            return "Другие задания"
        case .geometry:
            if has(["треуголь", "квадрат", "прямоуголь", "круг", "трапец", "фигур"]) { return "Плоские фигуры" }
            if has(["куб", "шар", "цилиндр", "конус", "гран", "ребр", "вершин"]) { return "Объёмные фигуры" }
            if has(["отрез", "луч", "прям", "угол", "параллел", "перпендикуляр"]) { return "Линии и углы" }
            if has(["длин", "линейк", "сантиметр", "периметр"]) { return "Измерение длины" }
            return "Другие задания"
        case .chemistry:
            if has(["fe", "au", "na", "o₂", "h₂", "символ", "обозначается", "элемент"]) { return "Химические элементы и символы" }
            if has(["колб", "мензур", "пипет", "чашк петри", "сосуд", "лаборатор"]) { return "Лабораторная посуда" }
            if has(["формул", "атом", "молекул"]) { return "Формулы и вещества" }
            return "Другие задания"
        case .pdd:
            if has(["светофор", "сигнал", "регулировщик"]) { return "Светофор и сигналы" }
            if has(["знак", "переход", "пешеход", "тротуар"]) { return "Дорожные знаки и пешеходы" }
            if has(["велосипед", "автобус", "машин", "дорог"]) { return "Безопасность на дороге" }
            return "Другие задания"
        case .informatics:
            if has(["клавиатур", "мыш", "монитор", "принтер", "устройств"]) { return "Устройства компьютера" }
            if has(["парол", "личн", "интернет", "безопас"]) { return "Безопасность в интернете" }
            if has(["алгоритм", "команд", "последователь"]) { return "Алгоритмы" }
            return "Другие задания"
        case .world, .biology:
            if has(["растен", "лист", "корен", "цвет", "фотосинтез"]) { return "Растения" }
            if has(["животн", "птиц", "рыб", "насеком", "звер"]) { return "Животные" }
            if has(["человек", "орган", "здоров", "питан"]) { return "Человек и здоровье" }
            if has(["вода", "воздух", "почв", "природ", "планет"]) { return "Природа вокруг нас" }
            return "Другие задания"
        case .geography:
            if has(["материк", "океан", "море", "река", "озер"]) { return "Воды и материки" }
            if has(["столиц", "стран", "город", "росси", "татарстан"]) { return "Страны и города" }
            if has(["карт", "компас", "сторон света", "север", "юг", "восток", "запад"]) { return "Карта и стороны света" }
            return "Другие задания"
        case .logic:
            if has(["последователь", "продолжи ряд", "закономер", "числовой ряд"]) { return "Закономерности" }
            if has(["лишн", "не подходит", "найди пару"]) { return "Поиск закономерностей" }
            if has(["если", "услови", "логическ"]) { return "Логические задачи" }
            return "Другие задания"
        case .art:
            if has(["цвет", "основн", "тёпл", "холодн", "палитр"]) { return "Цвета и палитра" }
            if has(["композиц", "рисунк", "материал", "карандаш", "краск"]) { return "Техники рисования" }
            return "Другие задания"
        }
    }

    private func recordSubjectAnswer(subject: StudySubject, correct: Bool, question: String? = nil) {
        var all = decodedSubjectPerformance
        var item = all[subject.rawValue] ?? SubjectPerformance()
        if correct { item.correct += 1 } else { item.incorrect += 1 }
        all[subject.rawValue] = item
        if let data = try? JSONEncoder().encode(all) { subjectPerformanceStorage = String(decoding: data, as: UTF8.self) }
        if let question {
            let topic = topicName(for: subject, question: question)
            let key = subject.rawValue + "::" + topic
            var topics = decodedTopicPerformance
            var topicItem = topics[key] ?? TopicPerformance()
            if correct { topicItem.correct += 1 } else { topicItem.incorrect += 1 }
            topics[key] = topicItem
            if let data = try? JSONEncoder().encode(topics) { topicPerformanceStorage = String(decoding: data, as: UTF8.self) }
        }
        guard selected == .task && subject == selectedSubject else { return }
        var history = (try? JSONDecoder().decode([String: [Bool]].self, from: Data(adaptiveDifficultyHistoryStorage.utf8))) ?? [:]
        var outcomes = history[subject.rawValue] ?? []
        outcomes.append(correct)
        if outcomes.count > 10 { outcomes = Array(outcomes.suffix(10)) }
        history[subject.rawValue] = outcomes
        if let data = try? JSONEncoder().encode(history) { adaptiveDifficultyHistoryStorage = String(decoding: data, as: UTF8.self) }
        if outcomes.count >= 5 && item.total.isMultiple(of: 5) {
            let recentFiveCorrect = outcomes.suffix(5).filter { $0 }.count
            if recentFiveCorrect >= 4 && difficultyLevel < 5 {
                difficultyLevel += 1
                currentTip = "Ты уверенно справляешься — сложность постепенно повышена до уровня \(difficultyLevel)."
            } else if recentFiveCorrect <= 2 && difficultyLevel > 1 {
                difficultyLevel -= 1
                currentTip = "Давай закрепим основу: сложность снижена до уровня \(difficultyLevel), чтобы идти спокойнее."
            }
        }
    }

    private func countCorrectTowardMilestone() -> Bool {
        lifetimeCorrectAnswers += 1
        return lifetimeCorrectAnswers.isMultiple(of: 50)
    }

    private func mistakeChoices(for item: Problem, selectedAnswer: String) -> [String] {
        if item.isComparison { return ["<", "=", ">"] }
        if item.isTatarChoice, item.tatarChoices.count >= 2 { return item.tatarChoices }
        if let correctNumber = Int(item.answer) {
            var values = [correctNumber, correctNumber + 1, max(0, correctNumber - 1), correctNumber + 2, correctNumber + 3]
            values = Array(Set(values)).shuffled()
            var result = [String(correctNumber)]
            result += values.map(String.init).filter { !result.contains($0) }.prefix(3)
            return result.shuffled()
        }
        var result: [String] = []
        for value in [item.answer, selectedAnswer, "Не знаю", "Попробуй ещё раз", "Вспомни правило"] where !value.isEmpty && !result.contains(value) {
            result.append(value)
        }
        return Array(result.prefix(4)).shuffled()
    }

    private func mistakeExplanation(for subject: StudySubject, question: String) -> String {
        let lower = question.lowercased()
        switch subject {
        case .world:
            if lower.contains("растен") { return "Растениям нужны свет, вода, воздух и подходящая температура. Вспомни, какая часть растения выполняет нужную функцию." }
            if lower.contains("живот") || lower.contains("птиц") { return "Сопоставь признаки животного с группой: где живёт, чем покрыто тело и чем питается." }
            return "Прочитай вопрос и найди основной природный объект. Вспомни его признак, назначение или связь с окружающим миром."
        case .math:
            if question.contains("×") { return "Умножение означает взять число несколько раз. Сначала вычисли произведение, затем выполни оставшиеся действия по порядку." }
            if question.contains(":") || question.contains("÷") { return "Деление помогает узнать, на сколько равных частей разделили число. Проверь ответ умножением: частное × делитель = делимое." }
            if question.contains("?") && (question.contains(">") || question.contains("<") || question.contains("Сравни")) { return "Сравни числа слева направо: сначала сотни, затем десятки и единицы. Знак раскрывается в сторону большего числа." }
            return "Прочитай знаки действий ещё раз, выполни вычисления по порядку и проверь ответ обратным действием."
        case .pdd:
            if lower.contains("светофор") || lower.contains("сигнал") { return "Вспомни сигнал светофора: красный — стой, жёлтый — приготовься остановиться, зелёный для пешехода разрешает переход только если это безопасно." }
            if lower.contains("зебр") || lower.contains("переход") { return "Переходи дорогу в установленном месте, остановись у края, посмотри по сторонам и убедись, что транспорт остановился." }
            if lower.contains("лини") || lower.contains("размет") { return "Дорожная разметка помогает разделять потоки и показывать места остановки или перехода. Не играй на проезжей части и не пересекай запрещающие линии." }
            return "Посмотри на форму, цвет и символ знака. Предупреждающие знаки часто имеют треугольную форму с красной каймой; круглые знаки могут запрещать или предписывать действие."
        case .orthography:
            if lower.contains("жи") || lower.contains("ши") { return "После Ж и Ш в обычных словах пишется И: например, «жираф», «машина», «шишка»." }
            if lower.contains("ча") || lower.contains("ща") { return "В сочетаниях ЧА–ЩА пиши А, а в ЧУ–ЩУ пиши У. Прочитай слово по слогам и проверь сомнительную букву." }
            if lower.contains("предлож") || lower.contains("запят") { return "Прочитай предложение вслух. Проверь границы частей предложения и поставь запятые между однородными членами или перед подходящим союзом по правилу." }
            return "Найди место, где сомневаешься. Для безударной гласной подбери проверочное слово, для парной согласной измени слово так, чтобы после неё стояла гласная."
        case .geography:
            if lower.contains("флаг") { return "У флага важны цвета и порядок полос. Сравни все полосы сверху вниз и не путай флаги похожих стран." }
            if lower.contains("столиц") || lower.contains("город") { return "Столица — главный город страны, но не обязательно самый большой. Вспомни пару «страна — столица» и повтори её на карте." }
            if lower.contains("океан") || lower.contains("море") { return "Океаны — самые большие водные пространства. Море меньше океана и часто частично окружено сушей." }
            if lower.contains("остров") || lower.contains("материк") { return "Остров со всех сторон окружён водой. Материк — огромный участок суши, например Евразия, Африка или Австралия." }
            if lower.contains("рек") { return "Река — поток воды, который течёт по руслу. Запомни название реки вместе с местом, где она протекает." }
            return "Сначала определи, о чём вопрос: стране, городе, флаге, материке, острове, море, океане или реке. Затем вспомни название и его расположение."
        case .english:
            return "Прочитай слово или предложение целиком. Вспомни перевод и правило, затем сравни грамматическую форму во всех четырёх вариантах."
        case .russian:
            return "Определи, что спрашивают: значение слова, часть речи или правило. Прочитай варианты и исключи те, которые не подходят по смыслу или грамматике."
        case .tatar:
            return "Повтори перевод татарского слова вслух и сопоставь его с русским значением. Полезно выучить слово вместе с коротким примером."
        case .art:
            return "Вспомни основное правило цвета, композиции или материала. Обрати внимание на ключевые слова вопроса и выбери определение, которое точно им соответствует."
        case .chemistry:
            if lower.contains("колб") { return "Колба нужна для смешивания, хранения или проведения реакций. Обрати внимание на форму горлышка и корпуса." }
            if lower.contains("мензур") { return "Мензурка — цилиндрический сосуд с делениями для измерения объёма жидкости." }
            if lower.contains("петри") { return "Чашка Петри — неглубокая круглая ёмкость для наблюдений и выращивания культур." }
            if lower.contains("пипет") { return "Пипетка помогает переносить небольшие объёмы жидкости, часто по каплям." }
            return "Проверь символ элемента: первая буква заглавная, вторая, если есть, строчная. Для формулы запомни, что нижний индекс показывает число атомов."
        case .informatics:
            return "Прочитай все варианты, подумай о назначении устройства или команды и исключи небезопасные действия. Пароли и личные данные никому не сообщают."
        case .logic:
            return "Ищи закономерность, внимательно проверь каждое условие и исключи варианты, которые противоречат последовательности."
        case .biology:
            return "Вспомни основные признаки живых организмов, функции органов и потребности растений и животных."
        case .geometry:
            if lower.contains("луч") { return "Луч начинается в одной точке и продолжается в одном направлении." }
            if lower.contains("отрез") { return "У отрезка есть два конца; длину можно измерить линейкой." }
            return "Определи форму тела и посчитай грани, рёбра или вершины."
        }
    }

    private func shouldShowStudyIllustration(for problem: Problem, subject: StudySubject) -> Bool {
        let text = problem.text.lowercased()
        switch subject {
        case .logic:
            // Только задания, в которых условие действительно связано с фигурами.
            return text.contains("фигур") || text.contains("угл") || text.contains("круг") || text.contains("квадрат") || text.contains("кубик") || text.contains("куб")
        case .biology:
            return false
        case .geometry:
            return problem.showIllustration
        case .chemistry:
            // Символы элементов и формулы остаются текстовыми заданиями.
            // Иллюстрации появляются только в отдельной группе вопросов о лабораторной посуде.
            return text.contains("колб") || text.contains("мензур") || text.contains("чашк") || text.contains("петри") || text.contains("пипет") || text.contains("сосуд") || text.contains("объём жидкости") || text.contains("по каплям") || text.contains("измельчения твёрдых")
        default:
            return false
        }
    }

    private func recordMistake(subject: StudySubject, item: Problem, selectedAnswer: String) {
        let questionText = item.text.isEmpty ? "Определи фигуру на рисунке: \(item.answer)" : item.text
        if let reviewID = reviewingMistakeID {
            let reviewed = decodedMistakes.first(where: { $0.id == reviewID })
            if reviewed?.subject != subject.rawValue || reviewed?.question != questionText {
                reviewingMistakeID = nil
            }
        }
        guard reviewingMistakeID == nil else { return }
        var items = decodedMistakes
        guard !items.contains(where: { $0.subject == subject.rawValue && $0.question == questionText }) else { return }
        let record = MistakeRecord(
            id: UUID().uuidString,
            subject: subject.rawValue,
            question: questionText,
            selectedAnswer: selectedAnswer,
            correctAnswer: item.answer,
            choices: mistakeChoices(for: item, selectedAnswer: selectedAnswer),
            explanation: mistakeExplanation(for: subject, question: item.text),
            date: StatsStore.dateKey(Date())
        )
        items.append(record)
        if let data = try? JSONEncoder().encode(items) { mistakesStorage = String(decoding: data, as: UTF8.self) }
    }

    private func removeMistake(id: String) {
        let remaining = decodedMistakes.filter { $0.id != id }
        if let data = try? JSONEncoder().encode(remaining) { mistakesStorage = String(decoding: data, as: UTF8.self) }
    }

    private func removeMistakes(subject: StudySubject, question: String) {
        let remaining = decodedMistakes.filter { !($0.subject == subject.rawValue && $0.question == question) }
        if let data = try? JSONEncoder().encode(remaining) { mistakesStorage = String(decoding: data, as: UTF8.self) }
    }

    private func startMistakeReview(_ item: MistakeRecord) {
        guard let subject = StudySubject(rawValue: item.subject) else { return }
        selectedSubjectName = subject.rawValue
        selected = .task
        problem = Problem(text: item.question, answer: item.correctAnswer, isTatarChoice: true, tatarChoices: item.choices)
        currentTip = item.explanation
        answer = ""
        answerState = .neutral
        reviewingMistakeID = item.id
        showSubjectPicker = false
        answerFocused = false
    }

    private func tickTimers() {
        let location = NSEvent.mouseLocation
        if abs(location.x - lastMouseLocation.x) > 0.5 || abs(location.y - lastMouseLocation.y) > 0.5 {
            lastMouseLocation = location
            lastMouseMovementAt = Date()
        }
        if Date().timeIntervalSince(lastMouseMovementAt) <= 300 {
            sessionSeconds += 1
            var daySeconds = decodedActiveSeconds
            let key = StatsStore.dateKey(Date())
            daySeconds[key, default: 0] += 1
            if let data = try? JSONEncoder().encode(daySeconds) { activeSecondsStorage = String(decoding: data, as: UTF8.self) }
            if selected == .task {
                var subjectSeconds = decodedActiveSecondsBySubject
                subjectSeconds[selectedSubjectName, default: 0] += 1
                if let data = try? JSONEncoder().encode(subjectSeconds) {
                    activeSecondsBySubjectStorage = String(decoding: data, as: UTF8.self)
                }
            }
        }
        if olympiadStarted && !olympiadPaused && !olympiadFinished {
            if olympiadSecondsRemaining <= 1 { finishOlympiad(won: false) }
            else { olympiadSecondsRemaining -= 1 }
        }
    }

    private func formattedTime(_ seconds: Int) -> String {
        let safe = max(0, seconds)
        let hours = safe / 3600
        let minutes = (safe % 3600) / 60
        let secs = safe % 60
        if hours > 0 { return String(format: "%d ч %02d мин", hours, minutes) }
        if minutes > 0 { return String(format: "%d мин %02d сек", minutes, secs) }
        return "\(secs) сек"
    }

    private func maybeUnlockRandomCollectible() -> Collectible? {
        guard Double.random(in: 0..<1) < 0.04 else { return nil }
        let owned = allOwnedCollectibleIDs
        guard let item = Collectible.all.filter({ !$0.isRare && !owned.contains($0.id) }).randomElement() else { return nil }
        randomCollectiblesStorage = unlockedCollectibleIDs.union([item.id]).sorted().joined(separator: ",")
        return item
    }
    private func rewardLarge(_ emoji: String, title: String, detail: String, progress: Int, goal: Int, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 20).fill(color.opacity(0.14))
                RoundedRectangle(cornerRadius: 20).stroke(color.opacity(0.58), lineWidth: 1.5)
                Text(emoji).font(.system(size: 63 * AppFontScale.factor)).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .frame(width: 102, height: 102, alignment: .center)
            Text(title).font(.system(size: 20 * AppFontScale.factor * fontScaleH3, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
            Text(detail).font(.system(size: 13 * AppFontScale.factor * fontScaleBody, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
                .fixedSize(horizontal: false, vertical: true)
            ProgressView(value: Double(progress), total: Double(goal)).tint(palette.purple)
            Text("\(progress) из \(goal)")
                .font(.system(size: 12 * AppFontScale.factor, weight: .bold, design: .rounded)).foregroundStyle(palette.purple)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .cardStyle(palette)
    }

    private func interactiveSlider(value: Binding<Double>, range: ClosedRange<Double>, step: Double, knobSize: CGFloat = 16) -> some View {
        GeometryReader { proxy in
            let usableWidth = max(1, proxy.size.width - knobSize)
            let fraction = CGFloat(max(0, min(1, (value.wrappedValue - range.lowerBound) / (range.upperBound - range.lowerBound))))
            ZStack {
                Capsule()
                    .fill(Color.black.opacity(0.9))
                    .frame(height: 3)
                Circle()
                    .fill(Color.black)
                    .frame(width: knobSize, height: knobSize)
                    .overlay(Circle().stroke(Color.white.opacity(0.95), lineWidth: 1))
                    .position(x: knobSize / 2 + fraction * usableWidth, y: proxy.size.height / 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        let position = max(0, min(usableWidth, drag.location.x - knobSize / 2))
                        let dragFraction = Double(position / usableWidth)
                        let rawValue = range.lowerBound + dragFraction * (range.upperBound - range.lowerBound)
                        let steppedValue = (rawValue / step).rounded() * step
                        value.wrappedValue = max(range.lowerBound, min(range.upperBound, steppedValue))
                    }
            )
        }
        .frame(height: knobSize + 8)
        .accessibilityElement()
        .accessibilityLabel("Регулятор")
        .accessibilityValue("\(Int((value.wrappedValue * 100).rounded())) процентов")
    }

    private func fontScaleControl(_ title: String, scale: Binding<Double>, example: String, baseSize: CGFloat) -> some View {
        // The global scale is already represented by AppFontScale.factor. Avoid
        // multiplying every preview by the body-text setting: each preview follows
        // its own slider, and the global preview applies the global value only once.
        let previewScale = title == "Все страницы приложения"
            ? CGFloat(scale.wrappedValue)
            : CGFloat(scale.wrappedValue) * AppFontScale.factor
        return VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(title).font(.system(size: 10 * AppFontScale.factor * fontScaleBody, weight: .bold, design: .rounded)).foregroundStyle(palette.ink)
                Spacer(minLength: 4)
                Text("\(Int((scale.wrappedValue * 100).rounded()))%").font(.system(size: 11 * AppFontScale.factor, weight: .black, design: .rounded)).foregroundStyle(palette.purple).monospacedDigit()
            }
            HStack(spacing: 10) {
                interactiveSlider(value: scale, range: 0.8...2.0, step: 0.1, knobSize: 14)
                    .frame(width: 220, height: 22)
                Text(example).font(.system(size: baseSize * previewScale, weight: .semibold, design: .rounded))
                    .foregroundStyle(palette.ink).lineLimit(1).minimumScaleFactor(0.7).frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(5)
        .background(LinearGradient(colors: [palette.purple.opacity(0.22), palette.pink.opacity(0.18)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(palette.purple, lineWidth: 1))
    }

    private func pageHeading(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.system(size: 29 * AppFontScale.factor * fontScaleH1, weight: .heavy, design: .rounded)).foregroundStyle(palette.ink)
            Text(subtitle).font(.system(size: 14 * AppFontScale.factor * fontScaleBody, weight: .medium, design: .rounded)).foregroundStyle(palette.muted)
        }
    }

    private func checkAnswer() {
        guard !answer.isEmpty, answerState != .correct else { return }
        let normalizedAnswer = answer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let isCorrect = normalizedAnswer == problem.answer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let rewards = store.record(correct: isCorrect)
        recordSubjectAnswer(subject: selectedSubject, correct: isCorrect, question: problem.text)
        let newAchievements = unlockEligibleAchievements()
        let salute = isCorrect ? countCorrectTowardMilestone() : false

        if isCorrect {
            var mastered = decodedCorrectQuestions.mapValues { Array($0) }
            var subjectMastered = Set(mastered[selectedSubject.rawValue, default: []])
            subjectMastered.insert(problem.text)
            mastered[selectedSubject.rawValue] = Array(subjectMastered)
            if let data = try? JSONEncoder().encode(mastered) {
                correctQuestionStorage = String(decoding: data, as: UTF8.self)
            }
            answerState = .correct
            if let reviewID = reviewingMistakeID,
               let reviewed = decodedMistakes.first(where: { $0.id == reviewID }),
               reviewed.subject == selectedSubject.rawValue,
               reviewed.question == problem.text {
                removeMistake(id: reviewID)
                reviewingMistakeID = nil
            } else {
                reviewingMistakeID = nil
                removeMistakes(subject: selectedSubject, question: problem.text)
            }
            if salute {
                triggerCelebration("milestone:50")
            } else if let reward = rewards.last {
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
            if reviewingMistakeID == nil {
                recordMistake(subject: selectedSubject, item: problem, selectedAnswer: answer)
            }
            currentTip = mistakeExplanation(for: selectedSubject, question: problem.text)
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

    private func ensureFourChoices(for item: Problem, subject: StudySubject) -> Problem {
        guard (subject == .math || subject == .russian), !item.isTatarChoice else { return item }
        let correct = item.answer.trimmingCharacters(in: .whitespacesAndNewlines)
        var choices: [String] = [correct]
        if item.isComparison {
            choices = ["<", ">", "=", "≠"]
        } else {
            let numericPrefix = String(correct.prefix { $0.isNumber || $0 == "-" })
            if let value = Int(numericPrefix), !numericPrefix.isEmpty {
                let suffix = String(correct.dropFirst(numericPrefix.count))
                let candidates = [value + 1, value - 1, value + 2, value - 2, value * 2, max(0, value / 2), value + 10, max(0, value - 10)]
                for candidate in candidates where choices.count < 4 {
                    let option = "\(candidate)\(suffix)"
                    if !choices.contains(option) { choices.append(option) }
                }
            } else if subject == .russian {
                let distractors = ["дом", "лес", "ночь", "друг", "книга", "быстрый", "солнце", "школа", "мама", "собака", "радость", "весёлый", "читать", "молоко", "река", "цветок", "трусливый", "широкий", "птица", "машина"].filter { $0.lowercased() != correct.lowercased() }.shuffled()
                choices.append(contentsOf: distractors.prefix(3))
            }
        }
        if choices.count < 4 {
            for fallback in ["0", "1", "2", "3", "4", "5", "10"] where choices.count < 4 && !choices.contains(fallback) {
                choices.append(fallback)
            }
        }
        return Problem(text: item.text, answer: item.answer, isComparison: item.isComparison, isTatarChoice: true, tatarChoices: Array(choices.prefix(4)).shuffled(), showIllustration: item.showIllustration)
    }

    private func makeUniqueProblem(for subject: StudySubject) -> Problem {
        let key = subject.rawValue
        var seen = seenQuestionTexts[key, default: []]
        let mastered = decodedCorrectQuestions[key, default: []]
        var candidate: Problem
        if subject == .informatics && difficultyLevel == 1 {
            candidate = ProblemGenerator.nextInformatics(excluding: seen.union(mastered))
            if seen.contains(candidate.text) { seen.removeAll() }
        } else {
            candidate = ProblemGenerator.next(for: subject, difficulty: difficultyLevel)
            for _ in 0..<300 {
                if !seen.contains(candidate.text) && !mastered.contains(candidate.text) { break }
                candidate = ProblemGenerator.next(for: subject, difficulty: difficultyLevel)
            }
            if seen.contains(candidate.text) { seen.removeAll() }
        }
        candidate = ensureFourChoices(for: candidate, subject: subject)
        seen.insert(candidate.text)
        seenQuestionTexts[key] = seen
        return candidate
    }

    private func nextProblem() {
        problem = makeUniqueProblem(for: selectedSubject)
        currentTip = ProblemGenerator.tip(for: selectedSubject, problem: problem)
        answer = ""
        answerState = .neutral
        answerFocused = true
        persistCurrentProblem()
    }

    private func persistCurrentProblem() {
        guard let data = try? JSONEncoder().encode(problem),
              let json = String(data: data, encoding: .utf8) else { return }
        savedProblemJSON = json
        savedProblemSubject = selectedSubjectName
    }

    private func restoreCurrentProblem() {
        if savedProblemSubject == selectedSubjectName,
           let data = savedProblemJSON.data(using: .utf8),
           let saved = try? JSONDecoder().decode(Problem.self, from: data) {
            problem = saved
            currentTip = ProblemGenerator.tip(for: selectedSubject, problem: saved)
        } else {
            problem = makeUniqueProblem(for: selectedSubject)
            currentTip = ProblemGenerator.tip(for: selectedSubject, problem: problem)
            persistCurrentProblem()
        }
        answer = ""
        answerState = .neutral
    }

    private func triggerCelebration(_ reward: String) {
        celebration = reward
        let emojis: [String]
        if reward == "milestone:50" {
            emojis = ["🎆", "🎇", "🌈", "⭐️", "🌟", "💫", "🎉", "🎊", "🪅", "💎", "🎈", "✨", "🚀", "🦄", "🪄", "🌸"]
        } else if reward == "diamonds:20" {
            emojis = ["🧸", "🎈", "🎉", "🪅", "🪁", "🧸", "🎊", "🧸", "🎈"]
        } else if reward == "diamonds:50" {
            emojis = ["🐦", "🦋", "🐤", "🦋", "🐦", "🦋", "🐦", "🦋", "🐤"]
        } else if reward.hasPrefix("achievement:") {
            let id = String(reward.dropFirst("achievement:".count))
            let emoji = AchievementCatalog.all.first(where: { $0.id == id })?.emoji ?? "🏆"
            emojis = [emoji, "✨", "🌟", emoji, "💜"]
        } else if reward.hasPrefix("rare:") {
            let id = String(reward.dropFirst("rare:".count))
            let emoji = Collectible.all.first(where: { $0.id == id })?.emoji ?? "🌠"
            emojis = ["🌠", "💎", "👑", "✨", emoji, "🎁", "🌈", "🪄", "💫", "🌟", emoji, "🏆"]
        } else if reward.hasPrefix("bonus:") {
            let id = String(reward.dropFirst("bonus:".count))
            let emoji = Collectible.all.first(where: { $0.id == id })?.emoji ?? "🎁"
            emojis = [emoji, "✨", emoji, "🌟", "🎉"]
        } else {
            emojis = ["⭐️", "✨", "💜", "🌸", "⭐️"]
        }

        let tokenCount = reward == "milestone:50" ? 96 : 42
        celebrationTokens = (0..<tokenCount).map { index in
            CelebrationToken(
                emoji: emojis[index % emojis.count],
                x: Double.random(in: 0.03...0.97),
                y: Double.random(in: 0.07...0.93),
                delay: Double.random(in: reward == "milestone:50" ? 0...1.7 : 0...1.1),
                drift: Double.random(in: reward == "milestone:50" ? -240...240 : -140...140)
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
                    let isBigMilestone = celebration == "milestone:50"
                    let baseSize: Double = isBigMilestone ? 27 : 24
                    let sizeMultiplier: Double = isBigMilestone ? 13 : 12
                    let tokenFontSize = CGFloat(baseSize + token.delay * sizeMultiplier)
                    let tokenX = CGFloat(token.x) * geo.size.width
                    let tokenY = CGFloat(token.y) * geo.size.height
                    Text(token.emoji)
                        .font(.system(size: tokenFontSize * AppFontScale.factor))
                        .position(x: tokenX, y: tokenY)
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
                    if let giftItem = celebrationGiftItem {
                        Collectible3DView(id: giftItem.id, title: giftItem.title, size: 140, animated: true)
                            .frame(height: 152)
                            .shadow(color: palette.purple.opacity(0.3), radius: 12, y: 5)
                    } else {
                        Reward3DBadge(symbol: "sparkles", tint: palette.purple, size: 104).frame(height: 112)
                    }
                    Text(celebrationTitle)
                        .font(.system(size: 34 * AppFontScale.factor, weight: .heavy, design: .rounded))
                        .multilineTextAlignment(.center)
                    Text(celebrationSubtitle)
                        .font(.system(size: 18 * AppFontScale.factor, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)
                    Button("Ура!") { withAnimation { showCelebration = false } }
                        .font(.system(size: 14 * AppFontScale.factor, weight: .heavy, design: .rounded))
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

    private var celebrationGiftItem: Collectible? {
        guard let reward = celebration else { return nil }
        let prefix = reward.hasPrefix("rare:") ? "rare:" : (reward.hasPrefix("bonus:") ? "bonus:" : "")
        guard !prefix.isEmpty else { return nil }
        let id = String(reward.dropFirst(prefix.count))
        return Collectible.all.first(where: { $0.id == id })
    }

    private var celebrationTitle: String {
        switch celebration {
        case "milestone:50": return "🎆 50 правильных ответов!"
        case "diamonds:20": return "🎉 20 алмазов!"
        case "diamonds:50": return "🦋 50 алмазов!"
        case "olympiad:win": return "🏆 Олимпийская победа!"
        default:
            if let reward = celebration, reward.hasPrefix("achievement:") {
                let id = String(reward.dropFirst("achievement:".count))
                return AchievementCatalog.all.first(where: { $0.id == id }).map { "\($0.emoji) Достижение!" } ?? "🏆 Новая награда!"
            }
            if let reward = celebration, reward.hasPrefix("rare:") {
                let id = String(reward.dropFirst("rare:".count))
                return Collectible.all.first(where: { $0.id == id }).map { "🌠 Редкий приз! \($0.title)" } ?? "🌠 Редкий коллекционный приз!"
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
        case "milestone:50": return "🎉 Вот это серия! Цветной салют за 50 правильных ответов."
        case "diamonds:20": return "Салют из разноцветных мягких игрушек!"
        case "diamonds:50": return "Птички и бабочки летают вокруг!"
        case "olympiad:win": return "Все \(olympiadTargetCount) заданий пройдены. Начислено 100 алмазов!"
        default:
            if let reward = celebration, reward.hasPrefix("achievement:") {
                let id = String(reward.dropFirst("achievement:".count))
                return AchievementCatalog.all.first(where: { $0.id == id })?.detail ?? "Новое достижение сохранено в коллекции."
            }
            if let reward = celebration, reward.hasPrefix("rare:") {
                let id = String(reward.dropFirst("rare:".count))
                let title = Collectible.all.first(where: { $0.id == id })?.title ?? "Особая игрушка"
                return "\(title) добавлена в коллекцию! Это редкий подарок за 100 алмазов."
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
            .background(palette.cardSurface.opacity(palette.isDark ? 0.97 : 0.82), in: RoundedRectangle(cornerRadius: 19))
            .overlay(RoundedRectangle(cornerRadius: 19).stroke(palette.line.opacity(0.7), lineWidth: 1))
            .shadow(color: palette.purple.opacity(0.035), radius: 8, y: 3)
    }
}