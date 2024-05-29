import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniberry2/core/utils/core_utils.dart';
import 'package:uniberry2/src/timetable/presentation/cubit/timetable_cubit.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  static const String routeName = '/timetable';

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final _productsSearcher = HitsSearcher(
    applicationID: 'K1COUI4FQ4',
    apiKey: '00383db0c4d34b63decf046026091f32',
    indexName: 'courses_index',
  );

  final _searchTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _mainScaffoldKey = GlobalKey();

  Stream<SearchMetadata> get _searchMetadata =>
      _productsSearcher.responses.map(SearchMetadata.fromResponse);

  final _filterState = FilterState();
  late final _facetList = _productsSearcher.buildFacetList(
    filterState: _filterState,
    attribute: 'credit',
  );

  @override
  void initState() {
    super.initState();
    _searchTextController
        .addListener(() => _productsSearcher.query(_searchTextController.text));
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _productsSearcher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
        actions: [
          IconButton(
            onPressed: () => _mainScaffoldKey.currentState?.openEndDrawer,
            icon: const Icon(Icons.filter_alt_outlined),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: _filters(context),
      ),
      body: BlocConsumer<TimetableCubit, TimetableState>(
        builder: (context, state) {
          if (state is TimetableLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CourseFetched) {
            return Center(child: Text(state.course.toString()));
          } else if (state is CourseIdsSearched) {
            context.read<TimetableCubit>().getCourses(state.courseIds);
            return const Center(child: CircularProgressIndicator());
          } else if (state is CoursesFetched) {
            return SafeArea(
              child: Column(
                children: [
                  const Text('Courses'),
                  Expanded(
                    child: ListView(
                      children: state.courses.map((course) {
                        return ListTile(
                          onTap: () {},
                          title: Text(course.toString()),
                          // title: Text(course.titles.toString()),
                          // subtitle: Text(course.codes.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: TextButton(
                  onPressed: () {
                    context
                        .read<TimetableCubit>()
                        .getCourse('1b8asuduvHpuH2PEqyBT');
                  },
                  child: const Text(
                    'Get a Course',
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.read<TimetableCubit>().searchCourses(
                          period: '月2',
                          school: '法学部',
                          // // term: "秋２Ｑ",
                          // campus: "衣笠",
                        );
                  },
                  child: const Text(
                    'Search courses',
                  ),
                ),
              ),
              SizedBox(
                height: 44,
                child: TextField(
                  controller: _searchTextController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter a search term',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              StreamBuilder<SearchMetadata>(
                stream: _searchMetadata,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${snapshot.data!.nbHits} hits'),
                  );
                },
              )
            ],
          );
        },
        listener: (context, state) {
          if (state is TimetableError) {
            return CoreUtils.showSnackBar(context, state.message);
          }
        },
      ),
    );
  }

  Widget _filters(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Filters'),
        ),
        body: StreamBuilder<List<SelectableItem<Facet>>>(
            stream: _facetList.facets,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              final selectableFacets = snapshot.data!;
              return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: selectableFacets.length,
                  itemBuilder: (_, index) {
                    final selectableFacet = selectableFacets[index];
                    return CheckboxListTile(
                      value: selectableFacet.isSelected,
                      title: Text(
                          "${selectableFacet.item.value} (${selectableFacet.item.count})"),
                      onChanged: (_) {
                        _facetList.toggle(selectableFacet.item.value);
                      },
                    );
                  });
            }),
      );
}

class SearchMetadata {
  final int nbHits;

  const SearchMetadata(this.nbHits);

  factory SearchMetadata.fromResponse(SearchResponse response) =>
      SearchMetadata(response.nbHits);
}
