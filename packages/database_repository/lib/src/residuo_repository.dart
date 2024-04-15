import 'package:database_repository/database_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// {@template residuo_repository}
/// Repository  whitch manages residuos.
/// {@endtemplate}


class ResiduoRepository {
  /// {@macro residuo_repository}
  
  ResiduoRepository ({FirebaseFirestore? firebaseFirestore}) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  // Create a residuos table and read all datas
  Stream<List<Residuos>> listAll({required String userId}) {
    try{
      return _firebaseFirestore
        .collection('residuos')
        .doc(userId)
        .collection('residuo')
        .orderBy('name')
        .snapshots()
        .map((result) {
          final List<Residuos> residuos = <Residuos>[];
          result.docs.forEach((doc) {
            final data = doc.data();
            var date;
            try{
              date = (data['date'] as Timestamp).toDate();
            }catch(exception){}
            residuos.add(Residuos(
              id: doc.id,
              name: data['name'],
              size: data['size'],
              solution: data['solution'],
              date: date
            ));
          });
          return residuos;
        });
      }catch(exception){
        rethrow;
      }
    }

  // Add a new residuo
  Future<Residuos> add({required String userId, required Residuos residuos}) {
    try{
      var date;
      try{
        date = Timestamp.fromDate(residuos.date!);
      }catch(exception){}
      return _firebaseFirestore
        .collection('residuos')
        .doc(userId)
        .collection('residuo')
        .add({
          'name' : residuos.name,
          'size' : residuos.size,
          'solution' : residuos.solution,
          'date' : date
        }).then((result) {
          return Residuos(
            id: result.id,
            name: residuos.name,
            size: residuos.size,
            solution: residuos.solution,
            date: residuos.date
          );
        });
    }catch(exception){
      rethrow;
    }
  }

  // Update a existing residuo
  Future<void> update({required String userId, required Residuos residuos}) {
    try{
      var date;
      try{
        date = Timestamp.fromDate(residuos.date!);
      }catch(exception){}
      return _firebaseFirestore
        .collection('residuos')
        .doc(userId)
        .collection('residuo')
        .doc(residuos.id)
        .update({
          'name' : residuos.name,
          'size' : residuos.size,
          'solution' : residuos.solution,
          'date' : date
        });
    }catch(exception){
      rethrow;
    }
  }

  // Delete a existing residuo
  Future<void> delete({required String userId, required Residuos residuos}) {
    try{
      return _firebaseFirestore
        .collection('residuos')
        .doc(userId)
        .collection('residuo')
        .doc(residuos.id)
        .delete();
    }catch(exception){
      rethrow;
    }
  }
}