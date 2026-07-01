import SwiftUI

struct HomeView: View {
    @Environment(AppModel.self) private var app
    var onBegin: () -> Void
    var onResume: () -> Void

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar

                Spacer()

                VStack(spacing: 6) {
                    Text("Japa")
                        .font(Theme.serif(34, weight: .regular))
                        .foregroundStyle(Theme.textPrimary)
                    Text("a quiet digital mala")
                        .font(Theme.ui(13))
                        .foregroundStyle(Theme.textSecondary)
                }

                emblem
                    .frame(width: 200, height: 200)
                    .padding(.vertical, 36)

                mantraRow

                Spacer()

                VStack(spacing: 14) {
                    if let state = app.resumableState {
                        resumeCard(state)
                    }
                    Button(action: onBegin) {
                        Text(app.resumableState == nil ? "Begin" : "Begin a new round")
                    }
                    .buttonStyle(OutlineButtonStyle())
                    .accessibilityIdentifier("homeBegin")
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 24)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var topBar: some View {
        HStack(spacing: 22) {
            Spacer()
            NavigationLink(value: RootView.Route.history) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 18))
                    .foregroundStyle(Theme.textMuted)
            }
            .accessibilityLabel("History")
            .accessibilityIdentifier("historyButton")
            NavigationLink(value: RootView.Route.settings) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 18))
                    .foregroundStyle(Theme.textMuted)
            }
            .accessibilityLabel("Settings")
            .accessibilityIdentifier("settingsButton")
        }
        .padding(.horizontal, 22)
        .padding(.top, 12)
    }

    private var emblem: some View {
        ZStack {
            Circle().stroke(Theme.ringTrack, lineWidth: 2)
            Circle()
                .trim(from: 0, to: 0.04)
                .stroke(Theme.accent, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: 2) {
                Text("\(app.preferences.defaultTarget)")
                    .font(Theme.serif(40, weight: .light))
                    .foregroundStyle(Theme.textPrimary)
                Text(app.preferences.defaultTarget == 108 ? "ONE MALA" : "PER ROUND")
                    .font(Theme.ui(10, weight: .medium))
                    .tracking(1.5)
                    .foregroundStyle(Theme.textMuted)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Target \(app.preferences.defaultTarget) per round")
    }

    private var mantraRow: some View {
        NavigationLink(value: RootView.Route.mantraSelect) {
            VStack(spacing: 4) {
                Text(app.selectedMantra.title)
                    .font(Theme.serif(19))
                    .foregroundStyle(Theme.accentBright)
                Text("Change mantra")
                    .font(Theme.ui(12))
                    .foregroundStyle(Theme.textMuted)
            }
        }
        .accessibilityLabel("Mantra: \(app.selectedMantra.title). Change mantra.")
        .accessibilityIdentifier("mantraRow")
    }

    private func resumeCard(_ state: ActiveSessionState) -> some View {
        Button(action: onResume) {
            HStack(spacing: 12) {
                Image(systemName: "arrow.uturn.forward.circle")
                    .font(.system(size: 22))
                    .foregroundStyle(Theme.accentBright)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Resume your round")
                        .font(Theme.ui(15, weight: .medium))
                        .foregroundStyle(Theme.textPrimary)
                    Text("\(state.mantraTitle) · \(state.count) of \(state.target)")
                        .font(Theme.ui(12))
                        .foregroundStyle(Theme.textSecondary)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .cardSurface()
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("resumeCard")
    }
}

#Preview {
    NavigationStack {
        HomeView(onBegin: {}, onResume: {})
            .environment(AppModel(persistence: Persistence(directory: FileManager.default.temporaryDirectory.appendingPathComponent("japa-preview-\(UUID())")), haptics: NoopHaptics(), tone: NoopTone()))
    }
}
