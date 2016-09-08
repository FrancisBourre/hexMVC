package hex.metadata;

import hex.domain.Domain;
import hex.domain.DomainUtil;
import hex.domain.TopLevelDomain;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class AnnotationProviderTest
{
	var _annotationProvider		: IAnnotationProvider;
	var _colors					: Map<String, UInt>;
	var _text					: Map<String, String>;
		
	@Before
    public function setUp() : Void
    {
		this._annotationProvider = AnnotationProvider.getAnnotationProvider();
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
	
	@Test( "Test get AnnotationProvider instance without passing a domain" )
	public function testGetProviderWithoutDomain() : Void
	{
		var provider 		= AnnotationProvider.getAnnotationProvider();
		var anotherProvider = AnnotationProvider.getAnnotationProvider();
		Assert.equals( provider, anotherProvider, "instances should be the same" );
		Assert.equals( provider, AnnotationProvider.getAnnotationProvider( TopLevelDomain.DOMAIN ), "instances should be the same" );
	}
	
	@Test( "Test get AnnotationProvider instance with a domain" )
	public function testGetProviderWithDomain() : Void
	{
		var provider 		= AnnotationProvider.getAnnotationProvider( DomainUtil.getDomain( 'testGetProviderWithoutDomain0', Domain ) );
		var anotherProvider = AnnotationProvider.getAnnotationProvider( DomainUtil.getDomain( 'testGetProviderWithoutDomain1', Domain ) );
		Assert.notEquals( provider, anotherProvider, "instances should not be the same" );
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
	
	@Test( "Test register before parsing with top inheritance" )
	public function testRegisterBeforeParsingWithTopInheritance() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		var provider = AnnotationProvider.getAnnotationProvider( DomainUtil.getDomain( 'testRegisterBeforeParsingWithTopInheritance', Domain ) );
		
		this._annotationProvider.registerMetaData( "color", this, this.getColorByName );
		this._annotationProvider.registerMetaData( "language", this, this.getText );
		
		provider.parse( mockObjectWithMetaData );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test register after parsing with top inheritance" )
	public function testRegisterAfterParsingWithTopInheritance() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		var domain = DomainUtil.getDomain( 'testRegisterAfterParsingWithTopInheritance', Domain );
		var provider = AnnotationProvider.getAnnotationProvider( domain );
		provider.parse( mockObjectWithMetaData );
		
		this._annotationProvider.registerMetaData( "color", this, this.getColorByName );
		this._annotationProvider.registerMetaData( "language", this, this.getText );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test register before parsing with inheritance" )
	public function testRegisterBeforeParsingWithInheritance() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		var parentDomain = DomainUtil.getDomain( 'testRegisterBeforeParsingWithTopInheritance0', Domain );
		var parentProvider = AnnotationProvider.getAnnotationProvider( parentDomain );
		var provider = AnnotationProvider.getAnnotationProvider( DomainUtil.getDomain( 'testRegisterBeforeParsingWithTopInheritance1', Domain ), parentDomain );
		
		parentProvider.registerMetaData( "color", this, this.getColorByName );
		parentProvider.registerMetaData( "language", this, this.getText );
		
		provider.parse( mockObjectWithMetaData );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test register after parsing with inheritance" )
	public function testRegisterAfterParsingWithInheritance() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		var parentDomain = DomainUtil.getDomain( 'testRegisterAfterParsingWithInheritance0', Domain );
		var domain = DomainUtil.getDomain( 'testRegisterAfterParsingWithInheritance1', Domain );
		
		var parentProvider = AnnotationProvider.getAnnotationProvider( parentDomain );
		var provider = AnnotationProvider.getAnnotationProvider( domain, parentDomain );
		
		provider.parse( mockObjectWithMetaData );
		
		parentProvider.registerMetaData( "color", this, this.getColorByName );
		parentProvider.registerMetaData( "language", this, this.getText );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Ignore( "Test register before parsing with overridding" )
	public function testRegisterBeforeParsingWithOverridding() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		var parentDomain = DomainUtil.getDomain( 'testRegisterBeforeParsingWithOverridding0', Domain );
		var parentProvider = AnnotationProvider.getAnnotationProvider( parentDomain );
		var provider = AnnotationProvider.getAnnotationProvider( DomainUtil.getDomain( 'testRegisterBeforeParsingWithOverridding1', Domain ), parentDomain );
		
		parentProvider.registerMetaData( "color", this, this.getColorByName );
		parentProvider.registerMetaData( "language", this, this.getText );
		provider.registerMetaData( "language", this, this.getAnotherText );
		
		provider.parse( mockObjectWithMetaData );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "anotherText", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test register after parsing with overridding" )
	public function testRegisterAfterParsingWithOverridding() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		var parentDomain = DomainUtil.getDomain( 'testRegisterAfterParsingWithOverridding0', Domain );
		var domain = DomainUtil.getDomain( 'testRegisterAfterParsingWithOverridding1', Domain );
		var parentProvider = AnnotationProvider.getAnnotationProvider( parentDomain );
		var provider = AnnotationProvider.getAnnotationProvider( domain, parentDomain );
		
		provider.parse( mockObjectWithMetaData );
		
		parentProvider.registerMetaData( "color", this, this.getColorByName );
		parentProvider.registerMetaData( "language", this, this.getText );
		provider.registerMetaData( "language", this, this.getAnotherText );
		
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
	
	function getAnotherText( name : String ) : String
	{
		return "anotherText";
	}
}