import 'package:xapptor_business/models/wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/show_list_error.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';

extension StateExtension on WpeEditorState {
  bool validate_wpe(Wpe wpe) {
    final List<String> errorMessages = [];
    //Initial variables
    errorMessages.clear();
    //Validate requiered field
    if (wpe.shift == "None") {
      errorMessages.add('Shift is required.');
    }
    if (wpe.supervisor_name == "None") {
      errorMessages.add('Supervisor is required.');
    }
    if (wpe.area == "None") {
      errorMessages.add('Area is required.');
    }
    //Validate that the person list is not empty
    if (wpe.persons.isEmpty) {
      errorMessages.add('No person registered.');
    }

    //Validate Conditions
    for (var condition in wpe.conditions) {
      if (condition.not_promptly_corrected != null &&
          condition.not_promptly_corrected!.isNotEmpty) {
        if (condition.mitigating_action == null ||
            condition.mitigating_action!.isEmpty) {
          errorMessages
              .add('Mitigation Action is necesary.'); // Validación fallida
        }
      }
      if (condition.promptly_corrected != null &&
          condition.promptly_corrected!.isNotEmpty) {
        if (condition.date_corrected == null) {
          errorMessages.add(
              'If condition is promptly corrected, Date Corrected must be filled in.'); // date_corrected no puede ser nulo
        }
      }
      if (condition.date_corrected != null) {
        // final correctedDate = condition.date_corrected!;
        // final docDate = wpe.date_wpe.toDate();
        final correctedDate = normalizeDate(condition.date_corrected!);
        final docDate = normalizeDate(wpe.date_wpe.toDate());
        if (correctedDate.isBefore(docDate)) {
          errorMessages
              .add('Date Corrected must be greater or equal than Doc Date');
        }
      }
    }
    //Condiciones que deben cumplirse al cierre del WPE
    // Si "maintenance_supervisor" está lleno,
    // entonces "maintenance_comment" también debe estar lleno
    if (wpe_close) {
      if (wpe.maintenance_supervisor != "None") {
        if (wpe.maintenance_comment.isEmpty) {
          errorMessages.add('Maintenance comment must be fill in.');
        }
      }

      if (wpe.supervisor_comment.isEmpty) {
        errorMessages.add('Supervisor comment must be fill in.');
      }
    }

    if (errorMessages.isNotEmpty) {
      showListError(
          context,
          errorMessages,
          text_list.get(source_language_index)[50],
          text_list.get(source_language_index)[51]);
    }

    return errorMessages.isEmpty;
  }
}

DateTime normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
