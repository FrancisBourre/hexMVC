package hex.metadata;

/**
 * ...
 * @author Francis Bourre
 */
import hex.di.ISpeedInjectorContainer;
class MockWithoutIAnnotationParsableImplementation implements ISpeedInjectorContainer
{
	@language( "welcome" )
	public var languageTest : String;
		
	public function new() 
	{
		
	}
}