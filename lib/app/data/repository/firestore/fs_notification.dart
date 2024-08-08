
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazyui/lazyui.dart';
import 'package:simanis/app/core/utils/toast.dart';
import 'package:simanis/app/data/repository/storage/auth_storage.dart';

class FsNotification {
  FsNotification._();
  static final FsNotification instance = FsNotification._();

  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('alarms');
  List docIds = [];

  // count all of notifications
  Stream<int>? countNotification(String username) {
    try {
      return _collection
          .where('created_by', isEqualTo: [ username])
          .snapshots()
          .map((event) {
            docIds.clear();
            int length = 0;

            for (var e in event.docs) {
              Map<String, dynamic> doc = e.data() as Map<String, dynamic>;
              doc['doc_id'] = e.id;

              List readers = (e['read_by'] ?? []) as List;
              if (!readers.contains(username)) {
                docIds.add(e.id);
                length++;
              }
            }

            return length;
          });
    } catch (e, s) {
      Errors.check(e, s);
      return Stream.value(0);
    }

    // return _collection.where('topic', isEqualTo: username).where('isRead', isEqualTo: false).snapshots().map((event) => event.docs.length);
  }

  // get all notification by username
  // Stream<List<Map<String, dynamic>>>? getNotifications(String username) {
  //   return _collection.where('to', arrayContainsAny: ['all', username]).orderBy('timestamp', descending: true).snapshots().map((event) {
  //         List<Map<String, dynamic>> docs = [
  //           ...event.docs.cast().map((e) {
  //             Map<String, dynamic> doc = e.data();
  //             doc['doc_id'] = e.id;

  //             List readers = doc['read_by'];

  //             if (!readers.contains(username)) {
  //               if (!docIds.contains(e.id)) {
  //                 docIds.add(e.id);
  //               }
  //             }

  //             return doc;
  //           })
  //         ];

  //         return docs;
  //       });
  // }

  // read notification
  Future markAsRead(String docId, {bool withLoader = true}) async {
    if (withLoader) Toasts.overlay();

    final auth = await Auth.user();
    // get doc by docId
    DocumentSnapshot doc = await _collection.doc(docId).get();
    List readers = doc.get('read_by');

    // add username to readers
    readers.add(auth.username);

    // update readers
    await _collection
        .doc(docId)
        .update({'read_by': readers}).catchError((e, s) => Errors.check(e, s));

    if (withLoader) Toasts.dismiss();
  }

  Future markAllAsRead() async {
    List docIds = [...this.docIds];

    if (docIds.isEmpty) {
      return Toasts.show('Semua notifikasi sudah terbaca');
    }

    Toasts.overlay();
    await Future.forEach(docIds, (e) async => await markAsRead('$e'));
    Toasts.dismiss();
    Toasts.show('Semua notifikasi sudah terbaca');
  }

  // delete notification
  Future deleteNotif(String docId) async {
    Toasts.overlay();
    final auth = await Auth.user();

    // get doc by docId
    DocumentSnapshot doc = await _collection.doc(docId).get();
    List to = doc.get('to');

    if (to.length <= 1) {
      // delete notification
      await _collection
          .doc(docId)
          .delete()
          .catchError((e, s) => Errors.check(e, s));
    } else {
      // remove username from to
      to.removeWhere((e) => e == auth.username);

      // update `to`
      await _collection
          .doc(docId)
          .update({'to': to}).catchError((e, s) => Errors.check(e, s));
    }

    Toasts.dismiss();
  }

  /* ----------------------------------------------------------
  | NOTIFICATION 2.0
  --------------------------------------------- */

  Future listenToAlarms(
      String username, Function(Stream<QuerySnapshot<Object?>> query) onData,
      {int limit = 10, DocumentSnapshot? lastDocument}) async {
    // Query<Object?> query = _collection
    //     .where('created_by', arrayContainsAny: [ username]).orderBy('timestamp',
    //         descending: true);
       Query<Object?> query = _collection
        .where('created_by', isEqualTo: username);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    Stream<QuerySnapshot<Object?>> stream = query.limit(limit).snapshots();
    onData(stream);
  }
}
