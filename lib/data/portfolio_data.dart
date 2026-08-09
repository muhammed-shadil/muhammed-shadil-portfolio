import 'package:flutter/material.dart';

import '../models/content_models.dart';
import '../models/project.dart';

/// ---------------------------------------------------------------------------
/// ALL SITE CONTENT LIVES HERE.
///
/// Nothing in `lib/sections` or `lib/widgets` hard-codes a name, a URL or a
/// sentence — edit this file to update the portfolio and the UI follows.
/// ---------------------------------------------------------------------------
abstract final class PortfolioData {
  // ==========================================================================
  // IDENTITY
  // ==========================================================================
  static const String name = 'Muhammed Shadil';
  static const String shortName = 'Shadil';
  static const String initials = 'MS';
  static const String role = 'Senior Flutter Developer';
  static const String roleShort = 'Flutter Developer';
  static const String location = 'Calicut, Kerala, India';
  static const String email = 'muhammedshadil220@gmail.com';
  static const String phone = '+91 7025510522';
  static const String yearsExperience = '2.5+';

  /// Hero headline. The words listed in [heroHighlight] are painted with the
  /// accent gradient wherever they appear in this string.
  static const String heroHeadline =
      'Building beautiful, scalable digital experiences.';
  static const String heroHighlight = 'scalable';

  static const String heroDescription =
      'I build production-ready mobile and web applications with Flutter — '
      'wired to Firebase, REST APIs, payment gateways, real-time communication '
      'and interfaces people actually enjoy using.';

  /// Rotating words in the hero sub-line.
  static const List<String> heroRoles = [
    'Flutter Developer',
    'Cross-platform Engineer',
    'UI/UX Enthusiast',
  ];

  static const String availability = 'Open to opportunities';

  // ==========================================================================
  // ABOUT
  // ==========================================================================
  static const String aboutTitle = 'Turning ideas into real products.';

  static const List<String> aboutParagraphs = [
    'I have $yearsExperience years of experience designing, building and '
        'deploying scalable, high-performance mobile applications in '
        'production. I work fluently in Dart with advanced state management — '
        'BLoC, GetX and Provider — and integrate REST APIs, Firebase and '
        'third-party SDKs such as ZegoCloud and Razorpay.',
    'I build on clean architecture patterns (MVC, MVVM), collaborate closely '
        'with design and backend teams, and mentor junior developers. So far '
        'that adds up to 10+ apps shipped to the Play Store and 7+ to the '
        'App Store.',
  ];

  /// Short capability list rendered as a two-column checklist in About.
  static const List<String> aboutCapabilities = [
    'Flutter & Dart',
    'State management',
    'Firebase & Firestore',
    'REST API integration',
    'Payment gateways',
    'Real-time communication',
    'Local storage & offline',
    'Play Store & App Store releases',
  ];

  static const List<StatItem> stats = [
    StatItem(
      value: 2.5,
      suffix: '+',
      label: 'Years of experience',
      icon: Icons.timeline_rounded,
    ),
    StatItem(
      value: 10,
      suffix: '+',
      label: 'Play Store releases',
      icon: Icons.shop_rounded,
    ),
    StatItem(
      value: 7,
      suffix: '+',
      label: 'App Store releases',
      icon: Icons.apple_rounded,
    ),
    StatItem(
      value: 0,
      isNumeric: false,
      text: 'Flutter',
      label: 'Primary stack',
      icon: Icons.flutter_dash_rounded,
    ),
  ];

  // ==========================================================================
  // LINKS
  // ==========================================================================
  static const String githubUrl = 'https://github.com/muhammed-shadil';
  static const String githubHandle = 'muhammed-shadil';
  static const String linkedinUrl =
      'https://www.linkedin.com/in/muhammed-shadil-45973a28b/';
  static const String instagramUrl =
      'https://www.instagram.com/shadi_k_muhammed/';
  static const String facebookUrl =
      'https://www.facebook.com/muhammed.shadil.7739';
  static const String resumeUrl =
      'https://drive.google.com/file/d/1jB_50LHw6y8C96wZRDvS5WIi2ewNpnZJ/view?usp=sharing';

  /// Google Drive direct-download form of [resumeUrl].
  static const String resumeDownloadUrl =
      'https://drive.google.com/uc?export=download&id=1jB_50LHw6y8C96wZRDvS5WIi2ewNpnZJ';

  static const String mailto = 'mailto:$email';
  static const String telUrl = 'tel:+917025510522';

  static const List<SocialLink> socials = [
    SocialLink(label: 'GitHub', handle: '@$githubHandle', url: githubUrl),
    SocialLink(
      label: 'LinkedIn',
      handle: 'in/muhammed-shadil',
      url: linkedinUrl,
    ),
    SocialLink(label: 'Email', handle: email, url: mailto),
  ];

  /// Shown in the footer alongside the three primary socials.
  static const List<SocialLink> secondarySocials = [
    SocialLink(
      label: 'Instagram',
      handle: '@shadi_k_muhammed',
      url: instagramUrl,
    ),
    SocialLink(label: 'Facebook', handle: 'muhammed.shadil', url: facebookUrl),
  ];

  // ==========================================================================
  // SKILLS
  // ==========================================================================
  static const List<SkillCategory> skillCategories = [
    SkillCategory(
      title: 'Mobile Development',
      blurb: 'Cross-platform apps that feel native on both stores.',
      icon: Icons.phone_iphone_rounded,
      accent: Color(0xFF54C5F8), // Flutter blue
      skills: [
        Skill('Flutter'),
        Skill('Dart'),
        Skill('Responsive UI'),
        Skill('Animations'),
        Skill('Android'),
        Skill('iOS'),
      ],
    ),
    SkillCategory(
      title: 'State & Architecture',
      blurb: 'Codebases that stay maintainable past version one.',
      icon: Icons.account_tree_rounded,
      accent: Color(0xFF7C5CFF),
      skills: [
        Skill('BLoC'),
        Skill('GetX'),
        Skill('Provider'),
        Skill('Clean Architecture'),
        Skill('MVVM'),
        Skill('MVC'),
      ],
    ),
    SkillCategory(
      title: 'Backend & Data',
      blurb: 'Talking to services, and remembering things offline.',
      icon: Icons.dns_rounded,
      accent: Color(0xFFFFCA28), // Firebase amber
      skills: [
        Skill('REST API'),
        Skill('Node.js'),
        Skill('Firebase'),
        Skill('Firestore'),
        Skill('Firebase Auth'),
        Skill('Hive'),
        Skill('SQFlite'),
        Skill('MongoDB'),
      ],
    ),
    SkillCategory(
      title: 'Integrations',
      blurb: 'The third-party SDKs production apps actually need.',
      icon: Icons.hub_rounded,
      accent: Color(0xFF22D3EE),
      skills: [
        Skill('Razorpay'),
        Skill('Easebuzz'),
        Skill('ZegoCloud'),
        Skill('Socket.IO'),
        Skill('Google Maps'),
        Skill('Push Notifications'),
        Skill('TrippJack & TBO'),
      ],
    ),
    SkillCategory(
      title: 'Tools & Workflow',
      blurb: 'Day-to-day kit, from first Figma frame to store listing.',
      icon: Icons.handyman_rounded,
      accent: Color(0xFF2BAE8C),
      skills: [
        Skill('Git'),
        Skill('GitHub'),
        Skill('Bitbucket'),
        Skill('VS Code'),
        Skill('Android Studio'),
        Skill('Postman'),
        Skill('Figma'),
      ],
    ),
  ];

  /// Compact chip row used in the hero and the GitHub section.
  static const List<String> techChips = [
    'Flutter',
    'Dart',
    'BLoC',
    'GetX',
    'Provider',
    'Firebase',
    'REST API',
    'Node.js',
    'Hive',
    'SQFlite',
    'Git',
    'Figma',
  ];

  // ==========================================================================
  // PROJECTS
  // ==========================================================================
  //
  // `iconUrl` points at the Play Store launcher icon on Google's CDN. Every
  // card falls back to a gradient monogram tile if the image fails to load,
  // so a blocked request never leaves a hole in the grid.
  // ==========================================================================
  static const List<Project> projects = [
    // ---------------------------------------------------------------- Kathoram
    Project(
      id: 'kathoram',
      name: 'Kathoram',
      tagline: 'Verified staff, secure calls.',
      summary:
          'A marketplace that connects users with verified staff and keeps '
          'both sides private by routing every conversation through secure, '
          'coin-based in-app voice calls.',
      accent: Color(0xFF6C5CE7),
      category: 'Real-time platform',
      status: ProjectStatus.live,
      featured: true,
      role: 'Flutter Developer',
      year: '2025',
      monogram: 'KA',
      iconUrl:
          'https://play-lh.googleusercontent.com/RuSvc0quVaKjMAgogA-PIVfvSFbJeT8Dr3pljH2hRrp6OrMcngtYMXEawVvxtifHKs5QI0dV5iLvgBl5mXb-Nw=s512',
      tech: [
        'Flutter',
        'GetX',
        'REST API',
        'ZegoCloud',
        'Payment Gateway',
        'Push Notifications',
      ],
      features: [
        'Secure in-app voice calling',
        'Coin-based call billing',
        'Staff online/offline presence',
        'Call history & duration tracking',
        'Wallet recharge flow',
        'Payment gateway integration',
        'Push notifications for incoming calls',
      ],
      links: [
        ProjectLink(
          kind: LinkKind.playStore,
          url:
              'https://play.google.com/store/apps/details?id=com.kathoram.user_app',
        ),
      ],
      detailBlocks: [
        DetailBlock(
          title: 'The problem',
          icon: Icons.help_outline_rounded,
          body:
              'Connecting customers to service staff normally means exchanging '
              'phone numbers, which exposes personal contact details on both '
              'sides and moves the conversation — and any dispute over it — '
              'off-platform entirely.',
        ),
        DetailBlock(
          title: 'The solution',
          icon: Icons.lightbulb_outline_rounded,
          body:
              'Every conversation runs as an in-app voice call over ZegoCloud, '
              'so neither party ever sees the other\'s number. Calls are '
              'metered against a coin balance that users top up through the '
              'payment gateway, giving the platform a clean billing model and '
              'a complete, auditable call history.',
        ),
        DetailBlock(
          title: 'Challenges',
          icon: Icons.bolt_rounded,
          body:
              'Call lifecycle was the hard part: reconciling ZegoCloud room '
              'state with the backend so that coin deduction matched real '
              'talk-time, handling calls that drop mid-conversation, and '
              'waking the app reliably for an incoming call when it had been '
              'killed in the background.',
        ),
        DetailBlock(
          title: 'My contribution',
          icon: Icons.person_outline_rounded,
          body:
              'Built the Flutter client end to end — call UI and lifecycle, '
              'presence handling, the wallet and recharge flow, payment '
              'integration, notification handling, and the release pipeline '
              'through to the Play Store listing.',
        ),
      ],
      architecture: [
        'GetX for reactive state, routing and dependency injection',
        'Repository layer isolating REST calls from controllers',
        'ZegoCloud SDK wrapped behind a single call service',
        'Presence + call events pushed from the backend',
        'Token-authenticated API client with centralised error handling',
      ],
      results: [
        'Shipped to the Google Play Store',
        'Zero phone numbers exchanged between users and staff',
        'Call billing reconciled to the second against wallet balance',
      ],
    ),

    // ---------------------------------------------------------------- RentDoor
    Project(
      id: 'rentdoor',
      name: 'RentDoor',
      tagline: 'Property management & hassle-free rent collection.',
      summary:
          'A two-sided rental SaaS with separate owner and tenant apps, '
          'covering rent collection, complaints, agreements, KYC and '
          'move-in/out reports — with each payment split automatically '
          'between the owner and the platform.',
      accent: Color(0xFF4A69BD),
      category: 'SaaS platform',
      status: ProjectStatus.live,
      featured: true,
      role: 'Flutter Developer',
      year: '2025',
      monogram: 'RD',
      iconUrl:
          'https://play-lh.googleusercontent.com/7saraT_PJk1_d7Nbiw1NktIFupmXzXK-2yoU0D7dA7BFO-Mwgr6eA1654Fj-zvJbQ1v1hqBcpT1B39rolUXSlcA=s512',
      tech: ['Flutter', 'GetX', 'Node.js', 'REST API', 'Razorpay'],
      features: [
        'Separate owner and tenant applications',
        'Online rent collection',
        'Automatic payment split via Razorpay Routes',
        'Complaints & announcements',
        'Billing and invoice history',
        'KYC and digital agreements',
        'Move-in / move-out condition reports',
      ],
      links: [
        ProjectLink(
          kind: LinkKind.playStore,
          url:
              'https://play.google.com/store/apps/details?id=com.rentdoor.owner',
        ),
      ],
      detailBlocks: [
        DetailBlock(
          title: 'The problem',
          icon: Icons.help_outline_rounded,
          body:
              'Small landlords run their properties out of chat threads and '
              'spreadsheets. Rent gets chased manually, complaints get lost, '
              'and there is no shared record of a property\'s condition when a '
              'tenant moves in or out.',
        ),
        DetailBlock(
          title: 'The solution',
          icon: Icons.lightbulb_outline_rounded,
          body:
              'Two purpose-built apps over one backend. Owners publish '
              'properties, raise bills and track collection; tenants pay rent, '
              'file complaints and sign agreements in-app. Razorpay Routes '
              'splits every incoming payment between the owner\'s account and '
              'the platform\'s commission at the moment of capture.',
        ),
        DetailBlock(
          title: 'Challenges',
          icon: Icons.bolt_rounded,
          body:
              'Getting the split-payment flow right — mapping owners to '
              'Razorpay route accounts, handling partial and failed captures, '
              'and making sure the ledger the tenant sees always agrees with '
              'the one the owner sees. Sharing a codebase across two apps with '
              'different permissions took a disciplined feature-module split.',
        ),
        DetailBlock(
          title: 'My contribution',
          icon: Icons.person_outline_rounded,
          body:
              'Built both Flutter applications, the shared design system and '
              'the payment integration, and worked directly with the Node.js '
              'team on the billing and KYC API contracts.',
        ),
      ],
      architecture: [
        'Shared feature modules consumed by both owner and tenant apps',
        'GetX bindings scoping controllers to each feature route',
        'Razorpay Routes for owner/platform payment splitting',
        'Node.js REST backend with role-scoped tokens',
        'Document upload pipeline for KYC and agreements',
      ],
      results: [
        'Live on the Google Play Store',
        'Rent collection, commission and payouts fully automated',
        'One codebase serving two distinct user roles',
      ],
    ),

    // ------------------------------------------------------------------- Zenvy
    Project(
      id: 'zenvy',
      name: 'Zenvy',
      tagline: 'Book online & walk-in doctor visits.',
      summary:
          'A doctor consultation platform with two roles — patients and '
          'doctors — offering online booking, clinic-side slot management, '
          'live video consultations and secure payments.',
      accent: Color(0xFF00B894),
      category: 'Healthcare',
      status: ProjectStatus.live,
      featured: true,
      role: 'Flutter Developer',
      year: '2025',
      monogram: 'ZV',
      iconUrl:
          'https://play-lh.googleusercontent.com/kbHzxZ6nFBFIZcNOzNJotAFzHaoGnX5eKKWzA5dUAcPCDDT_uJcOCvqUT6bwIbVqRW0WNhczN3Ji6CoB2gvb=s512',
      tech: [
        'Flutter',
        'GetX',
        'ZegoCloud',
        'Socket.IO',
        'Razorpay',
        'REST API',
      ],
      features: [
        'Patient and doctor roles in one app',
        'Online consultation booking',
        'Walk-in / clinic slot management',
        'Live video consultations',
        'Real-time chat over Socket.IO',
        'Secure Razorpay payments',
        'Appointment history & prescriptions',
      ],
      links: [
        ProjectLink(
          kind: LinkKind.playStore,
          url: 'https://play.google.com/store/apps/details?id=com.zenvy.app',
        ),
      ],
      detailBlocks: [
        DetailBlock(
          title: 'The problem',
          icon: Icons.help_outline_rounded,
          body:
              'Clinics juggle walk-in queues and online appointments in two '
              'separate systems, so slots get double-booked and patients wait '
              'without knowing where they are in the queue.',
        ),
        DetailBlock(
          title: 'The solution',
          icon: Icons.lightbulb_outline_rounded,
          body:
              'A single schedule that both sides write to. Doctors configure '
              'availability and manage the clinic queue; patients book online '
              'or in person against the same slots. Consultations run over '
              'ZegoCloud video with Socket.IO chat alongside, and payment is '
              'captured before the call begins.',
        ),
        DetailBlock(
          title: 'Challenges',
          icon: Icons.bolt_rounded,
          body:
              'Keeping slot availability consistent when two roles mutate the '
              'same schedule concurrently, and making the video consultation '
              'degrade gracefully — falling back to chat — on the patchy '
              'mobile connections that are common in real use.',
        ),
        DetailBlock(
          title: 'My contribution',
          icon: Icons.person_outline_rounded,
          body:
              'Implemented the dual-role application, the ZegoCloud video '
              'consultation layer, Socket.IO chat, the booking engine and '
              'Razorpay payment flow.',
        ),
      ],
      architecture: [
        'Role-aware routing that swaps the shell per authenticated user type',
        'Socket.IO client wrapped in a reconnect-aware service',
        'ZegoCloud video sessions keyed to appointment IDs',
        'Optimistic slot booking with server-side confirmation',
      ],
      results: [
        'Live on the Google Play Store',
        'Online and walk-in bookings unified into one schedule',
        'Video, chat and payment handled without leaving the app',
      ],
    ),

    // ----------------------------------------------------------------- Airbest
    Project(
      id: 'airbest',
      name: 'Airbest',
      tagline: 'Book cargo, track shipments, manage deliveries.',
      summary:
          'A cargo booking and tracking app for Airbest customers, wired '
          'directly into the company\'s internal cargo management software so '
          'the app and the back office never fall out of sync.',
      accent: Color(0xFF2E86DE),
      category: 'Logistics',
      status: ProjectStatus.live,
      role: 'Flutter Developer',
      year: '2025',
      monogram: 'AB',
      iconUrl:
          'https://play-lh.googleusercontent.com/y1sD3zma5xc2ivpEYLKe97a5oFEORaVWskwINegyqMCMC_AQYqZEc2Pd8DOQLUeRZgGVDpcI18Hf12hn9evVDQ=s512',
      tech: ['Flutter', 'GetX', 'Node.js', 'REST API'],
      features: [
        'Air & goods cargo booking',
        'Real-time shipment tracking',
        'Coupons and discounts',
        'Delivery management',
        'Live sync with internal cargo software',
      ],
      links: [
        ProjectLink(
          kind: LinkKind.playStore,
          url: 'https://play.google.com/store/apps/details?id=com.airbest.app',
        ),
      ],
      detailBlocks: [
        DetailBlock(
          title: 'The problem',
          icon: Icons.help_outline_rounded,
          body:
              'Customers had to phone the office to book a consignment or ask '
              'where it had got to, which put every status update through a '
              'human bottleneck.',
        ),
        DetailBlock(
          title: 'The solution',
          icon: Icons.lightbulb_outline_rounded,
          body:
              'A customer-facing app that reads and writes the same records as '
              'the internal cargo management system, so a booking made on a '
              'phone appears in the back office instantly and every scan along '
              'the route shows up as a tracking event.',
        ),
        DetailBlock(
          title: 'My contribution',
          icon: Icons.person_outline_rounded,
          body:
              'Built the Flutter app and integrated it against the existing '
              'internal system\'s REST services, including the booking, '
              'tracking and coupon flows.',
        ),
      ],
      architecture: [
        'GetX controllers per booking step with validated state hand-off',
        'REST integration against the existing internal cargo system',
        'Polling-based tracking timeline with cached last-known state',
      ],
      results: [
        'Live on the Google Play Store',
        'Bookings and tracking moved from phone calls to self-service',
      ],
    ),

    // --------------------------------------------------------- Flyden Holidays
    Project(
      id: 'flyden',
      name: 'Flyden Holidays',
      tagline: 'Holiday packages, hotels, flights & visa assistance.',
      summary:
          'A travel booking app integrating the TrippJack and TBO APIs for '
          'live hotel and flight availability, with dynamic booking workflows '
          'and visa assistance built in.',
      accent: Color(0xFF0984E3),
      category: 'Travel',
      status: ProjectStatus.live,
      role: 'Flutter Developer',
      year: '2025',
      monogram: 'FH',
      iconUrl:
          'https://play-lh.googleusercontent.com/eAQKosdt9vjv0imfu0su83kwhpQZdzqaSMbsQraVJrvXMldIl_yGJonw0k-3kFUIVAQGkI9iR93qLHNDlSnQ=s512',
      tech: ['Flutter', 'GetX', 'REST API', 'TrippJack', 'TBO'],
      features: [
        'Flight search and booking',
        'Live hotel availability',
        'Holiday package browsing',
        'Visa assistance requests',
        'Dynamic multi-step booking workflows',
      ],
      links: [
        ProjectLink(
          kind: LinkKind.playStore,
          url: 'https://play.google.com/store/apps/details?id=com.app.flydn',
        ),
      ],
      detailBlocks: [
        DetailBlock(
          title: 'The problem',
          icon: Icons.help_outline_rounded,
          body:
              'Travel aggregator APIs return large, deeply nested and '
              'inconsistent payloads, and prices go stale within minutes — a '
              'naive client shows fares that no longer exist by checkout.',
        ),
        DetailBlock(
          title: 'The solution',
          icon: Icons.lightbulb_outline_rounded,
          body:
              'A normalising layer that flattens TrippJack and TBO responses '
              'into one internal model, plus a booking workflow that re-prices '
              'before confirmation so the customer never commits to a fare the '
              'supplier has already withdrawn.',
        ),
        DetailBlock(
          title: 'Challenges',
          icon: Icons.bolt_rounded,
          body:
              'Two suppliers with different schemas, different error semantics '
              'and different session rules had to look identical to the UI, '
              'while search results over hundreds of fares still had to scroll '
              'at sixty frames per second.',
        ),
        DetailBlock(
          title: 'My contribution',
          icon: Icons.person_outline_rounded,
          body:
              'Integrated both supplier APIs, designed the shared result model '
              'and built the search, filtering and booking UI.',
        ),
      ],
      architecture: [
        'Adapter per supplier normalising into one result model',
        'Lazy, paginated result lists to keep long searches smooth',
        'Re-price step before payment confirmation',
      ],
      results: [
        'Live on the Google Play Store',
        'Two supplier APIs unified behind a single booking flow',
      ],
    ),

    // ----------------------------------------------------------------- Smileji
    Project(
      id: 'smileji',
      name: 'Smileji',
      tagline: 'Gentle daily habits for comfort and confidence.',
      summary:
          'A subscription app built around video-guided daily tasks, with '
          'progress tracked through charts and history graphs so users can see '
          'streaks and improvement over time.',
      accent: Color(0xFFE17055),
      category: 'Health & habits',
      status: ProjectStatus.live,
      role: 'Flutter Developer',
      year: '2025',
      monogram: 'SM',
      iconUrl:
          'https://play-lh.googleusercontent.com/lK4HrSRj-xYz9IvFWawnMHwoYakQPDZsPkaAxAXeJ88t1XBcBIal20MAGNNDeRlIUeBqmNKQDVfpFXji6iCdxQ=s512',
      tech: ['Flutter', 'GetX', 'Razorpay', 'REST API'],
      features: [
        'Video-based guided daily tasks',
        'Subscription plans & billing',
        'Progress charts and history graphs',
        'Streak tracking',
        'Razorpay payment integration',
      ],
      links: [
        ProjectLink(
          kind: LinkKind.playStore,
          url: 'https://play.google.com/store/apps/details?id=com.app.smileji',
        ),
      ],
      detailBlocks: [
        DetailBlock(
          title: 'The solution',
          icon: Icons.lightbulb_outline_rounded,
          body:
              'Each day surfaces a short set of video-guided tasks. Completion '
              'feeds a progress history the user can scroll back through, '
              'which is what keeps a habit app from being abandoned in week '
              'two. Access is gated behind a Razorpay subscription.',
        ),
        DetailBlock(
          title: 'Challenges',
          icon: Icons.bolt_rounded,
          body:
              'Video playback had to stay smooth on low-end devices while a '
              'chart of historical progress rendered on the same screen, which '
              'meant being deliberate about when the chart rebuilt.',
        ),
        DetailBlock(
          title: 'My contribution',
          icon: Icons.person_outline_rounded,
          body:
              'Built the app, the subscription and payment flow, the video '
              'task player and the custom progress charts.',
        ),
      ],
      architecture: [
        'Custom-painted progress charts — no charting dependency',
        'Cached video playback with pre-buffering of the next task',
        'Subscription state resolved server-side and cached locally',
      ],
      results: ['Live on the Google Play Store'],
    ),

    // ----------------------------------------------------------- Shwe Nan Taw
    Project(
      id: 'shwenantaw',
      name: 'Shwe Nan Taw',
      tagline: 'Jewellery, bought properly online.',
      summary:
          'An online jewellery store with product listings, cart, order '
          'management and secure checkout, built on a clean architecture with '
          'Provider driving state.',
      accent: Color(0xFFD4A017),
      category: 'E-commerce',
      status: ProjectStatus.live,
      role: 'Flutter Developer',
      year: '2024',
      monogram: 'SN',
      iconUrl:
          'https://play-lh.googleusercontent.com/CGfcEqVNck9jJXY7f-NM05R0jJGWpZCeBq1MXSmefLWXD5pLOUS_3aI7jWevOwoZSypaOHyxQp6A5FylMZ_H4Q=s512',
      tech: ['Flutter', 'Provider', 'REST API', 'Clean Architecture'],
      features: [
        'Product catalogue & categories',
        'Cart and wishlist',
        'Secure checkout',
        'Order tracking and history',
        'Address management',
      ],
      links: [
        ProjectLink(
          kind: LinkKind.playStore,
          url:
              'https://play.google.com/store/apps/details?id=com.shwenantaw.app',
        ),
      ],
      detailBlocks: [
        DetailBlock(
          title: 'The solution',
          icon: Icons.lightbulb_outline_rounded,
          body:
              'A conventional storefront done carefully: fast catalogue '
              'browsing, a cart that survives app restarts, and a checkout '
              'that never leaves the customer unsure whether their order went '
              'through.',
        ),
        DetailBlock(
          title: 'My contribution',
          icon: Icons.person_outline_rounded,
          body:
              'Built the app on a clean architecture split — presentation, '
              'domain and data layers — with Provider for state, which kept '
              'the catalogue, cart and order features independently testable.',
        ),
      ],
      architecture: [
        'Clean Architecture: presentation / domain / data separation',
        'Provider + ChangeNotifier scoped per feature',
        'Repository interfaces in domain, REST implementations in data',
        'Locally persisted cart surviving cold starts',
      ],
      results: ['Live on the Google Play Store'],
    ),

    // -------------------------------------------------------------------- Genex
    Project(
      id: 'genex',
      name: 'Genex',
      tagline: 'Employee management, end to end.',
      summary:
          'An internal workforce app covering task assignment, attendance, '
          'clock-in/out, live location tracking and expense claims, backed by '
          'REST services.',
      accent: Color(0xFF00A8A8),
      category: 'Enterprise',
      status: ProjectStatus.companyInternal,
      role: 'Flutter Developer',
      year: '2025',
      monogram: 'GX',
      tech: ['Flutter', 'GetX', 'Node.js', 'REST API', 'Geolocation'],
      features: [
        'Task assignment & tracking',
        'Attendance and clock-in / clock-out',
        'Live location tracking',
        'Expense claims and approvals',
        'Role-based access',
      ],
      detailBlocks: [
        DetailBlock(
          title: 'The problem',
          icon: Icons.help_outline_rounded,
          body:
              'A field workforce was being managed on paper and over the '
              'phone: attendance taken manually, expenses reimbursed against '
              'physical receipts, and no reliable picture of who was where.',
        ),
        DetailBlock(
          title: 'The solution',
          icon: Icons.lightbulb_outline_rounded,
          body:
              'One internal app that handles the whole loop — assign a task, '
              'clock in against it, track location while it runs, and file the '
              'expense claim at the end, all approved by managers in the same '
              'system.',
        ),
        DetailBlock(
          title: 'Challenges',
          icon: Icons.bolt_rounded,
          body:
              'Continuous location tracking is a battery and permissions '
              'minefield on modern Android. Getting useful location fidelity '
              'without draining a phone before the end of a shift took real '
              'tuning of update intervals and background execution.',
        ),
        DetailBlock(
          title: 'My contribution',
          icon: Icons.person_outline_rounded,
          body:
              'Built the Flutter application and its REST integration, '
              'including the attendance, location tracking and expense '
              'approval flows.',
        ),
      ],
      architecture: [
        'Foreground location service with tuned update intervals',
        'Offline-tolerant attendance queue that syncs when back online',
        'Role-scoped navigation for staff versus managers',
      ],
      results: [
        'Deployed internally as the company workforce tool',
        'Attendance, expenses and field tracking consolidated into one app',
      ],
    ),

    // ------------------------------------------------------------------- MEDICO
    Project(
      id: 'medico',
      name: 'MEDICO',
      tagline: 'Doctor appointment booking on Firebase.',
      summary:
          'An appointment platform with user registration, doctor profiles, '
          'slot scheduling and SMS notifications, running on Firebase with '
          'BLoC keeping the UI responsive in real time.',
      accent: Color(0xFF2BAE8C),
      category: 'Healthcare',
      status: ProjectStatus.openSource,
      role: 'Solo developer',
      year: '2024',
      monogram: 'MD',
      tech: ['Flutter', 'Firebase', 'Firestore', 'BLoC', 'Google Maps', 'Hive'],
      features: [
        'Doctor booking & slot scheduling',
        'Reception-side management',
        'Firebase authentication',
        'Doctor profiles and specialities',
        'Location integration via Google Maps',
        'Local data storage with Hive',
        'SMS notifications',
      ],
      links: [
        ProjectLink(
          kind: LinkKind.github,
          url: 'https://github.com/muhammed-shadil/doctor-booking-app',
        ),
      ],
      detailBlocks: [
        DetailBlock(
          title: 'The solution',
          icon: Icons.lightbulb_outline_rounded,
          body:
              'A Firebase-backed booking platform where a slot taken on one '
              'device disappears on every other device immediately, because '
              'the UI is driven by Firestore streams rather than by polling.',
        ),
        DetailBlock(
          title: 'Challenges',
          icon: Icons.bolt_rounded,
          body:
              'Preventing two patients from claiming the same slot in the '
              'moment between reading availability and writing a booking — '
              'solved with transactional writes rather than trusting the read.',
        ),
        DetailBlock(
          title: 'My contribution',
          icon: Icons.person_outline_rounded,
          body:
              'Designed and built the whole application: authentication, '
              'Firestore data model, BLoC state layer, maps integration and '
              'local caching with Hive.',
        ),
      ],
      architecture: [
        'BLoC over Firestore streams for real-time slot state',
        'Transactional booking writes to prevent double-booking',
        'Firebase Authentication for patients and reception roles',
        'Hive cache for offline reads of profiles and history',
      ],
      results: [
        'Source published on GitHub',
        'Real-time availability with no polling',
      ],
    ),

    // ------------------------------------------------------------------ Kinetix
    // NOTE: the only project here that is not in the verified brief — details
    // come from the build request. Delete this entry if it is not shipping.
    Project(
      id: 'kinetix',
      name: 'Kinetix',
      tagline: 'A physics puzzle game, built in Flutter.',
      summary:
          'A physics-based puzzle game built on the Flame engine with Forge2D '
          'rigid-body simulation — a deliberate detour from business apps to '
          'work on game loops, collision and frame budgets.',
      accent: Color(0xFFFF7A59),
      category: 'Game',
      status: ProjectStatus.inProgress,
      role: 'Solo developer',
      year: '2026',
      monogram: 'KX',
      tech: ['Flutter', 'Flame', 'Forge2D', 'Custom painters'],
      features: [
        'Rigid-body physics simulation',
        'Hand-built level design',
        'Collision-driven puzzle mechanics',
        'Custom particle and trail effects',
        'Frame-budget-aware rendering',
      ],
      detailBlocks: [
        DetailBlock(
          title: 'Why build it',
          icon: Icons.sports_esports_rounded,
          body:
              'Business apps rebuild on user input; a game rebuilds sixty '
              'times a second whether anything changed or not. Building on '
              'Flame and Forge2D was a way to work against a hard frame '
              'budget and get properly comfortable with Flutter\'s rendering '
              'pipeline.',
        ),
        DetailBlock(
          title: 'Challenges',
          icon: Icons.bolt_rounded,
          body:
              'Keeping the physics step stable and deterministic while the '
              'render loop varies with device performance, and keeping '
              'allocations out of the per-frame path so the garbage collector '
              'never causes a visible stutter.',
        ),
      ],
      architecture: [
        'Flame game loop with a fixed-step Forge2D physics world',
        'Component tree per level, disposed on transition',
        'Object pooling to keep per-frame allocation near zero',
      ],
      results: ['In active development'],
    ),
  ];

  /// Projects promoted to the large tiles at the top of the bento grid.
  static List<Project> get featuredProjects =>
      projects.where((p) => p.featured).toList();

  // ==========================================================================
  // EXPERIENCE
  // ==========================================================================
  static const List<ExperienceItem> experience = [
    ExperienceItem(
      role: 'Software Engineer — Flutter Developer',
      company: 'Geeksynergy Technologies Pvt. Ltd.',
      location: 'Bengaluru, India',
      period: 'Oct 2024 — Present',
      current: true,
      summary:
          'Building and maintaining production cross-platform applications, '
          'from architecture through to store release.',
      highlights: [
        'Built and maintained multiple cross-platform apps in Flutter using GetX and BLoC.',
        'Applied Clean Architecture, MVC and MVVM for scalable, maintainable codebases.',
        'Integrated REST APIs with secure network handling and robust error management.',
        'Shipped production apps to the Play Store; integrated Razorpay and Easebuzz.',
        'Worked with ZegoCloud video calling, TrippJack and TBO travel APIs, and Socket.IO chat.',
        'Collaborated with UI/UX and backend teams on responsive, smooth user flows.',
        'Mentored junior developers on Flutter patterns and code review.',
      ],
      tech: [
        'Flutter',
        'GetX',
        'BLoC',
        'Node.js',
        'Razorpay',
        'ZegoCloud',
        'Socket.IO',
      ],
    ),
    ExperienceItem(
      role: 'Flutter Developer — Intern',
      company: 'Self Stack',
      location: 'Calicut, India',
      period: 'Sept 2023 — Sept 2024',
      summary:
          'Learned the craft on real projects — architecture, UI/UX and '
          'backend integration.',
      highlights: [
        'Focused on mobile app architecture, UI/UX and backend integration.',
        'Built applications with Flutter and Firebase using Provider and BLoC.',
        'Worked on real projects with API integration and local storage (Hive, SQFlite).',
        'Implemented Figma designs faithfully across screen sizes.',
        'Gained frontend web experience with HTML, CSS and Bootstrap.',
      ],
      tech: ['Flutter', 'Firebase', 'Provider', 'BLoC', 'Hive', 'SQFlite'],
    ),
  ];

  static const List<EducationItem> education = [
    EducationItem(
      title: 'B.Sc. Chemistry',
      institution: 'University of Calicut',
      period: '2019 — 2022',
    ),
    EducationItem(
      title: 'Higher Secondary — Computer Science',
      institution: 'Plus Two',
      period: '2016 — 2018',
    ),
  ];

  static const List<String> achievements = [
    'Deployed 10+ production applications to the Google Play Store.',
    '7+ App Store (iOS) releases alongside Play Store launches.',
    'Integrated multiple payment gateways and real-time SDKs.',
    'Recognised for clean code, optimised architecture and teamwork.',
  ];

  // ==========================================================================
  // PROCESS
  // ==========================================================================
  static const List<ProcessStep> process = [
    ProcessStep(
      number: '01',
      title: 'Understand',
      description:
          'Get clear on the product, the users and the constraints before a '
          'single widget is written.',
      icon: Icons.search_rounded,
    ),
    ProcessStep(
      number: '02',
      title: 'Design',
      description:
          'Shape clean, intuitive flows and translate design into a system of '
          'reusable components.',
      icon: Icons.design_services_rounded,
    ),
    ProcessStep(
      number: '03',
      title: 'Build',
      description:
          'Develop scalable Flutter applications on a clean architecture, '
          'wired to real services.',
      icon: Icons.terminal_rounded,
    ),
    ProcessStep(
      number: '04',
      title: 'Launch',
      description:
          'Test, profile, optimise and ship to the Play Store and App Store — '
          'then keep it healthy.',
      icon: Icons.rocket_launch_rounded,
    ),
  ];

  // ==========================================================================
  // GITHUB SECTION
  // ==========================================================================
  static const String githubTitle = 'Code, build, repeat.';
  static const String githubBlurb =
      'Most of my production work lives in private company repositories, but '
      'personal projects and experiments are public on GitHub.';

  static const List<RepoCard> repos = [
    RepoCard(
      name: 'doctor-booking-app',
      description:
          'MEDICO — Firebase-backed doctor appointment booking with BLoC.',
      language: 'Dart',
      languageColor: Color(0xFF00B4AB),
      url: 'https://github.com/muhammed-shadil/doctor-booking-app',
    ),
    RepoCard(
      name: 'muhammed-shadil-portfolio',
      description:
          'Source of this site — Flutter Web, one dependency, deployed by '
          'GitHub Actions.',
      language: 'Dart',
      languageColor: Color(0xFF00B4AB),
      url: 'https://github.com/muhammed-shadil/muhammed-shadil-portfolio',
    ),
    RepoCard(
      name: 'flutter-portfolio',
      description: 'The earlier version of this portfolio, also in Flutter.',
      language: 'Dart',
      languageColor: Color(0xFF00B4AB),
      url: 'https://github.com/muhammed-shadil/flutter-portfolio',
    ),
  ];

  // ==========================================================================
  // CONTACT
  // ==========================================================================
  static const String contactTitle = 'Let\'s build something great together.';
  static const String contactBlurb =
      'Have a project, an idea, or an opportunity? I read every message and '
      'reply within a day or two.';

  // ==========================================================================
  // SEO / META
  // ==========================================================================
  static const String siteTitle = 'Muhammed Shadil | Flutter Developer';
  static const String siteDescription =
      'Portfolio of Muhammed Shadil, a Flutter Developer building modern '
      'mobile and web applications.';
}
