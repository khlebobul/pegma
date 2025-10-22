/// Tutorial board states for each step of the interactive tutorial
class TutorialBoardStates {
  static const List<List<List<String>>> states = [
    // Step 0: Initial board
    [
      ['-1', '1', '-1'],
      ['1', '0', '1'],
      ['-1', '1', '-1'],
    ],
    // Step 1: Select a peg
    [
      ['-1', '1', '-1'],
      ['*', '0', '1'],
      ['-1', '1', '-1'],
    ],
    // Step 2: Show possible move
    [
      ['-1', '1', '-1'],
      ['*', '0', 'possible'],
      ['-1', '1', '-1'],
    ],
    // Step 3: Move the peg (mid-animation)
    [
      ['-1', '1', '-1'],
      ['eaten', 'eaten', '1'],
      ['-1', '1', '-1'],
    ],
    // Step 4: Final state after move
    [
      ['-1', '1', '-1'],
      ['eaten', 'eaten', '1'],
      ['-1', '1', '-1'],
    ],
  ];
}
