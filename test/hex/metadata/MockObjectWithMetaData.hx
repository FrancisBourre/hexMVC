package hex.metadata;

import hex.core.IMetaDataParsable;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class MockObjectWithMetaData implements IMetaDataParsable
{
	@color( "white" )
	public var colorTest : Int;

	@language( "welcome" )
	public var languageTest : String;

	public var propWithoutMetaData : String;
		
	public function new() 
	{
		
	}
}