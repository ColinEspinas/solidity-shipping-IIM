// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Shipping {
  
  address owner = msg.sender;

  // Liste des addresses ETH des livreurs
  address[] deliverers;

  // Enum représantant les différents états du shipping
  enum Status {
    Pending,
    Shipped,
    Delivered
  }

  // Structure de donnée réprésentant les produits
  struct Product {
    uint32 id; // 32 bits suffisant pour un id
    string name;
    Status status;
    address deliverer;
  }
  Product[] public products;

  // Constructeur initialisant les produits
  constructor(address[] memory _deliverers) {
    deliverers = _deliverers;
    addProduct("Sample product", 0); // Sample product pour les tests
  }

  // Modifier pour que seul l'owner du contrat et les livreurs puissent changer l'état de shipping
  modifier onlyAllowed() {
    bool isSenderDeliverer = false;
    for (uint i = 0; i < deliverers.length; ++i) {
      if (msg.sender == deliverers[i]) {
        isSenderDeliverer = true;
      }
    }
    require(msg.sender == owner || isSenderDeliverer);
    _;
  }

  // Evenement changement d'état du shipping
  event ShippementStatusChange(uint productId, Status status);

  // Fonction d'ajout d'un produit au suivi d'état de shipping et retourne l'id du nouveau produit
  function addProduct(string memory _name, uint _delivererId) public onlyAllowed returns (uint) {
    products.push(Product(uint32(products.length), _name, Status.Pending, deliverers[_delivererId]));
    return products.length - 1;
  }

  // Fonction de changement d'état du shipping
  function setShippementStatus(uint _productId, Status _status) external onlyAllowed {
    products[_productId].status = _status;
    emit ShippementStatusChange(_productId, _status);
  }

  function getShippementStatus(uint _productId) external view returns (string memory) {
    Status productStatus = products[_productId].status;
    if (productStatus == Status.Pending) { return "Pending"; }
    if (productStatus == Status.Shipped) { return "Shipped"; }
    if (productStatus == Status.Delivered) { return "Delivered"; }
    return "Unknown status";
  }

  // Fonction de pourboire au livreur
  function giveTipToDeliverer(address payable _deliverer) public payable {
    _deliverer.transfer(msg.value);
  }
}
