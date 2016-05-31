package hex.metadata;

import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class AnnotationProviderTest
{
	var _annotationProvider:AnnotationProvider;
	var _colors:Map<String, UInt>;
	var _text:Map<String, String>;
		
	@Before
    public function setUp() : Void
    {
		this._annotationProvider = new AnnotationProvider();
		this._colors = new Map<String, UInt>();
		this._text = new Map<String, String>();
		
        this._colors.set( "white", 0xFFFFFF );
		this._text.set( "welcome", "Bienvenue" );
    }

    @After
    public function tearDown() : Void
    {
        this._colors.remove( "white" );
		this._text.remove( "welcome" );
		this._annotationProvider.clear();
    }
	
	@Test( "Test register before parsing" )
	public function testRegisterBeforeParsing() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		this._annotationProvider.registerMetaData( "color", this, this.getColorByName );
		this._annotationProvider.registerMetaData( "language", this, this.getText );
		
		this._annotationProvider.parse( mockObjectWithMetaData );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test register after parsing" )
	public function testRegisterAfterParsing() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		this._annotationProvider.parse( mockObjectWithMetaData );
		
		this._annotationProvider.registerMetaData( "color", this, this.getColorByName );
		this._annotationProvider.registerMetaData( "language", this, this.getText );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test with module" )
	public function testWithModule() : Void
	{
		var module = new MockModuleForAnnotationProviding();
		this._annotationProvider = module.getAnnotationProvider();
		
		this._annotationProvider.registerMetaData( "color", this, this.getColorByName );
		this._annotationProvider.registerMetaData( "language", this, this.getText );
		
		module.initialize();

		Assert.equals( 0xffffff, module.mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", module.mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( module.anotherMockObjectWithMetaData.languageTest, "property should be null when class is not implementing IAnnotationParsable" );
	}
	
	@Test( "Test clear method" )
	public function testClearMethod() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		this._annotationProvider.registerMetaData( "color", this, this.getColorByName );
		this._annotationProvider.clear();
		
		this._annotationProvider.parse( mockObjectWithMetaData );
		Assert.equals( 0, mockObjectWithMetaData.colorTest, "property should be set to 0 default value" );
	}
	
	function getColorByName( name : String ) : Int
	{
		return this._colors.get( name );
	}

	function getText( name : String ) : String
	{
		return this._text.get( name );
	}
}