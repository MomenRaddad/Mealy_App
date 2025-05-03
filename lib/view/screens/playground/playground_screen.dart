import 'package:flutter/material.dart';
import '../../components/custom_button.dart';
import '../../components/search_bar.dart';
import '../../components/filter_chip_list.dart';
import '../../components/section_title.dart';
import '../../components/loading_widget.dart';
import '../../components/empty_state_widget.dart';
import '../../components/pill_label.dart';

class PlaygroundScreen extends StatelessWidget {
  const PlaygroundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Playground")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SectionTitle(text: "Buttons"),
          CustomButton(
            text: "Primary Button",
            onPressed: () {},
          ),
          const SizedBox(height: 20),
          const SectionTitle(text: "Search Bar"),
          SearchBarWidget(
            hintText: "Search something...",
            onChanged: (value) {},
          ),
          const SizedBox(height: 20),
          const SectionTitle(text: "Filter Chips"),
          FilterChipList(
            filters: ["All", "Easy", "Vegan", "Fast"],
            onSelected: (filter) {},
          ),
          const SizedBox(height: 20),
          const SectionTitle(text: "Loading Widget"),
          const LoadingWidget(message: "Loading Data..."),
          const SizedBox(height: 20),
          const SectionTitle(text: "Empty State"),
          const EmptyStateWidget(
            title: "No Data Found!",
            subtitle: "Try again later.",
            icon: Icons.search_off,
          ),
          const SizedBox(height: 20),
          const SectionTitle(text: "Pill Labels"),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              PillLabel(text: "Simple"),
              PillLabel(text: "Difficult", backgroundColor: Colors.red, textColor: Colors.white),
              PillLabel(text: "20 mins", backgroundColor: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}
