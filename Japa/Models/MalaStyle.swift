import Foundation

/// A visual/motion "world" for the practice bead. `.classic` is the shipping
/// default and always sorts first; the other twenty are alternatives the user
/// previews and switches to from Settings → Mala Style.
///
/// Rendering lives in `MalaStyleView` and its renderer files — this type is
/// pure identity + metadata so it can persist in `Preferences` and drive the
/// picker without any drawing code.
enum MalaStyle: Int, CaseIterable, Codable, Identifiable, Sendable {
    case classic = 0
    case ultraMinimal = 1
    case warmTactile = 2
    case softlySpiritual = 3
    case modernLuxury = 4
    case abstractAtmospheric = 5
    case semi3DSculptural = 6
    case painterlyRealism = 7
    case darkMeditative = 8
    case lightAiry = 9
    case sculpturalMonument = 10
    case liquid = 11
    case crystalline = 12
    case celestial = 13
    case zenInk = 14
    case botanical = 15
    case templeBrass = 16
    case amberResin = 17
    case aurora = 18
    case ceramicGlaze = 19
    case wovenTextile = 20

    var id: Int { rawValue }

    static let `default`: MalaStyle = .classic

    /// Display metadata, mirroring the design's `meta()` table exactly.
    struct Info {
        let code: String
        let name: String
        let tag: String
        let summary: String
        let motion: String
    }

    var info: Info {
        switch self {
        case .classic:
            return Info(code: "00", name: "Classic", tag: "Signature",
                summary: "The shipping default — a quiet arc filling toward completion.",
                motion: "A hairline ring fills clockwise as you tap; the leading point glides one step and the whole ring breathes, brightening as it nears the target.")
        case .ultraMinimal:
            return Info(code: "01", name: "Ultra Minimal", tag: "Minimal",
                summary: "Paper-white stillness; one ink dot on a ring of ticks.",
                motion: "A single ink dot glides one tick clockwise; the big numeral cross-fades. Nothing else moves — pure, weightless focus.")
        case .warmTactile:
            return Info(code: "02", name: "Warm & Tactile", tag: "Warm",
                summary: "Sandalwood beads sliding through warm light.",
                motion: "Tap slides the strand one bead left; the next bead settles into a fixed warm spotlight over a soft contact shadow — a tactile click.")
        case .softlySpiritual:
            return Info(code: "03", name: "Softly Spiritual", tag: "Spiritual",
                summary: "A strand of light ascending through dusk.",
                motion: "A breathing halo holds the center as beads rise one step into it; the glow climbs the strand as the count grows.")
        case .modernLuxury:
            return Info(code: "04", name: "Modern Luxury", tag: "Luxury",
                summary: "Onyx and gold, a jeweler's loop.",
                motion: "A single champagne-lit bead travels the loop one link per tap, turning with a slow specular shimmer against the gold thread.")
        case .abstractAtmospheric:
            return Info(code: "05", name: "Abstract & Atmospheric", tag: "Atmospheric",
                summary: "Glowing orbs adrift in fog.",
                motion: "The ring drifts endlessly in mist; each tap advances a brighter leading orb one notch as motes of light settle around it.")
        case .semi3DSculptural:
            return Info(code: "06", name: "Semi-3D Sculptural", tag: "Dimensional",
                summary: "Rendered beads rolling through focus.",
                motion: "The focused bead sinks back as the next rolls forward into sharp focus — real depth-of-field with a shifting contact shadow.")
        case .painterlyRealism:
            return Info(code: "07", name: "Painterly Realism", tag: "Painterly",
                summary: "Gouache mala, worn smooth by the thumb.",
                motion: "Each counted bead darkens as if polished by touch; the whole strand sways with a gentle hand-painted parallax.")
        case .darkMeditative:
            return Info(code: "08", name: "Dark & Meditative", tag: "Dark",
                summary: "One ember of light in the dark.",
                motion: "A single ember hands off from bead to bead as the strand rises; everything else stays in darkness. Slow, breathing, calm.")
        case .lightAiry:
            return Info(code: "09", name: "Light & Airy", tag: "Light",
                summary: "Weightless pearls at sunrise.",
                motion: "The active pearl lifts and haloes at center while the strand glides beneath; a soft ripple pulses outward — light and floating.")
        case .sculpturalMonument:
            return Info(code: "10", name: "Sculptural Monument", tag: "Monument",
                summary: "A single turning stone.",
                motion: "The monument turns a precise increment each tap, its surface rotating as a hairline arc fills toward the target. Big, quiet, sculptural.")
        case .liquid:
            return Info(code: "11", name: "Liquid", tag: "Fluid",
                summary: "Beads of water on a still dark pool.",
                motion: "Each tap advances a droplet one step and sends slow concentric ripples across the surface; the active drop catches a bright meniscus of light.")
        case .crystalline:
            return Info(code: "12", name: "Crystalline", tag: "Crystal",
                summary: "Faceted gems that split the light.",
                motion: "The active facet advances and flares with a prismatic sparkle; fine rainbow glints cross it as the numerals shimmer with a faint chromatic edge.")
        case .celestial:
            return Info(code: "13", name: "Celestial", tag: "Cosmic",
                summary: "Planets on a slow orbit through starlight.",
                motion: "The whole constellation drifts endlessly; each tap moves a glowing planet one orbital step as distant stars twinkle. Vast and unhurried.")
        case .zenInk:
            return Info(code: "14", name: "Zen Ink", tag: "Zen",
                summary: "Sumi-e ink dots along an open enso.",
                motion: "A wet brush-dot blooms one step along the enso and darkens; counted dots hold their ink while untouched ones stay pale. Monochrome, calligraphic.")
        case .botanical:
            return Info(code: "15", name: "Botanical", tag: "Organic",
                summary: "Rough rudraksha seeds on a living vine.",
                motion: "The strand sways like a plant in a breeze; each tap turns the next seed forward, its furrows and a dewy highlight catching the daylight.")
        case .templeBrass:
            return Info(code: "16", name: "Temple Brass", tag: "Metal",
                summary: "Aged temple brass with engraved beads.",
                motion: "A polished specular streak sweeps across the active bead as it turns one link; heavier and slower, like handling real metal.")
        case .amberResin:
            return Info(code: "17", name: "Amber Resin", tag: "Amber",
                summary: "Light rising through a vessel of honey.",
                motion: "Each tap lifts the amber level one notch inside a glowing vessel; the surface ripples and the whole body of resin warms from within.")
        case .aurora:
            return Info(code: "18", name: "Aurora", tag: "Aurora",
                summary: "A light-node gliding an aurora ribbon.",
                motion: "Soft aurora bands drift and shimmer while the active node slides one step along the ribbon, flaring gently. Electric yet calm.")
        case .ceramicGlaze:
            return Info(code: "19", name: "Ceramic Glaze", tag: "Ceramic",
                summary: "Matte celadon beads, finely crackled.",
                motion: "The next glazed bead rolls into the warm light and a soft sheen glides across its craquelure; quiet, matte, unhurried.")
        case .wovenTextile:
            return Info(code: "20", name: "Woven Textile", tag: "Textile",
                summary: "Knotted beads on a hand-woven cord.",
                motion: "The active bead travels the draped cord one knot at a time while the whole strand sways with the pull — you can feel the thread tension.")
        }
    }
}
