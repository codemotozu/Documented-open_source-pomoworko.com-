import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class Todo {
  final String id;
  String title;
  String description;
  bool isActive;
  bool isEditable;
  TextEditingController titleController;
  TextEditingController descriptionController;

  bool isFocused = false;

  String originalTitle;
  String originalDescription;
  Todo({
    String? id,
    required this.title,
    required this.description,
    this.isActive = false,
    this.isFocused = false,
    this.isEditable = false,
  })  : titleController = TextEditingController(text: title),
        descriptionController = TextEditingController(text: description),
        originalTitle = title,
        originalDescription = description,
        id = id ?? const Uuid().v4();

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isActive,
    bool? isEditable,
    TextEditingController? titleController,
    TextEditingController? descriptionController,
    String? originalTitle,
    String? originalDescription,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      isEditable: isEditable ?? this.isEditable,
    );
  }
}
