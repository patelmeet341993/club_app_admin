import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_model/utils/my_utils.dart';
import 'package:club_model/utils/parsing_helper.dart';

class ProductModel {
  String id = "", name = "", thumbnailImage = "" , description = "";
  List<String> gameImages = <String>[];
  bool enabled = true;
  Timestamp? createdTime;

  ProductModel({
    required this.id,
    this.name = "",
    this.description = '',
    this.thumbnailImage = "",
    List<String>? gameImages,
    this.enabled = true,
    this.createdTime,
  }) {
    this.gameImages = gameImages ?? <String>[];
  }

  ProductModel.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    name = ParsingHelper.parseStringMethod(map['name']);
    description = ParsingHelper.parseStringMethod(map['description']);
    thumbnailImage = ParsingHelper.parseStringMethod(map['thumbnailImage']);
    gameImages = ParsingHelper.parseListMethod<dynamic, String>(map['gameImages']);
    enabled = ParsingHelper.parseBoolMethod(map['enabled'], defaultValue: true);
    createdTime = ParsingHelper.parseTimestampMethod(map['createdTime']);
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return {
      "id" : id,
      "name" : name,
      "description" : description,
      "thumbnailImage" : thumbnailImage,
      "gameImages" : gameImages,
      "enabled" : enabled,
      "createdTime" : toJson ? createdTime?.millisecondsSinceEpoch : createdTime,
    };
  }

  @override
  String toString({bool toJson = true}) {
    return toJson ? MyUtils.encodeJson(toMap(toJson: true)) : "GameModel(${toMap(toJson: false)})";
  }
}