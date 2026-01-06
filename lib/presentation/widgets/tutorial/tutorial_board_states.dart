/// Tutorial board states for each step of the interactive tutorial
class TutorialBoardStates {
  static const List<List<List<String>>> states = [
    // Step 0: Initial board
    [
      ['x', '1', 'x'],
      ['1', '1', '0'],
      ['x', '1', 'x'],
    ],
    // Step 1: Select a peg
    [
      ['x', '1', 'x'],
      ['*', '1', '0'],
      ['x', '1', 'x'],
    ],
    // Step 2: Show possible move
    [
      ['x', '1', 'x'],
      ['*', '1', 'possible'],
      ['x', '1', 'x'],
    ],
    // Step 3: Move the peg (mid-animation)
    [
      ['x', '1', 'x'],
      ['eaten', 'eaten', '1'],
      ['x', '1', 'x'],
    ],
    // Step 4: Final state after move
    [
      ['x', '1', 'x'],
      ['eaten', 'eaten', '1'],
      ['x', '1', 'x'],
    ],
  ];
}
