import 'package:flutter/material.dart';
import 'package:xapptor_business/workplace_exam/models/wpe_font.dart';
import 'package:xapptor_ui/utils/is_portrait.dart';
import 'package:xapptor_ui/values/ui.dart';

bool show_time_amount = true;
List<WpeFont> font_families_value = [];
WpeFont current_font_value = WpeFont.empty();

class WpeEditorAdditionalOptions extends StatefulWidget {
  final Function callback;

  const WpeEditorAdditionalOptions({
    super.key,
    required this.callback,
  });

  @override
  State<WpeEditorAdditionalOptions> createState() =>
      WpeEditorAdditionalOptionsState();
}

class WpeEditorAdditionalOptionsState
    extends State<WpeEditorAdditionalOptions> {
  String font_family_title = """
      Select the Font Family for the PDF Wpe:
      Note: Only for PDF File not for Web version.
    """;

  String checkbox_label =
      'Show the amount of time at\nthe side of the timeframe';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = is_portrait(context);

    return Column(
      children: [
        SizedBox(height: sized_box_space * 2),
        Flex(
          direction: portrait ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment:
              portrait ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Text(
              font_family_title,
            ),
            if (!portrait) SizedBox(width: sized_box_space),
            DropdownButton<String>(
              value: current_font_value.name,
              items: font_families_value.map((WpeFont font) {
                return DropdownMenuItem<String>(
                  value: font.name,
                  child: Text(
                    font.name,
                    style: TextStyle(
                      fontFamily: font.google_font_family,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                current_font_value = font_families_value.firstWhere(
                  (WpeFont font) => font.name == value,
                );
                setState(() {});
              },
            ),
          ],
        ),
        if (portrait) SizedBox(height: sized_box_space),
        Row(
          children: [
            Text(
              checkbox_label,
            ),
            SizedBox(width: sized_box_space),
            Checkbox(
              value: show_time_amount,
              onChanged: (bool? value) {
                show_time_amount = value!;
                widget.callback();
              },
            ),
          ],
        ),
      ],
    );
  }
}
