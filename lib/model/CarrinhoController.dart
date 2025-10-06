import 'package:flutter/material.dart';
import '../helper/ItemDao.dart';
import '../helper/ItemPedido.dart';
import '../helper/ItemPedidoDAO.dart';

class CarrinhoController extends ChangeNotifier {
  final ItemDAO itemDAO;
  final ItemPedidoDAO itemPedidoDAO;

  List<ItemPedido> itens = [];

  CarrinhoController({required this.itemDAO, required this.itemPedidoDAO}) {
    carregarItens();
  }

  Future<void> carregarItens() async {
    itens = await itemPedidoDAO.getList(); // carrega do DAO
    notifyListeners();
  }

  double get totalCarrinho =>
      itens.fold(0, (sum, item) => sum + (item.valor * item.quantidade));

  int get quantidadeProdutos => itens.length;

  void aumentarQuantidade(int index) {
    final item = itens[index];
    if (item.quantidade < item.estoque) {
      item.quantidade++;
      itemPedidoDAO.atualizar(item);
      notifyListeners();
    }
  }

  void diminuirQuantidade(int index) {
    final item = itens[index];
    if (item.quantidade > 1) {
      item.quantidade--;
      itemPedidoDAO.atualizar(item);
      notifyListeners();
    }
  }

  void removerProduto(int index) {
    final item = itens[index];
    itens.removeAt(index);
    itemPedidoDAO.remover(item);
    itemDAO.remover(item);
    notifyListeners();
  }

  bool get temProdutoNoCarrinho => itens.isNotEmpty;
}
