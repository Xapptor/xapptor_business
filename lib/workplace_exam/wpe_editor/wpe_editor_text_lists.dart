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
              "Shift *",
              "Area *",
              "Equiment/Specific",
              "Supervisor *",
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
              "Maintenance Comment *",

              // Supervisor Section
              "Supervisor Comment *", //22

              "Sections",
              "Competent Person(s) Section *", //24
              "Other Section", //25
              "Hazards Section", //26
              "ERICP Section", //27
              "Maintenance Section", //28
              "Supervisor Section", //29

              // Hazard Section
              "LOTOTO", //30
              "Hit or Caught", //31
              "Burn", //32
              "Health", //33
              "Work Environment Condition", //34
              "Fall", //35

              "Add to List", //36
              "Competent Person", //37
              "Department", //38
              "Responsible", //39
              "Present and/or Potential Hazards", //40
              "DOC Status:", //41
              "Close ", //42
              "Open  ", //43
              "Date Close:", //44

              "Before adding a new section you must first complete the last one",
              "Doc available online at:",
              "Doc Developed and Hosted by $organization_name:",
              "Use Example Doc",
              "Date", //49

              "Validation Errors", //50
              "Continue" //51
            ],
          ),
          TranslationTextList(
            source_language: "es",
            text_list: [
              "Doc Id",
              "Fecha / Hora",
              "Turno",
              "Área",
              "Equipo/Específico",
              "Supervisor",
              // Otros apartados
              "Número de ERP o de Orden",
              "Ubicación Transversal",
              "Supervisor de Mantenimiento",

              "Título",
              "Subtítulo",
              "Descripción",
              "Elegir Fechas",
              "Elige la fecha inicial",
              "Elige la fecha final",
              "Condiciones",

              // Sección ERICP
              "Eliminado",
              "Reducido",
              "Aislado",
              "Controlado",
              "EPP",

              // Sección de Mantenimiento
              "Comentario de Mantenimiento",

              // Sección de Supervisor
              "Comentario del Supervisor", //22

              "Secciones",
              "Sección de Persona(s) Competente(s)", //24
              "Otra Sección", //25
              "Sección de Peligros", //26
              "Sección ERICP", //27
              "Sección de Mantenimiento", //28
              "Sección de Supervisor", //29

              // Sección de Peligros
              "LOTOTO", //30
              "Golpe o Atrapamiento", //31
              "Quemadura", //32
              "Salud", //33
              "Condición del Entorno de Trabajo", //34
              "Caída", //35

              "Agregar a la Lista", //36
              "Persona Competente", //37
              "Departamento", //38
              "Responsable", //39
              "Peligros Presentes y/o Potenciales", //40
              "Estado de DOC:", //41
              "Cerrar", //42
              "Abrir", //43
              "Fecha de Cierre:", //44

              "Antes de agregar una nueva sección primero debes de completar la última",
              "Doc disponible en línea en:",
              "Doc Desarrollado y Alojado por $organization_name:",
              "Usar Doc de Ejemplo",
              "Fecha",

              "Errores de Validacion", //50
              "Continue" //51
            ],
          ),
        ],
      );

  TranslationTextListArray alert_text_list = TranslationTextListArray(
    [
      TranslationTextList(
        source_language: "en",
        text_list: [
          "Do you want to create a new DOC?",
          "Do you want to delete this DOC?",
          "Are you sure you want to delete this DOC?",
          "Do you want to save your DOC?",
          "Your Doc has been saved, do you want to save an extra backup?",
          "No",
          "Yes",
          "Cancel",
          "Backup",
          "Main",
          "You don't have backups at the moment",
          "First you must save one",
          "Ok",
          "Current Doc",
          "Doc Loaded",
          "Doc Saved",
          "Doc Deleted",
          "New",
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
          "¿Estás seguro de que deseas eliminar este DOC?",
          "¿En qué ranura deseas guardar tu DOC?",
          "Tu DOC ha sido guardado, ¿deseas guardar un respaldo extra?",
          "No",
          "Sí",
          "Cancelar",
          "Respaldo",
          "Principal",
          "Por el momento no posees respaldos",
          "Primero debes guardar uno",
          "Ok",
          "DOC Actual",
          "DOC Cargado",
          "DOC Guardado",
          "DOC Eliminado",
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
