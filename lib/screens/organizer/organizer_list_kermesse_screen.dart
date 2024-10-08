import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/kermesse_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/widgets/custom_button.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';


class OrganizerListKermesseScreen extends StatefulWidget {
  const OrganizerListKermesseScreen({super.key});

  @override
  State<OrganizerListKermesseScreen> createState() => _OrganizerListKermesseState();
}

class _OrganizerListKermesseState extends State<OrganizerListKermesseScreen> {
  final Key _key = UniqueKey();

  final KermesseService _kermesseService = KermesseService();

  Future<List<KermesseList>> _getKermesseList() async {
    ApiResponse<List<KermesseList>> response = await _kermesseService.getKermesseList();
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
      appBar: const GlobalAppBar(
        title: 'Kermesse',
      ),
      body: ScreenList(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Add Kermesse',
                  onPressed: () async {
                    await context.push(OrganizerRoutes.addKermesse);
                    _init();
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "List of kermesses:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<KermesseList>>(
                key: _key,
                future: _getKermesseList(),
                builder: (context, snapshot) {
                  return _buildContent(snapshot);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildContent(AsyncSnapshot<List<KermesseList>> snapshot) {
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
    if (snapshot.hasData && snapshot.data!.isEmpty) {
      return const Center(
        child: Text('No kermesses found'),
      );
    }
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return _buildKermesseCard(snapshot.data![index]);
        },
      );
    }
    return const Center(
      child: Text('Something went wrong'),
    );
  }

  Widget _buildKermesseCard(KermesseList kermesse) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          Icons.event,
          color: kermesse.status == 'STARTED' ? Colors.lightGreen : Colors.red,
          size: 40,
        ),
        title: Text(
          kermesse.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(kermesse.description),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.info, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Status: ${kermesse.status}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          context.push(
            OrganizerRoutes.detailsKermesse,
            extra: {
              "kermesseId": kermesse.id,
            },
          );
        },
      ),
    );
  }
}
