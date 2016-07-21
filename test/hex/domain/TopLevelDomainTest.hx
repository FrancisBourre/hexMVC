package hex.domain;

import hex.domain.DomainUtil;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Tamas Kinsztler
 */
class TopLevelDomainTest
{
		@Test( "Test 'TopLevelDomain'" )
	  public function testTopLevelDomain() : Void
	  {
	    	var staticVariable = TopLevelDomain.DOMAIN;
        var domain = DomainUtil.getDomain( "TopLevelDomain", TopLevelDomain );
	      Assert.equals( domain.getName(), staticVariable.getName(), "TopLevelDomain should exist" );
	  }
}
