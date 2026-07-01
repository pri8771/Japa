import SwiftUI

struct MantraSelectView: View {
    @Environment(AppModel.self) private var app
    @Environment(\.dismiss) private var dismiss
    @State private var showingAdd = false

    var body: some View {
        List {
            Section {
                ForEach(SeedMantras.all) { mantra in
                    MantraRow(mantra: mantra, isSelected: mantra.id == app.selectedMantra.id) {
                        choose(mantra)
                    }
                }
            } header: {
                header("Reviewed")
            }

            if !app.customMantras.isEmpty {
                Section {
                    ForEach(app.customMantras) { mantra in
                        MantraRow(mantra: mantra, isSelected: mantra.id == app.selectedMantra.id) {
                            choose(mantra)
                        }
                    }
                    .onDelete { offsets in
                        offsets.map { app.customMantras[$0] }.forEach(app.deleteCustomMantra)
                    }
                } header: {
                    header("Your mantras")
                }
            }

            Section {
                Button {
                    showingAdd = true
                } label: {
                    Label("Add your own", systemImage: "plus")
                        .font(Theme.ui(15))
                        .foregroundStyle(Theme.accentBright)
                }
                .listRowBackground(Theme.surface)
                .accessibilityIdentifier("addMantraButton")
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("Mantra")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAdd) {
            AddMantraView { title, script in
                // Add and select; the sheet dismisses itself. We stay on Mantra
                // Select showing the new mantra checked (no double-dismiss).
                if let mantra = app.addCustomMantra(title: title, script: script) {
                    app.select(mantra)
                }
            }
        }
    }

    private func choose(_ mantra: Mantra) {
        app.select(mantra)
        dismiss()
    }

    private func header(_ text: String) -> some View {
        Text(text)
            .font(Theme.ui(12, weight: .medium))
            .foregroundStyle(Theme.textMuted)
    }
}

private struct MantraRow: View {
    let mantra: Mantra
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(mantra.title)
                        .font(Theme.ui(16, weight: .medium))
                        .foregroundStyle(Theme.textPrimary)
                    if let script = mantra.script {
                        Text(script)
                            .font(Theme.serif(15))
                            .foregroundStyle(Theme.accentBright)
                    }
                    if let note = mantra.note {
                        Text(note)
                            .font(Theme.ui(12))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.accentBright)
                }
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .listRowBackground(Theme.surface)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
        .accessibilityIdentifier("mantra-\(mantra.title)")
    }
}

/// A small sheet for entering a free-text mantra. Mantra text never affects
/// counting; this is purely a label the practitioner chooses for themselves.
private struct AddMantraView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var script = ""
    var onSave: (String, String?) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Mantra name", text: $title)
                        .accessibilityIdentifier("mantraNameField")
                    TextField("Script or transliteration (optional)", text: $script)
                        .accessibilityIdentifier("mantraScriptField")
                } footer: {
                    Text("Your mantra stays on this device. It's a label for your practice — counting works the same either way.")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("New mantra")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(title, script.isEmpty ? nil : script)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
