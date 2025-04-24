import 'dart:ui';

class ColorManager{
  static Color appBackground= HexColor.fromHex("#FFFFFF");
  static Color headingColor1= HexColor.fromHex("#262C48");
  static Color headingColor2= HexColor.fromHex("#374277");
  // static Color primary= HexColor.fromHex("#064DBB");
  static Color primary= HexColor.fromHex("#8FC31F");
  static Color primary1= HexColor.fromHex("#E40077");
  static Color primary2= HexColor.fromHex("#F8B62D");
  static Color blue= HexColor.fromHex("#0C5983");
  static Color teal= HexColor.fromHex("#62C0B4");
  static Color brown= HexColor.fromHex("#40210F");
  static Color purple= HexColor.fromHex("#601986");
  static Color white= HexColor.fromHex("#FFFFFF");
  static Color black= HexColor.fromHex("#2D2D2D");
  static Color grey= HexColor.fromHex("#E9E9E9");
  static Color red= HexColor.fromHex("#FF3A30");
  static Color green= HexColor.fromHex("#35C759");
  static Color darkGreen= HexColor.fromHex("#008000");

}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString";
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}