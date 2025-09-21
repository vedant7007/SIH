import 'package:flutter/material.dart';

class FilterSortWidget extends StatelessWidget {
  final String searchQuery;
  final String? selectedStatus;
  final String? selectedSort;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onSortChanged;

  const FilterSortWidget({
    Key? key,
    required this.searchQuery,
    required this.selectedStatus,
    required this.selectedSort,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔍 Search Field
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search projects...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: onSearchChanged,
          ),
        ),

        // 🔽 Filters Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              // Status Dropdown
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text("All")),
                    DropdownMenuItem(value: "DRAFT", child: Text("Draft")),
                    DropdownMenuItem(
                        value: "SUBMITTED", child: Text("Submitted")),
                    DropdownMenuItem(
                        value: "APPROVED", child: Text("Approved")),
                    DropdownMenuItem(
                        value: "REJECTED", child: Text("Rejected")),
                  ],
                  onChanged: onStatusChanged,
                ),
              ),
              SizedBox(width: 12),

              // Sort Dropdown
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedSort,
                  decoration: InputDecoration(
                    labelText: "Sort By",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text("Default")),
                    DropdownMenuItem(value: "title", child: Text("Title")),
                    DropdownMenuItem(value: "date", child: Text("Date")),
                  ],
                  onChanged: onSortChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
