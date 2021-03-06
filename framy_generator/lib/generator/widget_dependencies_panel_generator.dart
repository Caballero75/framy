String generateWidgetDependenciesPanel() => '''
class FramyWidgetDependenciesPanel extends StatelessWidget {
  final List<FramyDependencyModel> dependencies;
  final ValueChanged<FramyDependencyModel> onChanged;
  final Map<String, Map<String, dynamic>> presets;

  const FramyWidgetDependenciesPanel(
      {Key key, this.dependencies, this.onChanged, this.presets})
      : super(key: const Key('FramyWidgetDependenciesPanel'));

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: dependencies
                  .map((dep) => FramyWidgetDependencyInput(
                        dependency: dep,
                        onChanged: onChanged,
                        presets: presets,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class FramyWidgetDependenciesFAB extends StatelessWidget {
  final List<FramyDependencyModel> dependencies;
  final ValueChanged<FramyDependencyModel> onChanged;
  final Map<String, Map<String, dynamic>> presets;

  const FramyWidgetDependenciesFAB(
      {Key key, this.onChanged, this.dependencies, this.presets})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'FramyWidgetDependenciesButton',
      child: Icon(Icons.tune),
      key: const Key('FramyWidgetDependenciesButton'),
      onPressed: () => showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => Column(
            children: [
              SizedBox(
                height: 2,
                key: Key('framySheetDragHandle'),
              ),
              Expanded(
                child: FramyWidgetDependenciesPanel(
                  dependencies: dependencies,
                  presets: presets,
                  onChanged: (dep) {
                    setState(() {});
                    onChanged(dep);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      mini: true,
    );
  }
}
''';
