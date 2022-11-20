import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'location.dart';
import 'weather.dart';

Future<Weather> forecast() async {
  const url = 'https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at';
const token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjRiY2JlMjY0YTQ5M2Y3MGI5NjdmZmRmNTgxYzMzNjNkZTY4MmE5ZTc0ZWZmNzY1ZDgzMDEwY2M4NTk1NGQ4MTYzYjc5NzVlZDUwN2Q3ODMwIn0.eyJhdWQiOiIyIiwianRpIjoiNGJjYmUyNjRhNDkzZjcwYjk2N2ZmZGY1ODFjMzM2M2RlNjgyYTllNzRlZmY3NjVkODMwMTBjYzg1OTU0ZDgxNjNiNzk3NWVkNTA3ZDc4MzAiLCJpYXQiOjE2Njg5MzM1MTgsIm5iZiI6MTY2ODkzMzUxOCwiZXhwIjoxNzAwNDY5NTE4LCJzdWIiOiIyMjc0Iiwic2NvcGVzIjpbXX0.Vnlj9MUzw73OmQeuV7wArFZtx1A1sYry2EyUhFU83jHP4BwQMwdiOJgwPhdUJ4g8hbKRBagsFViH2zmg-ClCn8HUZWJcXFIlsEdE9S5R14trir5Kpb8HkijzAxUbnCg2cY2rIgkjs88_nKIaQky4TraqvGRDyqW5Kl9rg_i6IqjKslHMvN4K9YnWfKptDSGJegnRs0huuZTlA2bCcEQyAxlYIqrCWgidLb_sMb9psl_jhdDLzhHQDni8CGXpkjK-q5yOsXX_Y8IIH4bMKr4tJSZOm6oejIf_9NvupDy97QVmFK0iK-0RV4TjmHtlzH7wvcbu7XL4n7WD4fIcTrmdpj5VHvBWguvAEp6cHmWAVrSKOgtBrm13zMituNUqNcmVw4L6qhoyhU7PxiS5LZx5N0Ud_xd5JhuPzXMTllD1xfnhGMUu_C0sreDlaehucTJoNJ-VpfvySA_qRGXPAIZnEzHvCY8KUyM6i5dBJC0lOgpeBNIv9znEpKgiM9tcudTxIX16bAoS1LLLNcDW1vQoZ8_-fuJCe649tay73NTGMvMZYuziqLQbyFgeKbu8muD8AK1hF9qNoPpsFeJTOBEj7HSikF0iW88Op99ozIgjgMrH_o0x_R2VxuCIgKn5FCB-Mnpmcgc-iemBEYghApZShPtm21tGzmRfhG00yowopgk';

try {
  Position location = await getCurrentLocation();
  http.Response response = await http.get(
    Uri.parse('$url?lat=${location.latitude}&lon=${location.longitude}&fields=tc,cond'), 
    headers: {
      'accept': 'application/json',
      'authorization': 'Bearer $token',
    }
);
if(response.statusCode == 200) {
  var result = jsonDecode(response.body)['WeatherForecasts'][0]['forecasts'][0]['data'];
Placemark address = (await placemarkFromCoordinates(location.latitude, location.longitude)).first;
return Weather(
  address: '${address.subLocality}\n${address.administrativeArea}',
  temperature: result['tc'],
  cond: result['cond'],
);

} else {
  return Future.error(response.statusCode);
}
} catch (e) {
  return Future.error(e);
}
}