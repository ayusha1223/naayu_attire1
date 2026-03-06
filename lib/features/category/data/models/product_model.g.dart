// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 0;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      image: fields[1] as String,
      previewImage: fields[2] as String?,
      name: fields[3] as String,
      price: fields[4] as double,
      description: fields[5] as String,
      rating: fields[6] as double,
      sizes: (fields[7] as List).cast<String>(),
      color: fields[8] as String,
      isNew: fields[9] as bool,
      oldPrice: fields[10] as double?,
      category: fields[11] as String,
      quantity: fields[12] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.previewImage)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.rating)
      ..writeByte(7)
      ..write(obj.sizes)
      ..writeByte(8)
      ..write(obj.color)
      ..writeByte(9)
      ..write(obj.isNew)
      ..writeByte(10)
      ..write(obj.oldPrice)
      ..writeByte(11)
      ..write(obj.category)
      ..writeByte(12)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
