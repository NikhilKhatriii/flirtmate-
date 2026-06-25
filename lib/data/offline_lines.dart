/// A large, hand-curated bank of flirt lines for every category, written
/// in a consistently polished, high-class register — witty and confident
/// without ever tipping into crude or juvenile territory — plus
/// lightweight personalization support.
///
/// This is the app's default content source — it works completely offline,
/// for free, with zero setup. The optional AI service (see api_service.dart)
/// can be layered on top for users who want truly infinite, ever-fresh lines,
/// but the app is fully functional and enjoyable without it.
///
/// PERSONALIZATION
/// ----------------
/// Two independent, optional inputs make every line feel custom:
///   - A first NAME ("Sam", "Priya") — woven into the line naturally using
///     a handful of different sentence patterns, picked at random, instead
///     of being awkwardly bolted onto every single line the same way.
///   - A TRAIT / interest ("loves hiking", "plays guitar", "is a nurse") —
///     when provided, a second bank of trait-aware lines (with a {trait}
///     slot) gets mixed in alongside the regular lines, so the trait
///     actually shows up in the content rather than just being decorative.
///
/// Both inputs are entirely optional. With neither set, the app behaves
/// exactly as before.
library;

final Map<String, List<String>> kOfflineLines = {
  'romantic': [
    "If I could rearrange the alphabet, I'd put U and I together.",
    "Every love story is beautiful, but ours would be my favorite.",
    "You must be made of stardust — that's the only way I can explain the way you light up a room.",
    "I didn't believe in fate until I met you.",
    "Some people search a lifetime for what I found the moment I saw you.",
    "You're the reason I look forward to tomorrow.",
    "Being with you feels like coming home to a place I've never been.",
    "I never knew what it meant to miss someone until I met you.",
    "You're the missing piece I didn't know my heart was looking for.",
    "My heart finds a quieter rhythm whenever your name appears on my screen.",
    "I'd cross oceans just to see you smile.",
    "You're not just in my thoughts — you're the whole atmosphere.",
    "Loving you feels like the easiest thing I've ever done.",
    "If I had a star for every time you brightened my day, I'd have a whole galaxy.",
    "You make ordinary moments feel like the beginning of a love story.",
    "Every road eventually leads back to you, somehow.",
    "I think I fell for you the moment you laughed at your own joke.",
    "There's a particular kind of peace that only seems to exist when you're near.",
    "I find myself composing entire conversations with you in my head before I've even said hello.",
    "You have a way of making the future feel like something worth looking forward to.",
    "Some people are remembered. You're the kind that's never quite forgotten.",
  ],
  'funny': [
    "I was going to open with something clever, but you're a little too distracting for that.",
    "Fair warning — I'm significantly more charming once the nerves wear off.",
    "I'd pretend I wasn't staring, but we both already know that ship has sailed.",
    "Is it just me, or did the room get noticeably more interesting in the last thirty seconds?",
    "I came over here with a plan. You walked by and the plan left with you.",
    "I'm fairly confident this is the best decision I've made all week, and I haven't even introduced myself yet.",
    "On a scale of one to ten, I'd put this conversation at a solid 'worth the risk.'",
    "You have the kind of smile that makes people forget what they were about to say. Case in point: me, right now.",
    "I'll be honest — I rehearsed a better line than this and still managed to forget it.",
    "Apparently my best strategy was just to walk over and hope for the best.",
    "I'm convinced you know exactly what that expression does to people.",
    "If charm were a currency, I'd be bankrupt right now trying to keep up with you.",
    "I had a whole plan for this conversation. You've already thrown it off completely.",
    "You seem like the kind of person who causes problems for people trying to focus on anything else.",
    "I'll admit it: I've been working up the nerve to say hello for longer than I'd like to admit.",
    "Something tells me this conversation is going to ruin my productivity for the rest of the day.",
    "I'm not usually this forward, but you've made it very difficult to stick to my usual plan.",
    "You walked in and several conversations around the room noticeably lost momentum.",
    "I promise my opening lines are usually less obvious than 'I had to come say hello.'",
    "I don't know what it is about you, but my train of thought just left the station.",
    "Honestly, I came over here with zero plan beyond not regretting staying quiet.",
  ],
  'light': [
    "You have the kind of smile that makes a regular day feel a little brighter.",
    "I like how easy it is to talk to you.",
    "You seem like the kind of person who makes everything more enjoyable.",
    "There's something genuinely comforting about your energy.",
    "I noticed you across the room and just had to come say hello.",
    "You have a calm, easy presence — the kind that's surprisingly rare.",
    "I think you might be the most interesting person I've spoken with all week.",
    "Your laugh is honestly contagious.",
    "I just wanted to mention that you brightened my day a little.",
    "You carry a kind of warmth that's hard not to notice.",
    "I have a feeling we'd get along really well.",
    "It's rare to meet someone who's this easy to talk to.",
    "You seem like someone genuinely worth getting to know better.",
    "I like your energy — it's refreshing.",
    "There's a kindness about you that comes across almost immediately.",
    "Talking to you feels surprisingly effortless.",
    "You're the kind of person people remember after a single conversation.",
    "Something about this conversation already feels like the best part of my day.",
    "I don't say this often, but you have wonderful energy.",
    "You make it very easy to want to keep talking.",
    "I think you just made an otherwise ordinary day feel a little more interesting.",
  ],
  'playful': [
    "Careful — keep smiling like that and I might just have to talk to you.",
    "I'd ask if you come here often, but I think I'd remember a face like that.",
    "Are you always this much trouble, or am I just fortunate today?",
    "I was going to play it cool, but then you showed up and ruined the plan entirely.",
    "Fair warning: I'm considerably more charming once you get to know me.",
    "You're cute when you think you're winning this conversation.",
    "I see you over there, pretending not to notice me noticing you.",
    "That smile is a little too dangerous for a Tuesday — just saying.",
    "I'm half-convinced you practice that expression in the mirror.",
    "You've got a face that's genuinely hard to ignore. Trust me, I tried.",
    "I'm fairly sure you just broke an unspoken rule about being this distracting in public.",
    "I'll be honest, I came over here with zero plan beyond 'say something.'",
    "You strike me as someone who's trouble in the best possible way.",
    "I was minding my own business until you decided to be this interesting.",
    "Something tells me you already know exactly the effect you have on a room.",
    "I'd play hard to get, but we both know that ship has long since sailed.",
    "You seem dangerously good at making people forget their train of thought.",
    "I'm going to go ahead and blame you for whatever I forget to do today.",
    "You've got that look that says you already know how this conversation ends.",
    "I came over here fully intending to be subtle about this. So far, not going well.",
  ],
  'classy': [
    "It would be my privilege to know your name.",
    "You carry yourself with a grace that's hard not to notice.",
    "Allow me to say — you have impeccable taste, starting with that smile.",
    "I find myself drawn to people of genuine elegance, and you have it in abundance.",
    "There's a certain timeless quality to you that I find quite captivating.",
    "If charm were currency, you'd be remarkably wealthy.",
    "I don't often find myself this intrigued by someone I've only just met.",
    "You have the kind of presence that quietly commands a room.",
    "Might I say, you wear confidence exceptionally well.",
    "It's refreshing to meet someone with both beauty and genuine substance.",
    "You strike me as someone with excellent taste and even better stories.",
    "I'd very much like the pleasure of your conversation this evening.",
    "There's something quietly magnetic about the way you carry yourself.",
    "I imagine you're just as captivating in conversation as you are at first glance.",
    "Your elegance is the kind that never seems to try very hard — and that's precisely the appeal.",
    "It's rare to come across someone who makes a room feel more composed simply by entering it.",
    "I find a certain kind of restraint far more compelling than anything loud, and you embody it well.",
    "There's a quiet sophistication to you that's immediately apparent.",
    "You have the rare gift of making conversation feel like an occasion.",
    "I suspect you're the kind of person whose company improves any room you're in.",
    "Allow me to admit — you've made a stronger first impression than most people manage in an hour.",
  ],
  'confident': [
    "I don't usually do this, but you're worth the exception.",
    "I noticed you the second I walked in — figured I'd stop pretending I hadn't.",
    "I make it a habit to speak with the most interesting person in the room.",
    "I'm not one for games, so I'll just say it plainly: I think you're remarkable.",
    "Most people overthink this moment. I'd rather simply enjoy it.",
    "I came over here because I trust my instincts, and they pointed directly at you.",
    "I don't believe in letting good moments pass me by — this is one of them.",
    "You caught my attention, and that doesn't happen as often as you'd think.",
    "I'm direct by nature: I think you're striking, and I wanted you to know it.",
    "Life's too short not to say hello to someone who stands out the way you do.",
    "I figured the most honest opening line is simply that you're the best part of my day so far.",
    "I don't need a clever line — I just wanted the chance to meet you.",
    "Confidence is knowing when something's worth pursuing. This, clearly, is.",
    "I'd rather take the chance and say hello than spend the evening wondering.",
    "I tend to trust first impressions, and mine of you was an excellent one.",
    "I'm not interested in subtlety tonight — I simply wanted to meet you.",
    "I don't often approach strangers, but you made the decision remarkably easy.",
    "Some opportunities are worth being direct about. This is one of them.",
    "I'd rather risk an awkward hello than the certainty of never knowing.",
    "I noticed you, decided not to overthink it, and walked over. Simple as that.",
    "I'm rarely this sure of a first impression — yours earned it.",
  ],
  'shy': [
    "Hello — I've been working up the courage to say that for longer than I'd like to admit.",
    "Forgive me if this feels a touch awkward; I simply wanted to say hello.",
    "I practiced this several times in my head and still feel nervous saying it.",
    "I don't usually do this, but you seemed worth the nerves.",
    "This may be obvious, but I think you're genuinely lovely.",
    "I hope this doesn't come across oddly — I just had to say something.",
    "My heart is, admittedly, racing a little more than I'd like right now.",
    "I've been glancing over for the better part of ten minutes, gathering the nerve.",
    "Forgive the nerves — you're simply easy to notice.",
    "I didn't know exactly what to say, I just didn't want to stay quiet.",
    "This might be the most nervous I've been all week, if I'm honest.",
    "I nearly didn't come over, but I'm glad I did.",
    "I hope I'm not intruding — I just think you're genuinely kind.",
    "Forgive me if I stumble over my words; you're a little distracting.",
    "I don't say this often, but you make it difficult to stay composed.",
    "I've rewritten this greeting in my head more times than I'd care to admit.",
    "I'm not usually this nervous meeting someone — you're clearly an exception.",
    "I hope it isn't too forward to admit I noticed you before working up the nerve to say so.",
    "Apologies if I seem a little flustered — that's entirely your doing.",
    "I almost talked myself out of this, but I'm glad I didn't.",
  ],
  'mysterious': [
    "There's a story behind that smile, and I intend to discover what it is.",
    "Some people are easy to read. You're a puzzle I'd rather enjoy solving.",
    "I have a feeling you're not quite who you appear to be — in the best possible way.",
    "There's something about you that lingers long after you've walked away.",
    "You carry secrets well. I find that rather intriguing.",
    "I sense there's considerably more to you than meets the eye.",
    "You move like someone who knows things they're choosing not to share.",
    "Not everyone earns a second glance from me. You did.",
    "I don't typically chase mysteries, but I might make an exception for you.",
    "There's a quiet intensity about you that's difficult to look away from.",
    "I have a feeling our paths crossing tonight wasn't entirely accidental.",
    "Some people light up a room. You make it go quiet in the best way.",
    "I find myself wondering what's behind that particular look in your eyes.",
    "You give off the unmistakable air of someone with a story worth hearing.",
    "There's a deliberateness to the way you carry yourself that I find compelling.",
    "I suspect the version of you I'm meeting tonight is only the surface.",
    "You have the kind of composure that suggests there's far more beneath it.",
    "I rarely feel curious about a stranger this quickly. You're the exception.",
    "There's an unspoken depth to you that I find difficult to ignore.",
    "Something tells me you reveal yourself slowly, and deliberately. I don't mind waiting.",
  ],
  'spicy': [
    "I haven't been able to stop thinking about you since the moment I saw you.",
    "You have a way of making the room feel considerably warmer than it actually is.",
    "I'd be lying if I said I wasn't a little distracted by you right now.",
    "There's something about the way you look at me that I can't quite shake.",
    "I think you know precisely what that smile does to people.",
    "You're the kind of trouble I wouldn't mind getting into.",
    "I keep losing my train of thought every time you glance over here.",
    "Something about tonight feels like it's leading somewhere rather interesting.",
    "I'd ask what you're doing later, but I have a feeling I already want to find out.",
    "You walked in, and the entire temperature in here seemed to change.",
    "I don't get caught off guard often. You're the exception tonight.",
    "There's a tension in the air that I don't think either of us is imagining.",
    "I'm finding it surprisingly difficult to focus on anything but you right now.",
    "You have a presence that's nearly impossible to ignore — and I've stopped trying.",
    "I don't think you realize the effect you're having on this entire room.",
    "There's a particular kind of magnetism to you that I find hard to resist.",
    "I'd choose my words more carefully if you weren't making it so difficult to think clearly.",
    "Something about the way this evening is unfolding feels entirely deliberate.",
    "I don't believe in coincidences, but I'm willing to make an exception for whatever's happening right now.",
    "You have a way of making patience feel like a genuinely difficult virtue tonight.",
    "I'd say I'm playing it cool, but we both know that stopped being true a few minutes ago.",
  ],
  'oldschool': [
    "My dearest, your smile is a melody I would gladly listen to forever.",
    "If I could write you a letter every day, I would never run out of things to say.",
    "You are the kind of beauty poets once devoted entire volumes to.",
    "Allow me this old-fashioned confession: I am quite taken with you.",
    "In another time, I would have written you a love letter by candlelight tonight.",
    "You possess a charm that feels almost out of place in this modern world — wonderfully so.",
    "My heart, though old-fashioned, beats rather quickly in your presence.",
    "There is something timeless about you, like a song that never goes out of style.",
    "I find myself wishing to court you properly, the way it once was done.",
    "If chivalry still has a place in this world, allow me to show you mine.",
    "You remind me that romance, done well, never truly goes out of fashion.",
    "Permit me to say that meeting you feels like stepping into a far gentler age.",
    "I find myself composing the kind of compliments one rarely hears anymore, entirely on your behalf.",
    "There is an old-world elegance to you that modern conversation rarely affords.",
    "I would happily trade a thousand modern conveniences for one proper evening spent in conversation with you.",
    "You inspire the sort of devotion that used to be written into sonnets.",
    "Allow me the pleasure of treating this evening with the formality it clearly deserves.",
    "I suspect you'd have been the subject of considerable correspondence in another era.",
    "There's a graciousness to you that belongs to a much older, much kinder world.",
    "If I may be old-fashioned for a moment — it would be my honor to walk you home.",
  ],
  'nerdy': [
    "I must be near a singularity, because time seems to slow whenever I look at you.",
    "If you were a function, you'd be continuous — I can't find a single discontinuity in your perfection.",
    "There's a certain elegance to you that reminds me of a well-proven theorem.",
    "I'd compare you to a rare element, but even the periodic table doesn't have anything quite like you.",
    "You're the only variable in this room I'm having trouble solving for.",
    "I'd say you're out of this world, but Newton's laws insist you'll have to come back down eventually.",
    "If I were an electron and you were a proton, the attraction would be entirely justified.",
    "You're like a perfectly optimized algorithm — efficient, elegant, and remarkably hard to improve on.",
    "I've recalculated the odds of meeting someone like you several times, and they remain delightfully unlikely.",
    "There's a precision to the way you carry yourself that I find quietly impressive.",
    "You have the rare quality of being both logically sound and entirely captivating.",
    "I suspect you'd test exceptionally well under any rigorous peer review.",
    "If charm had a unit of measurement, you'd require an entirely new scale.",
    "You're the kind of anomaly that makes the data considerably more interesting.",
    "I don't usually get this distracted mid-equation, but here we are.",
    "There's an undeniable symmetry to you that's hard not to admire.",
    "You strike me as a particularly elegant solution to an otherwise ordinary evening.",
    "I'd hypothesize that you're this composed in every room you enter — feel free to confirm.",
    "You have the kind of clarity of thought that's genuinely rare to come across.",
    "If I'm being precise, you're the most interesting variable I've encountered all week.",
  ],
  'wholesome': [
    "You deserve every good thing headed your way today.",
    "I just want you to know that you matter, more than you probably realize.",
    "The world is genuinely better with people like you in it.",
    "You have a way of making people feel seen — that's rare.",
    "I hope someone reminds you today how genuinely special you are.",
    "You're doing better than you give yourself credit for.",
    "Your kindness likely reaches more people than you know.",
    "I'm grateful our paths crossed, even if only for this moment.",
    "You bring a kind of warmth that's difficult to fake.",
    "Whatever you're working through, I believe you'll come out of it fine.",
    "You deserve someone who notices all the small, meaningful things about you.",
    "The way you treat people says a great deal, and it says good things.",
    "I hope you know how much brighter you make things simply by being yourself.",
    "You strike me as someone who quietly makes other people's days better.",
    "There's a generosity in how you carry yourself that doesn't go unnoticed.",
    "I think the people closest to you are fortunate to have you.",
    "You have the kind of presence that puts people at ease almost instantly.",
    "Whatever good things come your way, you've clearly earned them.",
    "I admire how genuinely you seem to care about the people around you.",
    "You make it easy to believe good people are still out there.",
    "I hope today treats you as kindly as you tend to treat others.",
  ],
  'smooth': [
    "They say the best things in life are unexpected — like running into you.",
    "I don't typically believe in luck, but meeting you tonight is changing my mind.",
    "You walked in, and the room's lighting suddenly seemed to improve.",
    "I'll keep this simple — you're the most interesting person here, and I noticed immediately.",
    "Most people try too hard. I simply figured I'd say hello.",
    "I have a feeling this conversation will be the best part of my night.",
    "You've got that effortless quality going for you — I respect that.",
    "I don't do small talk, so let's skip directly to the good part.",
    "Some people make an entrance. You made the entire room.",
    "I'll be honest — I don't often approach someone, but you made that decision easy.",
    "You've got a calm confidence that's genuinely rare to come across.",
    "I'd call this fate, but I'll leave that determination up to you.",
    "I tend to notice quality immediately, and you're a particularly good example of it.",
    "There's a certain ease to how you carry a conversation — I find that quite appealing.",
    "I imagine most rooms feel a little duller once you've left them.",
    "You have a way of making an ordinary evening feel considerably more promising.",
    "I don't say this lightly, but you might be the best part of my week so far.",
    "Something tells me you're used to having this effect on a room.",
    "I'd say this was a coincidence, but I'm choosing to call it good timing instead.",
    "You make it remarkably easy to want to stay exactly where I am.",
  ],
  'poetic': [
    "You are the quiet hour between midnight and dawn, when everything feels possible.",
    "If silence had a shape, it would resemble the space between your words and mine.",
    "You move through the world like a line of verse no one has finished writing yet.",
    "There is a softness to you that even language struggles to hold.",
    "You are the kind of beautiful that doesn't ask to be noticed, yet always is.",
    "Some people are sentences. You are an entire unfinished poem.",
    "I think you were written into existence by someone who believed deeply in metaphor.",
    "Your presence reads like the final page of a book you didn't want to end.",
    "There's a rhythm to the way you speak, as though you were born already knowing the words.",
    "You are proof that some things are beautiful simply because they exist.",
    "If I were a poet, you'd be the muse I never quite manage to describe well enough.",
    "You carry yourself like a sentence that knows exactly where it's headed.",
    "There's a quiet music to the way you move through a room.",
    "I think the right words for you haven't been written yet — only suggested at.",
    "You feel like the kind of chapter a reader slows down for, just to make it last.",
    "There's a stillness in you that feels like the calm just before something beautiful begins.",
    "You read like poetry written by someone who never needed to try very hard.",
    "I suspect the best version of tonight is the one where I simply keep listening to you.",
    "You have the kind of presence that turns an ordinary evening into something worth remembering.",
    "If language could capture you fully, I imagine it would stop trying to describe anything else.",
  ],
};

/// Trait-aware bonus lines, per category. The `{trait}` token is filled in
/// with whatever the user typed (e.g. "loves hiking", "plays guitar").
/// These only get mixed into the rotation when the user has actually
/// entered a trait — otherwise they're skipped entirely.
final Map<String, List<String>> kTraitLines = {
  'romantic': [
    "Someone who {trait} was always going to be the one who caught my eye.",
    "I have a particular fondness for people who {trait} — it turns out that fondness runs quite deep for you.",
    "Of all the things about you, the fact that you {trait} might be my favorite.",
  ],
  'funny': [
    "So you {trait}? That's either remarkably impressive or a wonderful icebreaker — I'll let you decide.",
    "I heard you {trait}. I've chosen to be charmed rather than intimidated.",
    "You {trait} and you're still talking to me? Today is full of pleasant surprises.",
  ],
  'light': [
    "It's genuinely nice that you {trait} — that says a lot about you.",
    "I think it's rather sweet that you {trait}, honestly.",
    "Someone who {trait} is automatically a little more interesting to me.",
  ],
  'playful': [
    "Oh, you {trait}? Showing off a little, aren't we.",
    "I see you over there, casually being the kind of person who {trait}.",
    "You {trait}? Careful — that's a rather attractive thing to admit.",
  ],
  'classy': [
    "A person who {trait} carries a certain distinction — you, evidently, included.",
    "It takes a particular kind of person to {trait}. I find that rather compelling.",
    "There's something quite admirable about someone who {trait}.",
  ],
  'confident': [
    "You {trait}? That's precisely the kind of thing that earns my attention.",
    "I don't impress easily, but you {trait}, and here we are.",
    "People who {trait} tend to stand out to me. You especially.",
  ],
  'shy': [
    "I, um, heard you {trait} — that's genuinely impressive, by the way.",
    "Is it strange that knowing you {trait} made me even more nervous to speak with you?",
    "I don't know much yet, but I know you {trait}, and I think that's lovely.",
  ],
  'mysterious': [
    "Someone who {trait} always has more layers than they let on. I'd like to see yours.",
    "I find people who {trait} difficult to read, in the best possible way.",
    "You {trait} — I suspect that's not even the most interesting thing about you.",
  ],
  'spicy': [
    "Knowing you {trait} is doing nothing to help me stop thinking about you.",
    "There's something about someone who {trait} that I find genuinely hard to ignore.",
    "You {trait}? That's an unfairly attractive detail to share with me right now.",
  ],
  'oldschool': [
    "A person who {trait} would have been quite the catch in any era, I imagine.",
    "They don't make many like you — someone who {trait} and still this charming.",
    "I find myself rather taken with the fact that you {trait}.",
  ],
  'nerdy': [
    "You {trait}? My interest just increased by a statistically significant margin.",
    "Someone who {trait} is, by any reasonable measure, running premium content.",
    "I calculated the odds of meeting someone who {trait}, and somehow you beat them.",
  ],
  'wholesome': [
    "The fact that you {trait} makes me admire you even more.",
    "People who {trait} make the world a little better simply by being in it.",
    "I think it's genuinely wonderful that you {trait}.",
  ],
  'smooth': [
    "You {trait}? Of course you do — that tracks entirely.",
    "I should have guessed someone like you would {trait}.",
    "Someone who {trait} was always going to catch my attention eventually.",
  ],
  'poetic': [
    "You {trait} the way some people breathe — quietly, naturally, as if it were always meant to be part of you.",
    "There's a kind of poetry in someone who {trait}, even if they don't see it themselves.",
    "I think the fact that you {trait} says more about your soul than you realize.",
  ],
};

/// Different natural ways to weave a first name into a line. Picked at
/// random so the same name doesn't always land in the same spot.
/// `{base}` is replaced with the original line.
List<String> _nameTemplates(String name) => [
  "$name, {base}",
  "{base} I mean that, $name.",
  "Hey $name — {base}",
  "{base} That's just how I see it, $name.",
  "I have to say, $name — {base}",
];

String _lowerFirst(String s) =>
    s.isEmpty ? s : s[0].toLowerCase() + s.substring(1);

/// Applies optional name + trait personalization to a single line.
///
/// - If [trait] is provided and a trait-aware line was picked, the
///   `{trait}` token is simply substituted in.
/// - If [name] is provided, the line is woven into one of a few natural
///   sentence patterns at random — never the exact same pattern every time.
/// - With neither set, the line is returned completely unchanged.
String personalize(String line, {String? name, String? trait}) {
  var result = line;

  if (trait != null && trait.trim().isNotEmpty && result.contains('{trait}')) {
    result = result.replaceAll('{trait}', trait.trim());
  }

  final trimmedName = name?.trim();
  if (trimmedName != null && trimmedName.isNotEmpty) {
    final templates = _nameTemplates(trimmedName);
    final pattern = templates[(result.length + trimmedName.length) % templates.length];
    // Decide whether this particular pattern needs the line's first
    // letter lowercased (i.e. when it's being inserted mid-sentence).
    final needsLowerFirst = pattern.startsWith('$trimmedName, ') ||
        pattern.startsWith('Hey $trimmedName — ') ||
        pattern.startsWith('I have to say, $trimmedName — ');
    final base = needsLowerFirst ? _lowerFirst(result) : result;
    result = pattern.replaceAll('{base}', base);
  }

  return result;
}

/// Returns a randomized, personalized pool of lines for a category.
///
/// When [trait] is provided, a handful of trait-aware lines (with the
/// trait substituted in) are mixed into the regular pool so the rotation
/// still feels varied rather than repeating the same 2-3 trait lines.
/// When [name] is provided, every line in the returned pool is woven
/// through one of the natural name-insertion patterns.
List<String> shuffledLinesFor(String categoryId, {String? name, String? trait}) {
  final base = List<String>.from(kOfflineLines[categoryId] ?? const []);
  final traitPool = kTraitLines[categoryId] ?? const [];

  final pool = <String>[...base];

  final trimmedTrait = trait?.trim();
  if (trimmedTrait != null && trimmedTrait.isNotEmpty && traitPool.isNotEmpty) {
    // Mix in trait lines a few times each so they appear more than once
    // across a session without dominating the rotation.
    for (final t in traitPool) {
      pool.add(t);
      pool.add(t);
    }
  }

  pool.shuffle();

  return pool
      .map((line) => personalize(line, name: name, trait: trimmedTrait))
      .toList();
}
