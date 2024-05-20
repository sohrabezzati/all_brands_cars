
import 'package:flutter/material.dart';

import 'getting_all_info.dart';
import 'subsubmodle_list.dart';

class ListOfSubModels extends StatefulWidget {
  final String title;
  final String brandUrl;

  const ListOfSubModels({
    Key? key,
    required this.title,
    required this.brandUrl,
  }) : super(key: key);

  @override
  State<ListOfSubModels> createState() => _ListOfSubModelsState();
}

class _ListOfSubModelsState extends State<ListOfSubModels> {
  final gettingData = GettingData();
  List thumpImageAddress = [];
  List subModelTitle = [];
  List subModelUrls = [];

  void settingData() async {
    await gettingData.gettingThump(widget.brandUrl).whenComplete(() {
      setState(() {
        thumpImageAddress = gettingData.subMudlethumpImg;
        subModelTitle = gettingData.subMudleTitle;
        subModelUrls = gettingData.subMudleUrl;
      });
    });
  }

  @override
  void initState() {
    settingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldOnSubModle(
      widget: widget,
      subModelImagesAddres: thumpImageAddress,
      subMudelTitle: subModelTitle,
      subModelUrls: subModelUrls,
    );
  }
}

class ScaffoldOnSubModle extends StatelessWidget {
  final ListOfSubModels widget;
  final List subModelImagesAddres;
  final List subMudelTitle;
  final List subModelUrls;

  const ScaffoldOnSubModle({
    super.key,
    required this.widget,
    required this.subModelImagesAddres,
    required this.subMudelTitle,
    required this.subModelUrls,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(subModelImagesAddres.toString());
    debugPrint(subMudelTitle.toString());
    debugPrint(subModelUrls.toString());
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).textTheme.titleLarge!.color,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(textAlign: TextAlign.center, widget.title),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: Theme.of(context).textTheme.titleLarge),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: BulderOfContent(
            widget: widget,
            subModelImagesAddres: subModelImagesAddres,
            subMudelTitle: subMudelTitle,
            subModelUrls: subModelUrls),
      ),
    );
  }
}

class BulderOfContent extends StatelessWidget {
  final ListOfSubModels widget;
  final List subModelImagesAddres;
  final List subMudelTitle;
  final List subModelUrls;

  const BulderOfContent({
    super.key,
    required this.widget,
    required this.subModelImagesAddres,
    required this.subMudelTitle,
    required this.subModelUrls,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ItemCardInsubModel(
            widget: widget,
            imageAddres: subModelImagesAddres[index],
            index: index,
            title: subMudelTitle[index],
            subModelUrl: subModelUrls[index]);
      },
      itemCount: subModelImagesAddres.length,
    );
  }
}

class ItemCardInsubModel extends StatelessWidget {
  final ListOfSubModels widget;
  final String baseUrl = "https://www.auto-data.net";
  final String title;
  final String subModelUrl;
  final String imageAddres;
  final int index;

  const ItemCardInsubModel(
      {super.key,
      required this.widget,
      required this.title,
      required this.subModelUrl,
      required this.imageAddres,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        color: Theme.of(context).colorScheme.onBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          splashColor: Theme.of(context).colorScheme.surface,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ListOfSubSubModles(
                        title: title,
                        brandUrl: subModelUrl,
                      )),
            );
          },
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.19,
                  width: double.maxFinite,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(baseUrl + imageAddres),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
