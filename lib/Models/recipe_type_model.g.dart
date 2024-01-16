// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_type_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeTypeModelAdapter extends TypeAdapter<RecipeTypeModel> {
  @override
  final int typeId = 2;

  @override
  RecipeTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeTypeModel(
      typeName: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeTypeModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.typeName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
