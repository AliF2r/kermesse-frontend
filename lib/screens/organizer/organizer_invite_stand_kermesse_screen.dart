import 'package:flutter/material.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/stand_data.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/services/stand_service.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';

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
      _refresh();
    }
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScreenList(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Kermesse Stand Invite",
          ),
          Expanded(
            child: FutureBuilder<List<StandList>>(
              key: _key,
              future: _getAllStands(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      StandList stand = snapshot.data![index];
                      return ListTile(
                        title: Text(stand.name),
                        subtitle: Text(stand.category),
                        leading: ElevatedButton(
                          onPressed: () async {
                            await _inviteStandToKermesse(stand.id);
                          },
                          child: const Text('Invite Stand'),
                        ),
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
    );
  }
}
