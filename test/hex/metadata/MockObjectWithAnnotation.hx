package hex.metadata;

import hex.di.ISpeedInjectorContainer;
import hex.core.IAnnotationParsable;

/**
 * ...
 * @author Francis Bourre
 */
class MockObjectWithAnnotation implements IAnnotationParsable implements ISpeedInjectorContainer
{
	@color( "white" )
	public var colorTest : Int = 0;

	@language( "welcome" )
	public var languageTest : String;

	public var propWithoutMetaData : String;
		
	public function new() 
	{
		
	}
}