package hex.metadata;

import hex.core.IAnnotationParsable;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class MockObjectWithAnnotation implements IAnnotationParsable
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