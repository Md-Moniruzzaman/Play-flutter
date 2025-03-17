import 'package:CBD/model/Memo/memo_details_data_model.dart';
import 'package:intl/intl.dart';

class MemoServices {
  //------------------------ convert with Commas -----------------------
  String convertNumberToBanglaWithCommas(double number) {
    const englishToBanglaDigits = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
    };

    final formattedNumber = NumberFormat.decimalPattern().format(number);

    String banglaNumber = formattedNumber.split('').map((digit) {
      return englishToBanglaDigits.containsKey(digit)
          ? englishToBanglaDigits[digit]!
          : digit;
    }).join();
    return banglaNumber;
  }

//------------------------ convert without Commas -----------------------
  String convertNumberToBangla(String number) {
    const englishToBanglaDigits = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
      "-": "-"
    };
    String banglaNumber = number.split('').map((digit) {
      return englishToBanglaDigits.containsKey(digit)
          ? englishToBanglaDigits[digit]!
          : digit;
    }).join();
    return banglaNumber;
  }

//-------------- Total Overall Value--------------------------
  double calculateTotalNetValue(
    List<InvoiceDetail> invoiceList,
  ) {
    double totalNetValue = 0.00;
    for (InvoiceDetail invoice in invoiceList) {
      totalNetValue += ((double.tryParse(invoice.price) ?? 0.00) *
              (double.tryParse(invoice.quantity) ?? 0.00)) -
          (double.tryParse(invoice.discount!) ?? 0.00);
    }

    return totalNetValue;
  }

//------------------------ total Qty -----------------------------
  double calculateTotalQty(List<InvoiceDetail> invoiceList) {
    double totalQty = 0;
    for (InvoiceDetail invoice in invoiceList) {
      totalQty += (double.tryParse(invoice.quantity) ?? 0);
    }

    return totalQty;
  }

//----------------------- total Discount ----------------------------
  double calculateTotalDiscount(List<InvoiceDetail> invoiceList) {
    if (invoiceList == null || invoiceList.isEmpty) {
      return 0.00;
    }
    double totalNetValue = 0.00;
    for (InvoiceDetail detail in invoiceList) {
      double returnValue = double.tryParse(detail.discount ?? "0.00") ?? 0.00;
      totalNetValue += returnValue;
    }
    return totalNetValue;
  }

//--------------------- Total Amount ------------------------
  double totalAmount(InvoiceDetail invoiceList) {
    double totalAmount = 0.00;
    totalAmount = (double.tryParse(invoiceList.price) ?? 0.00) *
        (double.tryParse(invoiceList.quantity) ?? 0.00);

    return totalAmount;
  }

//---------------------- Net value ------------------------
  double totalNetValue(InvoiceDetail invoiceList) {
    double totalNetValue = 0.00;
    totalNetValue = ((double.tryParse(invoiceList.price) ?? 0.00) *
            (double.tryParse(invoiceList.quantity) ?? 0.00)) -
        (double.tryParse(invoiceList.discount!) ?? 0.00);

    return totalNetValue;
  }

  double totalReturnQuantity(
      InvoiceDetail invoiceItem, List<InvoiceDetail> mrItemList) {
    double totalReturnQty = 0.0;

    InvoiceDetail? marketReturnItem = mrItemList
        .cast<InvoiceDetail?>()
        .firstWhere((item) => item?.itemId == invoiceItem.itemId,
            orElse: () => null);

    if (marketReturnItem != null) {
      print(marketReturnItem.quantity);
      totalReturnQty = double.tryParse(marketReturnItem.quantity) ?? 0.0;
    }

    return totalReturnQty;
  }

//------------------- each return value ---------------------------
  double totalReturnValue(
      InvoiceDetail invoiceItem, List<InvoiceDetail> mrItemList) {
    double totalValueWithDeduction = 0.0;

    InvoiceDetail? marketReturnItem = mrItemList
        .cast<InvoiceDetail?>()
        .firstWhere((item) => item?.itemId == invoiceItem.itemId,
            orElse: () => null);

    if (marketReturnItem != null) {
      double totalUnitPrice = 0.00;
      double deductionPercentage =
          (double.tryParse(marketReturnItem.deductionPercentage ?? "0") ?? 0) /
              100;
      totalUnitPrice = ((double.tryParse(marketReturnItem.price) ?? 0.00) *
          (double.tryParse(marketReturnItem.quantity) ?? 0.00));
      totalValueWithDeduction =
          totalUnitPrice - (totalUnitPrice * deductionPercentage);
      return totalValueWithDeduction;
    }

    return totalValueWithDeduction;
  }

  // double totalNetValue(InvoiceDetail invoiceList) {
  //   double totalNetValue = 0.00;
  //   totalNetValue = ((double.tryParse(invoiceList.price) ?? 0.00) *
  //           (double.tryParse(invoiceList.quantity) ?? 0.00)) -
  //       (double.tryParse(invoiceList.discount!) ?? 0.00);

  //   return totalNetValue;
  // }

  //------------------------ total Qty -----------------------------
  double sumOfReturnQuantity(List<InvoiceDetail> markreturnreturnItems) {
    double totalQty = 0;
    for (InvoiceDetail invoice in markreturnreturnItems) {
      totalQty += (double.tryParse(invoice.quantity) ?? 0);
    }

    return totalQty;
  }

//--------------------- Total Return amount ---------------------------------
  double sumOftotalReturnAmount(List<InvoiceDetail> invoiceList) {
    double totalNetValue = 0.00;
    for (InvoiceDetail invoice in invoiceList) {
      double deductionPercentage =
          (double.tryParse(invoice.deductionPercentage ?? "0") ?? 0) / 100;
      double productTotal =
          (double.parse(invoice.quantity ?? '0') * double.parse(invoice.price));
      double finalPrice = productTotal - (productTotal * deductionPercentage);
      totalNetValue += finalPrice;
    }
    return totalNetValue;
  }

  double overAllTotal(
      List<InvoiceDetail> invoiceList, List<InvoiceDetail> mrItmeList) {
    double totalNetValue = 0.00;
    for (InvoiceDetail invoice in invoiceList) {
      totalNetValue += ((double.tryParse(invoice.price) ?? 0.00) *
              (double.tryParse(invoice.quantity) ?? 0.00)) -
          (double.tryParse(invoice.discount!) ?? 0.00);
    }

    double totalMrItemList = 0.00; //-------------------
    for (InvoiceDetail invoice in mrItmeList) {
      double deductionPercentage =
          (double.tryParse(invoice.deductionPercentage ?? "0") ?? 0) / 100;
      double productTotal =
          (double.parse(invoice.quantity ?? '0') * double.parse(invoice.price));
      double finalPrice = productTotal - (productTotal * deductionPercentage);
      totalMrItemList += finalPrice;
    }

    return totalNetValue - totalMrItemList;
  }
}
