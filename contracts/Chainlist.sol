pragma solidity ^0.4.18;
import "./Ownable.sol";

contract Chainlist is Ownable{
  // custom types
  struct Article {
    uint256 id;
    address seller;
    address buyer;
    string name;
    string description;
    uint256 price;
  }
  // state variables
  // address owner;
  mapping (uint => Article) public articles;
  uint articleCounter;



  // constructor
  /*function Chainlist() public{
    sellArticle("Default artilce", "this is an article set by default",1000000000000000000);

  }*/


  //events

  event LogSellArticle(
    uint indexed _id,
    address indexed _seller,
    string _name,
    uint256 _price
    );

  event LogBuyArticle(
    uint indexed _id,
    address indexed _seller,
    address indexed _buyer,
    string _name,
    uint256 _price

    );

  //modifiers

  /* modifier onlyOwner(){
    require(msg.sender == owner);
    _;

  }
  */

  /*
  // constructor
  function Chainlist() public {
    owner = msg.sender;

  }
  */

  //deactivate the contract
  function kill() public onlyOwner {
    // only allow the contact owner
    // require(msg.sender == owner);

    selfdestruct(owner);
  }


  // sell an article
  function sellArticle(string _name, string _description, uint256 _price) public {
    //seller = msg.sender;
    //name = _name;
    //description = _description;
    //price = _price;
    articleCounter++;

    //storing this article
    articles[articleCounter] = Article(
      articleCounter,
      msg.sender,
      0x0,
      _name,
      _description,
      _price
      );

    LogSellArticle(articleCounter, msg.sender,_name,_price);
  }

  // fetch the number of articles in the contract
  function getNumberOfArticles() public view returns (uint){
    return articleCounter;

  }

  //fetch and return all article IDs for articles still for scale
  function getArticlesForSale() public view returns (uint[]){
    // prepare output array
    uint[] memory articleIds = new uint[](articleCounter);
    uint numberOfArticlesForSale = 0;
    // iterate over articles
    for(uint i =1; i<= articleCounter; i++){
      // keep the ID if the article is still for sale
      if(articles[i].buyer == 0x0){
        articleIds[numberOfArticlesForSale] = articles[i].id;
        numberOfArticlesForSale++;
      }
    }

    // copy the articleIds array into a smaller forSale array
    uint[] memory forSale = new uint[](numberOfArticlesForSale);
    for (uint j = 0; j < numberOfArticlesForSale; j++){
      forSale[j] = articleIds[j];
    }
    return forSale;
  }

  // buy an article

  function buyArticle(uint _id) payable public{
    // we check if there is an article for sale
    require(articleCounter > 0);

    // we check that the article exists
    require(_id > 0 && _id <= articleCounter);

    // we retrieve the articles
    Article storage article = articles[_id];

      //we check that the article has not been sold yet
    require(article.buyer == 0x0);

    // we don't allow the seller to buy its own article
    require(msg.sender != article.seller);

    // we check that the value sent corresponds to the price of the article
    require(msg.value == article.price);

    // keep track of the buyer's information
    article.buyer = msg.sender;

    //buyer can pay the _seller
    article.seller.transfer(msg.value);

    // trigger the event
    LogBuyArticle(_id, article.seller, article.buyer, article.name, article.price);

  }




}
