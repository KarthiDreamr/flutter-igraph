import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';

// https://pub.dev/packages/d_chart#bar-example

final Map<String, Map<String, int>> hjson = {
  "in_count": {
    'BH1': 25,
    'BH2': 100,
    'BH3': 75,
    'BH4': 100,
    'BH5': 10,
  },
  "total_count": {'BH1': 100, 'BH2': 200, 'BH3': 100, 'BH4': 100, "BH5": 100}
};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HostelGraph(),
    );
  }
}

class HostelGraph extends StatefulWidget {
  const HostelGraph({super.key});

  @override
  State<HostelGraph> createState() => _HostelGraphState();
}

class _HostelGraphState extends State<HostelGraph> {
  late Map<String, int> inMap;
  late Map<String, int> totMap;

  late List<String> inKey;
  late List<String> totKey;

  @override
  void initState() {
    super.initState();

    inMap = hjson[jsonKey[0]] ?? errorPrintMap();
    totMap = hjson[jsonKey[1]] ?? errorPrintMap();

    inKey = hjson[jsonKey[0]]!.keys.toList();
    totKey = hjson[jsonKey[1]]!.keys.toList();
  }

  List<Map<String, dynamic>> hlist1 = [];
  List<Map<String, dynamic>> hlist2 = [];
  List<String> jsonKey = hjson.keys.toList();

  Map<String, int> errorPrintMap() {
    throw "Null value Returned When accessing Map!";
  }

  int errorPrintInt() {
    throw "Null value Returned When accessing Integer!";
  }

  List<Map<String, dynamic>> presentCreate() {
    for (int i = 0; i < inKey.length; i++) {
      double percentage =
          (inMap[inKey[i]] ?? 1) / (totMap[totKey[i]] ?? -1) * 100;
      hlist1.add({'domain': inKey[i], 'measure': percentage});
    }

    return hlist1;
  }

  List<Map<String, dynamic>> absentCreate() {
    for (int i = 0; i < inKey.length; i++) {
      double percentage =
          100 - (inMap[inKey[i]] ?? errorPrintInt()) / (totMap[totKey[i]] ?? -errorPrintInt()) * 100;
      // double precentage = try(inMap[inKey[i]] / totMap[totKey[i]] ?? -1) * 100)
      hlist2.add({'domain': inKey[i], 'measure': percentage});
    }

    return hlist2;
  }

  @override
  Widget build(BuildContext context) {
    // var jkey = hjson["Total"]!.keys.toList();

    List<Map<String, dynamic>> presentData = presentCreate();
    List<Map<String, dynamic>> absentData = absentCreate();

    return Scaffold(
      appBar: AppBar(
        title: const Text("iGraph"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: DChartBar(
          data: [
            {'id': 'Present', 'data': presentData},
            {'id': 'Absent', 'data': absentData}
          ],
          barValue: (barData, index) {
            if (index != null) {
              int residentCount =
                  (barData["measure"] * (totMap[totKey[index]]! / 100)).toInt();

              return residentCount.toString();
            } else {
              return "Error Occoured";
            }
          },
          axisLineColor: Colors.black,
          barColor: (barData, index, id) {
            if (id == 'Present') {
              return Colors.blue;
            }
            return Colors.orange;
          },
          showBarValue: true,
          verticalDirection: false,
          xAxisTitle: "Attendance",
          yAxisTitle: "Hostel Name",
          // measureLabelPaddingToAxisLine: 8,
        ),
      ),
    );
  }
}
