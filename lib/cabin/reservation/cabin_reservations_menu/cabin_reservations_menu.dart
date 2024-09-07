import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_business/cabin/payments/register_payment.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservation_card/cabin_reservation_card.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservation_text_list.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/edit_button.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/get_current_reservations.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/get_floating_action_button.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/get_topbar.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/older_reservations_switch.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/select_date.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/show_edit_alert_dialog.dart';
import 'package:xapptor_business/cabin/cabins/get_cabin_from_id.dart';
import 'package:xapptor_business/cabin/cabins/get_cabins.dart';
import 'package:xapptor_business/cabin/payments/get_payments_by_reservation.dart';
import 'package:xapptor_business/cabin/reservation/get_reservation_period_label.dart';
import 'package:xapptor_business/cabin/payments/get_total_price_from_date_range.dart';
import 'package:xapptor_business/cabin/payments/get_total_price_from_reservation.dart';
import 'package:xapptor_business/models/cabin.dart';
import 'package:xapptor_business/models/payment.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';
import 'package:xapptor_business/models/season.dart';
import 'package:xapptor_logic/date/get_range_of_dates.dart';
import 'package:xapptor_logic/user/get_user_info.dart';
import 'package:xapptor_ui/utils/is_portrait.dart';
import 'package:xapptor_translation/translation_stream.dart';

class CabinReservationsMenu extends StatefulWidget {
  final Color topbar_color;
  final String website_url;
  final List<Season> seasons;

  const CabinReservationsMenu({
    super.key,
    required this.topbar_color,
    required this.website_url,
    required this.seasons,
  });

  @override
  State<CabinReservationsMenu> createState() => CabinReservationsMenuState();
}

class CabinReservationsMenuState extends State<CabinReservationsMenu> {
  bool show_creation_menu = false;

  late TranslationStream translation_stream;
  List<TranslationStream> translation_stream_list = [];

  int source_language_index = 1;

  update_source_language({
    required int new_source_language_index,
  }) {
    source_language_index = new_source_language_index;
    setState(() {});
  }

  update_text_list({
    required int index,
    required String new_text,
    required int list_index,
  }) {
    text_list.get(source_language_index)[index] = new_text;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();

    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pop(context);
    } else {
      translation_stream = TranslationStream(
        translation_text_list_array: text_list,
        update_text_list_function: update_text_list,
        list_index: 0,
        source_language_index: source_language_index,
      );

      translation_stream_list = [translation_stream];

      get_current_cabins();
    }
  }

  DateTime selected_date_1 = DateTime.now();
  DateTime selected_date_2 = DateTime.now();
  String date_label_1 = "";
  String date_label_2 = "";

  List<Cabin> cabins = [];
  List<ReservationCabin> reservations = [];
  int selected_date_index = 0;

  List<Cabin> available_cabins = [];
  String selected_cabin = "";
  ReservationCabin? current_reservation;

  DateFormat label_date_formatter = DateFormat.yMMMMd('en_US');

  update_selected_cabin(String new_cabin) {
    selected_cabin = new_cabin;
    setState(() {});
  }

  get_current_cabins() async {
    user_id = FirebaseAuth.instance.currentUser!.uid;
    user_info = await get_user_info(user_id);

    cabins = await get_cabins();
    get_current_reservations();
  }

  Map<String, dynamic> user_info = {};
  String user_id = "";

  cancel_button() {
    date_label_1 = "";
    date_label_2 = "";
    show_creation_menu = false;
    current_reservation = null;
    setState(() {});
  }

  bool show_older_reservations = false;

  TextEditingController amount_input_controller = TextEditingController();

  String reservation_period_label = "";

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    bool portrait = is_portrait(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: get_topbar(),
      body: Container(
        alignment: Alignment.center,
        child: !show_creation_menu
            ? Column(
                mainAxisAlignment: reservations.isEmpty ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
                children: [
                  older_reservations_switch(),
                  SizedBox(
                    height: screen_height * (portrait ? 0.8 : 0.8),
                    child: reservations.isEmpty
                        ? FractionallySizedBox(
                            widthFactor: (portrait ? 0.85 : 1),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                text_list.get(source_language_index)[26],
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : ListView(
                            shrinkWrap: true,
                            children: [
                              SizedBox(height: screen_height / 20),
                              Text(
                                text_list.get(source_language_index)[25],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: reservations.length,
                                itemBuilder: (context, index) {
                                  Cabin current_cabin = get_cabin_from_id(
                                    id: reservations[index].cabin_id,
                                    cabins: cabins,
                                  );

                                  int total_price_from_reservation = get_total_price_from_reservation(
                                    reservation: reservations[index],
                                    cabin_season_price: current_cabin.get_season_price(
                                      date_1: reservations[index].date_init,
                                      date_2: reservations[index].date_end,
                                      seasons: widget.seasons,
                                    ),
                                  );

                                  return FractionallySizedBox(
                                    widthFactor: portrait ? 0.9 : 0.4,
                                    child: FutureBuilder<List<Payment>>(
                                      future: get_payments_by_reservation(
                                        reservations[index],
                                      ),
                                      builder: (
                                        BuildContext context,
                                        AsyncSnapshot<List<Payment>> reservation_payments,
                                      ) {
                                        if (reservation_payments.hasData) {
                                          return Container(
                                            height: screen_height * (portrait ? 0.55 : 0.5),
                                            margin: const EdgeInsets.all(10),
                                            child: CabinReservationCard(
                                              reservation: reservations[index],
                                              select_date_available: true,
                                              select_date_callback: select_date,
                                              main_color: widget.topbar_color,
                                              text_list: text_list.get(source_language_index),
                                              cabin: current_cabin,
                                              reservation_period_label: get_reservation_period_label(
                                                date_1: reservations[index].date_init,
                                                date_2: reservations[index].date_end,
                                                source_language: text_list.list[source_language_index].source_language,
                                              ),
                                              selected_cabin: selected_cabin,
                                              update_selected_cabin: update_selected_cabin,
                                              register_reservation: (String reservation_id, bool register) =>
                                                  show_edit_alert_dialog(reservation_id, register),
                                              available_cabins: available_cabins,
                                              cancel_button_callback: () => cancel_button(),
                                              delete_button_callback: (String reservation_id, bool register) =>
                                                  show_edit_alert_dialog(reservation_id, register),
                                              edit_button_callback: (String reservation_id) =>
                                                  edit_button(reservation_id),
                                              editing_mode: show_creation_menu,
                                              register_payment_callback: (String reservation_id) => register_payment(
                                                  reservation_id: reservation_id,
                                                  context: context,
                                                  parent: this,
                                                  amount_input_controller: amount_input_controller,
                                                  text_list: text_list.get(source_language_index),
                                                  get_reservations_callback: get_current_reservations,
                                                  reservations: reservations,
                                                  user_info: user_info,
                                                  website_url: widget.website_url,
                                                  cabins: cabins,
                                                  reservation_payments: reservation_payments.data!,
                                                  source_language:
                                                      text_list.list[source_language_index].source_language,
                                                  seasons: widget.seasons,
                                                  show_older_reservations: show_older_reservations),
                                              total_price_from_reservation: total_price_from_reservation,
                                              reservation_payments_total: reservation_payments.data!.isNotEmpty
                                                  ? reservation_payments.data!
                                                      .map((payment) => payment.amount)
                                                      .toList()
                                                      .reduce((a, b) => a + b)
                                                  : 0,
                                              user_info: user_info,
                                              seasons: widget.seasons,
                                              number_of_days: get_range_of_dates(
                                                          reservations[index].date_init, reservations[index].date_end)
                                                      .length -
                                                  1,
                                            ),
                                          );
                                        } else {
                                          if (index == 0) {
                                            return Container(
                                              margin: EdgeInsets.only(top: screen_height / 5),
                                              child: FractionallySizedBox(
                                                widthFactor: 0.2,
                                                child: AspectRatio(
                                                  aspectRatio: 1,
                                                  child: CircularProgressIndicator(
                                                    color: widget.topbar_color,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: screen_height / 20),
                            ],
                          ),
                  ),
                ],
              )
            : date_label_1.isEmpty || date_label_2.isEmpty
                ? null
                : SizedBox(
                    height: screen_height * (portrait ? 0.6 : 0.55),
                    width: screen_width * (portrait ? 0.9 : 0.4),
                    child: CabinReservationCard(
                      reservation: current_reservation,
                      select_date_available: true,
                      select_date_callback: select_date,
                      main_color: widget.topbar_color,
                      text_list: text_list.get(source_language_index),
                      cabin: get_cabin_from_id(
                        id: selected_cabin,
                        cabins: available_cabins,
                      ),
                      reservation_period_label: get_reservation_period_label(
                        date_1: selected_date_1,
                        date_2: selected_date_2,
                        source_language: text_list.list[source_language_index].source_language,
                      ),
                      selected_cabin: selected_cabin,
                      update_selected_cabin: update_selected_cabin,
                      register_reservation: (String reservation_id, bool register) =>
                          show_edit_alert_dialog(reservation_id, register),
                      available_cabins: available_cabins,
                      cancel_button_callback: () => cancel_button(),
                      delete_button_callback: (String reservation_id, bool register) =>
                          show_edit_alert_dialog(reservation_id, register),
                      edit_button_callback: (String reservation_id) {},
                      editing_mode: show_creation_menu,
                      register_payment_callback: (String reservation_id) {},
                      total_price_from_reservation: current_reservation == null
                          ? get_total_price_from_date_range(
                              cabin_season_price: get_cabin_from_id(
                                id: selected_cabin,
                                cabins: available_cabins,
                              ).get_season_price(
                                date_1: selected_date_1,
                                date_2: selected_date_2,
                                seasons: widget.seasons,
                              ),
                              date_1: selected_date_1,
                              date_2: selected_date_2,
                            )
                          : get_total_price_from_reservation(
                              reservation: current_reservation!,
                              cabin_season_price: get_cabin_from_id(
                                id: current_reservation!.cabin_id,
                                cabins: available_cabins,
                              ).get_season_price(
                                date_1: current_reservation!.date_init,
                                date_2: current_reservation!.date_end,
                                seasons: widget.seasons,
                              ),
                            ),
                      reservation_payments_total: 0,
                      user_info: user_info,
                      seasons: widget.seasons,
                      number_of_days: get_range_of_dates(selected_date_1, selected_date_2).length - 1,
                    ),
                  ),
      ),
      floatingActionButton: get_floating_action_button(),
    );
  }
}
