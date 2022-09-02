import 'dart:io';

import 'package:contactbook/baseclass.dart';
import 'package:contactbook/insertpage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqlite_api.dart';

class viewpage extends StatefulWidget {
  const viewpage({Key? key}) : super(key: key);

  @override
  State<viewpage> createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {
  Database? db;
  bool search = false;
  List<Map> temp = [];
  List<Map> rem = [];

  @override
  void initState() {
    super.initState();
    getdata();
    gonext();
  }

  Future<List<Map<String, Object?>>> getdata() async {
    db = await baseclass().createdatabase();
    String qry = "select * from Test";
    List<Map<String, Object?>> l1 = await db!.rawQuery(qry);
    temp = l1;
    return l1;
  }
  gonext() async {
    var status = await Permission.camera.status;

    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses =
      await [Permission.camera].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return insertpage(
                  a: 0,
                );
              },
            ));
          },
          child: Text("Add"),
        ),
        appBar: search
            ? AppBar(
                title: TextField(
                  onChanged: (value) {
                    rem = [];
                    if (value.isEmpty) {
                      rem = temp;
                    } else {
                      for (int i = 0; i < temp.length; i++) {
                        if (temp[i]['name']
                                .toString()
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            temp[i]['contact'].toString().contains(value)) {
                          rem.add(temp[i]);
                        }
                      }
                    }
                    setState(() {});
                  },
                  autofocus: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      prefix: Icon(Icons.search),
                      suffix: IconButton(
                          onPressed: () {
                            search = false;
                            rem = [];
                            setState(() {});
                          },
                          icon: Icon(Icons.close))),
                ),
              )
            : AppBar(
                title: Text("Contactbook"),
                actions: [
                  IconButton(
                    onPressed: () {
                      search = true;
                      rem = temp;
                      setState(() {});
                    },
                    icon: Icon(Icons.search),
                  )
                ],
              ),
        body: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<Map<String, Object?>> l =
                    snapshot.data as List<Map<String, Object?>>;
                l = List.from(l);
                l.sort(
                  (a, b) =>
                      a['name'].toString().compareTo(b['name'].toString()),
                );
                rem = List.from(rem);
                rem.sort(
                  (a, b) =>
                      a['name'].toString().compareTo(b['name'].toString()),
                );
                return search
                    ? ListView.builder(
                        itemCount: rem.length,
                        itemBuilder: (context, index) {
                          Map m = rem[index];
                          return ListTile(
                            onTap: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return insertpage(a: 1, m: m);
                                },
                              ));
                            },
                            onLongPress: () {
                              showDialog(
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Delete"),
                                      content: Text(
                                          "Are you sure you want to delete '${m['name']}'"),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            int id = m['id'];
                                            String qry =
                                                "delete from Test where id = '$id'";
                                            await db!.rawDelete(qry);
                                            setState(() {});
                                          },
                                          child: Text("Yes"),
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("No")),
                                      ],
                                    );
                                  },
                                  context: context);
                            },
                            leading: Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xB2338CCF),
                                  shape: BoxShape.circle),
                              child:
                                  Text("${m['name'].toString().split("")[0]}"),
                            ),
                            title: Text("${m['name']}"),
                            subtitle: Text("${m['contact']}"),
                          );
                        },
                      )
                    : l.length > 0
                        ? ListView.builder(
                            itemCount: l.length,
                            itemBuilder: (context, index) {
                              Map m = l[index];
                              return ListTile(
                                onTap: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return insertpage(a: 1, m: m);
                                    },
                                  ));
                                },
                                onLongPress: () {
                                  showDialog(
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Delete"),
                                          content: Text(
                                              "Are you sure you want to delete '${m['name']}'"),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                int id = m['id'];
                                                String qry =
                                                    "delete from Test where id = '$id'";
                                                await db!.rawDelete(qry);
                                                setState(() {});
                                              },
                                              child: Text("Yes"),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("No")),
                                          ],
                                        );
                                      },
                                      context: context);
                                },
                                leading: (m['imagepath'] == '' )
                                    ? Container(
                                        height: 30,
                                        width: 30,
                                        child: Image.asset("myimage/user.png"),
                                      )
                                    : Container(
                                        height: 30,
                                        width: 30,
                                        child: Image.file(File(m['imagepath'])),
                                      ),
                                title: Text("${m['name']}"),
                                subtitle: Text("${m['contact']}"),
                              );
                            },
                          )
                        : Center(
                            child: Text("No Data found"),
                          );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          future: getdata(),
        ));
  }
}
