package hex.control.trigger.mock;

import hex.collection.Locator;
import hex.control.async.Expect;
import hex.control.async.Nothing;
import hex.control.trigger.ICommandTrigger;

/**
 * ...
 * @author Francis Bourre
 */
class MockController 
	implements ICommandTrigger
	implements IMockController 
{
	public function new(){}
	
	@Map( hex.control.trigger.MockCommandClassWithoutParameters )
	public function print() : Expect<Nothing>;
	
	@Map( hex.control.trigger.MockCommandClassWithParameters )
	public function say( 
							@Name( 'text' ) 								text 		: String, 
																			sender 		: CommandTriggerTest, 
							@Ignore 										anotherText : String,
							@Type( 'hex.collection.ILocator<String,Bool>' ) locator 	: Locator<String, Bool> 
						) : Expect<String>;

	public function sum( a : Int, b : Int ) : Int 
	{ 
		return a + b;
	}
	
	public function testLocalVarInjection() : String
	{
		@Inject
		var test : String;
		return test;
	}
	
	public function testLocalVarInjectionWithName() : String
	{
		@Inject( 'test' )
		var test : String;
		return test;
	}
	
	public function testLocalVarOptionalInjection() : Array<String>
	{
		@Optional
		@Inject( 'test1' )
		var test1 : String;
		
		@Inject( 'test2' )
		@Optional
		var test2 : String;
		
		@Inject( 'test3' )
		var test3 : String;

		return [ test1, test2, test3 ];
	}
	
	public function testLocalVarParamOptionalInjection() : Array<String>
	{
		@Optional( true )
		@Inject( 'test1' )
		var test1 : String;
		
		@Inject( 'test2' )
		@Optional( true )
		var test2 : String;
		
		@Inject( 'test3' )
		@Optional( false )
		var test3 : String;
		
		@Optional( false )
		@Inject( 'test4' )
		var test4 : String;
		
		return [ test1, test2, test3, test4 ];
	}
	
	static var IS_TRUE 	= true;
	static var IS_FALSE = false;
	
	static var NAME_1 	= 'test1';
	static var NAME_2 	= 'test2';
	static var NAME_3 	= 'test3';
	static var NAME_4 	= 'test4';
	
	public function testLocalVarReplacedParamOptionalInjection() : Array<String>
	{
		@Optional( IS_TRUE )
		@Inject( NAME_1 )
		var test1 : String;
		
		@Inject( NAME_2 )
		@Optional( IS_TRUE )
		var test2 : String;
		
		@Inject( NAME_3 )
		@Optional( IS_FALSE )
		var test3 : String;
		
		@Optional( IS_FALSE )
		@Inject( NAME_4 )
		var test4 : String;
		
		return [ test1, test2, test3, test4 ];
	}
}