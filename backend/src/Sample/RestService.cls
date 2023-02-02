Class Sample.RestService Extends %CSP.REST
{

/// IRIS can automatically handle CORS requests for us
Parameter HandleCorsRequest = 1;

Parameter CONTENTTYPE As STRING = "application/json";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CHARSET = "utf-8";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <Route Url="/test" Method="GET" Call="Test" />
  <Route Url="/swagger" Method="GET" Call="Swagger" />
  <!-- Place new routes below -->

</Routes>
}

/// This is a very simple method to test if our service is working
ClassMethod Test() As %Status
{
  Set json = { "test": "OK" }
  Do json.%ToJSON()
  Quit $$$OK
}

ClassMethod Swagger() As %Status
{
  $$$QuitOnError(##class(%REST.API).GetWebRESTApplication($Namespace, %request.Application, .swagger))
  Do swagger.%ToJSON()
  Quit $$$OK
}

/* Place new methods below */

}
