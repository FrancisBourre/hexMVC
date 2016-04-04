package hex.metadata;

import hex.core.IAnnotationParsable;
import hex.di.IInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class MockObjectWithAnnotation implements IAnnotationParsable implements IInjectorContainer
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