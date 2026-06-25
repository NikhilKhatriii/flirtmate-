/// A "vibe" describes the situation a line is meant for — not a person's
/// actual words, just a short, user-picked context that nudges tone and
/// approach. This is intentionally a fixed list rather than free-text
/// analysis of any pasted-in conversation: FlirtMate never reads or
/// processes anyone else's messages to generate a line aimed at them.
class Vibe {
  final String id;
  final String label;
  final String emoji;
  final String description;
  final String promptHint;

  const Vibe({
    required this.id,
    required this.label,
    required this.emoji,
    required this.description,
    required this.promptHint,
  });
}

const Vibe kNoVibe = Vibe(
  id: 'none',
  label: 'No specific vibe',
  emoji: '✨',
  description: 'Just give me a great line',
  promptHint: '',
);

final List<Vibe> kVibes = [
  kNoVibe,
  const Vibe(
    id: 'just_met',
    label: 'Just met',
    emoji: '👋',
    description: 'First impression, keep it light',
    promptHint:
    'This is for someone they just met — moments ago or earlier today. '
        'Keep it approachable and low-pressure, not overly intense.',
  ),
  const Vibe(
    id: 'already_flirty',
    label: 'Already flirty',
    emoji: '😏',
    description: 'There\'s already some chemistry',
    promptHint:
    'There is already a flirty, playful dynamic between them. '
        'The line can be a little bolder and lean into that existing energy.',
  ),
  const Vibe(
    id: 'long_crush',
    label: 'Long-time crush',
    emoji: '💭',
    description: 'Been wanting to say this for a while',
    promptHint:
    'They have liked this person for a while but haven\'t said much yet. '
        'The line should feel sincere and a little vulnerable, not overly bold.',
  ),
  const Vibe(
    id: 'reconnecting',
    label: 'Reconnecting',
    emoji: '🔄',
    description: 'Catching up after some time apart',
    promptHint:
    'They are reconnecting with someone after a period of not talking. '
        'The line should feel warm and curious, acknowledging the gap '
        'lightly without being heavy about it.',
  ),
  const Vibe(
    id: 'texting_first',
    label: 'Texting, haven\'t met yet',
    emoji: '💬',
    description: 'Online or matched, no in-person meeting yet',
    promptHint:
    'They have only spoken online or by text and haven\'t met in '
        'person yet. The line should work well as a text message and '
        'invite continued conversation rather than assume in-person context.',
  ),
];

Vibe vibeById(String id) =>
    kVibes.firstWhere((v) => v.id == id, orElse: () => kNoVibe);
