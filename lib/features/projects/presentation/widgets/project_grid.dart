import 'package:flutter/material.dart';
import '../../domain/entities/project.dart';
import 'project_card.dart';

class ProjectGrid extends StatelessWidget {
  final List<Project> projects;
  final Function(Project)? onProjectTap;

  const ProjectGrid({
    super.key,
    required this.projects,
    this.onProjectTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return ProjectCard(
              project: project,
              onTap: () => onProjectTap?.call(project),
            );
          },
        );
      },
    );
  }
}