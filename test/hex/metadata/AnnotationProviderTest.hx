package hex.metadata;

import hex.domain.Domain;
import hex.domain.DomainExpert;
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
		AnnotationProvider.release();
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
		var provider 		= AnnotationProvider.getAnnotationProvider( Domain.getDomain( 'testGetProviderWithoutDomain0' ) );
		var anotherProvider = AnnotationProvider.getAnnotationProvider( Domain.getDomain( 'testGetProviderWithoutDomain1' ) );
		Assert.notEquals( provider, anotherProvider, "instances should not be the same" );
	}
	
	@Test( "Test register before parsing" )
	public function testRegisterBeforeParsing() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		this._annotationProvider.registerMetaData( "color", this.getColorByName );
		this._annotationProvider.registerMetaData( "language", this.getText );
		
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
		
		this._annotationProvider.registerMetaData( "color", this.getColorByName );
		this._annotationProvider.registerMetaData( "language", this.getText );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test register before parsing with top inheritance" )
	public function testRegisterBeforeParsingWithTopInheritance() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		var provider = AnnotationProvider.getAnnotationProvider( Domain.getDomain( 'testRegisterBeforeParsingWithTopInheritance' ) );
		
		this._annotationProvider.registerMetaData( "color", this.getColorByName );
		this._annotationProvider.registerMetaData( "language", this.getText );
		
		provider.parse( mockObjectWithMetaData );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test register after parsing with top inheritance" )
	public function testRegisterAfterParsingWithTopInheritance() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		var domain = Domain.getDomain( 'testRegisterAfterParsingWithTopInheritance' );
		var provider = AnnotationProvider.getAnnotationProvider( domain );
		provider.parse( mockObjectWithMetaData );
		
		this._annotationProvider.registerMetaData( "color", this.getColorByName );
		this._annotationProvider.registerMetaData( "language", this.getText );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test register before parsing with inheritance" )
	public function testRegisterBeforeParsingWithInheritance() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		var parentDomain = Domain.getDomain( 'testRegisterBeforeParsingWithTopInheritance0' );
		var parentProvider = AnnotationProvider.getAnnotationProvider( parentDomain );
		var provider = AnnotationProvider.getAnnotationProvider( Domain.getDomain( 'testRegisterBeforeParsingWithTopInheritance1' ), parentDomain );
		
		parentProvider.registerMetaData( "color", this.getColorByName );
		parentProvider.registerMetaData( "language", this.getText );
		
		provider.parse( mockObjectWithMetaData );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test register after parsing with inheritance" )
	public function testRegisterAfterParsingWithInheritance() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		var parentDomain = Domain.getDomain( 'testRegisterAfterParsingWithInheritance0' );
		var domain = Domain.getDomain( 'testRegisterAfterParsingWithInheritance1' );
		
		var parentProvider = AnnotationProvider.getAnnotationProvider( parentDomain );
		var provider = AnnotationProvider.getAnnotationProvider( domain, parentDomain );
		
		provider.parse( mockObjectWithMetaData );
		
		parentProvider.registerMetaData( "color", this.getColorByName );
		parentProvider.registerMetaData( "language", this.getText );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test register before parsing with overridding" )
	public function testRegisterBeforeParsingWithOverridding() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		var parentDomain = Domain.getDomain( 'testRegisterBeforeParsingWithOverridding0' );
		var parentProvider = AnnotationProvider.getAnnotationProvider( parentDomain );
		var provider = AnnotationProvider.getAnnotationProvider( Domain.getDomain( 'testRegisterBeforeParsingWithOverridding1' ), parentDomain );
		
		provider.registerMetaData( "language", this.getAnotherText );
		parentProvider.registerMetaData( "color", this.getColorByName );
		parentProvider.registerMetaData( "language", this.getText );
		
		provider.parse( mockObjectWithMetaData );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "anotherText", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test register before parsing with late overridding" )
	public function testRegisterBeforeParsingWithLateOverridding() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		var parentDomain = Domain.getDomain( 'testRegisterBeforeParsingWithOverridding0' );
		var parentProvider = AnnotationProvider.getAnnotationProvider( parentDomain );
		var provider = AnnotationProvider.getAnnotationProvider( Domain.getDomain( 'testRegisterBeforeParsingWithOverridding1' ), parentDomain );
		
		parentProvider.registerMetaData( "color", this.getColorByName );
		parentProvider.registerMetaData( "language", this.getText );
		
		provider.parse( mockObjectWithMetaData );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
		
		provider.registerMetaData( "language", this.getAnotherText );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "anotherText", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test register after parsing with overridding" )
	public function testRegisterAfterParsingWithOverridding() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		var parentDomain = Domain.getDomain( 'testRegisterAfterParsingWithOverridding0' );
		var domain = Domain.getDomain( 'testRegisterAfterParsingWithOverridding1' );
		var parentProvider = AnnotationProvider.getAnnotationProvider( parentDomain );
		var provider = AnnotationProvider.getAnnotationProvider( domain, parentDomain );
		
		provider.parse( mockObjectWithMetaData );
		
		provider.registerMetaData( "language", this.getAnotherText );
		parentProvider.registerMetaData( "color", this.getColorByName );
		parentProvider.registerMetaData( "language", this.getText );
		
		Assert.equals( 0xffffff, mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "anotherText", mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( mockObjectWithMetaData.propWithoutMetaData, "property should be null" );
	}
	
	@Test( "Test with module" )
	public function testWithModule() : Void
	{
		var module = new MockModuleForAnnotationProviding();
		this._annotationProvider = module.getAnnotationProvider();
		
		this._annotationProvider.registerMetaData( "color", this.getColorByName );
		this._annotationProvider.registerMetaData( "language", this.getText );
		
		module.initialize();

		Assert.equals( 0xffffff, module.mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", module.mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( module.anotherMockObjectWithMetaData.languageTest, "property should be null when class is not implementing IAnnotationParsable" );
	}
	
	@Test( "Test with module top level inheritance" )
	public function testWithModuleTopLevelInheritance() : Void
	{
		var module = new MockModuleForAnnotationProviding();

		this._annotationProvider.registerMetaData( "color", this.getColorByName );
		this._annotationProvider.registerMetaData( "language", this.getText );
		
		module.initialize();

		Assert.equals( 0xffffff, module.mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", module.mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( module.anotherMockObjectWithMetaData.languageTest, "property should be null when class is not implementing IAnnotationParsable" );
	}
	
	@Test( "Test with module and inheritance" )
	public function testWithModuleAndInheritance() : Void
	{
		var parentDomain = Domain.getDomain( 'testWithModuleAndInheritance' );
		var parentProvider = AnnotationProvider.getAnnotationProvider( parentDomain );
		
		var moduleDomain = Domain.getDomain( 'moduleID' );
		DomainExpert.getInstance().registerDomain( moduleDomain );
		AnnotationProvider.registerToParentDomain( moduleDomain, parentDomain );
		var module = new MockModuleForAnnotationProviding();

		parentProvider.registerMetaData( "color", this.getColorByName );
		parentProvider.registerMetaData( "language", this.getText );
		
		module.initialize();

		Assert.equals( 0xffffff, module.mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", module.mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( module.anotherMockObjectWithMetaData.languageTest, "property should be null when class is not implementing IAnnotationParsable" );
	}
	
	@Test( "Test with module and inheritance overridding" )
	public function testWithModuleAndInheritanceOverridding() : Void
	{
		var parentDomain = Domain.getDomain( 'testWithModuleAndInheritance' );
		var parentProvider = AnnotationProvider.getAnnotationProvider( parentDomain );
		
		var moduleDomain = Domain.getDomain( 'moduleID' );
		DomainExpert.getInstance().registerDomain( moduleDomain );
		AnnotationProvider.registerToParentDomain( moduleDomain, parentDomain );
		var module = new MockModuleForAnnotationProviding();

		module.getAnnotationProvider().registerMetaData( "language", this.getAnotherText );
		parentProvider.registerMetaData( "color", this.getColorByName );
		parentProvider.registerMetaData( "language", this.getText );
		
		module.initialize();

		Assert.equals( 0xffffff, module.mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "anotherText", module.mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( module.anotherMockObjectWithMetaData.languageTest, "property should be null when class is not implementing IAnnotationParsable" );
	}
	
	@Test( "Test with module and late overridding" )
	public function testWithModuleAndLateOverridding() : Void
	{
		var parentDomain = Domain.getDomain( 'testWithModuleAndInheritance' );
		var parentProvider = AnnotationProvider.getAnnotationProvider( parentDomain );
		
		var moduleDomain = Domain.getDomain( 'moduleID' );
		DomainExpert.getInstance().registerDomain( moduleDomain );
		AnnotationProvider.registerToParentDomain( moduleDomain, parentDomain );
		var module = new MockModuleForAnnotationProviding();

		parentProvider.registerMetaData( "color", this.getColorByName );
		parentProvider.registerMetaData( "language", this.getText );
		
		module.initialize();

		Assert.equals( 0xffffff, module.mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "Bienvenue", module.mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( module.anotherMockObjectWithMetaData.languageTest, "property should be null when class is not implementing IAnnotationParsable" );
		
		module.getAnnotationProvider().registerMetaData( "language", this.getAnotherText );
		module.rebuildComponents();
		
		Assert.equals( 0xffffff, module.mockObjectWithMetaData.colorTest, "color should be the same" );
		Assert.equals( "anotherText", module.mockObjectWithMetaData.languageTest, "text should be the same" );
		Assert.isNull( module.anotherMockObjectWithMetaData.languageTest, "property should be null when class is not implementing IAnnotationParsable" );
	}
	
	@Test( "Test clear method" )
	public function testClearMethod() : Void
	{
		var mockObjectWithMetaData = new MockObjectWithAnnotation();
		
		this._annotationProvider.registerMetaData( "color", this.getColorByName );
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
