// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `language`
  String get language {
    return Intl.message('language', name: 'language', desc: '', args: []);
  }

  /// `the name {appName} is a play on words that combines: "peg" (peg, token) is the main element of the game and "theorema", which is associated with mathematical rigor and logic.`
  String appDescription(String appName) {
    return Intl.message(
      'the name $appName is a play on words that combines: "peg" (peg, token) is the main element of the game and "theorema", which is associated with mathematical rigor and logic.',
      name: 'appDescription',
      desc: 'Description of the app name meaning',
      args: [appName],
    );
  }

  /// `rate the app`
  String get rateTheApp {
    return Intl.message('rate the app', name: 'rateTheApp', desc: '', args: []);
  }

  /// `share with friends`
  String get shareWithFriends {
    return Intl.message(
      'share with friends',
      name: 'shareWithFriends',
      desc: '',
      args: [],
    );
  }

  /// `project website`
  String get projectWebsite {
    return Intl.message(
      'project website',
      name: 'projectWebsite',
      desc: '',
      args: [],
    );
  }

  /// `telegram`
  String get telegram {
    return Intl.message('telegram', name: 'telegram', desc: '', args: []);
  }

  /// `fun fact: i made the font specifically for this app myself for uniqueness and fun with `
  String get funFact {
    return Intl.message(
      'fun fact: i made the font specifically for this app myself for uniqueness and fun with ',
      name: 'funFact',
      desc: '',
      args: [],
    );
  }

  /// `github repository`
  String get githubRepository {
    return Intl.message(
      'github repository',
      name: 'githubRepository',
      desc: '',
      args: [],
    );
  }

  /// `my website`
  String get myWebsite {
    return Intl.message('my website', name: 'myWebsite', desc: '', args: []);
  }

  /// `my other apps`
  String get myOtherApps {
    return Intl.message(
      'my other apps',
      name: 'myOtherApps',
      desc: '',
      args: [],
    );
  }

  /// `x (twitter)`
  String get xTwitter {
    return Intl.message('x (twitter)', name: 'xTwitter', desc: '', args: []);
  }

  /// `the board has holes filled with pegs, usually with the center hole empty.`
  String get rulesOne {
    return Intl.message(
      'the board has holes filled with pegs, usually with the center hole empty.',
      name: 'rulesOne',
      desc: '',
      args: [],
    );
  }

  /// `move: a peg jumps over an adjacent peg (horizontally or vertically) into an empty hole right beyond it. the jumped peg is removed.`
  String get rulesTwo {
    return Intl.message(
      'move: a peg jumps over an adjacent peg (horizontally or vertically) into an empty hole right beyond it. the jumped peg is removed.',
      name: 'rulesTwo',
      desc: '',
      args: [],
    );
  }

  /// `goal: remove as many pegs as possible, ideally leaving only one — in the center.`
  String get rulesThree {
    return Intl.message(
      'goal: remove as many pegs as possible, ideally leaving only one — in the center.',
      name: 'rulesThree',
      desc: '',
      args: [],
    );
  }

  /// `peg solitaire, or solitaire on pegs, originated in europe in the 17th century and quickly became popular in france.`
  String get pegSolitaireOrSolitaireOnPegsOriginatedInEuropeIn {
    return Intl.message(
      'peg solitaire, or solitaire on pegs, originated in europe in the 17th century and quickly became popular in france.',
      name: 'pegSolitaireOrSolitaireOnPegsOriginatedInEuropeIn',
      desc: '',
      args: [],
    );
  }

  /// `the earliest documented mention of the game is in 1687 in a book by french writer bernard lebonn, describing a board with 33 holes.`
  String get theEarliestDocumentedMentionOfTheGameIsIn1687 {
    return Intl.message(
      'the earliest documented mention of the game is in 1687 in a book by french writer bernard lebonn, describing a board with 33 holes.',
      name: 'theEarliestDocumentedMentionOfTheGameIsIn1687',
      desc: '',
      args: [],
    );
  }

  /// `the classic board has a cross shape: 7×7 squares, 33 filled with pegs, the center square empty. besides the classic shape, there are circular, triangular, and other non-standard boards with different numbers of pegs.`
  String get theClassicBoardHasACrossShape77Squares33 {
    return Intl.message(
      'the classic board has a cross shape: 7×7 squares, 33 filled with pegs, the center square empty. besides the classic shape, there are circular, triangular, and other non-standard boards with different numbers of pegs.',
      name: 'theClassicBoardHasACrossShape77Squares33',
      desc: '',
      args: [],
    );
  }

  /// `the goal is to remove all pegs, leaving only one in the center. interesting fact: for the classic 33-peg board, there is only one perfect solution path, although players often find many intermediate variations.`
  String get theGoalIsToRemoveAllPegsLeavingOnlyOne {
    return Intl.message(
      'the goal is to remove all pegs, leaving only one in the center. interesting fact: for the classic 33-peg board, there is only one perfect solution path, although players often find many intermediate variations.',
      name: 'theGoalIsToRemoveAllPegsLeavingOnlyOne',
      desc: '',
      args: [],
    );
  }

  /// `peg solitaire is not only a game but also a subject of mathematical study. combinatorialists and logicians have used it to explore strategies, optimal moves, and problem-solving techniques.`
  String get pegSolitaireIsNotOnlyAGameButAlsoA {
    return Intl.message(
      'peg solitaire is not only a game but also a subject of mathematical study. combinatorialists and logicians have used it to explore strategies, optimal moves, and problem-solving techniques.',
      name: 'pegSolitaireIsNotOnlyAGameButAlsoA',
      desc: '',
      args: [],
    );
  }

  /// `in the 19th century, the game spread across europe and england, becoming a popular pastime in aristocratic circles. modern versions now exist as computer games, mobile apps, and online puzzles.`
  String get inThe19thCenturyTheGameSpreadAcrossEuropeAnd {
    return Intl.message(
      'in the 19th century, the game spread across europe and england, becoming a popular pastime in aristocratic circles. modern versions now exist as computer games, mobile apps, and online puzzles.',
      name: 'inThe19thCenturyTheGameSpreadAcrossEuropeAnd',
      desc: '',
      args: [],
    );
  }

  /// `settings`
  String get settings {
    return Intl.message('settings', name: 'settings', desc: '', args: []);
  }

  /// `rules`
  String get rules {
    return Intl.message('rules', name: 'rules', desc: '', args: []);
  }

  /// `story`
  String get story {
    return Intl.message('story', name: 'story', desc: '', args: []);
  }

  /// `about`
  String get about {
    return Intl.message('about', name: 'about', desc: '', args: []);
  }

  /// `others`
  String get others {
    return Intl.message('others', name: 'others', desc: '', args: []);
  }

  /// `dark theme`
  String get darkTheme {
    return Intl.message('dark theme', name: 'darkTheme', desc: '', args: []);
  }

  /// `report bug`
  String get reportBug {
    return Intl.message('report bug', name: 'reportBug', desc: '', args: []);
  }

  /// `request feature`
  String get requestFeature {
    return Intl.message(
      'request feature',
      name: 'requestFeature',
      desc: '',
      args: [],
    );
  }

  /// `share feedback`
  String get shareFeedback {
    return Intl.message(
      'share feedback',
      name: 'shareFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Discover Pegma — a free, open-source take on the classic Peg Solitaire! Enjoy the timeless puzzle on your mobile device!`
  String get discoverPegmaAFreeOpensourceTakeOnTheClassicPeg {
    return Intl.message(
      'Discover Pegma — a free, open-source take on the classic Peg Solitaire! Enjoy the timeless puzzle on your mobile device!',
      name: 'discoverPegmaAFreeOpensourceTakeOnTheClassicPeg',
      desc: '',
      args: [],
    );
  }

  /// `1. goal: leave as few pieces as possible.\n2. pieces jump over adjacent ones into an empty space.\n3. jumped pieces are removed.`
  String get gameTutorialText {
    return Intl.message(
      '1. goal: leave as few pieces as possible.\n2. pieces jump over adjacent ones into an empty space.\n3. jumped pieces are removed.',
      name: 'gameTutorialText',
      desc: '',
      args: [],
    );
  }

  /// `restart`
  String get restart {
    return Intl.message('restart', name: 'restart', desc: '', args: []);
  }

  /// `menu`
  String get menu {
    return Intl.message('menu', name: 'menu', desc: '', args: []);
  }

  /// `next level`
  String get nextLevel {
    return Intl.message('next level', name: 'nextLevel', desc: '', args: []);
  }

  /// `you won :)`
  String get youWon {
    return Intl.message('you won :)', name: 'youWon', desc: '', args: []);
  }

  /// `no more moves`
  String get noMoreMoves {
    return Intl.message(
      'no more moves',
      name: 'noMoreMoves',
      desc: '',
      args: [],
    );
  }

  /// `ok`
  String get ok {
    return Intl.message('ok', name: 'ok', desc: '', args: []);
  }

  /// `cancel`
  String get cancel {
    return Intl.message('cancel', name: 'cancel', desc: '', args: []);
  }

  /// `start again?`
  String get startAgain {
    return Intl.message('start again?', name: 'startAgain', desc: '', args: []);
  }

  /// `yes`
  String get yes {
    return Intl.message('yes', name: 'yes', desc: '', args: []);
  }

  /// `again`
  String get again {
    return Intl.message('again', name: 'again', desc: '', args: []);
  }

  /// `level completed`
  String get levelCompleted {
    return Intl.message(
      'level completed',
      name: 'levelCompleted',
      desc: '',
      args: [],
    );
  }

  /// `continue`
  String get doContinue {
    return Intl.message('continue', name: 'doContinue', desc: '', args: []);
  }

  /// `you have an unfinished game`
  String get youHaveAnUnfinishedGame {
    return Intl.message(
      'you have an unfinished game',
      name: 'youHaveAnUnfinishedGame',
      desc: '',
      args: [],
    );
  }

  /// `how to play`
  String get howToPlay {
    return Intl.message('how to play', name: 'howToPlay', desc: '', args: []);
  }

  /// `this is the board. pegs (filled circles) can jump over each other into empty holes.`
  String get tutorialStep1 {
    return Intl.message(
      'this is the board. pegs (filled circles) can jump over each other into empty holes.',
      name: 'tutorialStep1',
      desc: '',
      args: [],
    );
  }

  /// `tap a peg to select it. the selected peg is highlighted.`
  String get tutorialStep2 {
    return Intl.message(
      'tap a peg to select it. the selected peg is highlighted.',
      name: 'tutorialStep2',
      desc: '',
      args: [],
    );
  }

  /// `highlighted dots show where you can move. tap a dot to jump there.`
  String get tutorialStep3 {
    return Intl.message(
      'highlighted dots show where you can move. tap a dot to jump there.',
      name: 'tutorialStep3',
      desc: '',
      args: [],
    );
  }

  /// `the peg jumps over the middle peg into the empty hole.`
  String get tutorialStep4 {
    return Intl.message(
      'the peg jumps over the middle peg into the empty hole.',
      name: 'tutorialStep4',
      desc: '',
      args: [],
    );
  }

  /// `the jumped peg is removed. keep going until only one peg remains.`
  String get tutorialStep5 {
    return Intl.message(
      'the jumped peg is removed. keep going until only one peg remains.',
      name: 'tutorialStep5',
      desc: '',
      args: [],
    );
  }

  /// `previous`
  String get previous {
    return Intl.message('previous', name: 'previous', desc: '', args: []);
  }

  /// `next`
  String get next {
    return Intl.message('next', name: 'next', desc: '', args: []);
  }

  /// `done`
  String get done {
    return Intl.message('done', name: 'done', desc: '', args: []);
  }

  /// `play`
  String get play {
    return Intl.message('play', name: 'play', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
