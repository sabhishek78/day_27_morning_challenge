import 'main.dart';

import 'package:test/test.dart';

void main() {
  test('cal point', () {
    expect(calPoint({'x':50,'y':60},{'x':100,'y':100},10),{'x': '56.75', 'y': '65.40'});
    expect(calPoint({'x':50,'y':60},{'x':100,'y':100},0),{'x': '50', 'y': '60'});
  });
 
}