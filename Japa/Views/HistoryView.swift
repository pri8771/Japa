import SwiftUI

/// A calm, reverse-chronological record of past sessions.
///
/// Deliberately non-gamified: there is no streak counter, no chain, no "days in
/// a row", and no nudge to return. Just an honest log — including partial
/// sessions — that the practitioner fully controls.
struct HistoryView: View {
    @Environment(AppModel.self) private var app
    @State private var showingClearConfirm = false

    var body: some View {
        Group {
            if app.sessions.isEmpty {
                emptyState
            } else {
                list
            }
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !app.sessions.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Clear", role: .destructive) { showingClearConfirm = true }
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
        .confirmationDialog("Clear all history?", isPresented: $showingClearConfirm, titleVisibility: .visible) {
            Button("Clear all", role: .destructive) { app.clearHistory() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This permanently removes every saved session from this device.")
        }
    }

    private var list: some View {
        List {
            ForEach(app.sessions) { session in
                HistoryRow(session: session)
                    .listRowBackground(Theme.surface)
            }
            .onDelete { offsets in
                offsets.map { app.sessions[$0] }.forEach(app.deleteSession)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "circle.dotted")
                .font(.system(size: 34))
                .foregroundStyle(Theme.accentSoft)
            Text("Your sessions appear here")
                .font(Theme.serif(18))
                .foregroundStyle(Theme.textPrimary)
            Text("Finish a round to begin a quiet record of your practice.")
                .font(Theme.ui(13))
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct HistoryRow: View {
    let session: PracticeSession

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.mantraTitle)
                    .font(Theme.ui(16, weight: .medium))
                    .foregroundStyle(Theme.textPrimary)
                Text(dateText)
                    .font(Theme.ui(12))
                    .foregroundStyle(Theme.textSecondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(session.completedCount) / \(session.target)")
                    .font(Theme.ui(15, weight: .medium))
                    .foregroundStyle(session.isComplete ? Theme.accentBright : Theme.textSecondary)
                    .monospacedDigit()
                Text(session.isComplete ? durationText : "partial · \(durationText)")
                    .font(Theme.ui(11))
                    .foregroundStyle(Theme.textMuted)
            }
        }
        .padding(.vertical, 4)
    }

    private var dateText: String {
        session.startedAt.formatted(date: .abbreviated, time: .shortened)
    }

    private var durationText: String {
        let total = Int(session.duration)
        let minutes = total / 60
        let seconds = total % 60
        return minutes > 0 ? "\(minutes)m \(seconds)s" : "\(seconds)s"
    }
}
