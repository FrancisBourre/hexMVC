package hex.metadata;

import hex.core.IMetadataParsable;

/**
 * ...
 * @author Francis Bourre
 */
@:rtti
class MockObjectWithMetaData implements IMetadataParsable
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