import 'dart:math';
import 'package:executor/executor.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:async';

// Challenge 1
// Flutter module makes multiple, parallel, requests to a web service, and
// shares the result with the host app. We'll use the "balldontlie" API for this
// purpose, since it's open and supports cross-domain requests for web apps. in
// this case, the input value represents the number of calls to be made, eg a
// value of 3 means we will fetch data for players 1, 2, 3. The URL for player 2,
// for example, is:
// https://www.balldontlie.io/api/v1/players/2
// Once all calls have been made, the Flutter module should calculate average
// weight of all queried players and print it in console.
//  The calls must occur in parallel, always using up to *four* separate threads,
// in a typical "worker" pattern, to ensure there are always three pending requests
// until no further requests are needed. The requests should be logged when initiated
// and again when completed.

// Challenge 2
// A point on the screen (pt1) wants to move a certain distance (dist) closer to
// another point on the screen (pt2) The function has three arguments,
// two of which are objects with x & y values, and the third being the distance,
// e.g. {x:50, y:60}, {x: 100, y: 100}, 10. The expected result is a similar
// object with the new co-ordinate.
waitForFetchWeight() async {
  await fetchWeight();
}

List<int> playerWeights = [];

Future balldontlie(int numberOfCalls) async {
  Executor executor = Executor(concurrency: 3);
  for (int i = 0; i < numberOfCalls; i++) {
    executor.scheduleTask(waitForFetchWeight);
  }
  await executor.join(withWaiting: true);
  print(AverageWeight(playerWeights));
}

Future<void> fetchWeight() async {
  Random rand = Random();
  int playerIndex = rand.nextInt(1000);
  Map balldontlieMap;
  Response response =
      await get('https://www.balldontlie.io/api/v1/players/${playerIndex}');
  if (response.statusCode == 200) {
    balldontlieMap = jsonDecode(response.body);
  }
  int weight = balldontlieMap['weight_pounds'];
  playerWeights.add(weight);
}

String AverageWeight(List<int> playerWeights) {
  num sum = 0;
  String average;
  print(playerWeights);
  playerWeights.removeWhere((item) => item == null);
  playerWeights.join(', ');
  for (int i = 0; i < playerWeights.length; i++) {
    sum = sum + playerWeights[i];
  }
  average = (sum / playerWeights.length).toStringAsFixed(2);
  return average;
}

calPoint(Map<String, double> map1, Map<String, double> map2, m1) {
  Map<String, String> m3 = {};
  double x1 = map1['x'];
  double y1 = map1['y'];
  double x2 = map2['x'];
  double y2 = map2['y'];
  double m2;
  double d = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
  m2 = d - m1;
  String x3 = ((m1 * x2 + m2 * x1) / (m1 + m2)).toStringAsFixed(2);
  String y3 = ((m1 * y2 + m2 * y1) / (m1 + m2)).toStringAsFixed(2);
  m3['x'] = x3;
  m3['y'] = y3;
  return m3;
}

main() {
  print(calPoint({'x': 50, 'y': 60}, {'x': 100, 'y': 100}, 10));
  balldontlie(5);
}
