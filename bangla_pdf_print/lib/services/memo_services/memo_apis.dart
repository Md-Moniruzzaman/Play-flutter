class MemoApis {
  // String base = "https://my.transcombd.com";
  // String applicationName = "cbd_api";

  String memoOutlitsApis(String memoString) => "$memoString/challan/memo_list";
  String memoDetails(String memoString) => "$memoString/challan/memo";
  String memByOrderSl(String memoString) => "$memoString/challan/memo_selected";
}
