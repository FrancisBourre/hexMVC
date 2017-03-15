package hex.control.trigger.mock;

import hex.control.trigger.MacroCommand;
import hex.error.Exception;

/**
 * ...
 * @author Francis Bourre
 */
class MockMacroCommandWithFailHandler extends MacroCommand<String>
{
	static public var executionCount 	: UInt = 0;
	static public var command			: MockMacroCommandWithFailHandler;
	
	static public var completeCallCount	: UInt = 0;
	static public var failCallCount		: UInt = 0;
	static public var cancelCallCount	: UInt = 0;
	
	@Inject( 'name1' )
	public var pString1 : String;
	
	@Inject( 'name2' )
	public var pString2 : String;
	
	@Inject
	public var pInt 	: Int;
	
	@Inject
	public var pUInt 	: UInt;
	
	@Inject
	public var pFloat 	: Float;
	
	@Inject
	public var pBool 	: Bool;
	
	@Inject
	public var pArray 	: Array<String>;
	
	@Inject
	public var pStringMap : Map<String, String>;
	
	@Inject
	public var pDate : Date;
	
	public function new()
	{
		super();
	}
	
	override function _prepare():Void 
	{
		MockMacroCommandWithFailHandler.executionCount++;
		MockMacroCommandWithFailHandler.command = this;
		
		MockMacroCommandWithFailHandler.completeCallCount = 0;
		this.add( MockCommandFailing ).withCompleteHandler( _whenComplete ).withFailHandler( _whenFail ).withCancelHandler( _whenCancel );
		this.add( AnotherMockCommand ).withCompleteHandler( _whenComplete ).withFailHandler( _whenFail ).withCancelHandler( _whenCancel );
	}
	
	function _whenComplete( result : String ) : Void
	{
		MockMacroCommandWithFailHandler.completeCallCount++;
	}
	
	function _whenFail( error : Exception ) : Void
	{
		MockMacroCommandWithFailHandler.failCallCount++;
	}
	
	function _whenCancel() : Void
	{
		MockMacroCommandWithFailHandler.cancelCallCount++;
	}
}