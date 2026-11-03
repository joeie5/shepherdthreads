import '../constants/app_images.dart';
import '../models/content.dart';

/// Ported from react-source/src/data/journal.ts
final journalPosts = <JournalPost>[
  JournalPost(
    slug: 'clothed-in-purpose',
    title: 'Clothed in Purpose: Why We Make Garments That Last',
    category: JournalCategory.behindTheSeams,
    excerpt:
        'Fast fashion asks us to forget what we bought last season. We want to make the kind of hoodie you hand down.',
    image: AppImages.workshop,
    author: 'Daniel Okafor',
    date: 'October 28, 2026',
    readTime: '6 min read',
    featured: true,
    body: const [
      'When we started Shepherds Thread, we made a promise to ourselves before we made a single garment: nothing would leave our studio that we wouldn’t be proud to see on someone ten years from now.',
      'That promise changes everything about how a piece is made. It means 480gsm fleece instead of 300. It means ribbing that is knit, not cut. It means paying the families who sew our garments a wage that lets them rest on the Sabbath.',
      'Scripture is full of craftspeople. Bezalel was filled with the Spirit of God “in wisdom, in understanding, in knowledge, and in all manner of workmanship.” We take that seriously. Good work is a form of worship.',
      'So when you feel the weight of one of our hoodies, know that the weight is intentional. It is there so that it lasts — through seasons, through washes, through whatever God is walking you through.',
    ],
    pullQuote: const PullQuote(
      text: 'And whatever you do, work heartily, as for the Lord and not for men.',
      reference: 'Colossians 3:23',
    ),
  ),
  JournalPost(
    slug: 'psalm-23-in-the-everyday',
    title: 'Psalm 23 in the Everyday',
    category: JournalCategory.devotional,
    excerpt: 'Six verses that have carried people through every kind of valley. A slow read for a busy week.',
    image: AppImages.journalBible,
    author: 'Ruth Adeyemi',
    date: 'October 19, 2026',
    readTime: '8 min read',
    body: const [
      'Psalm 23 is often read at funerals, but it was written for the living. It is a song for the ordinary Tuesday as much as the darkest valley.',
      '“The Lord is my shepherd; I shall not want.” Before David names a single blessing, he names a relationship. Everything that follows flows from being known and led.',
      'This week, try reading one verse each morning. Sit with it before you open your phone. Notice where it meets you.',
    ],
    pullQuote: const PullQuote(text: 'He restores my soul.', reference: 'Psalm 23:3'),
  ),
  JournalPost(
    slug: 'layering-the-good-shepherd-hoodie',
    title: 'Three Ways to Layer the Good Shepherd Hoodie This Fall',
    category: JournalCategory.style,
    excerpt: 'Under a chore coat, over a long sleeve, or simply on its own — a guide to our heaviest piece.',
    image: AppImages.lookbookSteps,
    author: 'Marcus Lee',
    date: 'October 10, 2026',
    readTime: '4 min read',
    body: const [
      'The Good Shepherd Hoodie was designed to be the backbone of a cold-weather wardrobe. Its boxy fit leaves room underneath and sits cleanly under outerwear.',
      'Start with the Narrow Path Long Sleeve underneath and let the cuffs show. Add straight-leg trousers and a clean leather sneaker.',
      'For colder days, size up and wear it under a waxed or wool chore coat. The double-layer hood sits neatly over the collar.',
    ],
  ),
  JournalPost(
    slug: 'the-quiet-week',
    title: 'The Quiet Week: A Five-Day Sabbath Practice',
    category: JournalCategory.devotional,
    excerpt: 'Rest is not a reward for finishing. It is a rhythm God built into creation itself.',
    image: AppImages.lookbookField,
    author: 'Ruth Adeyemi',
    date: 'September 30, 2026',
    readTime: '7 min read',
    body: const [
      'We designed the Sabbath collection after a season of burnout in our own team. We were making clothes about rest while running ourselves ragged.',
      'Here is the five-day practice that helped us return to a healthier rhythm: one small act of stopping each day, building toward a full day set apart.',
    ],
    pullQuote: const PullQuote(text: 'Be still, and know that I am God.', reference: 'Psalm 46:10'),
  ),
  JournalPost(
    slug: 'hands-behind-the-thread',
    title: 'Meet the Hands Behind the Thread',
    category: JournalCategory.behindTheSeams,
    excerpt: 'A visit to the family-run workshop in Porto that knits and sews our fleece.',
    image: AppImages.lookbookDetail,
    author: 'Daniel Okafor',
    date: 'September 14, 2026',
    readTime: '5 min read',
    body: const [
      'The Silva family has been knitting fleece outside Porto for three generations. When we first visited, Maria Silva showed us the machines her grandfather bought in 1971.',
      'Every Shepherds Thread fleece passes through their hands. We visit twice a year, and we pray with them every time.',
    ],
  ),
  JournalPost(
    slug: 'faith-on-the-rooftop',
    title: 'Community Notes: Faith on the Rooftop',
    category: JournalCategory.community,
    excerpt: 'How a Thursday night Bible study in Atlanta grew from four friends to forty.',
    image: AppImages.community,
    author: 'Marcus Lee',
    date: 'August 29, 2026',
    readTime: '5 min read',
    body: const [
      'It started with four friends, a folding table, and a rooftop nobody else used. Two years later, forty people gather every Thursday.',
      'We sat down with the group to talk about community, doubt, and why they keep showing up.',
    ],
  ),
];
