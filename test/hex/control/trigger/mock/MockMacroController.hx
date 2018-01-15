package hex.control.trigger.mock;

import hex.collection.ILocator;
import hex.control.MockEnum;
import hex.control.async.Expect;

/**
 * ...
 * @author Francis Bourre
 */
class MockMacroController 
	implements ICommandTrigger
{
	public function new(){}
	
	@Map( hex.control.trigger.mock.MockMacroCommand )
	public function doSomething
	( 
		@Name( 'name1' )				s1 	: String,
		@Name( 'name2' )				s2 	: String,
										i 	: Int,
										ui 	: UInt,
										f	: Float,
										b 	: Bool,
										a 	: Array<String>,
		@Type( 'Map<String, String>' )	m 	: Map<Dynamic, Dynamic>,
		@Ignore							ai	: Array<Int>,
										d 	: Date,
										me	: MockEnum
	) : Expect<String>;
	
	public function sum( a : Int, b : Int ) : Int 
	{ 
		return a + b;
	}
	
	@Map( hex.control.trigger.MockCommandClassWithParameters )
	public function say( 
							@Name( 'text' ) 		text 		: String, 
													sender 		: CommandTriggerTest, 
													locator 	: ILocator<String,Bool>
						) : Expect<String>;
}