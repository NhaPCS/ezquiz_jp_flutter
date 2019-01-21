final String tableCoin = 'coin';
final String _id = 'id';
final String _cost = 'cost';
final String _coin = 'coin';

class Coin {
  String id;
  int coin;
  String cost;

  Coin({this.id, this.coin, this.cost});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{_id: id, _coin: coin, _cost: cost};
    return map;
  }

  Coin.fromMap(Map<dynamic, dynamic> map) {
    id = map[_id];
    cost = map[_cost];
    coin = map[_coin];
  }
}
