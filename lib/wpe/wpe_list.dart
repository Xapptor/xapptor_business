import 'package:flutter/material.dart';
import 'package:xapptor_auth/model/xapptor_user.dart';
import 'package:xapptor_business/wpe/model/workplace_exam.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_ui/widgets/is_portrait.dart';

class WpeList extends StatefulWidget {
  const WpeList({super.key});

  @override
  State createState() => _WpeListState();
}

class _WpeListState extends State<WpeList> {
  List<WorkplaceExam> wpes = [];

  fetch_wpes() async {
    get_wpes((List<WorkplaceExam> new_wpes) {
      wpes = new_wpes;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    fetch_wpes();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool portrait = is_portrait(context);

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: wpes.isEmpty
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: SizedBox(
                  width: width,
                  child: FractionallySizedBox(
                    widthFactor: portrait ? 0.9 : 0.4,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: sized_box_space * 4,
                            bottom: sized_box_space * 2,
                          ),
                          child: const Text(
                            'Workplace Exam History',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: sized_box_space * 2,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: wpes.length,
                            itemBuilder: (context, index) {
                              WorkplaceExam wpe = wpes[index];
                              return WpeTile(
                                wpe: wpe,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );

    // return SingleChildScrollView(
    //   child: Column(
    //     children: [
    //       Text(
    //         'Pending',
    //         style: TextStyle(
    //           fontSize: 20,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //       Text(
    //         'Closed',
    //         style: TextStyle(
    //           fontSize: 20,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //       Text(
    //         'Current',
    //         style: TextStyle(
    //           fontSize: 20,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //       ListView.builder(
    //         itemBuilder: (context, index) {
    //           return ListTile(
    //             title: Text('Title'),
    //             subtitle: Text('Subtitle'),
    //           );
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }
}

class WpeTile extends StatefulWidget {
  final WorkplaceExam wpe;

  const WpeTile({
    super.key,
    required this.wpe,
  });

  @override
  State<WpeTile> createState() => _WpeTileState();
}

class _WpeTileState extends State<WpeTile> {
  String user_name = '';

  @override
  void initState() {
    super.initState();
    get_user_info();
  }

  get_user_info() async {
    XapptorUser user = await get_xapptor_user(id: widget.wpe.user_id);
    user_name = '${user.firstname} ${user.lastname}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Competent Person: $user_name\nWPE ID: ${widget.wpe.id}';

    return ListTile(
      title: Text(
        title,
      ),
      onTap: () {
        //
      },
    );
  }
}
