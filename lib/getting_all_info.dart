import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:html/parser.dart' show parse;

class GettingData {
  final Dio dio = Dio();
  final String baseUrl = "https://www.auto-data.net";
  List logoImageSources = [];
  List firstTitles = [];
  List strongTitles = [];
  List brandUrl = [];
  List subMudlethumpImg = [];
  List subMudleTitle = [];
  List subMudleUrl = [];
  List oldlogoImageSources = [];
  List<String> genrationUrlS = [];
  List<String> genrationImagesSrc = [];
  List<String> genrationTitles = [];
  List<String> genrationSubTitles = [];
  List<String> genrationPower = [];
  List<String> genrationDmimetions = [];
  List<String> subGenrationMainTitles = [];
  List<String> subGenrationSubTitles = [];
  List<String> subGenrationUrls = [];
  List<String> fullSpascesKeykeyspecs = [];
  List<String> fullSpascesValuekeyspecs = [];
  List<String> fullSpascesKeycardetailsout = [];
  List<String> fullSpascesValuecardetailsout = [];

  List<String> carSpascesTitle = [];
  List<String> cardetailTitleSpasces = [];
  List finalImageSursces = [];

  // List<String> subGenrationImagesSrc = [];

  Future settingAllLogoAndTitle() async {
    // getting all logos
    final logoImage = await getFromElementByTagName(
        "https://www.auto-data.net/en/allbrands", "img");
    oldlogoImageSources =
        logoImage.map((tag) => tag.attributes['src']!).toList();
    oldlogoImageSources.removeWhere((element) =>
        element == "/img/social/youtube.png" ||
        element == "/img/social/instagram.png" ||
        element == "/img/social/facebook.png" ||
        element == "/img/social/twitter.png" ||
        element == "/img/social/tiktok.png" ||
        element == "/img/social/pinterest.png" ||
        element == "/img/social/linkedin.png" ||
        element == "/img/social/rss.png" ||
        element == "/img/logind.png" ||
        element == "/img/login.png" ||
        element == "/img/spacer.gif" ||
        element == "/img/lock.png" ||
        element == "/img/logoA.png" ||
        element == "/img/login.png?v1" ||
        element == "/img/logind.png?v1" ||
        element == "/img/logo.png");

    for (String address in oldlogoImageSources) {
      String newAddress = address.substring(11, address.length);
      newAddress = "/img/logos2/$newAddress";
      debugPrint(newAddress);
      logoImageSources.add(newAddress);
    }

    // Getting all brands name
    final allBrandsTitels = await getFromElementByTagName(
        "https://www.auto-data.net/en/allbrands", 'strong');
    firstTitles = allBrandsTitels.map((tag) => tag.text!).toList();
    // debugPrint(firstTitles.toString());

    final allBrandsUrl = await getAllBrandsUrlAndTiteles(
        "https://www.auto-data.net/en/allbrands", 'marki_blok');
    brandUrl = allBrandsUrl.map((tag) => tag.attributes['href']!).toList();
  }

  Future gettingThump(String url) async {
    const String baseUrl = "https://www.auto-data.net";

    final thumpImges = await getFromElementByTagName(baseUrl + url, 'img');
    subMudlethumpImg = thumpImges.map((tag) => tag.attributes['src']!).toList();
    subMudlethumpImg.removeWhere((element) =>
        element == "/img/social/youtube.png" ||
        element == "/img/social/instagram.png" ||
        element == "/img/social/facebook.png" ||
        element == "/img/social/twitter.png" ||
        element == "/img/social/pinterest.png" ||
        element == "/img/social/linkedin.png" ||
        element == "/img/social/tiktok.png" ||
        element == "/img/social/rss.png" ||
        element == "/img/logind.png" ||
        element == "/img/login.png" ||
        element == "/img/spacer.gif" ||
        element == "/img/login.png?v1" ||
        element == "/img/logind.png?v1" ||
        element == "/img/logoA.png" ||
        element == "/img/lock.png" ||
        element == "/img/logo.png");

    final subMudelTitel =
        await getFromElementByTagName(baseUrl + url, 'strong');
    subMudleTitle = subMudelTitel.map((tag) => tag.text!).toList();
    subMudleTitle.removeAt(0);

    final allBrandsUrl =
        await getAllBrandsUrlAndTiteles(baseUrl + url, 'modeli');
    subMudleUrl = allBrandsUrl.map((tag) => tag.attributes['href']!).toList();
  }

  Future gettingGenerations(String url) async {
    Response response = await dio.get(url);
    final document = parse(response.data);
    String subTitle = '';
    List elements = document.querySelectorAll('tr');

    for (final element in elements) {
      if (element.querySelector('img') != null) {
        String src = element.querySelector('img').attributes['src'];

        genrationImagesSrc.add(src);
      }
      if (element.querySelector('a') != null) {
        String href = element.querySelector('a').attributes['href'];

        genrationUrlS.add(href);
      }
      if (element.querySelector('span') != null) {
        String span = element.querySelector('span').text;
        genrationPower.add(span);
      } else {
        genrationPower.add('');
      }

      if (element.querySelector('strong.tit') != null) {
        String strongTit = element.querySelector('strong.tit').text;
        genrationTitles.add(strongTit);
      }
      if (element.querySelector('strong.chas') != null) {
        String strongChas = element.querySelector('strong.chas').text;
        subTitle = strongChas;
      }
      if (element.querySelector('strong.cur') != null) {
        String strongEnd =
            element.querySelector('strong.cur').text + "\t\t\t" + subTitle;
        genrationSubTitles.add(strongEnd);
      } else if (element.querySelector('strong.end') != null) {
        String strongEnd =
            element.querySelector('strong.end').text + "\t\t\t" + subTitle;
        genrationSubTitles.add(strongEnd);
      } else if (element.querySelector('strong.cur') == null &&
          element.querySelector('strong.end') == null) {
        genrationSubTitles.add(subTitle);
      }
    }
  }

  Future gettingSubGeneration(String url) async {
    Response response = await dio.get(url);
    final document = parse(response.data);
    List elements = document.querySelectorAll('th');

    for (final element in elements) {
      if (element.querySelector('a') != null) {
        String src = element.querySelector('a').attributes['href'];
        subGenrationUrls.add(src);
      }
      if (element.querySelector('a') != null) {
        String strongTit = element.querySelector('a').attributes['title'];
        subGenrationMainTitles.add(strongTit);
      }
      if (element.querySelector('span.tit') != null) {
        String strongTit = element.querySelector('span.tit').text;
        subGenrationSubTitles.add(strongTit);
      }
    }
  }

  Future gettingFullSpecses(String url) async {
    Response response = await dio.get(url);
    final document = parse(response.data);
    final keyspecs = document.querySelectorAll('table.keyspecs');
    final cardetailsout = document.querySelectorAll('table.cardetailsout');

    if (keyspecs.isNotEmpty) {
      for (final table in keyspecs) {
        final rows = table.querySelectorAll('tr');
        final titleh2 = table.querySelector('h2')!.text;
        final titleh3 = '$titleh2  ${table.querySelector('h3')!.text}';
        carSpascesTitle.add(titleh3);

        for (final row in rows) {
          String key = row.querySelector('th')?.text ?? '';
          String value = row.querySelector('td')?.text ?? '';
          value = value.replaceAll('<br>', ' : ');
          value = value.replaceAll(
              '<span title="Calculated by Auto-Data.net">', '');
          value = value.replaceAll('</span>', '');
          value = value.replaceAll('<sup>3</sup>', '³');
          value = value.replaceAll('<sup>2</sup>', '²');
          value = value.replaceAll('<sub>2</sub>', '\u2082');
          // debugPrint(value);

          fullSpascesKeykeyspecs.add(key);
          fullSpascesValuekeyspecs.add(value);
        }
      }
    }
    if (cardetailsout.isNotEmpty) {
      for (final table in cardetailsout) {
        final rows = table.querySelectorAll('tr');
        final title = table.querySelector('caption')!.text;
        carSpascesTitle.add(title);

        for (final row in rows) {
          String key = row.querySelector('th')?.text ?? '';
          String value = row.querySelector('td')?.text ?? '';
          value = value.replaceAll('<br>', ' : ');
          value = value.replaceAll(
              '<span title="Calculated by Auto-Data.net">', '');
          value = value.replaceAll('</span>', '');
          value = value.replaceAll('<span class="val2">', '');
          value = value.replaceAll('<sup>3</sup>', '³');
          value = value.replaceAll('<sup>2</sup>', '²');
          value = value.replaceAll('<sub>2</sub>', '\u2082');
          value = value.replaceAll('<a href=""></a>', '');
          fullSpascesKeycardetailsout.add(key);
          fullSpascesValuecardetailsout.add(value);
        }
      }
    }

    // debugPrint(fullSpascesKeykeyspecs.toString());
    // debugPrint(fullSpascesValuekeyspecs.toString());
    // debugPrint(carSpascesTitle.toString());
    // debugPrint(fullSpascesKeycardetailsout.toString());
    // debugPrint(fullSpascesKeycardetailsout.length.toString());
    // debugPrint(fullSpascesValuecardetailsout.toString());
    // debugPrint(fullSpascesValuecardetailsout.length.toString());

    // debugPrint(cardetailTitleSpasces.toString());
  }

  Future<void> getSixImageOfEachBrand(String carSpacesUrl) async {
    // final imageTags = await getFromElementByTagName(carSpacesUrl, "img");

    // List imageSources = imageTags.map((tag) => tag.attributes['src']!).toList();
    // imageSources.removeWhere((element) =>
    //     element == "/img/social/youtube.png" ||
    //     element == "/img/social/instagram.png" ||
    //     element == "/img/social/facebook.png" ||
    //     element == "/img/social/twitter.png" ||
    //     element == "/img/social/pinterest.png" ||
    //     element == "/img/social/linkedin.png" ||
    //     element == "/img/social/tiktok.png" ||
    //     element == "/img/social/rss.png" ||
    //     element == "/img/logind.png" ||
    //     element == "/img/login.png" ||
    //     element == "/img/spacer.gif" ||
    //     element == "/img/login.png?v1" ||
    //     element == "/img/logind.png?v1" ||
    //     element == "/img/lock.png" ||
    //     element == "/img/logoA.png" ||
    //     element == "/img/logo.png");

    // for (String source in imageSources) {
    //   finalImageSursces.add("$baseUrl$source");
    // }

    final scriptTags = await getFromElementByTagName(carSpacesUrl, "script");

    if (scriptTags != null) {
      // Extract the JavaScript code from the script tag
      final script = scriptTags.map((tag) => tag.innerHtml!).toList();
      // debugPrint(script.toString());
      // Extract the information from the JavaScript code

      final bigImages = RegExp(r'bigs\[\d+\] = "(.*?)";')
          .allMatches(script.toString())
          .map((m) => m.group(1))
          .toList();

      for (final images in bigImages) {
        finalImageSursces.add("$baseUrl/images/$images");
      }
      debugPrint(carSpacesUrl);
      debugPrint(bigImages.toString());
      debugPrint(finalImageSursces.toString());
    } else {
      debugPrint("Script tag not found");
    }
  }
}

final Dio dio = Dio();
Future getFromElementByTagName(String url, String tag) async {
  Response response = await dio.get(url);
  final document = parse(response.data);
  final imgTags = document.getElementsByTagName(tag);
  return imgTags;
}

Future getFromElementByTagId(String url) async {
  Response response = await dio.get(url);
  final document = parse(response.data);
  final imgTags = document.querySelector('#bigimg');
  return imgTags;
}

Future getAllBrandsUrlAndTiteles(String url, String className) async {
  Response response = await dio.get(url);
  final document = parse(response.data);
  final allBrandsUrl = document.getElementsByClassName(className);
  return allBrandsUrl;
}
