/// Content for the "Conversation Arc" feature.
///
/// Most pickup-line apps (including earlier versions of this one) only ever
/// help with message one — the opener — then leave the user stranded the
/// moment the other person actually replies. This file fills that gap with
/// two more stages, organized by the same 14 categories as the main line
/// bank, so the tone carries through the whole arc instead of resetting:
///
///   1. OPENER    — the existing lines in offline_lines.dart
///   2. FOLLOW-UP — what to say *after* a good reply, so the conversation
///                  doesn't stall right after it started working
///   3. DEEPER    — genuine, warmer questions for once things are flowing,
///                  closer to "36 Questions to Fall in Love" territory than
///                  to a pickup line
///
/// Like the rest of the app, this is static, curated content the user reads
/// and chooses from — never anything derived from analyzing a real
/// conversation or another person's actual messages.
///
/// Design system: Apple-style professional palette.
///   Primary blue  : #007AFF  (iOS system blue)
///   Label primary : #000000
///   Label secondary: #3C3C43 @ 60% → rendered #636366
///   Separator     : #3C3C43 @ 30% → rendered #C6C6C8
///   Fill primary  : #F2F2F7  (iOS grouped background)
///   Fill secondary: #FFFFFF
///   Accent teal   : #32ADE6  (iOS teal / system cyan)
///   Destructive   : #FF3B30  (iOS red — not used here but defined)
///
/// Icons: use flutter/cupertino.dart CupertinoIcons exclusively so the UI
/// reads as native iOS. No emoji characters appear anywhere in the UI layer.
library;

import 'package:flutter/cupertino.dart';
import 'offline_lines.dart';

// ---------------------------------------------------------------------------
// Arc stage content
// ---------------------------------------------------------------------------

/// What to say once the other person has replied well to an opener.
/// Keeps the same tone as the category's openers, but is written to
/// function as a *response*, not another cold open.
final Map<String, List<String>> kFollowUpLines = {
  'romantic': [
    "I have to say, that might be the nicest reply I've gotten in a while.",
    "Okay, that answer just made me like you more than I already did.",
    "I wasn't expecting that, and I mean that as a genuinely good thing.",
    "You just made this significantly harder to stop talking to you.",
    "I think I'm going to be thinking about that answer for a bit.",
    "That's exactly the kind of answer that makes me want to know more.",
    "I didn't expect to feel this comfortable this fast, for the record.",
    "You have a way of answering that makes the question feel worth asking.",
    "I think we just upgraded from small talk to something better.",
    "Okay, now I actually want to know your whole story.",
  ],
  'funny': [
    "Okay, that response was unfairly good. I wasn't ready for that.",
    "I see we're both committed to the bit. I respect that.",
    "I'm choosing to interpret that as a sign this is going well.",
    "You're funnier than I expected, and I expected a lot.",
    "I think you just won this round, and I'm oddly fine with that.",
    "That's the kind of reply that makes me forget my next line entirely.",
    "I didn't think you'd top my opener, and yet, here we are.",
    "I'm going to need a second to recover from that one.",
    "Okay, I'm officially invested in this conversation now.",
    "You're trouble, and I mean that as the highest compliment.",
  ],
  'light': [
    "That's a really nice answer, honestly.",
    "I like that — feels like a good sign for this conversation.",
    "Okay, you just made this even easier to keep talking about.",
    "That's a nicer reply than I was expecting, in a good way.",
    "I think I like where this conversation is heading.",
    "You have a nice way of answering things, you know that?",
    "That actually made me smile, just so you know.",
    "I appreciate that you didn't just give a one-word answer.",
    "This is turning into a genuinely nice conversation.",
    "I like learning these little things about you already.",
  ],
  'playful': [
    "Okay, that was a good comeback. I'll give you that one.",
    "You're better at this than I expected, and that's saying something.",
    "I see what you did there. Cute, but I see it.",
    "Alright, you've officially earned my full attention now.",
    "That's the kind of answer that makes me want to keep teasing you.",
    "I think you're enjoying this as much as I am, just saying.",
    "Okay, round two goes to you. I'm taking notes.",
    "You're definitely more fun than I gave you credit for.",
    "I like that you're not making this easy for me.",
    "Careful, that answer just made me significantly more interested.",
  ],
  'classy': [
    "That's a rather elegant answer, if I may say so.",
    "I find myself even more intrigued than I was a moment ago.",
    "You answer questions the way I'd hope someone like you would.",
    "That response had considerably more depth than I expected.",
    "I appreciate an answer with that much thought behind it.",
    "You've just made this conversation noticeably more interesting.",
    "That's the kind of reply that earns a second question.",
    "I think you might be exactly as interesting as you seem.",
    "Allow me to say, that was a genuinely impressive answer.",
    "I'm rather glad I asked, now.",
  ],
  'confident': [
    "Good answer. I don't say that to just anyone.",
    "That's exactly the kind of response that keeps me interested.",
    "I knew this conversation was worth starting. Glad I was right.",
    "You just confirmed my first impression was a good one.",
    "I don't impress easily, and that answer came close.",
    "That's the kind of reply that makes me want to keep going.",
    "Good. I was hoping you'd be this interesting.",
    "I trust my instincts, and they're looking pretty good right now.",
    "That answer earned you my full attention, for what it's worth.",
    "I like people who answer like they mean it. You just did.",
  ],
  'shy': [
    "Oh — that's actually a really good answer, sorry, I wasn't expecting that.",
    "I think I just got a little more nervous, in a good way.",
    "That made me smile more than I'd like to admit right now.",
    "Okay, I definitely want to keep talking after that answer.",
    "I'm a little embarrassed how much I liked that response.",
    "You just made this a lot less awkward, thank you for that.",
    "I think I'm actually relaxing into this conversation now.",
    "That's a really sweet thing to say, honestly.",
    "I didn't expect to feel this comfortable this quickly.",
    "Okay, now I really want to know more about you.",
  ],
  'mysterious': [
    "Interesting answer. I think you just gave away more than you meant to.",
    "That response only made me more curious, for the record.",
    "You answer like someone with more to say than they're letting on.",
    "I think there's a layer under that answer I'd like to see.",
    "That's exactly the kind of reply that keeps someone interesting.",
    "I don't think you've shown me the real version of that answer yet.",
    "You're good at saying just enough. I noticed.",
    "That answer raised more questions than it answered. I like that.",
    "I think I want to know what you're not saying.",
    "You just became considerably more interesting with that reply.",
  ],
  'spicy': [
    "Okay, that answer did something to the temperature in this conversation.",
    "I wasn't ready for that response, in the best way.",
    "You just made this a lot harder to stay composed during.",
    "That's exactly the kind of reply I was hoping for.",
    "I think we both know where this conversation just shifted.",
    "That answer is doing nothing to help me focus right now.",
    "You're better at this than I expected, and I expected a lot.",
    "I don't think either of us is imagining this tension anymore.",
    "That response just raised the stakes considerably.",
    "I like that you're not holding back. Neither am I.",
  ],
  'oldschool': [
    "What a wonderfully thoughtful answer, if I may say so.",
    "You respond the way I'd hope someone with your charm would.",
    "That reply had a certain grace to it I quite admired.",
    "I find myself even more taken with you after that answer.",
    "You've a lovely way of putting things, I must say.",
    "That response only deepens my interest in getting to know you.",
    "I'm rather glad I had the nerve to ask, now.",
    "What a pleasure it is to receive an answer that thoughtful.",
    "You answer with a sincerity that's genuinely rare these days.",
    "I think I'd quite like to hear more, if you're willing.",
  ],
  'nerdy': [
    "That response had a surprisingly elegant structure to it.",
    "I think you just became a statistically significant outlier.",
    "That's the kind of answer that improves my whole hypothesis about you.",
    "I'd peer-review that response as excellent, honestly.",
    "You just gave me considerably more data, and I like what I see.",
    "That answer was unexpectedly well-optimized, if I'm honest.",
    "I think my interest in you just increased measurably.",
    "You respond with a clarity I find genuinely impressive.",
    "That's a solid proof of exactly why I wanted to keep talking.",
    "I'm recalculating my expectations for this conversation upward.",
  ],
  'wholesome': [
    "That's such a kind way to put it, honestly.",
    "I really appreciate an answer like that.",
    "You have a genuinely lovely way of responding to things.",
    "That made my day a little better, just so you know.",
    "I think this is turning into a really nice conversation.",
    "You're easy to talk to in the best, most genuine way.",
    "That answer felt really sincere, and I appreciate that.",
    "I'm grateful this conversation happened, honestly.",
    "You have a kind way of putting things into words.",
    "I think I'm really enjoying getting to know you.",
  ],
  'smooth': [
    "Good answer. I had a feeling you'd come through with something like that.",
    "That's exactly the kind of reply that keeps a conversation interesting.",
    "I figured you'd be this good at this. Glad I was right.",
    "That response just made the rest of this conversation easy.",
    "You're as sharp as I hoped you'd be, honestly.",
    "I don't usually say this, but that was a genuinely great answer.",
    "That's the kind of reply that makes staying in this conversation easy.",
    "You just confirmed every good instinct I had about you.",
    "I think this conversation just got considerably more interesting.",
    "Good. I was hoping you'd be exactly this easy to talk to.",
  ],
  'poetic': [
    "That answer read like the better half of a sentence I didn't expect.",
    "There's a quiet weight to that reply I wasn't ready for.",
    "I think you just said more in that answer than the words alone carried.",
    "That response felt like the kind of line worth underlining.",
    "You answer like someone who chooses words carefully, on purpose.",
    "I think I'd like to hear the rest of whatever that answer was the start of.",
    "That reply had more music to it than I expected.",
    "You just turned a simple question into something worth remembering.",
    "I think that answer might stay with me longer than I'd planned.",
    "There's a softness to how you respond that I find genuinely striking.",
  ],
};

/// Genuine, warmer questions for once a conversation is already flowing —
/// distinct in register from pickup lines. These are meant to deepen an
/// existing conversation, not open one, so they read more like real
/// curiosity than performance. Loosely inspired by the "36 Questions to
/// Fall in Love" tradition of escalating, sincere questions, kept light
/// enough for an early conversation rather than a first date deep-dive.
final Map<String, List<String>> kDeeperLines = {
  'romantic': [
    "What's a small thing that instantly makes you feel like yourself again?",
    "Is there a place you go back to in your memory a lot?",
    "What's something you used to believe about love that you don't anymore?",
    "What does a really good day look like for you, start to finish?",
    "What's a song that means more to you than it probably should?",
    "What's something you're quietly proud of that most people wouldn't guess?",
    "What's a memory you'd want to relive exactly as it happened?",
    "What's something you've never told anyone you just met?",
  ],
  'funny': [
    "What's the most ridiculous thing you've ever been genuinely confident about?",
    "What's a hill you'll die on that has zero practical importance?",
    "What's the worst advice you've ever taken seriously?",
    "What's a weirdly specific thing you're irrationally good at?",
    "What's the most embarrassing thing you've ever said with total confidence?",
    "What's a food combination you'll defend to the death?",
    "What's the dumbest reason you've ever stayed up until 3am?",
    "What's a conspiracy theory you secretly find a little compelling?",
  ],
  'light': [
    "What's something simple that always puts you in a good mood?",
    "What's your idea of a perfect lazy Sunday?",
    "What's a small thing you appreciate that most people overlook?",
    "What's something you're genuinely looking forward to right now?",
    "What's a comfort show or song you go back to on repeat?",
    "What's something that made you smile this week?",
    "What's your go-to order when you don't want to think about it?",
    "What's a tiny habit that makes your day better?",
  ],
  'playful': [
    "What's something you're weirdly competitive about?",
    "What's a rule you break on purpose, just a little?",
    "What's the most chaotic thing you've done for fun recently?",
    "What's your most useless but impressive party trick?",
    "What's a game you take way more seriously than you should?",
    "What's something you'd 100% do on a dare?",
    "What's the boldest thing you've done this year?",
    "What's a trend you actually committed to, no shame?",
  ],
  'classy': [
    "What's something you consider yourself genuinely particular about?",
    "What's a habit or ritual you take seriously, even if it's small?",
    "What's something you've put real effort into mastering?",
    "What's a place that left a lasting impression on you?",
    "What's something you appreciate that you think is underrated?",
    "What's a quality you admire most in the people you respect?",
    "What's something you've learned that changed how you see things?",
    "What's a tradition or routine that matters more to you than people realize?",
  ],
  'confident': [
    "What's something you decided to go all-in on, and don't regret?",
    "What's a moment you backed yourself when it would've been easier not to?",
    "What's something you're better at than you let on?",
    "What's a risk you took that paid off?",
    "What's something you changed your mind about and are glad you did?",
    "What's a goal you're actually working toward right now?",
    "What's something you're more confident about than most people expect?",
    "What's a decision you made fast that turned out right?",
  ],
  'shy': [
    "What's something you're more comfortable doing than talking about?",
    "What's a small thing that made your week a little better?",
    "What's something you wish more people asked you about?",
    "What's a place that feels the most like you?",
    "What's something you're quietly working on for yourself?",
    "What's a kindness someone showed you that you still think about?",
    "What's something that made you feel proud of yourself recently?",
    "What's a question you wish people asked more often?",
  ],
  'mysterious': [
    "What's something about you that surprises people once they know you?",
    "What's a part of your life you don't usually talk about right away?",
    "What's something you've changed your mind about completely?",
    "What's a question people rarely think to ask you?",
    "What's something you keep mostly to yourself, on purpose?",
    "What's a story you'd only tell someone you trusted?",
    "What's something you're still figuring out about yourself?",
    "What's a side of you that takes longer to show?",
  ],
  'spicy': [
    "What's something that instantly gets your attention in a person?",
    "What's a quality you find more attractive than people expect?",
    "What's something you find yourself drawn to without really planning to?",
    "What's a moment you felt the most like yourself, confidence-wise?",
    "What's something you find genuinely magnetic about someone?",
    "What's a small thing someone's done that completely caught your attention?",
    "What's something you can't help noticing about people?",
    "What's a feeling you chase more than you'd probably admit?",
  ],
  'oldschool': [
    "What's a tradition you wish more people still kept up?",
    "What's something you appreciate that feels a little out of fashion now?",
    "What's a quality you think doesn't get enough credit anymore?",
    "What's something from an earlier time you genuinely wish you'd experienced?",
    "What's a kind of gesture you think people don't make enough of these days?",
    "What's something timeless you think still holds up completely?",
    "What's a value you were raised with that still matters to you?",
    "What's something you'd want to do the old-fashioned way, on principle?",
  ],
  'nerdy': [
    "What's something you've gone unexpectedly deep into learning about?",
    "What's a topic you could talk about for an hour without noticing the time?",
    "What's a fact you bring up way more often than is socially necessary?",
    "What's something you taught yourself just out of curiosity?",
    "What's a hobby that's secretly more technical than people assume?",
    "What's the most niche thing you're genuinely passionate about?",
    "What's something you've gotten unreasonably good at for fun?",
    "What's a question you wish more people actually wanted to discuss?",
  ],
  'wholesome': [
    "What's something someone did for you that you still think about?",
    "What's a small kindness you try to practice regularly?",
    "What's something you're genuinely grateful for right now?",
    "What's a person who shaped who you are, and how?",
    "What's something you hope people remember about you?",
    "What's a value that matters more to you than most things?",
    "What's something kind you wish you'd said to someone, in hindsight?",
    "What's a quality in others you find yourself drawn to most?",
  ],
  'smooth': [
    "What's something you're genuinely good at that you don't lead with?",
    "What's a decision that worked out better than you expected?",
    "What's something you do differently than most people, on purpose?",
    "What's a moment you felt completely sure of yourself?",
    "What's something you've gotten more confident about over time?",
    "What's a habit that's quietly made your life better?",
    "What's something you've learned to stop overthinking?",
    "What's a small thing you do that you think sets you apart?",
  ],
  'poetic': [
    "What's a memory that still feels vivid, even years later?",
    "What's something beautiful you noticed recently that most people missed?",
    "What's a feeling you've never quite found the right words for?",
    "What's a place that felt like it meant something the moment you saw it?",
    "What's something ordinary that quietly means a lot to you?",
    "What's a moment you wish you could've slowed down?",
    "What's something that's stayed with you longer than you expected?",
    "What's a small detail about life you find yourself thinking about often?",
  ],
};

// ---------------------------------------------------------------------------
// Arc stage enum — Apple-style professional design tokens
// ---------------------------------------------------------------------------

/// The three stages of a Conversation Arc, in order.
enum ArcStage { opener, followUp, deeper }

extension ArcStageLabel on ArcStage {
  /// Short display label shown in the segmented control / tab bar.
  String get label => switch (this) {
    ArcStage.opener   => 'Opener',
    ArcStage.followUp => 'Follow-up',
    ArcStage.deeper   => 'Going Deeper',
  };

  /// One-line description shown beneath the label in the stage selector.
  String get description => switch (this) {
    ArcStage.opener   => 'Break the ice',
    ArcStage.followUp => 'Keep it going after a good reply',
    ArcStage.deeper   => 'Genuine questions once it\'s flowing',
  };

  // -------------------------------------------------------------------------
  // Icon — CupertinoIcons only; no emoji characters in the UI layer.
  // -------------------------------------------------------------------------

  /// SF Symbol / CupertinoIcon for this stage.
  ///
  /// Opener    → bubble.left          (starting a conversation)
  /// Follow-up → arrow.turn.down.right (continuing the thread)
  /// Deeper    → waveform             (flowing, deepening signal)
  IconData get icon => switch (this) {
    ArcStage.opener   => CupertinoIcons.chat_bubble,
    ArcStage.followUp => CupertinoIcons.arrow_turn_down_right,
    ArcStage.deeper   => CupertinoIcons.waveform,
  };

  // -------------------------------------------------------------------------
  // Color — Apple system palette; no pink, no purple.
  //
  //   opener   : #007AFF  iOS system blue   — initiating, primary action
  //   followUp : #32ADE6  iOS system cyan   — continuation, secondary blue
  //   deeper   : #636366  iOS label/secondary gray — settled, substantive
  // -------------------------------------------------------------------------

  /// Accent color for this stage, expressed as a Flutter [Color].
  Color get accentColor => switch (this) {
    ArcStage.opener   => const Color(0xFF007AFF),
    ArcStage.followUp => const Color(0xFF32ADE6),
    ArcStage.deeper   => const Color(0xFF636366),
  };
}

// ---------------------------------------------------------------------------
// Line retrieval
// ---------------------------------------------------------------------------

/// Returns a randomized pool of lines for the given stage + category.
/// For [ArcStage.opener], this defers to the main offline line bank
/// (including personalization) so the opener stage is identical to the
/// regular generator experience. Follow-up and deeper lines don't carry
/// name/trait personalization — they're written to work as general
/// continuations regardless of who's on the other end.
List<String> shuffledArcLinesFor(
    ArcStage stage,
    String categoryId, {
      String? name,
      String? trait,
    }) {
  switch (stage) {
    case ArcStage.opener:
      return shuffledLinesFor(categoryId, name: name, trait: trait);
    case ArcStage.followUp:
      final lines = List<String>.from(kFollowUpLines[categoryId] ?? const []);
      lines.shuffle();
      return lines;
    case ArcStage.deeper:
      final lines = List<String>.from(kDeeperLines[categoryId] ?? const []);
      lines.shuffle();
      return lines;
  }
}