import 'package:flutter/material.dart';
import 'getting_all_info.dart';
import 'sub_modle_generations.dart';

class ListOfSubSubModles extends StatefulWidget {
  final String title;
  final String brandUrl;

  const ListOfSubSubModles({
    super.key,
    required this.title,
    required this.brandUrl,
  });

  @override
  State<ListOfSubSubModles> createState() => _ListOfSubSubModlesState();
}

class _ListOfSubSubModlesState extends State<ListOfSubSubModles> {
  final gettingData = GettingData();
  List thumpImageAddress = [];
  List mainTitle = [];
  List subTitle = [];
  List subUrls = [];
  List subPower = [];

  final String baseUrl = "https://www.auto-data.net";

  @override
  void initState() {
    settingData();
    super.initState();
  }

  void settingData() async {
    await gettingData
        .gettingGenerations(baseUrl + widget.brandUrl)
        .whenComplete(() {
      setState(() {
        thumpImageAddress = gettingData.genrationImagesSrc;
        mainTitle = gettingData.genrationTitles;
        subTitle = gettingData.genrationSubTitles;
        subPower = gettingData.genrationPower;
        subUrls = gettingData.genrationUrlS;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "thumpImageAddress : \n ${thumpImageAddress.length}\n$thumpImageAddress");
    debugPrint("mainTitle : \n ${mainTitle.length}\n$mainTitle");
    debugPrint("subTitle : \n ${subTitle.length}\n$subTitle");
    debugPrint("subPower : \n ${subPower.length}\n$subPower");
    return Scaffold(
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
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
      ),
      body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          physics: const BouncingScrollPhysics(),
          itemCount: thumpImageAddress.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
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
                      builder: (context) => SubModleGneration(
                        title: mainTitle[index],
                        brandUrl: subUrls[index],
                      ),
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.20,
                            width: MediaQuery.of(context).size.width * 1,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      baseUrl + thumpImageAddress[index]),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 4,
                            ),
                            Text(mainTitle[index],
                                textScaleFactor: 1,
                                maxLines: 1,
                                style:
                                    Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              index < subTitle.length ? subTitle[index] : '',
                              textScaleFactor: 1,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              index < subTitle.length ? subPower[index] : '',
                              textScaleFactor: 1,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                             // additional SizedBox widget
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
