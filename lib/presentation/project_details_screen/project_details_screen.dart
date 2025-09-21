import 'package:flutter/material.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project['title'] ?? 'Project Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("📌 Title: ${project['title'] ?? ''}"),
            SizedBox(height: 8),
            Text("📝 Description: ${project['description'] ?? ''}"),
            SizedBox(height: 8),
            Text("🌱 Saplings: ${project['saplings'] ?? ''}"),
            SizedBox(height: 8),
            Text("📍 Location: ${project['lat']}, ${project['lng']}"),
            SizedBox(height: 8),
            Text("🌿 Species: ${project['species'] ?? ''}"),
            SizedBox(height: 8),
            Text("📅 Status: ${project['status'] ?? ''}"),
          ],
        ),
      ),
    );
  }
}
