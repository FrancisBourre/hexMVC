package hex.service;

/**
 * ...
 * @author duke
 */
class ServiceResultVO<DataType>
{
	public var success:Bool;
	public var errorCode:UInt;
	public var errorMessage:String;
	
	public var data:DataType;
	

	public function new() 
	{
		
	}
	
}