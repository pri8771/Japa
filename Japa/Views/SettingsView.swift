import SwiftUI

struct SettingsView: View {
    @Environment(AppModel.self) private var app
    @State private var showingClearConfirm = false

    var body: some View {
        Form {
            Section {
                Picker("Beads per round", selection: targetBinding) {
                    ForEach(Preferences.targetChoices, id: \.self) { value in
                        Text(label(for: value)).tag(value)
                    }
                }
            } header: {
                sectionHeader("Round")
            } footer: {
                Text("108 is one full mala. Smaller and larger rounds are here for shorter sits or longer practice.")
            }

            Section {
                Toggle("Completion tone", isOn: toneBinding)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Haptic strength")
                        .font(Theme.ui(15))
                        .foregroundStyle(Theme.textPrimary)
                    Slider(value: intensityBinding, in: 0.2...1.0)
                }
                .padding(.vertical, 4)
            } header: {
                sectionHeader("Feel")
            } footer: {
                Text("The per-bead buzz works even on silent. The completion tone follows your ringer switch and this toggle — the completion buzz always fires.")
            }

            Section {
                Button(role: .destructive) {
                    showingClearConfirm = true
                } label: {
                    Text("Clear history")
                }
                .disabled(app.sessions.isEmpty)
            } header: {
                sectionHeader("Data")
            } footer: {
                Text("Everything stays on this device. Japa has no account, makes no network requests, and collects nothing.")
            }

            Section {
                LabeledContent("Version", value: appVersion)
            } header: {
                sectionHeader("About")
            }
        }
        .scrollContentBackground(.hidden)
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Clear all history?", isPresented: $showingClearConfirm, titleVisibility: .visible) {
            Button("Clear all", role: .destructive) { app.clearHistory() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This permanently removes every saved session from this device.")
        }
    }

    // MARK: Bindings into AppModel

    private var targetBinding: Binding<Int> {
        Binding(get: { app.preferences.defaultTarget }, set: { app.setDefaultTarget($0) })
    }
    private var toneBinding: Binding<Bool> {
        Binding(get: { app.preferences.completionToneEnabled }, set: { app.setCompletionToneEnabled($0) })
    }
    private var intensityBinding: Binding<Double> {
        Binding(get: { app.preferences.hapticIntensity }, set: { app.setHapticIntensity($0) })
    }

    private func label(for value: Int) -> String {
        value == 108 ? "108 (one mala)" : "\(value)"
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(Theme.ui(12, weight: .medium))
            .foregroundStyle(Theme.textMuted)
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        return version
    }
}
