import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import '../models/objectbox.g.dart'; // Adjust the path

class ObjectBoxService {
  late final Store store;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    store = Store(getObjectBoxModel(), directory: '${dir.path}/objectbox');
  }

  void dispose() {
    store.close();
  }
}
