  
class Transactions {
  int id;
  String transactionName;
  String type;
  double amount;

  Transactions(this.id, this.transactionName, this.amount, this.type);
 
  Map<String, dynamic> toMap(){
    var map = <String, dynamic> {
      'id' : id,
      'transaction_name': transactionName,
      'amount' : amount,
      'type' : type,
    };
    return map;
  }

  Transactions.fromMap(Map<String, dynamic> map){
    id= map['id'];
    transactionName= map['transaction_name'];
    type= map['type'];
    amount= map['amount'];
  }
}
