package hex.metadata;

import hex.service.ServiceConfiguration;
import hex.service.stateless.StatelessService;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class AnnotationProviderTest
{
	var _colors 	: Map<String, Int> 		= new Map();
	var _text 		: Map<String, String> 	= new Map();
		
	@Before
    public function setUp() : Void
    {
        this._colors.set( "white", 0xFFFFFF );
		this._text.set( "welcome", "Bienvenue" );
    }

    @After
    public function tearDown() : Void
    {
        this._colors.remove( "white" );
		this._text.remove( "welcome" );
		AnnotationProvider.getInstance().clear();
    }
	
	@Test( "Test register before parsing" )
	public function testRegisterBeforeParsing() : Void
	{
		var mockObjectWithMetaData : MockObjectWithAnnotation = new MockObjectWithAnnotation();
		var annotationProvider : IAnnotationProvider = AnnotationProvider.getInstance();
		
		annotationProvider.registerMetaData( "color", this, this.getColorByName );
		annotationProvider.registerMetaData( "language", this, this.getText );
		
		annotationProvider.parse( mockObjectWithMetaData );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test register after parsing" )
	public function testRegisterAfterParsing() : Void
	{
		var mockObjectWithMetaData : MockObjectWithAnnotation = new MockObjectWithAnnotation();
		var annotationProvider : IAnnotationProvider = AnnotationProvider.getInstance();
		
		annotationProvider.parse( mockObjectWithMetaData );
		
		annotationProvider.registerMetaData( "color", this, this.getColorByName );
		annotationProvider.registerMetaData( "language", this, this.getText );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test with module" )
	public function testWithModule() : Void
	{
		var annotationProvider : IAnnotationProvider = AnnotationProvider.getInstance();

		annotationProvider.registerMetaData( "color", this, this.getColorByName );
		annotationProvider.registerMetaData( "language", this, this.getText );

		var module : MockModuleForAnnotationProviding = new MockModuleForAnnotationProviding();
		module.initialize();

		Assert.equals( 0xffffff, module.mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", module.mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( module.anotherMockObjectWithMetaData.languageTest, "property should be null when class is not implementing IAnnotationParsable" );
	}
	
	@Test( "Test clear method" )
	public function testClearMethod() : Void
	{
		var mockObjectWithMetaData : MockObjectWithAnnotation = new MockObjectWithAnnotation();
		var annotationProvider : IAnnotationProvider = AnnotationProvider.getInstance();
		
		annotationProvider.registerMetaData( "color", this, this.getColorByName );
		annotationProvider.clear();
		
		annotationProvider.parse( mockObjectWithMetaData );
		Assert.isNull( mockObjectWithMetaData.colorTest, "property should be null" );
	}
	
	function getColorByName( name : String ) : Int
	{
		return this._colors.get( name );
	}

	function getText( name : String ) : String
	{
		return this._text.get( name );
	}
	
	@Test( "Test parse service" )
	public function testParseService() : Void
	{
		var service : MockStatelessService = new MockStatelessService();
		var annotationProvider : IAnnotationProvider = AnnotationProvider.getInstance();
		
		annotationProvider.parse( service );
		//Assert.isNull( mockObjectWithMetaData.colorTest, "property should be null" );
	}
}

private class MockStatelessService extends StatelessService<ServiceConfiguration>
{
	public function new() 
	{
		super();
	}
	
	@postConstruct
	override public function createConfiguration() : Void
	{
		trace( "config created" );
	}
	
	public function call_getRemoteArguments() : Array<Dynamic> 
	{
		return this._getRemoteArguments();
	}
	
	public function call_reset() : Void 
	{
		this._reset();
	}
	
	public function testSetResult( result : Dynamic ) : Void
	{
		this._setResult( result );
	}
}