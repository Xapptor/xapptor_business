import 'package:xapptor_translation/model/text_list.dart';

class DepartmentTextLists {
  TranslationTextListArray text_list({
    required String organization_name,
  }) =>
      TranslationTextListArray(
        [
          TranslationTextList(
            source_language: "en",
            text_list: [
              //Header Section
              "Department Name",
              "Date / Time",
            ],
          ),
          TranslationTextList(
            source_language: "es",
            text_list: [
              "Nombre Departamento",
              "Fecha / Hora",
            ],
          ),
        ],
      );

  TranslationTextListArray alert_text_list = TranslationTextListArray(
    [
      TranslationTextList(
        source_language: "en",
        text_list: [
          "Menu",
          "Close",
          "New",
          "Save",
          "Add",
        ],
      ),
      TranslationTextList(
        source_language: "es",
        text_list: [
          "Menú",
          "Cerrar",
          "Adicionar",
          "Guardar",
          "Añadir",
        ],
      ),
    ],
  );
}
