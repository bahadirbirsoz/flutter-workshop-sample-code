import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: Home())
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _bottomNavbarCurrentIndex = 0;
  int _tapCounter = 0;
  void _increse(){
    setState(() {
      _tapCounter++;
    });
  }
  void _decrese(){
    setState(() {
      _tapCounter--;
    });
  }

  void _onBottomNavbarTapped(int index) {
    setState(() {
      _bottomNavbarCurrentIndex = index;
    });
    print(index.toString() + ". index tıklandı");
  }

  void _reset(){
    setState(() {
      _tapCounter=0;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Workshop"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _reset)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          
          onTap: _onBottomNavbarTapped,
          currentIndex: _bottomNavbarCurrentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.print), title: Text("Sol İkon")),
            BottomNavigationBarItem(
                icon: Icon(Icons.closed_caption), title: Text("Sağ İkon")),
          ]),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(child: Text("HEADER")),
            ListTile(title: Text("Son Haberler")),
            ListTile(title: Text("Enteresan Haberler")),
            ListTile(title: Text("Ciddi Haberler")),
            ListTile(title: Text("Şaka Haberler")),
          ],
        ),
      ),
      body: Container(

          child: FutureBuilder(
            future: getKategori(),
            builder: (BuildContext context, AsyncSnapshot<Kategori> snapshot){
              if(!snapshot.hasData){
                return Text("No Data Loaded Yet");
              }

              return ListView(
                children: snapshot.data.list.map(_buildItem).toList(),
              );

            }


            ,
          ),

        ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: _increse
      ),
      
    );
  }

  Widget _buildItem(Content context) {
    print(context.imgUrl1);
    return ExpansionTile(
        title: Text(context.title),
      children: <Widget>[

        Padding(
          child: Text(context.desc),
          padding: EdgeInsets.all(10.0),
        ) ,
        Image.network(context.imgUrl1.replaceAll('https:', 'http:'))
      ],
    );

  }
}

class Kategori {
  int id;
  String lang;
  String title;
  List<Content> list;

  Kategori({this.id, this.lang, this.title, this.list});

  Kategori.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lang = json['lang'];
    title = json['title'];
    if (json['list'] != null) {
      list = new List<Content>();
      json['list'].forEach((v) {
        list.add(new Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lang'] = this.lang;
    data['title'] = this.title;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Content {
  int id;
  String title;
  String imgUrl1;
  String imgUrl2;
  String desc;

  Content({this.id, this.title, this.imgUrl1, this.imgUrl2, this.desc});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imgUrl1 = json['imgUrl1'];
    imgUrl2 = json['imgUrl2'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['imgUrl1'] = this.imgUrl1;
    data['imgUrl2'] = this.imgUrl2;
    data['desc'] = this.desc;
    return data;
  }
}

Future<Kategori> getKategori() async{
  http.Response response =  await http.get('https://balathastanesi.narhavuz.com/api/webcontents?typeId=6&lang=tr');
  return Kategori.fromJson( json.decode(response.body) );
}
