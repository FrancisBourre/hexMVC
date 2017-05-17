package hex.control.trigger.mock;
import hex.annotation.IAnnotationReplace;
import hex.control.async.Expect;
import hex.control.async.Nothing;
import hex.control.trigger.ICommandTrigger;
import hex.control.trigger.MockCommandClassWithoutParameters;

/**
 * ...
 * @author 
 */
class MockAnnotationReplaceController implements ICommandTrigger implements IAnnotationReplace
{

	static var NAME = "name";
	
	public function new() 
	{
	}
	
	@Inject(NAME)
	public var mockInjection:MockInjectee;
	
	@Map( hex.control.trigger.MockCommandClassWithoutParameters )
	public function printFQCN() : Expect<Nothing>;
	
	@Map( MockCommandClassWithoutParameters )
	public function print() : Expect<Nothing>;
	
}

class MockInjectee
{
	public function new(){}
}