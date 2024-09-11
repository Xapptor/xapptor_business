import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:xapptor_business/workplace_exam/models/wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_visualizer/wpe_skill.dart';

List<dynamic> populate_skills({
  required Resume resume,
  required BuildContext context,
}) {
  List<Widget> skills = [];
  List<pw.Widget> skills_pw = [];

  for (var skill in resume.skills) {
    skills.add(
      ResumeSkill(
        skill: skill,
        apply_variation: resume.skills.indexOf(skill) != 0,
      ),
    );

    skills_pw.add(
      resume_skill_pw(
        skill: skill,
        context: context,
      ),
    );
  }

  return [skills, skills_pw];
}
