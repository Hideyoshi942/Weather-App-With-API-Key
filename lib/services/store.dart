import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService{
  FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<String?> addData (Map<String, dynamic> data,  String _nameCollection) async{
    try{
      DocumentReference documentref = await _store.collection(_nameCollection).add(data);
      return documentref.id;
    }
    catch(err){
      print("có lỗi thêm dữ liệu: $err");
      return null;
    }
  }

  Future<QuerySnapshot?> getData (String collaption, String nameField ,var valueField)async {
    try{
      QuerySnapshot query = await _store.collection(collaption).where(nameField, isEqualTo: valueField).get();
      return query;
    }
    catch(err){
      print("Có lỗi lấy dữ liệu $err");
      return null;
    }
  }

  Future<void> updateData(String collection, String documentId, Map<String, dynamic> newData) async {
    try {
      await FirebaseFirestore.instance.collection(collection).doc(documentId).update(newData);
    } catch (err) {
      print("Có lỗi sửa đổi dữ liệu: $err");
    }
  }

  Future<void> deleteData(String collection, String documentId) async{
    try{
      await FirebaseFirestore.instance.collection(collection).doc(documentId).delete();
    }
    catch(err){

    }
  }
}