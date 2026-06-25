import 'package:flutter/cupertino.dart';

/// A "vibe" describes the situation a line is meant for — not a person's
/// actual words, just a short, user-picked context that nudges tone and
/// approach. This is intentionally a fixed list rather than free-text
/// analysis of any pasted-in conversation: FlirtMate never reads or
/// processes anyone else's messages to generate a line aimed at them.
///
/// Design system: Apple-style professional palette.
///   Primary blue   : #007AFF  (iOS system blue)
///   Cyan           : #32ADE6  (iOS system cyan)
///   Teal           : #30B0C7  (iOS system teal)
///   Green          : #34C759  (iOS system green)
///   Orange         : #FF9500  (iOS system orange)
///   Brown          : #A2845E  (iOS system brown)
///   Label secondary: #636366
///   Grouped BG     : #F2F2F7
///
/// Icons: CupertinoIcons exclusively. No emoji characters anywhere.
class Vibe {
  final String id;
  final String label;

  /// SF Symbol / CupertinoIcon for this vibe. Replaces emoji.
  final IconData icon;

  /// Accent color drawn from the iOS system palette.
  final Color accentColor;

  final String description;
  final String promptHint;

  const Vibe({
    required this.id,
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.description,
    required this.promptHint,
  });
}

// ---------------------------------------------------------------------------
// Default / neutral vibe
// ---------------------------------------------------------------------------

const Vibe kNoVibe = Vibe(
  id: 'none',
  label: 'No specific vibe',
  icon: CupertinoIcons.sparkles,        // neutral "just give me something good"
  accentColor: Color(0xFF007AFF),       // system blue — primary default
  description: 'Just give me a great line',
  promptHint: '',
);

// ---------------------------------------------------------------------------
// Vibe list
// ---------------------------------------------------------------------------

final List<Vibe> kVibes = [
  kNoVibe,

  // Just met — wave / greeting; system cyan (airy, open)
  const Vibe(
    id: 'just_met',
    label: 'Just met',
    icon: CupertinoIcons.hand_raised,
    accentColor: Color(0xFF32ADE6),     // system cyan
    description: 'First impression, keep it light',
    promptHint:
    'This is for someone they just met — moments ago or earlier today. '
        'Keep it approachable and low-pressure, not overly intense.',
  ),

  // Already flirty — bolt for existing energy; system orange (warm, charged)
  const Vibe(
    id: 'already_flirty',
    label: 'Already flirty',
    icon: CupertinoIcons.bolt,
    accentColor: Color(0xFFFF9500),     // system orange
    description: 'There\'s already some chemistry',
    promptHint:
    'There is already a flirty, playful dynamic between them. '
        'The line can be a little bolder and lean into that existing energy.',
  ),

  // Long-time crush — clock showing patient waiting; system teal (sincere, calm)
  const Vibe(
    id: 'long_crush',
    label: 'Long-time crush',
    icon: CupertinoIcons.clock,
    accentColor: Color(0xFF30B0C7),     // system teal
    description: 'Been wanting to say this for a while',
    promptHint:
    'They have liked this person for a while but haven\'t said much yet. '
        'The line should feel sincere and a little vulnerable, not overly bold.',
  ),

  // Reconnecting — arrow loop; system green (fresh start, renewal)
  const Vibe(
    id: 'reconnecting',
    label: 'Reconnecting',
    icon: CupertinoIcons.arrow_2_circlepath,
    accentColor: Color(0xFF34C759),     // system green
    description: 'Catching up after some time apart',
    promptHint:
    'They are reconnecting with someone after a period of not talking. '
        'The line should feel warm and curious, acknowledging the gap '
        'lightly without being heavy about it.',
  ),

  // Texting, haven't met yet — chat bubble; system blue (digital, conversational)
  const Vibe(
    id: 'texting_first',
    label: 'Texting, haven\'t met yet',
    icon: CupertinoIcons.chat_bubble_text,
    accentColor: Color(0xFF0066CC),     // mid blue (distinct from kNoVibe blue)
    description: 'Online or matched, no in-person meeting yet',
    promptHint:
    'They have only spoken online or by text and haven\'t met in '
        'person yet. The line should work well as a text message and '
        'invite continued conversation rather than assume in-person context.',
  ),
];

// ---------------------------------------------------------------------------
// Lookup helper
// ---------------------------------------------------------------------------

Vibe vibeById(String id) =>
    kVibes.firstWhere((v) => v.id == id, orElse: () => kNoVibe);