# Seed Mantra Content Review (B6)

The bundled seed mantra set is **spiritual content** and must be human-reviewed
for accuracy and respectfulness before App Store submission. This file is the
review record.

Source of truth: [`Japa/Content/SeedMantras.swift`](../Japa/Content/SeedMantras.swift).

## Review status

| State | Meaning |
|-------|---------|
| **Drafted — pending human sign-off** | Text is written and self-checked for common transliteration, but a qualified human reviewer has **not yet** signed off. This is the current state and a launch gate (see `LAUNCH_READINESS.md` §9, B6). |

> The entries below were drafted to be widely-known, mainstream mantras with
> neutral, non-sectarian glosses. They still require review by someone qualified
> in the relevant traditions before v1 ships. Do not submit to the App Store
> until the sign-off line at the bottom is completed.

## Entries to review

| ID | Title | Script | Tradition / gloss | Notes for reviewer |
|----|-------|--------|-------------------|--------------------|
| …01 | Om | ॐ | The pranava | Universal; verify glyph renders. |
| …02 | Om Namah Shivaya | ॐ नमः शिवाय | Shaiva salutation to Shiva | Verify sandhi/spelling. |
| …03 | Om Mani Padme Hum | ॐ मणि पद्मे हूँ | Avalokiteshvara (Tibetan Buddhism) | Shown in Devanagari, not Tibetan script — confirm acceptable. |
| …04 | Om Gam Ganapataye Namaha | ॐ गं गणपतये नमः | Invocation of Ganesha | Verify bija "gaṃ". |
| …05 | Hare Krishna | हरे कृष्ण हरे राम | Abbreviated Vaishnava maha-mantra | This is an **abbreviation** of the 16-word mantra; confirm the short label + note are acceptable, or replace with the full mantra. |
| …06 | Waheguru | ਵਾਹਿਗੁਰੂ | Sikh remembrance of the Divine | Gurmukhi script — verify glyphs render on device. |
| …07 | So Ham | सो ऽहम् | Breath mantra, "I am that" | Verify avagraha rendering. |
| …08 | Om Shanti | ॐ शान्ति | Invocation of peace | — |
| 00…00 | Counting | (none) | Neutral / no mantra | Allows practice without a label. |

## Guidance applied

- Tiny set by design; the app never gates practice behind a content library
  (users add their own free-text mantras).
- Glosses are kept short, factual, and non-sectarian. No claims of efficacy,
  no instruction on "correct" practice.
- Mantra text never affects counting — it is a label only.

## Sign-off

- [ ] Reviewed by: _______________________  (name / qualification)
- [ ] Date: _______________
- [ ] Approved for App Store submission

Until this sign-off is complete, treat B6 as **open**.
