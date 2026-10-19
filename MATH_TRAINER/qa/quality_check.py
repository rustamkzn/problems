#!/usr/bin/env python3
"""Static quality gate for the question banks in MathTrainer.

Checks literal question records and verifies that every question-producing area is
wired into the source. Dynamic generators are reviewed structurally; this script
does not claim to prove natural-language correctness.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

SOURCE = Path("Sources/MathTrainer/MathTrainerApp.swift")
if not SOURCE.exists():
    print(f"ERROR: source file not found: {SOURCE}")
    sys.exit(2)

source = SOURCE.read_text(encoding="utf-8")
errors: list[str] = []
warnings: list[str] = []
checked = 0
literal_prompts: dict[str, int] = {}

def norm(value: str) -> str:
    return re.sub(r"\s+", " ", value.strip().casefold())

def swift_strings(text: str) -> list[str]:
    # Extract simple, non-interpolated Swift string literals from a choices array.
    return re.findall(r'"((?:\\.|[^"\\])*)"', text)

# Check static ActivityQuestion records where prompt, answer and options are literal.
activity_pattern = re.compile(
    r'ActivityQuestion\s*\(\s*prompt:\s*"((?:\\.|[^"\\])*)"\s*,\s*'
    r'answer:\s*"((?:\\.|[^"\\])*)"\s*,\s*choices:\s*\[([^\]]*)\]',
    re.DOTALL,
)
for match in activity_pattern.finditer(source):
    prompt, answer, raw_choices = match.groups()
    # Skip interpolated strings: their concrete values are checked by generator invariants.
    if "\\(" in prompt or "\\(" in answer or "\\(" in raw_choices:
        continue
    choices = swift_strings(raw_choices)
    checked += 1
    line = source.count("\n", 0, match.start()) + 1
    label = f"ActivityQuestion at line {line}: {prompt[:75]!r}"
    normalized_choices = [norm(choice) for choice in choices]
    if len(choices) != 4:
        errors.append(f"{label} — expected 4 literal choices, found {len(choices)}")
    if len(set(normalized_choices)) != len(normalized_choices):
        errors.append(f"{label} — duplicate answer options")
    if norm(answer) not in normalized_choices:
        errors.append(f"{label} — correct answer is absent from the choices")
    key = norm(prompt)
    if key:
        if key in literal_prompts:
            warnings.append(f"{label} — prompt duplicates a literal prompt at line {literal_prompts[key]}")
        else:
            literal_prompts[key] = line
    if prompt.rstrip().endswith("?."):
        warnings.append(f"{label} — suspicious punctuation '?.'")
    if prompt and prompt[0].islower() and not prompt.startswith(("«", "…")):
        warnings.append(f"{label} — prompt starts with a lowercase letter")

# Check literal multiple-choice Problem records. Geometry may intentionally use an
# empty prompt when an illustration itself is the question.
problem_pattern = re.compile(
    r'Problem\s*\(\s*text:\s*"((?:\\.|[^"\\])*)"\s*,\s*'
    r'answer:\s*"((?:\\.|[^"\\])*)".{0,500}?'
    r'tatarChoices:\s*\[([^\]]*)\]',
    re.DOTALL,
)
for match in problem_pattern.finditer(source):
    prompt, answer, raw_choices = match.groups()
    if "\\(" in prompt or "\\(" in answer or "\\(" in raw_choices:
        continue
    choices = swift_strings(raw_choices)
    if not choices:
        continue
    checked += 1
    line = source.count("\n", 0, match.start()) + 1
    label = f"Problem at line {line}: {prompt[:75]!r}"
    normalized_choices = [norm(choice) for choice in choices]
    if len(choices) != 4:
        errors.append(f"{label} — expected 4 literal choices, found {len(choices)}")
    if len(set(normalized_choices)) != len(normalized_choices):
        errors.append(f"{label} — duplicate answer options")
    if norm(answer) not in normalized_choices:
        errors.append(f"{label} — correct answer is absent from the choices")
    if prompt and prompt.rstrip().endswith("?."):
        warnings.append(f"{label} — suspicious punctuation '?.'")

# Coverage guard: fail if a question-producing area is accidentally removed or
# renamed without updating the audit. This includes subjects and mini-games.
coverage = {
    "math": "static func next(difficulty: Int = 1)",
    "real-life math": "private static func realLifeMathQuestion(level: Int)",
    "advanced math": "private static func advancedMathQuestion(level: Int)",
    "logic": "private static func logicQuestion(level: Int)",
    "biology": "private static func biologyQuestion(level: Int, illustrated: Bool)",
    "chemistry": "private static func chemistryQuestionBank()",
    "geography": "private static func geographyQuestion(level: Int)",
    "traffic rules": "private static func trafficQuestion(level: Int)",
    "spelling": "private static func orthographyQuestion(level: Int)",
    "geometry": "private static func geometryQuestion(level: Int)",
    "language and world subjects": "private static func languageOrWorldQuestion(for subject: StudySubject)",
    "advanced subject questions": "fileprivate static func nextAdvancedQuestion(for subject: StudySubject, level: Int)",
    "informatics bank": "private static let informaticsQuestionBank: [Problem] = makeInformaticsQuestionBank()",
    "daily detective": "static let detective: [ActivityQuestion]",
    "life skills": "static let lifeSkills: [ActivityQuestion]",
    "memory training": "private func makeMemoryChoices(for sequence: [String])",
    "memory round generation": "private func startMemoryRound()",
    "Olympiad flow": "private func nextOlympiadProblem()",
    "mistake review": "private func mistakeChoices(for item: Problem, selectedAnswer: String)",
    "unified review queue": "private var unifiedReviewItems: [UnifiedReviewItem]",
    "unified review page": "private var unifiedMistakeReviewPage: some View",
    "persistent review history": "private func recordUnifiedReviewAttempt(_ item: UnifiedReviewItem, selected: String)",
}
for area, token in coverage.items():
    if token not in source:
        errors.append(f"Coverage check failed: missing question source for {area} ({token})")

# Check that every displayed study subject has a generation route.
for token, area in [
    ("case .math", "math"),
    ("case .russian", "Russian"),
    ("case .english", "English"),
    ("case .tatar", "Tatar"),
    ("case .chemistry", "chemistry"),
    ("case .geometry", "geometry"),
    ("case .logic", "logic"),
    ("case .biology", "biology"),
    ("case .pdd", "traffic rules"),
    ("case .geography", "geography"),
    ("case .orthography", "spelling"),
    ("case .informatics", "informatics"),
]:
    if token not in source:
        errors.append(f"Coverage check failed: no explicit subject route for {area} ({token})")

# Guard against the Olympiad progress bar drifting from the configured target.
if "CGFloat(olympiadCompleted) / CGFloat(max(1, olympiadTargetCount))" not in source:
    errors.append("Olympiad progress bar must use olympiadTargetCount as its denominator.")
if "CGFloat(olympiadCompleted) / 50" in source:
    errors.append("Olympiad progress bar still uses the obsolete fixed target of 50.")
if "guard olympiadStarted, !olympiadPaused, !olympiadFinished" not in source:
    errors.append("Olympiad answer submission must be blocked while paused or finished.")
if ".disabled(olympiadPaused || olympiadFeedback.hasPrefix(\"Верно\"))" not in source:
    errors.append("Olympiad buttons must allow retry after a wrong answer and remain disabled during pause.")

# Detect known risky patterns without blocking a build for subjective language guesses.
if 'fallback = ["Другой вариант", "Нужно подумать ещё раз"' in source:
    warnings.append("ActivityQuestion initializer contains generic fallback answers; verify no malformed bank item relies on them.")
if 'let otherAnswers = Array(Set(pool.filter { $0 != answer })).shuffled().prefix(3)' in source:
    warnings.append("Informatics options are created from Set; automated checks should verify 3 distinct distractors remain for each prompt.")
if "private static let generatedLifeSkills" in source and "for i in 0..<5000" not in source:
    errors.append("Life Skills generator is expected to generate 5,000 records; loop signature is missing.")
if "private static let generatedDetective" in source and "for i in 0..<120" not in source:
    errors.append("Daily Detective generator loop signature changed; update its coverage assertion.")

print("=== MathTrainer question quality audit ===")

# Keep the detailed subject statistics understandable: explain topic badge colors
# and explicitly label accuracy and attempt counts in each topic row.
app_source = SOURCE.read_text(encoding="utf-8")
for required in (
    "зелёный — 80–100%, оранжевый — 60–79%, красный — ниже 60%",
    "Верно \\(stats.correct) из \\(stats.total) · \\(stats.accuracy)%",
):
    if required not in app_source:
        errors.append(f"Subject statistics clarity check failed: missing {required!r}")

print(f"Literal multiple-choice records inspected: {checked}")
print(f"Distinct literal prompts seen: {len(literal_prompts)}")
print(f"Coverage areas verified: {len(coverage) + 12}")
print(f"Errors: {len(errors)}")
print(f"Warnings: {len(warnings)}")
for item in errors:
    print(f"ERROR: {item}")
for item in warnings:
    print(f"WARNING: {item}")

if errors:
    print("QUALITY AUDIT FAILED. Fix critical structural issues before packaging.")
    sys.exit(1)
print("QUALITY AUDIT PASSED (warnings may still need human review).")
