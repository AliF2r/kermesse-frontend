import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/stand_data.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/services/stand_service.dart';
import 'package:kermesse_frontend/widgets/app_theme_helper.dart';
import 'package:kermesse_frontend/widgets/confirmation_dialog.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';
import 'package:kermesse_frontend/widgets/stand_card_list.dart';

class OrganizerinviteStandKermesseScreen extends StatefulWidget {
  final int kermesseId;

  const OrganizerinviteStandKermesseScreen({
    super.key,
    required this.kermesseId,
  });

  @override
  State<OrganizerinviteStandKermesseScreen> createState() =>
      _OrganizerinviteStandKermesseScreenState();
}

class _OrganizerinviteStandKermesseScreenState extends State<OrganizerinviteStandKermesseScreen> {

  final Key _key = UniqueKey();

  final StandService _standService = StandService();
  final KermesseService _kermesseService = KermesseService();

  Future<List<StandList>> _getAllStands() async {
    ApiResponse<List<StandList>> response = await _standService.getAllStands(isReady: true);
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  Future<void> _inviteStandToKermesse(int standId) async {
    ApiResponse<Null> response = await _kermesseService.inviteStandForKermesse(kermesseId: widget.kermesseId, standId: standId);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.error!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stand invited successfully'),
        ),
      );
      _init();
    }
  }

  Future<void> _showConfirmationDialog(int standId) async {
    showConfirmationDialog(
      context,
      'Are you sure you want to invite this stand?',
          () => _inviteStandToKermesse(standId),
    );
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Text(
                "Available Stands: ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<StandList>>(
                key: _key,
                future: _getAllStands(),
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
                          isClickable: true,
                          onTap: () async {
                            await _showConfirmationDialog(stand.id);
                          },
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
