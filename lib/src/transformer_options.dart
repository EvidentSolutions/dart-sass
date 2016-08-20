part of sass.transformer;

/// Class to be used to parse sass transformer options coming from pubspec.yaml file
class TransformerOptions {
  /// entry_point: web/builder.sass - main file to build or [file1.sass, ...,fileN.sass]
  final List<String> entry_points;

  /// include_path: /lib/sassIncludes - variable and mixims files
  final List<String> include_paths;

  /// output: web/output.css - result file. If '' same as web/input.css
  final String output;

  /// executable: sassc - command to execute sassc  - NOT USED
  final String executable;
  final String style;
  final bool compass;
  final bool lineNumbers;
  final bool copySources;

  TransformerOptions({
    this.entry_points,
    this.include_paths,
    this.output,
    this.executable,
    this.style,
    this.compass,
    this.lineNumbers,
    this.copySources
  });

  factory TransformerOptions.parse(Map configuration){
    config(key, defaultValue) {
      var value = configuration[key];
      return value != null ? value : defaultValue;
    }

    List<String> readStringList(value) {
      if (value is List<String>) return value;
      if (value is String) return [value];
      return null;
    }

    List<String> readEntryPoints(entryPoint, entryPoints) {
      List<String> result = [];
      List<String> value;

      value = readStringList(entryPoint);
      if (value != null) result.addAll(value);

      value = readStringList(entryPoints);
      if (value != null) result.addAll(value);

      //if (result.length < 1) print('$INFO_TEXT No entry_point supplied. Processing *.sass and *.html.');
      return result;
    }

    return new TransformerOptions (
        entry_points: readEntryPoints(configuration['entry_point'], configuration['entry_points']),
        include_paths: readStringList(configuration['include_paths']),
        output: config('output', ''),
        executable: config('executable', (Platform.operatingSystem == "windows" ? "sass.bat" : "sass")),
        style: config("style", null),
        compass: config("compass", false),
        lineNumbers: config("line-numbers", false),
        copySources: config("copy-sources", false)
    );
  }
}