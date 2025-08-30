import 'dart:convert';

class BoardModel {
  final List<List<int>> board;

  BoardModel({required this.board});

  factory BoardModel.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final List<dynamic> boardList = json['board'];
    final List<List<int>> board = boardList
        .map((row) => List<int>.from(row.map((e) => e as int)))
        .toList();
    return BoardModel(board: board);
  }
}
