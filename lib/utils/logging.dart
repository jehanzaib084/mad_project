import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class FileOutput extends LogOutput {
  late final File _file;

  FileOutput() {
    _init();
  }

  Future<void> _init() async {
    final directory = await getApplicationDocumentsDirectory();
    _file = File('${directory.path}/app.log');
    if (!await _file.exists()) {
      await _file.create();
    }
  }

  @override
  void output(OutputEvent event) {
    final log = '${event.lines.join('\n')}\n';
    _file.writeAsStringSync(log, mode: FileMode.append);
  }
}

final logger = Logger(
  printer: PrettyPrinter(),
  output: MultiOutput([
    ConsoleOutput(),
    FileOutput(),
  ]),
);