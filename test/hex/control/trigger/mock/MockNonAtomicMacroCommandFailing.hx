package hex.control.trigger.mock;

import hex.control.async.Nothing;
import hex.control.trigger.MacroCommand;

/**
 * ...
 * @author Francis Bourre
 */
class MockNonAtomicMacroCommandFailing extends MacroCommand<String>
{
	static public var executionCount 	: UInt = 0;
	static public var command			: MockNonAtomicMacroCommandFailing;
	
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
		this.isAtomic = false;
		
		MockNonAtomicMacroCommandFailing.executionCount++;
		MockNonAtomicMacroCommandFailing.command = this;
		
		this.add( MockCommandFailing );
		this.add( AnotherMockCommand );
	}
}