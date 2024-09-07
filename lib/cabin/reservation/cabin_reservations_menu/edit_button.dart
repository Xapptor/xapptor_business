import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/cabin_reservations_menu.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/get_current_available_cabins.dart';

extension StateExtension on CabinReservationsMenuState {
  edit_button(String reservation_id) async {
    show_creation_menu = true;
    current_reservation = reservations.firstWhere((element) => element.id == reservation_id);

    selected_date_1 = current_reservation!.date_init;
    date_label_1 = label_date_formatter.format(selected_date_1);

    selected_date_2 = current_reservation!.date_end;
    date_label_2 = label_date_formatter.format(selected_date_1);

    get_current_available_cabins(
      ignore_reservation_with_id: reservation_id,
      cabins: cabins,
    );
  }
}
