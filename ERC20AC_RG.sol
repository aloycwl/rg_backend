pragma solidity>0.8.0;//SPDX-License-Identifier:None
contract ERC20AC{
    event Transfer(address indexed from,address indexed to,uint value);
    event Approval(address indexed owner,address indexed spender,uint value);
    mapping(address=>uint)internal _balances;
    mapping(address=>mapping(address=>uint))internal _allowances;
    address internal _owner;
    uint internal _totalSupply;
    string private _name;
    string private _sym;
    constructor(string memory name_,string memory sym_){
        (_owner,_name,_sym)=(msg.sender,name_,sym_);
    }
    function name()external view returns(string memory){
        return _name;
    }
    function symbol()external view returns(string memory){
        return _sym;
    }
    function decimals()external pure returns(uint){
        return 18;
    }
    function totalSupply()external view returns(uint){
        return _totalSupply;
    }
    function balanceOf(address a)external view returns(uint){
        return _balances[a];
    }
    function transfer(address a,uint b)external returns(bool){
        transferFrom(msg.sender,a,b);
        return true;
    }
    function allowance(address a,address b)external view returns(uint){
        return _allowances[a][b];
    }
    function approve(address a,uint b)external returns(bool){
        _allowances[msg.sender][a]=b;
        emit Approval(msg.sender,a,b);
        return true;
    }
    function transferFrom(address a,address b,uint c)public virtual returns(bool){unchecked{
        require(_balances[a]>=c);
        require(a==msg.sender||_allowances[a][b]>=c);
        if(_allowances[a][b]>=c)_allowances[a][b]-=c;
        (_balances[a]-=c,_balances[b]+=c);
        emit Transfer(a,b,c);
        return true;
    }}
}
contract OnlyAccess {
    mapping(address=>uint)public _access;
    modifier onlyAccess(){
        require(_access[msg.sender]>0);
        _;
    }
    constructor(){
        _access[msg.sender]=1;
    }
    function ACCESS(address a,uint b)external onlyAccess{
        if(b==0)delete _access[a];
        else _access[a]=1;
    }
}
contract RGT is ERC20AC,OnlyAccess{
    constructor(string memory name_,string memory sym_)ERC20AC(name_,sym_){}
    function transferFrom(address a,address b,uint c)public override returns(bool){unchecked{
        require(_balances[a]>=c);
        require(a==msg.sender||_allowances[a][b]>=c);
        (_balances[a]-=c,_balances[b]+=c);
        emit Transfer(a,b,c);
        return true;
    }}
    function mint(address a,uint b)external onlyAccess{unchecked{
        (_balances[a]+=b,_totalSupply+=b);
        emit Transfer(address(this),a,b);
    }}
    function burn(uint a)external onlyAccess{unchecked{
        _totalSupply-=a;
        emit Transfer(address(this),address(0),a);
    }}
}
