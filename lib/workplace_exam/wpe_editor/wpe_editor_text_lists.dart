import 'package:xapptor_translation/model/text_list.dart';

class WpeEditorTextLists {
  TranslationTextListArray text_list({
    required String organization_name,
  }) =>
      TranslationTextListArray(
        [
          TranslationTextList(
            source_language: "en",
            text_list: [
              //Header Section
              "Doc Id",
              "Date / Time",
              "Shift",
              "Area",
              "Equiment/Specific",
              "Supervisor",
              //Other Sections
              "ERP or Order Number",
              "Transversal/Location",
              "Maintenance Supervisor",

              "Title",
              "Subtitle",
              "Description",
              "Choose Dates",
              "Choose initial date",
              "Choose end date",
              "Conditions",

              // ERICP Section
              "Eliminated",
              "Reduced",
              "Isolated",
              "Controled",
              "PPE",

              // Maintenance Section
              "Maintenance Comment",

              // Maintenance Section
              "Supervisor Comment", //22

              "Sections",
              "Competent Person(s) Section", //24
              "Other Section", //25
              "Hazards Section", //26
              "ERICP Section", //27
              "Maintenance Section", //28
              "Supervisor Section", //29

              // Hazard Section
              "LOTOTO", //30
              "HIT OR CAUGHT", //31
              "BURN", //32
              "HEALTH", //33
              "WORK ENVIRONMENT CONDITION", //34
              "FALL", //35

              "Add to List", //36
              "Competent Person", //37
              "Before adding a new section you must first complete the last one",
              "Wpe available online at:",
              "Wpe Developed and Hosted by $organization_name:",
              "Use Example Wpe",
            ],
          ),
          TranslationTextList(
            source_language: "es",
            text_list: [
              "Doc Id",
              "Fecha / Hora",
              "Turno",
              "Area",
              "Equipo Especifico",
              "Supervisor",
              "Vista Previa del CV",
              "Historial de Empleo",
              "Título",
              "Subtítulo",
              "Descripción",
              "Presente",
              "Seleccionar Fechas",
              "Selecciona fecha de inicio",
              "Selecciona fecha de finalización",
              "Condicion",
              "Secciones Personalizadas",
              "Antes de agregar una nueva sección primero debes de completar la última",
              "CV disponible en línea en:",
              "CV Desarrollado y Alojado por $organization_name:",
              "Usar CV de Ejemplo",
            ],
          ),
        ],
      );

  TranslationTextListArray alert_text_list = TranslationTextListArray(
    [
      TranslationTextList(
        source_language: "en",
        text_list: [
          "Which slot do you want to load?",
          "Which slot do you want to delete?",
          "Are you sure you want to delete this Wpe?",
          "In which slot do you want to save your Wpe?",
          "Your Wpe has been saved, do you want to save an extra backup?",
          "No",
          "Yes",
          "Cancel",
          "Backup",
          "Main",
          "You don't have backups at the moment",
          "First you must save one",
          "Ok",
          "Current Wpe Slot",
          "Wpe Loaded",
          "Wpe Saved",
          "Wpe Deleted",
          "Load",
          "Save",
          "Delete",
          "Download",
          "Menu",
          "Close",
        ],
      ),
      TranslationTextList(
        source_language: "es",
        text_list: [
          "¿Qué ranura deseas cargar?",
          "¿Qué ranura deseas eliminar?",
          "¿Estás seguro de que deseas eliminar este CV?",
          "¿En qué ranura deseas guardar tu CV?",
          "Tu CV ha sido guardado, ¿deseas guardar un respaldo extra?",
          "No",
          "Sí",
          "Cancelar",
          "Respaldo",
          "Principal",
          "Por el momento no posees respaldos",
          "Primero debes guardar uno",
          "Ok",
          "Ranura Actual del CV",
          "CV Cargado",
          "CV Guardado",
          "CV Eliminado",
          "Cargar",
          "Guardar",
          "Eliminar",
          "Descargar",
          "Menú",
          "Cerrar",
        ],
      ),
    ],
  );

  TranslationTextListArray education_text_list = TranslationTextListArray(
    [
      TranslationTextList(
        source_language: "en",
        text_list: [
          "Condition Promptly Corrected",
          "Condition Not Promptly Corrected",
          "If Not Corrected, Mitigating Action(s) Taken",
        ],
      ),
      TranslationTextList(
        source_language: "es",
        text_list: [
          "Condición Inmediatamente Corregida",
          "Condición no Corregida",
          "Condición no Corregida, se tomaron acciones de mitigación",
        ],
      ),
    ],
  );

  TranslationTextListArray picker_text_list = TranslationTextListArray(
    [
      TranslationTextList(
        source_language: "en",
        text_list: [
          "Choose Photo",
          "Choose Main Color",
          "Choose Color",
        ],
      ),
      TranslationTextList(
        source_language: "es",
        text_list: [
          "Seleccionar Foto",
          "Selecciona el Color Principal",
          "Selecciona el Color",
        ],
      ),
    ],
  );

  TranslationTextListArray sections_by_page_text_list =
      TranslationTextListArray(
    [
      TranslationTextList(
        source_language: "en",
        text_list: [
          "Enter the numbers of sections by page separate by comas",
          "Example: 7, 2",
        ],
      ),
      TranslationTextList(
        source_language: "es",
        text_list: [
          "Ingresa los números de secciones por página separados por comas",
          "Ejemplo: 7, 2",
        ],
      ),
    ],
  );

  TranslationTextListArray time_text_list = TranslationTextListArray(
    [
      TranslationTextList(
        source_language: "en",
        text_list: [
          "Year",
          "Years",
          "Month",
          "Months",
        ],
      ),
      TranslationTextList(
        source_language: "es",
        text_list: [
          "Año",
          "Años",
          "Mes",
          "Meses",
        ],
      ),
    ],
  );
}
