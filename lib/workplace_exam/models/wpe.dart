import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'wpe_section.dart';
import 'package:xapptor_logic/color/hex_color.dart';

class Wpe {
  String id;
  String image_url;
  final String name;
  final String job_title;
  final String email;
  final String website;
  final List<int> sections_by_page;
  final WpeCondition profile_section;
  final List<WpeCondition> condition_sections;
  final Color icon_color;
  final String language_code;
  List<String> text_list;
  final Timestamp creation_date;
  final String user_id;
  int slot_index;
  final Uint8List? chosen_image_bytes;
  String font_name = 'Nunito';
  bool show_time_amount = true;

  Wpe({
    this.id = "",
    required this.image_url,
    required this.name,
    required this.job_title,
    required this.email,
    required this.website,
    required this.sections_by_page,
    required this.profile_section,
    required this.condition_sections,
    required this.icon_color,
    required this.language_code,
    required this.text_list,
    required this.creation_date,
    required this.user_id,
    required this.slot_index,
    required this.chosen_image_bytes,
    required this.font_name,
    required this.show_time_amount,
  });

  Wpe.from_snapshot(
    this.id,
    Map<dynamic, dynamic> snapshot,
  )   : image_url = snapshot['image_url'] ?? '',
        name = snapshot['name'] ?? '',
        job_title = snapshot['job_title'] ?? '',
        email = snapshot['email'] ?? '',
        website = snapshot['website'] ?? '',
        sections_by_page = ((snapshot['sections_by_page'] ?? []) as List)
            .map((e) => e as int)
            .toList(),
        profile_section =
            WpeCondition.from_snapshot(snapshot['profile_section']),
        condition_sections = (snapshot['condition_sections'] as List)
            .map((section) => WpeCondition.from_snapshot(section))
            .toList(),
        icon_color = HexColor.fromHex(snapshot['icon_color']),
        language_code = snapshot['language_code'] ?? 'en',
        text_list =
            (snapshot['text_list'] as List).map((e) => e as String).toList(),
        creation_date = snapshot['creation_date'] ?? Timestamp.now(),
        user_id = snapshot['user_id'] ?? '',
        slot_index = snapshot['slot_index'] ?? 0,
        chosen_image_bytes = null,
        font_name = snapshot['font_name'] ?? 'Nunito',
        show_time_amount = snapshot['show_time_amount'] ?? true;

  Map<String, dynamic> to_json() {
    return {
      'image_url': image_url,
      'name': name,
      'job_title': job_title,
      'email': email,
      'website': website,
      'sections_by_page': sections_by_page,
      'profile_section': profile_section.to_json(),
      'condition_sections': condition_sections.map((e) => e.to_json()),
      'icon_color': icon_color.toHex(),
      'language_code': language_code,
      'text_list': text_list,
      'creation_date': creation_date,
      'user_id': user_id,
      'slot_index': slot_index,
      'font_name': font_name,
      'show_time_amount': show_time_amount,
    };
  }

  Map<String, dynamic> to_pretty_json() {
    return {
      'image_url': image_url,
      'name': name,
      'job_title': job_title,
      'email': email,
      'website': website,
      'sections_by_page': sections_by_page,
      'profile_section': profile_section.to_pretty_json(),
      'condition_sections':
          condition_sections.map((e) => e.to_pretty_json()).toList(),
      'icon_color': icon_color.toHex(),
      'language_code': language_code,
      'text_list': text_list,
      'creation_date': creation_date.toDate().toIso8601String(),
      'user_id': user_id,
      'slot_index': slot_index,
      'font_name': font_name,
      'show_time_amount': show_time_amount,
    };
  }

  Wpe.from_json(
    this.id,
    Map<String, dynamic> json,
  )   : image_url = json['image_url'] ?? '',
        name = json['name'] ?? '',
        job_title = json['job_title'] ?? '',
        email = json['email'] ?? '',
        website = json['website'] ?? '',
        sections_by_page =
            (json['sections_by_page'] as List).map((e) => e as int).toList(),
        profile_section = WpeCondition.from_json(json['profile_section']),
        condition_sections = (json['condition_sections'] as List)
            .map((section) => WpeCondition.from_json(section))
            .toList(),
        icon_color = HexColor.fromHex(json['icon_color']),
        language_code = json['language_code'] ?? 'en',
        text_list =
            (json['text_list'] as List).map((e) => e as String).toList(),
        creation_date = json['creation_date'] != null
            ? Timestamp.fromDate(DateTime.parse(json['creation_date']))
            : Timestamp.now(),
        user_id = json['user_id'] ?? '',
        slot_index = json['slot_index'] ?? 0,
        chosen_image_bytes = null,
        font_name = json['font_name'] ?? 'Nunito',
        show_time_amount = json['show_time_amount'] ?? true;

  factory Wpe.empty() {
    return Wpe(
      image_url: '',
      name: '',
      job_title: '',
      email: '',
      website: '',
      sections_by_page: [],
      profile_section: WpeCondition.empty(),
      condition_sections: [],
      icon_color: Colors.blue,
      language_code: 'en',
      text_list: [],
      creation_date: Timestamp.fromDate(
        DateTime(2014, 5, 10),
      ),
      user_id: '',
      slot_index: 0,
      chosen_image_bytes: null,
      font_name: 'Nunito',
      show_time_amount: true,
    );
  }
}
