import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kermesse_frontend/api/api_response.dart';
import 'package:kermesse_frontend/data/kermesse_data.dart';
import 'package:kermesse_frontend/routers/routes.dart';
import 'package:kermesse_frontend/services/kermesse_service.dart';
import 'package:kermesse_frontend/widgets/global_appBar.dart';
import 'package:kermesse_frontend/widgets/screen_list.dart';

class ParentListKermesseScreen extends StatefulWidget {
  const ParentListKermesseScreen({super.key});

  @override
  State<ParentListKermesseScreen> createState() => _ParentListKermesseScreenState();
}

class _ParentListKermesseScreenState extends State<ParentListKermesseScreen> {
  final Key _key = UniqueKey();

  final KermesseService _kermesseService = KermesseService();

  Future<List<KermesseList>> _getAllKermesse() async {
    ApiResponse<List<KermesseList>> response = await _kermesseService.getKermesseList();
    if (response.error != null) {
      throw Exception(response.error);
    }
    return response.data!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: "List of kermesses"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Kermesses :",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<KermesseList>>(
                key: _key,
                future: _getAllKermesse(),
                builder: (context, snapshot) {
                  return _buildContent(snapshot); // Separate content builder
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildKermesseCard(KermesseList kermesse) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
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
            ParentRoutes.detailsKermesse,
            extra: {
              "kermesseId": kermesse.id,
            },
          );
        },
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
}


