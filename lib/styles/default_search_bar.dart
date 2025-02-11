import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DefaultSearchBar extends StatelessWidget {
  const DefaultSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: const Color(0x0ff1d617).withOpacity(0.11),
                blurRadius: 40,
                spreadRadius: 0.0)
          ]),
          child: TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                contentPadding: const EdgeInsets.all(15),
                hintText: 'Search in store',
                hintStyle:
                    const TextStyle(color: Color(0xffDDDADA), fontSize: 14),
                prefixIcon: const Icon(
                    FluentSystemIcons.ic_fluent_search_regular,
                    color: Color(0xFFBFC285)),
                suffixIcon: SizedBox(
                  width: 100,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const VerticalDivider(
                          color: Color.fromARGB(255, 0, 0, 0),
                          indent: 10,
                          endIndent: 10,
                          thickness: 0.2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset("assets/images/Filter.svg"),
                        ),
                      ],
                    ),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                )),
          ),
        )
      ],
    );
  }
}
