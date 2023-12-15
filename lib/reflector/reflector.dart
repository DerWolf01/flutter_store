import 'package:reflectable/reflectable.dart';

class Reflector extends Reflectable {
  const Reflector()
      : super(
          // superclassQuantifyCapability,
          subtypeQuantifyCapability,
          invokingCapability,
          declarationsCapability,
          metadataCapability,
          instanceInvokeCapability,
          reflectedTypeCapability,
          invokingCapability, typeCapability,
          typingCapability,
          typeRelationsCapability,
        );
}

const reflector = Reflector();
