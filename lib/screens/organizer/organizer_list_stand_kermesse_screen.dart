import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/stand_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/stand_service.dart';
import 'package:kermesse_frontend/widgets/app_theme_helper.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';
import 'package:kermesse_frontend/widgets/stand_card_list.dart';

class OrganizerListStandKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const OrganizerListStandKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<OrganizerListStandKermesseScreen> createState() =>
      _OrganizerListStandKermesseScreenState();
}

class _OrganizerListStandKermesseScreenState extends State<OrganizerListStandKermesseScreen> {
  final Key _key = UniqueKey();

  final StandService _standService = StandService();

  Future<List<StandList>> _getAll() async {
    ApiResponse<List<StandList>> response = await _standService.getAllStands(kermesseId: widget.kermesseId);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  void _init() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: 'List of Stands'),
      body: ScreenList(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomButton(
                    text: 'Stand Invitation',
                    onPressed: () async {
                      await context.push(
                        OrganizerRoutes.kermesseInvitationStands,
                        extra: {
                          'kermesseId': widget.kermesseId,
                        },
                      );
                      _init();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Text(
                "Stands: ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<StandList>>(
                key: _key,
                future: _getAll(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        StandList stand = snapshot.data![index];
                        return StandCard(
                          icon: AppThemeHelper.getStandIcon(stand.category),
                          title: stand.name,
                          subtitle: 'Category: ${stand.category}',
                          description: stand.description,
                          price: 'Price: ${stand.price}',
                          onTap: () {},
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text('No stands found'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
