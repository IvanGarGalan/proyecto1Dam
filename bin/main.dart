import './entities/entities.dart';
import './utils/utils.dart';

void main(List<String> args) async {
  await Database.instalacionDB();
  Menu.menuInicio();
}
