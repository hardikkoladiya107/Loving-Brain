import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/location_data_model.dart';

void main() {
  test('India timezone parsing and offset computation', () {
    expect(LocationDataModel.computeGmtOffset('Asia/Kolkata'), 'GMT+5:30');
    expect(
      LocationDataModel.tryParse('Thiruvananthapuram, India')?.formatted,
      'Thiruvananthapuram, India · GMT+5:30',
    );
    expect(
      LocationDataModel.tryParse(
        'Thiruvananthapuram, India · GMT+0',
      )?.gmtOffset,
      'GMT+5:30',
    );
    final LocationDataModel loc = LocationDataModel.fromOpenMeteoJson(
      <String, dynamic>{
        'name': 'Thiruvananthapuram',
        'country': 'India',
        'timezone': 'Asia/Kolkata',
      },
    );
    expect(loc.formatted, 'Thiruvananthapuram, India · GMT+5:30');
    final LocationDataModel parsedFromMap = LocationDataModel.fromJson(
      loc.toJson(),
    );
    expect(parsedFromMap.formatted, 'Thiruvananthapuram, India · GMT+5:30');
  });
}
