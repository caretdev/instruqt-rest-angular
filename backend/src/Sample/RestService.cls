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
  <Route Url="/list" Method="GET" Call="List" />
  <Route Url="/add" Method="POST" Call="Add" />
  <Route Url="/swagger" Method="GET" Call="Swagger" />
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

/// Get all bookmarks from the database
ClassMethod List() As %Status
{
  Set list = [], sc = 1
  Set sql="SELECT Url, Description, DateAdded, TimeAdded FROM Sample.Bookmark"
  Set Statement = ##class(%SQL.Statement).%New()
  Set sc=$$$ADDSC(sc,Statement.%Prepare(sql))
  Set Result = Statement.%Execute()
  If (Result.%SQLCODE<0) {
    Set sc=$$$ADDSC(sc,$$$ERROR(5001, "Error executing sql statement"))
  }
  While Result.%Next() {
    Set bookmark={
      "url":(Result.Url),
      "description":(Result.Description),
      "dateAdded":($ZDate(Result.DateAdded,3)),
      "timeAdded":($ZTime(Result.TimeAdded,2))
    }
    Do list.%Push(bookmark)
  }
  If $$$ISOK(sc) Write list.%ToJSON()
  Return sc
}

/// Add one bookmark to database
ClassMethod Add() As %Status
{
  Set sc=$$$OK
  Set jsonRequest=##class(%Library.DynamicObject).%FromJSON(%request.Content)
  Set Bookmark=##class(Sample.Bookmark).%New()
  Set Bookmark.Url=jsonRequest.url
  Set Bookmark.Description=jsonRequest.description
  Set Bookmark.DateAdded=$Piece($Horolog,",",1)
  Set Bookmark.TimeAdded=$Piece($Horolog,",",2)
  Set sc=$$$ADDSC(sc,Bookmark.%Save())
  Return sc
}

}
