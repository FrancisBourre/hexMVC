package hex.metadata;

import hex.di.IInjectorContainer;
/**
 * ...
 * @author Francis Bourre
 */
class MockWithoutIAnnotationParsableImplementation implements IInjectorContainer
{
	@language( "welcome" )
	public var languageTest : String;
		
	public function new() 
	{
		
	}
}