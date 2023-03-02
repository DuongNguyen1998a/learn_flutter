import 'package:flutter/material.dart';

class LongTextPage extends StatelessWidget {
  const LongTextPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String longText =
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

    double screenWidth = MediaQuery.of(context).size.width;
    double maxWidth = screenWidth - 32;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            _ExpandableTextWidget(
              text: longText,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              maxWidth: maxWidth,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandableTextWidget extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final double maxWidth;

  const _ExpandableTextWidget({
    Key? key,
    required this.text,
    required this.textStyle,
    required this.maxWidth,
  }) : super(key: key);

  @override
  State<_ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<_ExpandableTextWidget> {
  int numLines = 1;
  int tempNumLines = 1;

  @override
  void didChangeDependencies() {
    tempNumLines = numLines = getLines(widget.text, widget.maxWidth);
    debugPrint(numLines.toString());
    super.didChangeDependencies();
  }

  int getLines(String text, double maxWidth) {
    final span = TextSpan(
      text: text,
      style: widget.textStyle,
    );
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: maxWidth);
    final numLines = tp.computeLineMetrics().length;
    return numLines;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: widget.textStyle,
          maxLines: numLines > 4 ? 4 : null,
          overflow: numLines > 4 ? TextOverflow.ellipsis : null,
        ),
        const SizedBox(height: 8),
        if (tempNumLines > 4)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (mounted) {
                setState(() {
                  numLines = numLines > 4 ? 1 : tempNumLines;
                });
              }
            },
            child: Row(
              children: [
                Text(
                  'Show ${numLines > 4 ? 'more' : 'less'}',
                  style: const TextStyle(color: Colors.blue),
                ),
                const SizedBox(width: 4),
                numLines > 4
                    ? const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue,
                      )
                    : const Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.blue,
                      ),
              ],
            ),
          ),
      ],
    );
  }
}
