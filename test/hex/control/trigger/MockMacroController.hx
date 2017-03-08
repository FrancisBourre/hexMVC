package hex.control.trigger;

import hex.control.async.IAsyncCallback;
import hex.control.async.Nothing;

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
										d 	: Date
	) : IAsyncCallback<String>;
}