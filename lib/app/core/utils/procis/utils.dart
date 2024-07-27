import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazyui/lazyui.dart' hide Errors;

class ProcisUtils {
  static Offset boxOffset(GlobalKey key) {
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    final Offset? offset = box?.localToGlobal(Offset.zero);
    return offset ?? Offset.zero;
  }

  static void scrollToItem(GlobalKey key, ScrollController scroller, double dialogPosition, double dialogHeight) {
    Utils.timer(() {
      if (key.currentContext != null) {
        // todo: centering the item
        // kita punya overlay-dialog widget di mana itu akan muncul berdasarkan posisi select-option widget
        // pada overlay-dialog widget, kita punya scrollview dengan daftar item
        // saat item tertentu dipilih, kita ingin scrollview itu scroll ke posisi item yang dipilih

        // render widget by key
        RenderBox box = key.currentContext?.findRenderObject() as RenderBox;

        // get item height
        double itemHeight = box.size.height;

        // get item position
        double dy = box.localToGlobal(Offset.zero).dy;

        // get max scroll
        double maxScroll = scroller.position.maxScrollExtent;

        // keterangan :
        // - scroller.offset = posisi scroll saat ini
        // - dy = posisi item saat ini
        // - itemHeight = tinggi item
        // - dialogPosition = posisi overlay-dialog widget
        // - dialogHeight = tinggi overlay-dialog widget

        // perhitungan :
        // - scroller.offset + (dy - itemHeight) = posisi item saat ini
        // - (Get.height - dialogHeight) / 2 = posisi tengah overlay-dialog widget
        // - ((dialogPosition + itemHeight) - dialogHeight / 2) = posisi tengah item

        double pos = (scroller.offset + (dy - itemHeight) - (Get.height - dialogHeight) / 2) - ((dialogPosition + itemHeight) - dialogHeight / 2);

        // set scroll position
        scroller.animateTo(
          pos < 0
              ? 0
              : pos > maxScroll
                  ? maxScroll
                  : pos,
          duration: 300.ms,
          curve: Curves.easeInOut,
        );
      }
    }, 350.ms);
  }
}
