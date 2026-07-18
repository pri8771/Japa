import SwiftUI

/// "Change Mala" — swipe through all 21 styles as live, tappable full-screen
/// previews; nothing changes the real practice screen until Apply is pressed.
///
/// Each style keeps its own local preview count while browsing (tapping one,
/// paging away, and paging back preserves where you left it), and tapping
/// fires the same real haptic feedback a practice tap would — this is meant
/// to be felt, not just looked at.
struct MalaStylePickerView: View {
    @Environment(AppModel.self) private var app
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var pickerIndex: Int
    @State private var previewCounts: [MalaStyle: Int]
    @State private var justApplied = false

    private let target: Int

    init() {
        // Deferred to onAppear for the real app value (Environment isn't
        // available in init), start neutral and correct immediately.
        _pickerIndex = State(initialValue: 0)
        _previewCounts = State(initialValue: [:])
        target = 108
    }

    private var styles: [MalaStyle] { MalaStyle.allCases.sorted { $0.rawValue < $1.rawValue } }
    private var currentStyle: MalaStyle { styles[pickerIndex] }
    private var appliedStyle: MalaStyle { app.preferences.malaStyle }
    private var currentTarget: Int { app.preferences.defaultTarget }

    var body: some View {
        VStack(spacing: 28) {
            deviceFrame
                .frame(width: 278, height: 604)
                .padding(.top, 12)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Change Mala")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            pickerIndex = appliedStyle.rawValue
        }
    }

    // MARK: Device frame chrome

    private var deviceFrame: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 48, style: .continuous)
                .fill(LinearGradient(colors: [Color(hex: 0x2a2a2c), Color(hex: 0x0d0d0e)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(color: .black.opacity(0.35), radius: 30, y: 20)

            TabView(selection: $pickerIndex) {
                ForEach(styles) { style in
                    previewPage(for: style)
                        .tag(style.rawValue)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(11)
            .clipShape(RoundedRectangle(cornerRadius: 48, style: .continuous))

            // Notch.
            Capsule()
                .fill(Color(hex: 0x050505))
                .frame(width: 86, height: 25)
                .position(x: 139, y: 24.5)
                .allowsHitTesting(false)
        }
    }

    private func previewPage(for style: MalaStyle) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 38, style: .continuous)
                .fill(Color.black)
                .overlay(
                    MalaStyleView(
                        style: style,
                        count: previewCount(for: style),
                        target: currentTarget,
                        isComplete: false,
                        breathing: true
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 38, style: .continuous))
                    .contentShape(Rectangle())
                    .onTapGesture { tapAdvance(style) }
                )

            VStack {
                Text("Change Mala")
                    .font(Theme.ui(10, weight: .semibold))
                    .tracking(3)
                    .textCase(.uppercase)
                    .foregroundStyle(.white.opacity(0.55))
                    .padding(.top, 44)
                Spacer()
            }
            .allowsHitTesting(false)

            HStack {
                chevron("chevron.left") { step(-1) }
                Spacer()
                chevron("chevron.right") { step(1) }
            }
            .padding(.horizontal, 2)

            VStack {
                Spacer()
                bottomOverlay(for: style)
            }
        }
    }

    private func chevron(_ systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .light))
                .foregroundStyle(.white.opacity(0.6))
                .frame(width: 40, height: 64)
                .contentShape(Rectangle())
        }
        .accessibilityLabel(systemName == "chevron.left" ? "Previous style" : "Next style")
    }

    private func bottomOverlay(for style: MalaStyle) -> some View {
        VStack(spacing: 14) {
            VStack(spacing: 3) {
                Text(style.info.name)
                    .font(Theme.serif(22))
                    .foregroundStyle(.white)
                Text("\(style.info.tag) · \(String(format: "%02d", pickerIndex + 1)) / \(styles.count)")
                    .font(Theme.ui(9, weight: .semibold))
                    .tracking(2)
                    .textCase(.uppercase)
                    .foregroundStyle(.white.opacity(0.5))
            }

            dots

            applyButton(for: style)
        }
        .padding(.horizontal, 20)
        .padding(.top, 26)
        .padding(.bottom, 30)
        .background(
            LinearGradient(colors: [.black.opacity(0.62), .clear], startPoint: .bottom, endPoint: .top)
                .padding(.bottom, -40)
        )
    }

    private var dots: some View {
        HStack(spacing: 4) {
            ForEach(styles) { style in
                let distance = abs(style.rawValue - pickerIndex)
                let size: CGFloat = distance == 0 ? 8 : distance == 1 ? 5.5 : distance <= 3 ? 4 : 3
                Circle()
                    .fill(style.rawValue == pickerIndex ? Color.white : (style == appliedStyle ? Color(hex: 0xe6b45c) : Color.white.opacity(0.42)))
                    .frame(width: size, height: size)
                    .opacity(style.rawValue == pickerIndex ? 1 : (distance <= 3 ? 0.85 : 0.42))
            }
        }
        .animation(reduceMotion ? nil : .easeOut(duration: 0.25), value: pickerIndex)
    }

    private func applyButton(for style: MalaStyle) -> some View {
        Button(action: { apply(style) }) {
            Text(justApplied ? "Applied ✓" : (style == appliedStyle ? "Current mala" : "Apply this mala"))
                .font(Theme.ui(12, weight: .semibold))
                .tracking(0.5)
                .foregroundStyle(Color(hex: 0x1c140a))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(
                    LinearGradient(colors: [Color(hex: 0xf0d199), Color(hex: 0xdcb066)], startPoint: .top, endPoint: .bottom)
                )
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .accessibilityIdentifier("malaApplyButton")
        .accessibilityHint(style == appliedStyle ? "Already your current mala" : "Applies \(style.info.name) as your mala")
    }

    // MARK: Behavior

    private func previewCount(for style: MalaStyle) -> Int {
        previewCounts[style] ?? max(1, min(currentTarget - 1, currentTarget * 3 / 10))
    }

    private func tapAdvance(_ style: MalaStyle) {
        let target = currentTarget
        let current = previewCount(for: style)
        let next = current >= target ? 1 : current + 1
        previewCounts[style] = next
        if next == target {
            app.playPreviewCompletion()
        } else {
            app.playPreviewTick()
        }
    }

    private func step(_ direction: Int) {
        let next = (pickerIndex + direction + styles.count) % styles.count
        withAnimation(reduceMotion ? nil : .easeOut(duration: 0.3)) {
            pickerIndex = next
        }
    }

    private func apply(_ style: MalaStyle) {
        guard style != appliedStyle else { return }
        app.setMalaStyle(style)
        justApplied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            justApplied = false
        }
    }
}

#Preview {
    NavigationStack {
        MalaStylePickerView()
            .environment(AppModel(persistence: Persistence(directory: FileManager.default.temporaryDirectory.appendingPathComponent("japa-preview-\(UUID())")), haptics: NoopHaptics(), tone: NoopTone()))
    }
}
