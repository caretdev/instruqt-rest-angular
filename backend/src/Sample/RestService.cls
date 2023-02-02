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
  <Route Url="/list" Method="GET" Call="List" />
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
ClassMethod List() As %Status
{
  set list=[],sc=1
  set sql="SELECT Url, Description, DateAdded, TimeAdded FROM Sample.Bookmark"
  set Statement = ##class(%SQL.Statement).%New()
  set sc=$$$ADDSC(sc,Statement.%Prepare(sql))
  set Result = Statement.%Execute()
  if (Result.%SQLCODE<0) {
    set sc=$$$ADDSC(sc,$$$ERROR(5001, "Error executing sql statement"))
  }
  while Result.%Next() {
    set bookmark={
      "url":(Result.Url),
      "description":(Result.Description),
      "dateAdded":($zd(Result.DateAdded,3)),
      "timeAdded":($zt(Result.TimeAdded,2))
    }
    do list.%Push(bookmark)
  }
  if $$$ISOK(sc) write list.%ToJSON()
  return sc
}

}
