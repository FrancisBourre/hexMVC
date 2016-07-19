package hex.domain;

/**
 * ...
 * @author Tamas Kinsztler
 */
class MVCDomainSuite
{
  	@Suite("Domain")
    public var list : Array<Class<Dynamic>> = [ TopLevelDomainTest ];
}
