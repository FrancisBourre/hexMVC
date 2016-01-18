package hex.metadata;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class MetadataProviderTest
{
	private var _colors 	: Map<String, Int> 		= new Map();
	private var _text 		: Map<String, String> 	= new Map();
		
	@setUp
    public function setUp() : Void
    {
        this._colors.set( "white", 0xFFFFFF );
		this._text.set( "welcome", "Bienvenue" );
    }

    @tearDown
    public function tearDown() : Void
    {
        this._colors.remove( "white" );
		this._text.remove( "welcome" );
		MetadataProvider.getInstance().clear();
    }
	
	@test( "Test register before parsing" )
	public function testRegisterBeforeParsing() : Void
	{
		var mockObjectWithMetaData : MockObjectWithMetaData = new MockObjectWithMetaData();
		var metaDataProvider : IMetadataProvider = MetadataProvider.getInstance();
		
		metaDataProvider.registerMetaData( "color", this, this.getColorByName );
		metaDataProvider.registerMetaData( "language", this, this.getText );
		
		metaDataProvider.parse( mockObjectWithMetaData );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@test( "Test register after parsing" )
	public function testRegisterAfterParsing() : Void
	{
		var mockObjectWithMetaData : MockObjectWithMetaData = new MockObjectWithMetaData();
		var metaDataProvider : IMetadataProvider = MetadataProvider.getInstance();
		
		metaDataProvider.parse( mockObjectWithMetaData );
		
		metaDataProvider.registerMetaData( "color", this, this.getColorByName );
		metaDataProvider.registerMetaData( "language", this, this.getText );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@test( "Test with module" )
	public function testWithModule() : Void
	{
		var metaDataProvider : IMetadataProvider = MetadataProvider.getInstance();

		metaDataProvider.registerMetaData( "color", this, this.getColorByName );
		metaDataProvider.registerMetaData( "language", this, this.getText );

		var module : MockModuleForMetaDataProviding = new MockModuleForMetaDataProviding();
		module.initialize();

		Assert.equals( 0xffffff, module.mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", module.mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( module.anotherMockObjectWithMetaData.languageTest, "property should be null when class is not implementing IMetadataParsable" );
	}
	
	@test( "Test clear method" )
	public function testClearMethod() : Void
	{
		var mockObjectWithMetaData : MockObjectWithMetaData = new MockObjectWithMetaData();
		var metaDataProvider : IMetadataProvider = MetadataProvider.getInstance();
		
		metaDataProvider.registerMetaData( "color", this, this.getColorByName );
		metaDataProvider.clear();
		
		metaDataProvider.parse( mockObjectWithMetaData );
		Assert.isNull( mockObjectWithMetaData.colorTest, "property should be null" );
	}
	
	private function getColorByName( name : String ) : Int
	{
		return this._colors.get( name );
	}

	private function getText( name : String ) : String
	{
		return this._text.get( name );
	}
}