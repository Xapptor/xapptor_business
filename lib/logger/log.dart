class ProductLog {
  final String user_id;
  final ProductLogAction log_action;
  final String doc_id;
  final String collection_id;

  const ProductLog({
    required this.user_id,
    required this.log_action,
    required this.doc_id,
    required this.collection_id,
  });
}

enum ProductLogAction {
  read,
  create,
  update,
  delete,
  remove,
  add,
}
