import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class ButtonFilter extends StatefulWidget {
  const ButtonFilter({
    super.key,
    this.index = 0,
    required this.onTap,
  });

  final int index;
  final Function(int index) onTap;

  @override
  State<ButtonFilter> createState() => _ButtonFilterState();
}

class _ButtonFilterState extends State<ButtonFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(kRadiusDeffault),
      ),
      padding: const EdgeInsets.symmetric(horizontal: kDeffaultPadding, vertical: kDeffaultPadding),
      child: Row(
        children: List.generate(4, (i) {
          late String label;
          switch (i) {
            case 0:
              label = 'Year';
              break;
            case 1:
              label = 'Month';
              break;
            case 2:
              label = 'Day';
              break;
            case 3:
              label = 'Hour';
              break;
            default:
          }
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            i == widget.index ? Colors.amber : kPrimaryColor.withGreen(100)),
                    onPressed: () {
                      widget.onTap.call(i);
                    },
                    child: Text(label),
                  ),
                ),
                if (i != 3)
                  const SizedBox(
                    width: 4,
                  ),
              ],
            ),
          );
        }),
      ),
      // child: ListView.separated(
      //   shrinkWrap: true,
      //   physics: NeverScrollableScrollPhysics(),
      //   scrollDirection: Axis.horizontal,
      //   itemCount: 3,
      //   separatorBuilder: (context, index) => SizedBox(
      //     width: index != 2 ? 8 : 0,
      //   ),
      //   itemBuilder: (context, index) {
      //     late String label;
      //     switch (index) {
      //       case 0:
      //         label = 'Year';
      //         break;
      //       case 1:
      //         label = 'Month';
      //         break;
      //       case 2:
      //         label = 'Day';
      //         break;
      //       default:
      //     }
      //     return ElevatedButton(
      //       // style: ElevatedButton.styleFrom(
      //       //   minimumSize: Size.fromHeight(,
      //       // ),
      //       onPressed: () {},
      //       child: Text(label),
      //     );
      //   },
      // ),
    );
  }
}
