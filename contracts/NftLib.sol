pragma solidity 0.6.2;

 
interface ERC721TokenReceiver {
    function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
}
	
//合约
contract NFTLib is ERC721TokenReceiver{
	
	struct NftStatus{
	   status 		uint8;				//0-已托管  1-上架  2-借出
	   price  		uint256;
	   maxDays 		unit8;
	   startHeight	unit256;
	}
	
	//nft的所有者映射表
	mapping (uint256 => address) public nftToOwner;
	
	mapping (unit256 => NftStatus) public nftShelf;
	
	//费用地址
	address constant feeAddress = address(0x3ca0ab21f6101baec51fdcb4dafc0b9fecc33e53);
	
	/*
	 * transfer即托管（本合约获得使用权）
	 */
	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4) {
		require( nftToOwner(_tokenId) == address(0), "nft is invalid"); 	//验证tokenId
		nftToOwner(_tokenId) = _form;
		nftShelf(_tokenId) = NftStatus(0, 0, 0, 0);
		return bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
	}
	
	/**
	 * 上架
	 */
	function shelf(ERC721 nft, unit256 tokenId, uint256 price, unit4 maxDays) external {
		//验证tokenId已托管
        require( nftToOwner(_tokenId) != address(0), "nft is invalid"); 	
		//验证权限
		address ownerAddress = nftToOwner(_tokenId);
		require( msg.sender == ownerAddress, "no right!");
		require( price > 0, "price cannot be 0");
		require( maxDays > 0, "borrow day must big than 0");
		//验证状态
		NftStatus nftStatus = nftShelf(_tokenId);
		require( nftStatus.status == 0, "cannot be shelf");
		nftShelf(_tokenId) = NftStatus(1, price, maxHeight, 0);
    }
	
	/**
	 * 借出 TODO
	 * 借入者发起调用
	 */
	function borrowStart(ERC721 nft, unit256 tokenId, uint4 days) external {
		//验证tokenId已托管
        require( nftToOwner(_tokenId) != address(0), "nft is invalid"); 
		address ownerAddress = nftToOwner(_tokenId);		
		require( msg.sender != ownerAddress, "cannot borrow by self!");
		//验证状态
		NftStatus nftStatus = nftShelf(_tokenId);
		require( nftStatus.status == 1, "cannot be borrowed");
		//借入者抵押借入费用
		
		//借出交易
		
	}
	
	/**
	 * 赎回 系统收取5%手续费
	 * 借出者赎回
	 * 借入者赎回
	 * 系统自动赎回
	 */
	function redeemByOwner(ERC721 nft, unit256 _tokenId) external{
		//验证tokenId已托管
        require( nftToOwner(_tokenId) != address(0), "nft is invalid"); 
		//验证状态
		NftStatus nftStatus = nftShelf(_tokenId);
		require( nftStatus.status == 0, "it is be borrowed");
		
		//nu
		
		//TODO
		nft.safeTransferFrom(from, msg.sender, _tokenId);
		delete( nftToOwner(_tokenId));
		delete( nftShelf(_tokenId));
	}
	
}