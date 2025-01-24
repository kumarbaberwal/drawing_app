import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'custom_offset.g.dart';

@HiveType(typeId: 0)
class CustomOffset extends HiveObject {
  @HiveField(0)
  final double dx;

  @HiveField(1)
  final double dy;

  CustomOffset(this.dx, this.dy);

  Offset toOffset() => Offset(dx, dy);

  factory CustomOffset.fromOffset(Offset offset) {
    return CustomOffset(offset.dx, offset.dy);
  }
}
