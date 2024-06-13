import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final databaseref = FirebaseDatabase.instance.ref('UserDetails');
final user = FirebaseAuth.instance.currentUser;

abstract class userdatafunction {
  Future<void> addWater(String wtime, String Water, String _selectedDate);
  Future<WaterListItem> getWatervalue(String Value, String _selectedDate);
  Future<List<WaterListItem>> getList(String _selectedDate);
}

class WaterListItem {
  String? id;
  String? wtime;
  String? Glass;

  WaterListItem({this.id, this.wtime, this.Glass});

  String toString() {
    return '{$wtime $Glass $id}';
  }
}

class WaterList {
  List<WaterListItem>? waterList;

  WaterList({this.waterList});

  String toString() {
    return '{$waterList}';
  }
}

class WaterDB implements userdatafunction {
  WaterDB._internal();
  static WaterDB instances = WaterDB._internal();

  factory WaterDB() {
    return instances;
  }
  ValueNotifier<WaterListItem> userList = ValueNotifier(WaterListItem());

  @override
  Future<List<WaterListItem>> getList(String _selectedDate) async {
    List<WaterListItem> userDetails = [];
    try {
      final userdetail =
          await databaseref.child('${user!.uid}/${_selectedDate}/Water').get();
      if (userdetail.exists) {
        // ignore: unused_local_variable
        int index = 0;
        for (final child in userdetail.children) {
          userDetails.add(await getWatervalue(child.key, _selectedDate));
          index++;
        }
      }
    } catch (error) {
      print('Error getting user details: $error');
    }
    return userDetails;
  }

  @override
  Future<WaterListItem> getWatervalue(
      String? Value, String _selectedDate) async {
    WaterListItem userDetails = WaterListItem();
    try {
      final userdetail = await databaseref
          .child('${user!.uid}/${_selectedDate}/Water/${Value}')
          .get();
      if (userdetail.exists) {
        userDetails = WaterListItem(
            id: userdetail.child('id').value.toString(),
            wtime: userdetail.child('wtime').value.toString(),
            Glass: userdetail.child('Water').value.toString());

        return await userDetails;
      }
    } catch (error) {
      print('Error getting user details: $error');
    }
    return userDetails;
  }

  @override
  Future<void> addWater(
      String wtime, String Water, String _selectedDate) async {
    try {
      await databaseref
          .child(
              '${user!.uid}/${_selectedDate}/Water/${(DateTime.now().millisecondsSinceEpoch).toString()}')
          .set({
        'id': '${(DateTime.now().millisecondsSinceEpoch).toString()}',
        'wtime': wtime,
        'Water': '${Water} Glass',
      });
      print('UserDetails added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error adding wtime: $error');
    }
  }

  Future<void> deleteWater(String id, String _selectedDate) async {
    try {
      await databaseref
          .child('${user!.uid}/${_selectedDate}/Water/${id}')
          .remove();
      print('UserDetails added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error adding wtime: $error');
    }
  }
}
