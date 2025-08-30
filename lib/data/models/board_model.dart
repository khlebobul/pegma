import 'dart:convert';

class BoardModel {
  final List<List<String>> board;

  BoardModel({required this.board});

  factory BoardModel.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final List<dynamic> boardList = json['board'];
    final List<List<String>> board = boardList
        .map((row) => List<String>.from(row.map((e) => e.toString())))
        .toList();
    return BoardModel(board: board);
  }
}
