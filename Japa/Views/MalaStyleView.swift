import SwiftUI

/// Renders any of the 21 mala styles full-bleed, given the current count.
///
/// Used by the style picker (which needs every style, including Classic, in
/// an identical full-screen frame to browse) and by the practice/completion
/// screens for every style *except* Classic — Classic keeps its original
/// small-ring-on-`Theme.background` look there (see `PracticeView`/
/// `CompletionView`), since it's the pre-existing shipped default and this
/// feature must not change it.
struct MalaStyleView: View {
    let style: MalaStyle
    let count: Int
    let target: Int
    let isComplete: Bool
    var breathing: Bool = true

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Group {
            switch style {
            case .classic: MalaRender_Classic(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .ultraMinimal: MalaRender_UltraMinimal(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .warmTactile: MalaRender_WarmTactile(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .softlySpiritual: MalaRender_SoftlySpiritual(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .modernLuxury: MalaRender_ModernLuxury(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .abstractAtmospheric: MalaRender_AbstractAtmospheric(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .semi3DSculptural: MalaRender_Semi3DSculptural(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .painterlyRealism: MalaRender_PainterlyRealism(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .darkMeditative: MalaRender_DarkMeditative(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .lightAiry: MalaRender_LightAiry(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .sculpturalMonument: MalaRender_SculpturalMonument(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .liquid: MalaRender_Liquid(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .crystalline: MalaRender_Crystalline(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .celestial: MalaRender_Celestial(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .zenInk: MalaRender_ZenInk(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .botanical: MalaRender_Botanical(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .templeBrass: MalaRender_TempleBrass(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .amberResin: MalaRender_AmberResin(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .aurora: MalaRender_Aurora(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .ceramicGlaze: MalaRender_CeramicGlaze(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            case .wovenTextile: MalaRender_WovenTextile(count: count, target: target, isComplete: isComplete, breathing: breathing, reduceMotion: reduceMotion)
            }
        }
        .clipped()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Mala style: \(style.info.name)")
        .accessibilityValue("\(count) of \(target)")
    }
}

#Preview {
    MalaStyleView(style: .celestial, count: 42, target: 108, isComplete: false)
        .frame(width: 278, height: 604)
        .clipShape(RoundedRectangle(cornerRadius: 38))
}
